---
title: DroneAD
date: 2025/09/05
categories:
  - Drone
tags:
  - Anomaly Detection
mathjax: true
abbrlink: 7d96b074
---

# Motor Anomaly Detection for Unmanned Aerial Vehicles Using Reinforcement Learning

## Summary

**（写完笔记之后最后填，概述文章的内容，以后查阅笔记的时候先看这一段。注：写文章summary切记需要通过自己的思考，用自己的语言描述。忌讳直接Ctrl + c原文）**


## Background 
**（研究的背景，帮助你理解研究的动机和必要性，包括行业现状和之前研究的局限性）**

1. 无人机广泛用于气象观测、农用化学品喷洒、基础设施检查和灾区监测。但是在极端环境中使用无人机引发一系列问题。（Introduction-Sub1）
2. 目前为止，还没有设计出检测无人机发动机（电机）运行异常的系统。在本文中，我们开发了一种检测和保护系统，当检测到发动机温度异常时，该系统可使无人机着陆。（Introduction-Sub1）
3. 电机设计寿命的一个关键因素是轴承的寿命。这可以通过两种方式进行监测。第一种方法是检测油脂因受热而变质的情况。第二种方法是通过考虑滚动疲劳来估算机械寿命。在大多数情况下，润滑脂的劣化比机械故障的影响更大。温度是影响轴承润滑脂使用寿命的关键因素。因此，我们对电机的温度进行监控，以此来检测异常情况。这意味着电机故障通常与温度异常有关。（Introduction-Sub2）


常见的电机异常检测方法：
1. 异常声音检测：。从测量目标处收集声音、降噪、建模。这个过程是一个监督训练。在大多数情况下，很难在极端环境中训练数据集。因此，在嘈杂背景下使用基于声音的检测系统时，会出现错误检测。（Related Work-SubA）
2. 红外成像检测：收集电机的红外图像，并在温度等于或超过预定阈值时触发警报。很难在无人机上安装具有足够精确红外成像的紧凑型热像仪，以确定温度的变化。（Related Work-SubB）
3. 异常旋转检测：使用传感器监测风扇的旋转速度，并在检测到异常旋转时触发警报。然而，很难确定转速降低是由于异常还是无人机的气流速度发生了变化。风扇传感器也会影响无人机的飞行特性。



## Problem Statement



-   现有的无人机很容易坠毁，常见的无人机事故是于电池容量不足、电机故障或直流电（DC）问题以及通信中断等问题导致的失控下降。（Introduction-Sub2）
-   


## Method(s)

### 基于强化学习的温度阈值更新

算法根据速度变化调整温度上升率，得出抑制温度上升的最佳速度变化率。


定义了三个符号

t: 电机实时温度测量值
line_T_{n+1}：历史温度均值
sigma_{n+1}: 温度波动标准差

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-09-05_11-56-05.png)


## Evaluation

在这次模拟实验中，我们构建了一个系统，当电机温度超过一定值时，无人机就会着陆。

### 减速率计算

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-09-05_11-13-23.png)

0-50秒，速度和温度的变化

1个count是2s。




## Conclusion
**（作者给出了哪些结论？哪些是strong conclusions, 哪些又是weak的conclusions。即作者并没有通过实验提供evidence，只在discussion中提到；或实验的数据并没有给出充分的evidence?）**

## Notes(optional) 
**（不在以上列表中，但需要特别记录的笔记。）**

这篇论文的实验部分比较薄弱：
- 没有和别的的方法进行比较
- 仅仅使用温度来对电机进行异常检测，指标单一


## References(optional) 
**（列出相关性高的文献，以便之后可以继续track下去。）**