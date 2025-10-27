---
title: DDP
date: 2025/10/21
categories:
  - AI
tags:
  - 分布式训练
mathjax: true
abbrlink: 77ac27fb
---

# 基础概念

forward（前向传递）：输入数据，得到输出的过程。
backward(后向传递)：根据输出结果，计算参数梯度的过程。

## 分布式训练技术

- **Data Parallelism** (数据并行)
  - Naive: 每个worker存储一份model和optimizer，每轮迭代时，将样本分为若干份分发给各个worker，实现并行计算.
  - ZeRO: Zero Redundancy Optimizer，微软提出的数据并行内存优化技术，核心思想是保持Naive数据并行通信效率的同时，尽可能降低内存占用。
- **Model/Pipeline Parallelism** (模型并行)
  - GPipe：小批量流水线方式的纵向切割模型并行
  - Megatron-LM：Tensor-slicing方式的模型并行加速
- **Non-parallelism approach** (非并行技术)
  - Gradient Accumulation: 通过梯度累加的方式解决显存不足的问题，常用于模型较大，单卡只能塞下很小的batch的并行训练中
  - CPU Offload: 同时利用 CPU 和 GPU 内存来训练大型模型，即存在GPU-CPU-GPU的 transfers操作


# DP和DDP

## DP训练原理

网络在前向传播时会将 model 从主卡 (默认是逻辑 0 卡) broadcast 到所有 device 上，input data 会在 batch 这个维度被分组后 scatter 到不同的 device 上进行前向计算，计算完毕后网络的输出被 gather 到主卡上，loss 随后在主卡上被计算出来 (这也是为什么主卡负载更大的原因，loss 每次都会在主卡上计算，这就造成主卡负载远大于其他显卡)。在反向传播时，loss 会被 scatter 到每个 device 上，每个卡各自进行反向传播计算梯度，然后梯度会被 reduce 到主卡上 (i.e. 求得各个 device 的梯度之和，然后按照 batch_size 大小求得梯度均值)，再用反向传播在主卡上更新模型参数，最后将更新后的模型参数 broadcast 到其余 GPU 中进行下一轮的前向传播，以此来实现并行。


## DP缺陷

DataParallel 复制一个网络到多个 cuda 设备，然后再 split 一个 batch 的 data 到多个 cuda 设备，通过这种并行计算的方式解决了 batch 很大的问题，但也有自身的不足：

- **单进程多线程带来的问题**：DataParallel 是单进程多线程的，无法在多个机器上工作 (不支持分布式)，而且不能使用 Apex 进行混合精度训练。同时它基于多线程的方式，确实方便了信息的交换，但受困于 GIL (Python 全局解释器锁)，会带来性能开销 (GIL 的存在使得一个 Python 进程只能利用一个 CPU 核心，不适合用于计算密集型的任务)
- **存在效率问题**，主卡性能和通信开销容易成为瓶颈，GPU 利用率通常很低：数据集需要先拷贝到主进程，然后再 split 到每个设备上；权重参数只在主卡上更新，需要每次迭代前向所有设备做一次同步；每次迭代的网络输出需要 gather 到主卡上
- **不支持 model parallel**


## DDP

DP 和 DDP 的主要差异可以总结为以下几点：

- **DDP 是多进程**，每个 GPU 对应一个进程，适用于单机和多机情况，真正实现分布式训练，并且因为每个进程都是独立的 Python 解释器，DDP 避免了 GIL 带来的性能开销。
- **DDP 的训练更高效**，不存在 DP 中负载不均衡的问题。DDP 中每个 GPU 直接处理 mini-batch 数据，不需要由主卡分发；每个 GPU 独立进行参数更新，不需要由主卡 broadcast 模型参数；每个 GPU 独立计算 loss，不需要汇聚到主卡计算。
- **DDP 支持模型并行**

## DDP如何保证梯度同步

DDP通过"All-Reduce"确保所有参与进程（GPU）都获得相同的结果。通常不需要手动编写All-Reduce代码。当你使DistributedDataParallel包装模型后，梯度同步是自动完成的。

## DDP中，不同卡上验证集loss不同如何处理

