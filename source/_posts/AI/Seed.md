---
title: Seed
date: 2025/10/22
categories:
  - AI
tags:
  - 随机种子
mathjax: true
---

# 随机种子概念

random.seed()函数使用给定值初始化随机数生成器。
种子被赋予一个整数值，以确保伪随机生成的结果是可重现的。
每次生成的随机数序列将是确定性的，这意味着可以在不同的运行中获得相同的随机数序列，从而使实验可复现。

在Python中，随机种子是通过random.seed()函数设置的，而在PyTorch中，可以通过设置torch.manual_seed()来实现，在TensorFlow中，使用tf.random.set_seed()设置。

# 随机种子与shuff的联系

当我们设置 DataLoader的 shuffle=True时，每个训练周期（epoch）开始前，数据加载器都会使用随机数来打乱数据的顺序。数据打乱并非直接在原始数据集上进行，而是​​生成一个随机的索引序列​​。DataLoader会根据这个新的索引顺序来提取数据，组装成批次。

**​固定随机种子带来的效果是**：

-   多次实验间，每个epoch的数据顺序可重现​​：如果你设置了一个固定的随机种子（比如 42），那么每次你从头运行整个训练脚本时：
    -   第1个epoch​​的数据打乱顺序将是完全相同的。
    -   第2个epoch​​的数据打乱顺序也将是完全相同的。
    -   以此类推，每个epoch的数据顺序在多次实验中都保持一致。

随机种子和shuff结合的示例代码：
```
import torch
import random
import numpy as np
from torch.utils.data import Dataset, DataLoader

# 设置随机种子的函数，确保可复现性
def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed(seed)
        torch.cuda.manual_seed_all(seed)  # 多GPU情况
    torch.backends.cudnn.deterministic = True  # 禁用非确定性算法
    torch.backends.cudnn.benchmark = False

# 设置全局随机种子（例如42）
seed = 42
set_seed(seed)

# 设置随机种子
torch.manual_seed(123)

# 创建一个简单的自定义数据集
class SimpleDataset(Dataset):
    def __init__(self):
        self.data = [i for i in range(10)]  # 数据：0到9的列表

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        return self.data[idx]

# 创建数据集实例
dataset = SimpleDataset()

# 创建DataLoader，设置shuffle=True
# 注意：num_workers=0 避免多进程复杂性（如需多进程需额外设置worker_init_fn）
dataloader = DataLoader(
    dataset,
    batch_size=2,       # 每个batch包含2个样本
    shuffle=True,       # 关键：启用打乱
    num_workers=0       # 单进程简化示例
)

# 运行3个epoch，打印每个epoch的batch数据
num_epochs = 3
for epoch in range(num_epochs):
    print(f"--- Epoch {epoch+1} ---")
    for batch_idx, batch_data in enumerate(dataloader):
        print(f"Batch {batch_idx}: {batch_data}")
    print()  # 空行分隔epoch
```


是否使用shuff的示例代码：
```
from torch.utils.data import DataLoader, Dataset

# 一个简单的数据集，包含数字0到9
class SimpleDataset(Dataset):
    def __init__(self):
        self.data = [i for i in range(10)]
    def __len__(self):
        return len(self.data)
    def __getitem__(self, idx):
        return self.data[idx]

dataset = SimpleDataset()

print("=== Shuffle=True ===")
loader_shuffle = DataLoader(dataset, batch_size=2, shuffle=True)
for epoch in range(2):  # 模拟2个epoch
    print(f"Epoch {epoch+1}: ", end="")
    for batch in loader_shuffle:
        print(batch, end=" ")
    print()  # 换行

print("\n=== Shuffle=False ===")
loader_no_shuffle = DataLoader(dataset, batch_size=2, shuffle=False)
for epoch in range(2):
    print(f"Epoch {epoch+1}: ", end="")
    for batch in loader_no_shuffle:
        print(batch, end=" ")
    print()  # 换行
```

# 分布式环境中的随机种子和shuff

