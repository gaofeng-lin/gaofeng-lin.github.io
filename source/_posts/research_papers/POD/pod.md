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