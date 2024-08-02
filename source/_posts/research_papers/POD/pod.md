---
title: pod
date: 2024/07/13
categories:
  - pod
tags:
  - pod
mathjax: true
abbrlink: 30a636b
---


## 论文笔记框架
### Summary
写完笔记之后最后填，概述文章的内容，以后查阅笔记的时候先看这一段。注：写文章summary切记需要通过自己的思考，用自己的语言描述。忌讳直接Ctrl + c原文。

### Background 
**（研究的背景，帮助你理解研究的动机和必要性，包括行业现状和之前研究的局限性。）**

### Problem Statement
**（问题陈述：问题作者需要解决的问题是什么？）**

### Method(s)
**（作者解决问题的方法/算法是什么？是否基于前人的方法？基于了哪些？）**

### Evaluation
**（作者如何评估自己的方法？实验的setup是什么样的？感兴趣实验数据和结果有哪些？有没有问题或者可以借鉴的地方？）**

### Conclusion
**（作者给出了哪些结论？哪些是strong conclusions, 哪些又是weak的conclusions。即作者并没有通过实验提供evidence，只在discussion中提到；或实验的数据并没有给出充分的evidence?）**

### Notes(optional) 
**（不在以上列表中，但需要特别记录的笔记。）**

### References(optional) 
**（列出相关性高的文献，以便之后可以继续track下去。）**


## Enhancing dynamic mode decomposition workflow with in situ visualization and data compression

流式svd的步骤:
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/%E6%B5%81%E5%BC%8Fsvd.png)


## Mode Multigrid - A novel convergence acceleration method

**《非结构网格高阶数值格式与加速收敛方法》**

这篇论文是上面这篇博士论文里面的内容，实验部分都是一样的。



- **做的什么方向**：
  - 流场加速收敛
- **解决了什么问题**：
  - 多重网格在非结构网格上面因为非结构网格随机存储的原因，难以实现，而且不便并行计算。

- **方法步骤**
  - 收集流场快照，进行DMD分解，然后重构流场（论文没直接说预测外推，只说了结合向量外插类方法，那么认为是重构的未来一个时间步的流场）。然后基于重构的结果续算，达到加速收敛的目的。**DMD的公式步骤和代码实现可以看博客。**



## Improved Mode Multigrid Method for Accelerating Turbulence Flows

这篇论文是在上一篇论文《Mode Multigrid - A novel convergence acceleration method》的基础上进行调整的，实验的对比对象也是上一篇论文提到的方法


- **做的什么方向**：
  - 流场加速收敛
- **解决了什么问题**：
  - 消除模态多重网格方法（上一篇论文提出的）出现的不规则残差跳跃问题

- **方法步骤**
  - 在DMD重构的时候，保留“零频移动模态”（zero-frequency shift modes），可以加速收敛


## AI-enhanced iterative solvers for accelerating the solution of large-scale parametrized systems

- **做的什么方向**：
  - 构建高效的数值求解器
- **做了什么事情**：
  - 使用标准有限元方法进行一组简化的模型评估，并使用相应的解决方案，使用深度前馈神经网络和卷积自编码器的组合建立从问题的参数空间到其解空间的近似映射。这种映射的成本忽略不计，而且精度比较高
  - 基于代数多重网格法结合本征正交分解( POD )开发了迭代求解器POD - 2G，将代理模型的初始预测逐次精化到精确解。
- **解决了什么问题**：
  - 传统方法可能需要较高的计算资源，占用较高的内存；神经网络推理出来的解不满足任何物理规律

- **创新点出发**
  - 将传统方法和神经网络的优势结合起来，用机器学习算法来增强线性代数求解器；例如，POD已成功地用于截断增广的Krylov子空间，仅保留高能量模式63，以有效地求解具有右端变化和对称正定矩阵特征的线性方程组序列。




## Enhancing dynamic mode decomposition workflow with in situ visualization and data compression

### Summary


### Background 
**（研究的背景，帮助你理解研究的动机和必要性，包括行业现状和之前研究的局限性。）**

- 数据驱动方法在工程和科学应用中的使用大幅增长。
- 从数据中提取信息非常有用，可以做很多事。


### Problem Statement
**（问题陈述：问题作者需要解决的问题是什么？）**
- 计算速率和I/O速率之间差距大，大型仿真很难将结果保存到磁盘。
- 非线性系统中获取的数据很可能是高维的，保存到磁盘需要大量空间。