对于验证集，正确的做法是​**​计算整个验证集的总Loss或平均Loss**。使用all_reduce同步，在每个GPU计算完自己那部分数据的Loss之和后，使用 all_reduce将这些局部Loss求和值进行全局汇总，然后除以全局总样本数得到平均Loss。**如果不汇总处理，可能会出现某张卡loss升高（早停+1），某张卡loss下降的情况，甚至卡住。**

要实现这一步，最关键的代码是```dist.all_reduce(total_loss, op=dist.ReduceOp.SUM) ```

如果采用dist.reduce，则有可能出现卡住的情况。

dist.reduce(total_loss, dst=0, op=dist.ReduceOp.SUM)意味着只有 ​​Rank 0​​ 这个进程会得到所有进程损失求和后的正确结果。而​​其他进程（例如 Rank 1, 2, 3）上的 total_loss变量在操作之后并没有被更新为全局求和的值​​，它们仍然保持着自己原始的、局部的损失值


下面给一个验证集的代码供参考：

```
    def vali(self, vali_data, vali_loader, criterion, is_test=False):
        total_loss = []
        total_count = []
        time_now = time.time()
        test_steps = len(vali_loader)
        iter_count = 0
        
        self.model.eval()    
        with torch.no_grad():
            for i, (batch_x, batch_y, batch_x_mark, batch_y_mark) in enumerate(vali_loader):
                iter_count += 1
                batch_x = batch_x.float().to(self.device)
                batch_y = batch_y.float()
                batch_x_mark = batch_x_mark.float().to(self.device)
                batch_y_mark = batch_y_mark.float().to(self.device)
                
                # outputs = self.model(batch_x, batch_x_mark, batch_y_mark)
                # 关键修改1：验证时使用 model.module，避免DDP内部通信
                if self.args.ddp:
                    outputs = self.model.module(batch_x, batch_x_mark, batch_y_mark)  # 使用 .module
                else:
                    outputs = self.model(batch_x, batch_x_mark, batch_y_mark)

                if is_test or self.args.nonautoregressive:
                        outputs = outputs[:, -self.args.output_token_len:, :]
                        batch_y = batch_y[:, -self.args.output_token_len:, :].to(self.device)
                else:
                    outputs = outputs[:, :, :]
                    batch_y = batch_y[:, :, :].to(self.device)
                if self.args.covariate:
                    if self.args.last_token:
                        outputs = outputs[:, -self.args.output_token_len:, -1]
                        batch_y = batch_y[:, -self.args.output_token_len:, -1]
                    else:
                        outputs = outputs[:, :, -1]
                        batch_y = batch_y[:, :, -1]
                       
                
                loss = criterion(outputs, batch_y)

                loss = loss.detach().cpu()
                total_loss.append(loss)
                total_count.append(batch_x.shape[0])
                if (i + 1) % 100 == 0:
                    if (self.args.ddp and self.args.local_rank == 0) or not self.args.ddp:
                        speed = (time.time() - time_now) / iter_count
                        left_time = speed * (test_steps - i)
                        print("\titers: {}, speed: {:.4f}s/iter, left time: {:.4f}s".format(i + 1, speed, left_time))
                        iter_count = 0
                        time_now = time.time()
        if self.args.ddp:
            total_loss = torch.tensor(np.average(total_loss, weights=total_count)).to(self.device)
            dist.barrier()
            # dist.reduce(total_loss, dst=0, op=dist.ReduceOp.SUM)
            dist.all_reduce(total_loss, op=dist.ReduceOp.SUM)
            total_loss = total_loss.item() / dist.get_world_size()
        else:
            total_loss = np.average(total_loss, weights=total_count)
            
        if self.args.model == 'gpt4ts':
            # GPT4TS just requires to train partial layers
            self.model.in_layer.train()
            self.model.out_layer.train()
        else: 
            self.model.train()
            
        return total_loss
```

# DDP训练时间变慢、训练效果变差


这里的变慢和变差是针对单GPU训练来说。

## 训练时间变慢

原链接：https://zhuanlan.zhihu.com/p/710265518

有两种可能。

### 某张/多张卡有程序占用

