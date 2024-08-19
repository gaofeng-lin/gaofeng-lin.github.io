---
title: POD关注点
date: 2024/08/16
categories:
  - CFD论文
tags:
  - POD
mathjax: true
abbrlink: e7a840c2
---

## 基于本征正交分解的流场快速预测方法研究

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-08-16_10-11-23.png)

这篇论文里面提到了：POD结合插值方法在跨声速范围（流场在该区域随马赫数的变化存在间断特征）的流场插值结果的可靠性无法保证。这也是这篇文献《基于本征正交分解和代理模型的流场预测方法》提到的“噪声”激波的真实根源。

## 基于本征正交分解和代理模型的流场预测方法

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-08-16_11-36-53.png)

**这样的话，或许如刘溢浪里面提到的，DMD或许可以从频率的角度去解决这个问题。**