---
title: 深度学习Graph
date: 2025/06/17
categories:
  - AI
tags:
  - 异构图
mathjax: true
---

# 同构图和异构图

## 概念

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-890ca73f952eef1c7edb138223a75791_1440w.png)

同构图：节点类型和边的类型只有一种
异构图：节点类型+边类型＞2 

在异构图中，节点类型可以代表不同的实体，如用户、商品、话题等，而边类型表示不同实体之间的关系，如用户之间的关注关系、用户与商品之间的购买关系等。节

异构图提供了一种强大的图模型，能够更好地表达和分析具有多种类型实体和复杂关系的现实世界系统。在不同领域的数据分析和应用中，异构图具有广泛的应用前景和研究价值。

## 异构图定义

以”小明参加跨学科学术会议“为例

-   节点类型：
    -   学生 (Student): 例如：小明、学生B、学生C

    -   教授 (Professor): 例如：教授A

    -   论文 (Paper): 例如：论文P1（小明和教授A合作）、论文P2（学生B发表）
    -   研究主题 (Topic): 例如：人工智能 (AI)、生物信息学 (Bioinfo)
-   边类型：
    -   写/发表 (writes): 连接 作者（学生或教授）和 论文。如 小明 --writes--> 论文P1
    -   属于 (belongs_to): 连接 论文 和 研究主题。如 论文P1 --belongs_to--> AI
    -   聊天/互动 (interacts_with): 连接 参会者（学生或教授）之间。如 小明 --interacts_with--> 学生C
    -   关注/感兴趣 (interested_in) （可选，节点特征可隐含）: 连接 参会者 和 研究主题 (这个关系在图中可能不显式存在，但可以作为节点特征或下游任务目标)。

**可视化：**

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-06-17_16-03-28.png)