因为ddp每个epoch都需要同步，如果有一张卡因为有别的程序占用跑得慢，那么别的卡也要等它，就导致整体变慢。解决办法就是找个没有程序占用的显卡。下面是我的一个实验记录。
  - 单一GPU：
    - Epoch: 1 cost time:       2.8094277381896973
    - Epoch: 2 cost time: 1.6581542491912842
    - Epoch: 3 cost time: 2.0224006175994873
    - Epoch: 4 cost time: 1.5787155628204346
    - 平均用时：
  - 两个节点有个节点有程序占用：
    - Epoch: 1 cost time: 16.403035879135132
    - Epoch: 2 cost time: 13.876952886581421
    - Epoch: 3 cost time: 13.925655841827393
    - Epoch: 4 cost time: 14.027090549468994
    - Epoch: 5 cost time: 14.02741527557373
  - 两个节点均空闲：
    - Epoch: 1 cost time: 4.169334888458252
    - Epoch: 2 cost time: 1.9797673225402832
    - Epoch: 3 cost time: 1.9697625637054443
    - Epoch: 4 cost time: 2.0179057121276855
    - Epoch: 5 cost time: 1.9602136611938477


这里只有4或5个epoch，是因为早停。


### 通信

跨组调用GPU可能会带来较大的延迟。一般来说并不是一个服务器上面卡的传输效率一样，实际上如果是一般的单CPU，4卡台式机，确实差别不会很明显。因为所有的显卡都在一个PCIe桥或者直连CPU。但是如果是八卡服务器，一般是带两个CPU的。八张卡会分为两组：0，1，2，3GPU在CPU0；4，5，6，7在CPU1。

提高通信的方法可以使用NVLink，在显卡间搭建了直连通道，数据不需要走PCIe就能直接在卡间传输。并且带宽、延迟、速度都显著超过走PCIe。

## 训练效果变差

从单gpu变为DDP训练，为了保证优化过程相同，batch_size或者学习率是需要进行调整的。

先说batch_size

### batch_size的调整

在单gpu上面，假设batch_size是8（假设为B）。现在使用DDP，假设有N张卡，那么每张卡上面的batch_size也是B，然后聚合梯度，并计算平均值，一共有N张卡，那么也就是B*N个，实际有效batch_size变为了B*N，扩大了N倍。如果要让DDP和单GPU一样，应该要减小batch_size，变为B/N。

**但是GPU在处理大batch_size的时候效率会更高，为了以最佳的方式使用GPU，我们仍然希望GPU一次性处理B个batch_size。那么就进入第二个问题，学习率**。

### 学习率的调整

因为batch_size增大了N倍，权重更新减少了N倍。每步都是B*N。缩放方法可以参考论文《Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour》里面提到的线性缩放。~~新的学习率=sqrt(N)/lr。还要注意，这种情况下，如果模型使用了batch norm，应该禁止batch norm。~~




# 入门

作者：小志哥
链接：https://zhuanlan.zhihu.com/p/178402798
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 一个简单的DDP代码

```
作者：小志哥
链接：https://zhuanlan.zhihu.com/p/178402798
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## main.py文件
import torch
# 新增：
import torch.distributed as dist

# 新增：从外面得到local_rank参数
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--local_rank", default=-1)
FLAGS = parser.parse_args()
local_rank = FLAGS.local_rank

# 新增：DDP backend初始化
torch.cuda.set_device(local_rank)
dist.init_process_group(backend='nccl')  # nccl是GPU设备上最快、最推荐的后端

# 构造模型
device = torch.device("cuda", local_rank)
model = nn.Linear(10, 10).to(device)
# 新增：构造DDP model
model = DDP(model, device_ids=[local_rank], output_device=local_rank)

# 前向传播
outputs = model(torch.randn(20, 10).to(rank))
labels = torch.randn(20, 10).to(rank)
loss_fn = nn.MSELoss()
loss_fn(outputs, labels).backward()
# 后向传播
optimizer = optim.SGD(model.parameters(), lr=0.001)
optimizer.step()


## Bash运行
# 改变：使用torch.distributed.launch启动DDP模式，
#   其会给main.py一个local_rank的参数。这就是之前需要"新增:从外面得到local_rank参数"的原因
python -m torch.distributed.launch --nproc_per_node 4 main.py
```

