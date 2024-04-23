---
title: cfd
date: 2024/04/23
categories:
  - CFD
tags:
  - CFD
mathjax: true
---



## Extrapolation-Based Acceleration of Iterative Solvers: Application to Simulation of 3D Flows

### 要做什么
1. 获得一个新的初始状态（$u_{ap}$），让解算器可以加速收敛。（如果初始状态与精确解越接近，越容易收敛）；传统的做法是把上一个时间步的解作为初始状态（$u_{n}$）,可以计算$u_{n+1}$的近似解，如果|$u_{ap}$-$u_{n}$| 远小于 |$u_{n}$-$u_{n}$|，可以大大减少迭代次数。
2. 论文使用了两个方法来获取这个新的初始状态: POD和