---
title: AI
date: 2023/12/22
categories:
  - AI
tags:
  - SGD
mathjax: true
abbrlink: 53791
---



# Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour


本文旨在展示分布式同步SGD在大规模训练的可行性。

举了一个例子，模型ResNet-50，数据集是ImageNet(第五章实验有提到)，minibatch为256，使用8个P100GPU，训练时间是29个小时。但是随着minibatch增加，验证集的loss也在增加。

但是本文提出的方法，可以使用minibatch为8192，使用256个GPU训练，只需要1个小时，能达到和256minibatch相同水准（same level）的准确率。


核心规则是：​​使用线性缩放规则（Linear Scaling Rule）并结合渐进式预热（Gradual Warmup）策略​​。

线性缩放规则：当最小批次大小（Minibatch Size）乘以系数 k时，学习率（Learning Rate）也应乘以 k。​（论文2.1节）

预热策略：在训练最初的几个周期（如5个epoch）内，将学习率从​​基线学习率​​线性地增加到​​根据线性缩放规则计算出的目标学习率​​。（论文2.2节）