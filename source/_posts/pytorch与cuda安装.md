---
title: pytorch与cuda安装
date: 2023/11/24
categories:
  - AI
tags:
  - cuda
  - pytorch
mathjax: true
---

## CUDA、CUDNN相关的内容
一般来说，如果要使用CUDA，一共需要安装3个东西Nvidia驱动、CUDA、CUDNN。

CUDA看作是一个工作台，上面配有很多工具，如锤子、螺丝刀等。cuDNN是基于CUDA的深度学习GPU加速库，有了它才能在GPU上完成深度学习的计算。它就相当于工作的工具，比如它就是个扳手。但是CUDA这个工作台买来的时候，并没有送扳手。想要在CUDA上运行深度神经网络，就要安装cuDNN，就像你想要拧个螺帽就要把扳手买回来。这样才能使GPU进行深度神经网络的工作，工作速度相较CPU快很多。

但是我们经常只安装CUDA Driver，比如我们的笔记本电脑，安装个CUDA Driver就可正常看视频、办公和玩游戏了。

### Nvidia驱动

Nvidia驱动可以单独安装，也可以使用CUDA Toolkit Installer安装，CUDA Toolkit Installer通常会集成了GPU driver Installer和CUDA。
安装完成以后，使用```nvidia-smi```可以驱动是否安装成功。nvidia-smi 全称是 NVIDIA System Management Interface ，是一种命令行实用工具，旨在帮助管理和监控NVIDIA GPU设备。

### CUDA
可以使用命令行、官网下载脚本、CUDA Toolkit Installer。
**不过目前看下来，使用官网下载的.run脚本（这是cuda10.1的安装包cuda_10.1.105_418.39_linux.run）是最容易成功的，虽然比较费时间。这个脚本里面也包含了驱动安装，如果安装了驱动，就不要再安装了**


**安装的时候我曾经遇到过gcc版本过高的问题，并且无法直接使用命令行来降低版本。只能通过网上下载低版本的包，然后再安装**
安装后使用```nvcc -v```来看是否安装成功

### nvcc和nvidia-smi的关系
nvcc 属于CUDA的编译器，将程序编译成可执行的二进制文件，nvidia-smi 全称是 NVIDIA System Management Interface ，是一种命令行实用工具，旨在帮助管理和监控NVIDIA GPU设备。

CUDA有 runtime api 和 driver api，两者都有对应的CUDA版本， nvcc --version 显示的就是前者对应的CUDA版本，而 nvidia-smi显示的是后者对应的CUDA版本。

**如果使用了单独的GPU driver installer来安装GPU dirver，这样就会导致 nvidia-smi 和 nvcc --version 显示的版本不一致了。**

通常，**driver api的版本能向下兼容runtime api的版本，即 nvidia-smi 显示的版本大于nvcc --version 的版本通常不会出现大问题。**

### 如何选择与CUDA版本匹配的Pytorch
如果nvcc和nvidia-smi的版本不一致，应该如何选择pytorch的版本？
**选择与nvcc -v 对应的CUDA版本**


## pytorch安装

### cuda安装
[原链接](https://zhuanlan.zhihu.com/p/94220564)

桌面右键打开英伟达控制面板，点击帮助->系统信息->组件

可以看到支持的版本，安装的cuda版本必须小于等于该版本

安装好cuda后，安装cuDNN。
版本要和cuda对应起来

### miniconda和pytorch安装

[原链接](https://zhuanlan.zhihu.com/p/174738684)


[miniconda的镜像](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/)

要注意安装的是x86_64的版本，一开始装成的x86(32位，一直出问题)

安装pytorch的时候要进入[这里](https://pytorch.org/get-started/previous-versions/)。根据对应的cuda版本来下载，最然根据教程来验证是否安装成果。



### 安装jupyter notebook

安装jupyter notebook有三个办法：

**方法1：**
**为每一个 conda 环境 都安装 jupyter**

上面的安装好以后，使用```conda activate d2l```，激活d2l环境。
用```conda install jupyter```安装一直卡在那，换pip安装。但是还是因为网速原因没成功，可以使用临时换源的办法：

```
pip install jupyter -i https://pypi.tuna.tsinghua.edu.cn/simple
```



**方法2：**

在base环境安装好jupyter后

```
conda create -n my-conda-env                               # creates new virtual env
conda activate my-conda-env                                # activate environment in terminal
conda install ipykernel                                    # install Python kernel in new conda env
ipython kernel install --user --name=my-conda-env-kernel   # configure Jupyter to use Python kernel
```

然后在base环境运行jupyter，下面两种方式都可以切换环境

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/微信图片_20230315114520.png)

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/微信图片_20230315114528.png  )

**缺点是你新建一个环境，就要重复操作一次**

**方法3：**

```
conda activate my-conda-env    # this is the environment for your project and code
conda install ipykernel
conda deactivate

conda activate base      # could be also some other environment
conda install nb_conda_kernels
jupyter notebook
```

注意：这里的 ```conda install nb_conda_kernels``` 是在 base 环境下操作的。

然后就可以进行conda环境求换，方式和法2相同。

本人在使用方法3的时候遇到了问题，web端显示500，命令行显示的关键信息如下：



**ImportError: cannot import name 'contextfilter' from 'jinja2'**

最后的解决方法：
```
conda update nbconvert
```

### 导入torchvision出现错误

cuda和pythorch都安装成功的时候，且gpu也能正常使用。但是运行d2l里面的代码报错：
```
import torch 成功

import torchvision,报错

DLL:找不到模块
```

根据torch版本找到对应的torchvision，然后卸载torchvision再安装，显示没有这个版本。当时安装torch的时候，torchvision也安装了，且版本正确。

**解决办法：**
1. 先查看一下Pillow的版本
  
```
pip show Pillow
```

如果没有直接安装
```
pip install Pillow
```

如果有，先卸载
```
pip uninstall Pillow
```

再安装
```
pip install Pillow
```

然后检验torchvision是否正常
```
import torchvision
torchvision.__version__ #'0.8.2'
```