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


# DP和DDP的区别

https://docs.pytorch.org/tutorials/beginner/ddp_series_theory.html

可以看一下官方的介绍，再好好总结下，也顺便学习下GIL这些知识，下午上课的时候可以学习下。

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

## DDP如何保证梯度同步

假设我们采用分布式训练，每个进程