## DDP的基本原理

假如我们有N张显卡，（缓解GIL限制）在DDP模式下，会有N个进程被启动，每个进程在一张卡上加载一个模型，这些模型的参数在数值上是相同的。（Ring-Reduce加速）在模型训练时，各个进程通过一种叫Ring-Reduce的方法与其他进程通讯，交换各自的梯度，从而获得所有进程的梯度；（实际上就是Data Parallelism）各个进程用平均后的梯度更新自己的参数，因为各个进程的初始参数、更新梯度是一致的，所以更新后的参数也是完全相同的。


## 与DP模式的不同

DP模式是很早就出现的、单机多卡的、参数服务器架构的多卡训练模式，在PyTorch，即是：

```model = torch.nn.DataParallel(model)```

在DP模式中，总共只有一个进程（受到GIL很强限制）。master节点相当于参数服务器，其会向其他卡广播其参数；在梯度反向传播后，各卡将梯度集中到master节点，master节点对搜集来的参数进行平均后更新参数，再将参数统一发送到其他卡上。这种参数更新方式，会导致master节点的计算任务、通讯量很重，从而导致网络阻塞，降低训练速度。但是DP也有优点，优点就是代码实现简单。

## DDP为什么能加速

- **Python GIL**：Python GIL的存在使得，一个python进程只能利用一个CPU核心，不适合用于计算密集型的任务。使用多进程，才能有效率利用多核的计算资源。而DDP启动多进程训练，一定程度地突破了这个限制。
- **Ring-Reduce梯度合并**：Ring-Reduce是一种分布式程序的通讯方法。各进程独立计算梯度。每个进程将梯度依次传递给下一个进程，之后再把从上一个进程拿到的梯度传递给下一个进程。循环n次（进程数量）之后，所有进程就可以得到全部的梯度了。可以看到，每个进程只跟自己上下游两个进程进行通讯，极大地缓解了参数服务器的通讯阻塞现象！



## DDP概念

我有两台机子，每台8张显卡，在16张显卡，16的并行数下，DDP会同时启动16个进程。下面介绍一些分布式的概念。

- group：即进程组。默认情况下，只有一个组。这个可以先不管，一直用默认的就行。
- world size:表示全局的并行数，简单来讲，就是2x8=16。
```
# 获取world size，在不同进程里都是一样的，得到16
torch.distributed.get_world_size()
```
- rank：表现当前进程的序号，用于进程间通讯。对于16的world sizel来说，就是0,1,2,…,15。
注意：rank=0的进程就是master进程。
```
# 获取rank，每个进程都有自己的序号，各不相同
torch.distributed.get_rank()
```

- local_rank：又一个序号。这是每台机子上的进程的序号。机器一上有0,1,2,3,4,5,6,7，机器二上也有0,1,2,3,4,5,6,7

```
# 获取local_rank。一般情况下，你需要用这个local_rank来手动设置当前模型是跑在当前机器的哪块GPU上面的。
torch.distributed.local_rank()
```
## Pytorch中如何使用DDP

DDP有不同的使用模式。**DDP的官方最佳实践是，每一张卡对应一个单独的GPU模型（也就是一个进程），在下面介绍中，都会默认遵循这个pattern**。
举个例子：我有两台机子，每台8张显卡，那就是2x8=16个进程，并行数是16。

但是，我们也是可以给每个进程分配多张卡的。总的来说，分为以下三种情况：

1. 每个进程一张卡。这是DDP的最佳使用方法。
2. 每个进程多张卡，复制模式。一个模型复制在不同卡上面，每个进程都实质等同于DP模式。这样做是能跑得通的，但是，速度不如上一种方法，一般不采用。
3. 每个进程多张卡，并行模式。一个模型的不同部分分布在不同的卡上面。例如，网络的前半部分在0号卡上，后半部分在1号卡上。这种场景，一般是因为我们的模型非常大，大到一张卡都塞不下batch size = 1的一个模型。

