---
title: latex公式
date: 2025/03/17
categories:
  - latex
tags:
  - latex
  - Linux
  - 运维
  - 代码管理
mathjax: true
abbrlink: 47c30637
---

# 说明

$\operatorname{AssDis}(P,{\mathcal{S}};{\mathcal{X}})=\left[{\frac{1}{L}}\sum_{l=1}^{L}\left(\operatorname{KL}(P_{i,}^{l}\|{\mathcal{S}}_{i,}^{l})+\operatorname{KL}(S_{i,}^{l}\|P_{i,}^{l})\right)\right]_{i=1,\cdots,N}$

${\mathcal{L}}_{Total}(\hat{\mathcal{X}},{\mathcal{P}},{\mathcal{S}},{\lambda};\mathcal{X})=\||{\mathcal{X}}-\hat{\mathcal{X}}\||_{\mathrm{F}}^{2}-\lambda\times\||\mathrm{AssDis}({\mathcal{P}},{\mathcal{S}};\mathcal{X})\||_{1}$

$\mathrm{Minimize\ Phase:\ }\mathcal{L}_{Total}\left(\hat{\mathcal{X}},\mathcal{P},\mathcal{S}_{\mathrm{detach}},-\lambda;\mathcal{X}\right)$

$\mathrm{Maximize\ Phase:\ }\mathcal{L}_{Total}\left(\mathcal{X},\mathcal{P}_{\mathrm{detach}},\mathcal{S},\lambda;\hat{\mathcal{X}}\right)$

${\mathcal{L}}_{Total}(\hat{\mathcal{X}},\mathcal{P},\mathcal{S}_{\mathrm{\mathcal{d}\mathcal{e}\mathcal{t}\mathcal{a}\mathcal{c}\mathcal{h}\ }},-\lambda;\mathcal{X})=\||{\mathcal{X}}-\hat{\mathcal{X}}\||_{\mathrm{F}}^{2}-(-\lambda)\cdot\mathrm{AssDis}(P,S;\mathcal{X})$

${\mathcal{L}}_{Total} = 重构误差 + \lambda \cdot 关联差异$


${\mathcal{L}}_{Total}(\hat{\mathcal{X}},\mathcal{P}_{\mathrm{\mathcal{d}\mathcal{e}\mathcal{t}\mathcal{a}\mathcal{c}\mathcal{h}\ }},\mathcal{S},\lambda;\mathcal{X})=\||{\mathcal{X}}-\hat{\mathcal{X}}\||_{\mathrm{F}}^{2}-\lambda\cdot\mathrm{AssDis}(P,S;\mathcal{X})$

${\mathcal{L}}_{Total} = 重构误差 - \lambda \cdot 关联差异$

