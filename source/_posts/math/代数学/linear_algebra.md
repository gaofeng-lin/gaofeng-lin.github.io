---
title: linear_algebra
date: 2025/09/26
categories:
  - 数学
tags:
  - 线性代数
mathjax: true
abbrlink: 6b912686
---

**本文内容出自3Blue1Brown**

# 视频对应文档资料

https://www.3blue1brown.com/#lessons


# 如何理解矩阵左乘和右乘

https://www.zhihu.com/question/449981594

左乘行变，右乘列变。

左乘某个矩阵，是对这个矩阵的行向量做线性组合，线性组合的系数就是左乘矩阵对应位置的元素。

右乘某个矩阵，是对这个矩阵的列向量做线性组合，线性组合的系数就是右乘矩阵对应位置的元素。




# 向量

线代中最基础、最根源的组成部分就是向量。

向量究竟是什么？不同领域的人有不同的解读，但是比较常用的解读是下面两种：

-   **向量是空间中的箭头**

向量经常以原点为起点，决定一个向量的是它的长度和所指的方向。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-09-26_11-09-00.png)

-   **向量是有序的数字列表**

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-09-26_11-09-38.png)

第一个数表示沿x轴移动多少，第二个数表示沿y轴移动多少。正负表示移动方向。

# 线性变化（Linear transformation）

## Transformations Are Functions

Transformation本质上是“函数”的一种花哨说法，接受一些输入，输出一些结果。对于线性变化来说，输入是向量，输出也是向量。

既然这样，为什么还要使用Transformation而不是function?

**“变换”这个词在暗示你用运动去思考**

想象每一个输入向量都移动到对应输出向量的位置上。

## What makes a transformation "linear"?

如果一个变换具有以下两条性质，我们就称它是线性的：

-   直线在变换后仍然保持直线，不能有弯曲。
-   原地必须保持固定