**注意，我们后面的内容都是说的的每个进程一张卡，每个进程多张卡涉及到切割模型**。



## 分布式训练相关参数

- **分布式训练的重要参数**：
  - -nnodes：有多少台机器
  - node_rank：当前是哪台机器
  - nproc_per_node：每台机器有多少个进程
  - address：通讯ip
  - port：通讯端口

针对分布式训练来说，每一台机子（总共m台）上都运行一次torch.distributed.launch。每个torch.distributed.launch会启动n个进程，并给每个进程一个--local_rank=i的参数。这样我们就得到n*m个进程，world_size=n*m


分布式训练的启动代码：
```
## Bash运行
# 假设我们在2台机器上运行，每台可用卡数是8
#    机器1：
CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7" python -m torch.distributed.launch --nnodes=2 --node_rank=0 --nproc_per_node 8 \
  --master_adderss $my_address --master_port $my_port main.py
#    机器2：
CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7" python -m torch.distributed.launch --nnodes=2 --node_rank=1 --nproc_per_node 8 \
  --master_adderss $my_address --master_port $my_port main.py
```

参考代码：
```
作者：小志哥
链接：https://zhuanlan.zhihu.com/p/178402798
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

################
## main.py文件
import argparse
from tqdm import tqdm
import torch
import torchvision
import torch.nn as nn
import torch.nn.functional as F
# 新增：
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP

### 1. 基础模块 ### 
# 假设我们的模型是这个，与DDP无关
class ToyModel(nn.Module):
    def __init__(self):
        super(ToyModel, self).__init__()
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)
    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(-1, 16 * 5 * 5)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        return x
# 假设我们的数据是这个
def get_dataset():
    transform = torchvision.transforms.Compose([
        torchvision.transforms.ToTensor(),
        torchvision.transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
    ])
    my_trainset = torchvision.datasets.CIFAR10(root='./data', train=True, 
        download=True, transform=transform)
    # DDP：使用DistributedSampler，DDP帮我们把细节都封装起来了。
    #      用，就完事儿！sampler的原理，第二篇中有介绍。
    train_sampler = torch.utils.data.distributed.DistributedSampler(my_trainset)
    # DDP：需要注意的是，这里的batch_size指的是每个进程下的batch_size。
    #      也就是说，总batch_size是这里的batch_size再乘以并行数(world_size)。
    trainloader = torch.utils.data.DataLoader(my_trainset, 
        batch_size=16, num_workers=2, sampler=train_sampler)
    return trainloader
    
### 2. 初始化我们的模型、数据、各种配置  ####
# DDP：从外部得到local_rank参数
parser = argparse.ArgumentParser()
parser.add_argument("--local_rank", default=-1, type=int)
FLAGS = parser.parse_args()
local_rank = FLAGS.local_rank

# DDP：DDP backend初始化
torch.cuda.set_device(local_rank)
dist.init_process_group(backend='nccl')  # nccl是GPU设备上最快、最推荐的后端

# 准备数据，要在DDP初始化之后进行
trainloader = get_dataset()

# 构造模型
model = ToyModel().to(local_rank)
# DDP: Load模型要在构造DDP模型之前，且只需要在master上加载就行了。
ckpt_path = None
if dist.get_rank() == 0 and ckpt_path is not None:
    model.load_state_dict(torch.load(ckpt_path))
# DDP: 构造DDP model
model = DDP(model, device_ids=[local_rank], output_device=local_rank)

# DDP: 要在构造DDP model之后，才能用model初始化optimizer。
optimizer = torch.optim.SGD(model.parameters(), lr=0.001)

# 假设我们的loss是这个
loss_func = nn.CrossEntropyLoss().to(local_rank)

### 3. 网络训练  ###
model.train()
iterator = tqdm(range(100))
for epoch in iterator:
    # DDP：设置sampler的epoch，
    # DistributedSampler需要这个来指定shuffle方式，
    # 通过维持各个进程之间的相同随机数种子使不同进程能获得同样的shuffle效果。
    trainloader.sampler.set_epoch(epoch)
    # 后面这部分，则与原来完全一致了。
    for data, label in trainloader:
        data, label = data.to(local_rank), label.to(local_rank)
        optimizer.zero_grad()
        prediction = model(data)
        loss = loss_func(prediction, label)
        loss.backward()
        iterator.desc = "loss = %0.3f" % loss
        optimizer.step()
    # DDP:
    # 1. save模型的时候，和DP模式一样，有一个需要注意的点：保存的是model.module而不是model。
    #    因为model其实是DDP model，参数是被`model=DDP(model)`包起来的。
    # 2. 只需要在进程0上保存一次就行了，避免多次保存重复的东西。
    if dist.get_rank() == 0:
        torch.save(model.module.state_dict(), "%d.ckpt" % epoch)


################
## Bash运行
# DDP: 使用torch.distributed.launch启动DDP模式
# 使用CUDA_VISIBLE_DEVICES，来决定使用哪些GPU
# CUDA_VISIBLE_DEVICES="0,1" python -m torch.distributed.launch --nproc_per_node 2 main.py
```

