---
title: ROPE
date: 2025/11/21
categories:
  - AI
tags:
  - ROPE
mathjax: true
abbrlink: 878b3a83
---

# 基础知识

## 三角函数

## 旋转矩阵 
https://zhuanlan.zhihu.com/p/183973440

XY坐标系中，向量OP旋转β角度到了OP'的位置：

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-11-21_11-08-17.png)

根据三角函数关系，可以列出向量OP与OP'的坐标表示形式：

对比上面个两个式子，将第2个式子展开：

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-cdf8b5fa36af46cdd4986cdbc3ec8d2a_r.png)


用矩阵形式重新表示为：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-8803684cd287390b2b689c128d76563b_1440w.jpg)

中间的矩阵即二维旋转的旋转矩阵，坐标中的某一向量左乘该矩阵后，即得到这个向量旋转β角后的坐标。