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



## An improved criterion to select dominant modes from dynamic mode decomposition

### Summary


### Background 
**（研究的背景，帮助你理解研究的动机和必要性，包括行业现状和之前研究的局限性。）**

- 建立复杂的降阶模型在许多领域（动力学建模、优化、机理分析）有广泛的工程价值->目前基于输入-输出数据构造的ROM（Autoregressive with exogenous input model、神经网络）效果不错->研究去全阶流体时，更适合采用模态分解技术。
  
- 模态分解技术对动力学系统建模取决于所选择的模态和时间系数。
  - POD模态可以通过能量来确定，但是时间系数的外推不容易，确定POD时间系数发展规律有两个方法。
    - nonintrusive modeling(非侵入式建模)：利用一些代理模型进行系数插值
    - intrusive modeling(侵入式建模)：将正交模态投影到原偏微分方程组上，建立一个由常微分方程组描述的系统
  -  DMD技术在模拟流动动态时更为方便，因为所有可用的动态模态都伴随着以相应模态特征值表征的时间动态。这一优势使得基于数据驱动的DMD方法成为模拟复杂湍流流动的有效方法。

- 提取DMD的主导模态（dominant modes）的**标准不唯一**，模态选择的目的是通过少量模态找到非定常流的紧凑表示（compact representation），提供物理特征的最佳近似。


我们提供了一种有效且通用的方法来选择主要 DMD 模式。在评估每种模式的贡献时，考虑了每种 DMD 模式的初始条件和时间演化，并开发了适合不同 DMD 表达式的简单标准。

### Problem Statement
**（问题陈述：问题作者需要解决的问题是什么？）**


- **以前的模态选择策略不适合不稳定系统**【以前的模态选择策略适用于周期流或完整线性系统的主要流动。这是因为在大多数周期性或线性流中，每种模态的大小差异很大，并且可以从初始条件或每个模态范数中轻松识别出主导模态。然而，对于不稳定系统（例如，低雷诺数的圆柱体的瞬态或具有移动冲击波的跨音速流）或高度湍流，捕获主要流动特征变得困难，因为可能存在多个基本频率并且在数值上更多需要瞬态模式来完全近似样本。】


### Method(s)
**（作者解决问题的方法/算法是什么？是否基于前人的方法？基于了哪些？）**

- 提出了模态选择策略。对时间系数进行积分，以此来排序模态
- 收到Sayadi工作的启发，将振幅重新定义为与时间相关的系数（T. Sayadi, P.J. Schmid, F. Richecoeur, D. Durox, Parametrized datadriven decomposition for bifurcation analysis, with application to thermo-acoustically unstable systems, Phys. Fluids 27 (2015) 037102. http://dx.doi.org/10.1063/1.4913868.）

下面是用相似矩阵得到的DMD重构表达式：

$x\_{i} = \Phi\Lambda^{i-1}\mathbf{b} = \sum\_{j=1}^{r}\Phi\_{j}(\lambda\_{j})^{i-1}\alpha\_{j}$

其中$i$表示某个时刻，$j$某个模态

假设
$b\_{ij} = (\lambda\_{j})^{i-1}\alpha\_{j}$

其中$b\_{ij}$被称为时间系数，每个模态对数据集的贡献仅由其时间系数决定，如果$b\_{ij}$比较大，对应的模态占据了该时刻的大部分能量，对时间系数进行积分。**表示第 j 个动态模式对整个采样空间的影响。**

$I\_{j}=\int\left|b\_{j}(t)\right|d t\approx\int\_{i=1}^{N}\left|b\_{i j}\right|d t$

用DMD中相似矩阵的公式可以进一步得到下面的表达式：

$I\_{j}=\sum\_{i=1}^{N}\,\big|\alpha\_{j}(\lambda\_{j})^{i-1}\big|\,\big|\big|\Phi\_{j}\big|_{F}^{2}\times\Delta t$

### Evaluation
**（作者如何评估自己的方法？实验的setup是什么样的？感兴趣实验数据和结果有哪些？有没有问题或者可以借鉴的地方？）**

- 想要证明什么结论
  - 利用所提出的准则，以合理的方式对每个DMD模式的主导地位进行排序，并且可以通过最少数量的DMD模式和最多的流能量实现高分辨率流重建和预测。


- 实验例子
  - 低雷诺数的气缸
  - 跨音速流中的翼型抖振

### Conclusion
**（作者给出了哪些结论？哪些是strong conclusions, 哪些又是weak的conclusions。即作者并没有通过实验提供evidence，只在discussion中提到；或实验的数据并没有给出充分的evidence?）**

### Notes(optional) 
**（不在以上列表中，但需要特别记录的笔记。）**

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

#### 提出了一种基于Moore-Penrose伪逆的改进模式时间系数
  - 常规的时间系数定义：$\Phi D\_{\alpha}V\_{and}$，论文里面经过公式的带入和变量替换，新的定义：$W^{-1}\Sigma V^{\mathbb{H}}$
  - 改进的时间系数定义**不受限于具有指数增长的模态**，理论上适合任何增长类型的模态


#### 定义了一种基于改进模式时间系数的新积分参数来对分解模式进行排序
  - 本文的排序方式是在这篇论文进行修改的（J. Kou and W. Zhang, “An improved criterion to select dominant modes from dynamic mode decomposition,” Eur. J. Mech. B 62, 109–129 (2017).）
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-08-08_10-44-54.png)

本文的排序方式：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-08-08_10-45-43.png)


变化主要有两处
1. 时间系数的定义不同
2. 模态的处理方式不同，之前的处理方式是二范数平方，现在是取绝对值


然后通过能量比来确定第$j$个模态的重要性

$ER\_{j}=\frac{E\_{j}}{\displaystyle\sum\_{j=1}^{r}E\_{j}}\$

根据参数$ER\_{j}$的排序选择主导动态模式，**与Kou的方法相比，该标准以非指数的增长率提供了更合理的排名**

### Evaluation
**（作者如何评估自己的方法？实验的setup是什么样的？感兴趣实验数据和结果有哪些？有没有问题或者可以借鉴的地方？）**

#### 实验1：验证改进时间系数的有效性

图中的横轴表示时间，纵轴表示时间系数

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-08-08_21-06-29.png)

就u2而言，其振幅应该呈对数增长。如图2 ( b )所示，由DMD - TC得到的模式时间系数以对数形式变化。然而，DMD的增长似乎是以指数形式增长的。这表明DMD - TC可以准确地描述对数增长模式，而DMD不能。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-08-08_20-58-46.png)


u3具有较小的初始振幅，但随后线性增长到显著水平。如图2 ( c )所示，DMD - TC正确地画出了模式时间系数。然而，DMD显著低估了模态时间系数的幅值。值得注意的是，由DMD绘制的模式时间系数仍然以指数形式变化。

#### 实验2：改进时间系数的应用

##### 圆柱绕流

##### 俯仰翼型的动态失速

### Conclusion
**（作者给出了哪些结论？哪些是strong conclusions, 哪些又是weak的conclusions。即作者并没有通过实验提供evidence，只在discussion中提到；或实验的数据并没有给出充分的evidence?）**

### Notes(optional) 
**（不在以上列表中，但需要特别记录的笔记。）**

### References(optional) 
**（列出相关性高的文献，以便之后可以继续track下去。）**