## 总结

如果想启动分布式训练，相比于单机单卡训练，主要有以下区别：

- **分布式参数**：
  - nnodes：有多少台机器
  - node_rank：当前是哪台机器
  - nproc_per_node：每台机器有多少个进程
  - address：通讯ip
  - port：通讯端口

- **启动方式**：不同于单卡的直接运行python,现在，需要用torch.distributed.launch来启动训练。并且在每个机器上都启动。启动示例脚本如下：
```
## Bash运行
# 假设我们在2台机器上运行，每台可用卡数是8
#    机器1：
CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7" python -m torch.distributed.launch --nnodes=2 --node_rank=0 --nproc_per_node 8 \
  --master_adderss $my_address --master_port $my_port main.py
#    机器2：
CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7" python -m torch.distributed.launch --nnodes=2 --node_rank=1 --nproc_per_node 8 \
  --master_adderss $my_address --master_port $my_port main.py
```

- **分布式代码**：

相较于原来单卡代码，分布式新增部分主要为：
```
# 新增：
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP

### 2. 初始化我们的模型、数据、各种配置  ####
# DDP：从外部得到local_rank参数
parser = argparse.ArgumentParser()
parser.add_argument("--local_rank", default=-1, type=int)
FLAGS = parser.parse_args()
local_rank = FLAGS.local_rank

# DDP：DDP backend初始化
torch.cuda.set_device(local_rank)
dist.init_process_group(backend='nccl')  # nccl是GPU设备上最快、最推荐的后端

# 构造模型
model = ToyModel().to(local_rank)
# DDP: Load模型要在构造DDP模型之前，且只需要在master上加载就行了。
ckpt_path = None
if dist.get_rank() == 0 and ckpt_path is not None:
    model.load_state_dict(torch.load(ckpt_path))
# DDP: 构造DDP model
model = DDP(model, device_ids=[local_rank], output_device=local_rank)

# DDP: 要在构造DDP model之后，才能用model初始化optimizer。
optimizer = torch.optim.SGD(model.parameters(), lr=0.001)



### 3. 网络训练  ###
model.train()
iterator = tqdm(range(100))
for epoch in iterator:
    # DDP：设置sampler的epoch，
    # DistributedSampler需要这个来指定shuffle方式，
    # 通过维持各个进程之间的相同随机数种子使不同进程能获得同样的shuffle效果。
    trainloader.sampler.set_epoch(epoch)
    # 后面这部分，则与原来完全一致了。
    for data, label in trainloader:
        data, label = data.to(local_rank), label.to(local_rank)
        optimizer.zero_grad()
        prediction = model(data)
        loss = loss_func(prediction, label)
        loss.backward()
        iterator.desc = "loss = %0.3f" % loss
        optimizer.step()
    # DDP:
    # 1. save模型的时候，和DP模式一样，有一个需要注意的点：保存的是model.module而不是model。
    #    因为model其实是DDP model，参数是被`model=DDP(model)`包起来的。
    # 2. 只需要在进程0上保存一次就行了，避免多次保存重复的东西。
    if dist.get_rank() == 0:
        torch.save(model.module.state_dict(), "%d.ckpt" % epoch)
```




