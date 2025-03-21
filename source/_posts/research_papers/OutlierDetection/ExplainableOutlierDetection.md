---
title: 异常解释论文
date: 2025/03/21
categories:
  - 异常检测
tags:
  - 机器学习
mathjax: true
---

# A survey of visual analytics for Explainable Artificial Intelligence methods

## 整理框架

论文将解释方法分为两类：

- ​视觉解释（Visual Interpretability, VI）​：仅用可视化技术解释模型，​不依赖XAI算法。
- ​基于视觉的XAI（Visual XAI, vXAI）​：结合XAI算法（如LIME、SHAP）和可视化技术，​依赖XAI生成解释，再通过可视化呈现。


每类进一步分为两个维度：

​- Model Usage：如何从技术角度使用模型（即解释模型的什么内容？）。
​- Visual Approaches：如何用可视化技术实现解释（即用什么图表或交互方式呈现？）。

## VI（视觉解释）的详细拆解

**(1) VI的Model Usage（模型使用方式）​**
指 ​仅通过可视化技术直接分析模型自身，不依赖外部XAI算法，具体包括：

​特征选择（Feature Selection）​
​目的：找出模型依赖的关键输入特征。
​例子：用热图显示图像分类模型关注的像素区域（如高亮狗头）。
​性能分析（Performance Analysis）​
​目的：评估模型的整体表现（如准确率、误差分布）。
​例子：用混淆矩阵比较多个模型在测试集上的分类效果。
​模型架构理解（Architecture Understanding）​
​目的：理解模型的内部结构或训练动态。
​例子：用网络结构图展示CNN的层连接，或用激活图显示神经元响应模式。

​**(2) VI的Visual Approaches（视觉方法）​**
指 ​实现上述目标的具体可视化技术，分为三类：

​数据表示（Data Representation）​
​方法：原始数据可视化（如图像网格）、降维投影（如t-SNE散点图）。
​例子：用t-SNE将高维特征投影到2D，观察数据聚类。
​架构可视化（Architecture Visualization）​
​方法：网络结构图（如DAG有向无环图）、节点-链接图、热图。
​例子：用节点大小表示卷积核重要性，连线表示层间连接。
​性能分析视图（Performance Views）​
​方法：混淆矩阵、动态训练曲线、误差实例跟踪。
​例子：用桑基图展示模型在不同类别间的错误流动。
​VI的核心特点
​不依赖XAI算法，直接通过可视化技术分析模型。
​关注模型自身属性​（结构、特征、性能），而非决策逻辑。

## vXAI（基于视觉的XAI）的详细拆解

**(1) vXAI的Model Usage（模型使用方式）​**
指 ​依赖XAI算法生成解释，再通过可视化呈现，具体分为：

​基于特征的XAI（Feature-based XAI）​
​目的：用XAI算法（如LIME、SHAP）计算特征重要性。
​例子：用SHAP值条形图显示影响房价预测的关键因素。
​基于规则的XAI（Rule-based XAI）​
​目的：提取模型的决策规则（如IF-THEN逻辑）。
​例子：用矩阵图展示规则列表（如“收入>50k且信用分>700 → 批准贷款”）。
​基于传播的XAI（Propagation-based XAI）​
​目的：分析模型内部的信息流动或贡献传播。
​例子：用LRP（层相关性传播）热图显示输入像素对分类的贡献度。
​**(2) vXAI的Visual Approaches（视觉方法）​**
指 ​呈现XAI解释结果的可视化技术，分为三类：

​数据表示（Data Representation）​
​方法：原始数据与解释叠加（如热图覆盖在图像上）、实例聚类。
​例子：在医学影像上用红色覆盖层显示病灶区域的SHAP贡献值。
​解释可视化（Explanation Views）​
​方法：特征重要性条形图、规则流程图、贡献传播路径图。
​例子：用瀑布图展示SHAP值如何将预测从基线值推至最终结果。
​交互功能（Interaction）​
​方法：动态调整解释范围、多模型对比、焦点区域缩放。
​例子：用户拖拽滑块调整LIME的扰动样本数量，实时更新热图。
​vXAI的核心特点
​依赖XAI算法​（如LIME、SHAP、规则提取）生成解释。
​关注模型决策逻辑​（为什么预测这个结果？哪些因素驱动了决策？）。

## 案例区分

**​案例1：分析CNN模型的特征关注区域**
​
- VI方法：
​
  - Model Usage：特征选择。
  - ​Visual Approach：热图直接显示卷积层的激活区域（如高亮狗头）。
  - ​工具：CNNVis、ActiVis。

- ​vXAI方法：
​
  - ​Model Usage：基于特征的XAI（如Grad-CAM）。
  - ​Visual Approach：用颜色覆盖层显示类激活热图。
  - ​工具：Grad-CAM、SHAP热图。





**​案例2：解释贷款审批模型的决策**

- VI方法：
​
  - ​Model Usage：性能分析。
  - ​Visual Approach：用桑基图展示不同收入群体的审批通过率。

- ​vXAI方法：
​
  - ​Model Usage：基于规则的XAI（如ANCHORS）。
  - ​Visual Approach：用矩阵图显示规则：“收入>50k且信用分>700 → 批准”。


**​案例3：理解Transformer模型的注意力机制**

- VI方法：
​
  - ​Model Usage：架构理解。
  - ​Visual Approach：用节点-链接图可视化自注意力头的连接权重。

- ​vXAI方法：
​
  - ​Model Usage：基于传播的XAI（如Integrated Gradients）。
  - ​Visual Approach：用热图显示输入词对翻译结果的贡献度。