### Method(s)
**（作者解决问题的方法/算法是什么？是否基于前人的方法？基于了哪些？）**

#### 运行时原位数据可视化
  - 在仿真运行的时候进行原位可视化和数据分析，减少磁盘写入的数据量。
  - 作者在已有的原位可视化框架ParaView Catalyst进行开发。
  - 利用ParaView Catalyst创建png图像文件，将当前的视图（像素信息）输入到流式DMD算法，避免标量/矢量等大文件。
  - 流式DMD是在已有的基础上做了些小的改变（we have implemented a slightly different version [68] of the usual iSVD algorithm, initially proposed for Proper Orthogonal Decomposition (POD) applications.）
#### 数据压缩
  - 压缩方法采用新兴的ZFP库。
  - 仿真完成后，将所有的输出文件通过压缩算法压缩为HDF5文件。对这边部分文件的处理采用传统的DMD。



### Evaluation
**（作者如何评估自己的方法？实验的setup是什么样的？感兴趣实验数据和结果有哪些？有没有问题或者可以借鉴的地方？）**

#### 实验一：Particle‐driven gravity flow

- 时间步长为0.001，运行20个时间单位；意味着有20000个时间点

#### 实验二：Bubble rising problem



### Conclusion
**作者给出了哪些结论？哪些是strong conclusions, 哪些又是weak的conclusions。即作者并没有通过实验提供evidence，只在discussion中提到；或实验的数据并没有给出充分的evidence?**

### Notes(optional) 
**（不在以上列表中，但需要特别记录的笔记。）**


因为我是用ipca来重构flow-star里面的数据，重构p和v的时候，误差非常大；邓老师让我看看这篇论文实验部分中重构误差是多大。

论文里面将流式DMD应用到PNG重构，两个实验。
1. 实验一：PNG保留的是concentration这个变量，**我无法知道这个变量的范围是多少，无法和flow-star中的p和v进行比较。**
2. 实验二：PNG保存的是气泡的形状，**也不知道这个变量的范围是多少，无法和flow-star中的p和v进行比较。**




### References(optional) 
**（列出相关性高的文献，以便之后可以继续track下去。）**

## An improved mode time coefficient for dynamic mode decomposition

### Summary


### Background 
**（研究的背景，帮助你理解研究的动机和必要性，包括行业现状和之前研究的局限性。）**

- CFD方法进步->越精确的细节->大量的流数据->提取有用信息难度增加；非定常流需要有效的提取方法，数据驱动的模态分解方法已被证明是有效的技术。
  
- POD方法的缺陷：
  - 模态通常包含多频分量，限制了pod在单频模式分析中的应用。有人提出了一种F-POD的方式来克服这个问题。
  - pod从能量角度对模态排序，没有考虑模态的 动态性
  - 对于模态的截断没有明确的标准

- DMD的模态时间系数还存在问题：
  - 模态时间系数无法处理模态呈非指数演化的流场。尽管multi-resolution DMD and the timedelay DMD 一定程度缓解这个问题，但是对于空间维远大于时间维的大规模流场来说是不行的
  - 模态时间系数可能还会影响DMD模态的排序，从而影响主导模态的选择


### Problem Statement
**（问题陈述：问题作者需要解决的问题是什么？）**

- DMD的模态时间系数无法处理不稳定流场。
- 不准确的模态时间系数可能会导致分解模态的排序不合理，从而导致主导模态被忽略。


### Method(s)
**（作者解决问题的方法/算法是什么？是否基于前人的方法？基于了哪些？）**

- 提出了一种基于Moore-Penrose伪逆的改进模式时间系数
- 定义了一种基于改进模式时间系数的新积分参数来对分解模式进行排序


### Evaluation
**（作者如何评估自己的方法？实验的setup是什么样的？感兴趣实验数据和结果有哪些？有没有问题或者可以借鉴的地方？）**

### Conclusion
**（作者给出了哪些结论？哪些是strong conclusions, 哪些又是weak的conclusions。即作者并没有通过实验提供evidence，只在discussion中提到；或实验的数据并没有给出充分的evidence?）**

### Notes(optional) 
**（不在以上列表中，但需要特别记录的笔记。）**

### References(optional) 
**（列出相关性高的文献，以便之后可以继续track下去。）**