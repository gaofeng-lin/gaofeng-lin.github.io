---
title: Slurm 命令
date: 2022/9/11
categories:
  - Linux
tags:
  - Linux
  - 运维
  - Slurm
abbrlink: 34673
---

## 基础概念介绍
[原链接](http://events.jianshu.io/p/58973da3b659)
Slurm呢是一种脚本语言，是操作大型计算集群的脚本语言。
我们想象一下，如果我们很有钱，有个100台带带T100显卡的计算机组成的集群，我们怎么用呀？你可能会说，很简单呀就跑代码就是的。但是，请思考一下，如果我想同时用很多台计算机呢？那么这些计算机是不是要组成个局域网，然后我要写个代码协调这些计算机工作。是不是有点复杂了？

我们再想，如果这个集群我们希望能做大做强，不止给我一个人用，想给100个人，1000个人同时用，能行吗？这个时候自然还需要考虑协调用户的功能。这个协调用户包含很多东西，包括资源的分配，包括用户环境的安装等等。

是不是很复杂？这才哪到哪，我这还只是章口就来随便举的例子。真实的情况比这个要复杂的多得多，那我们怎么办？自己从头写代码来管理这个集群？显然不是，我们有专门的管理软件。这个管理软件呢不是我们今天的研究重点，我就不说了，我也不会哈哈哈哈。重点是如何使用这个管理软件，如何通过它来操作集群。我们呢正是通过slurm 脚本语言来控制这个管理软件的。

## 集群常用概念
**Resource**：资源，作业运行过程中使用的可量化实体，包括硬件资源（节点、内存、CPU、GPU）和软件资源（License）
**Cluster**：集群，包含计算、存储、网络等各种资源实体且彼此联系的资源集合，物理上一般由计算处理、互联通信、I/O存储、操作系统、编译器、运行环境、开发工具等多个软硬件子系统组成。
**Node**：节点，是集群的基本组成单位，从角色上一半可以划分为管理节点、登录节点、计算节点、存储节点等。
**job**：作业，物理构成，一组关联的资源分配请求，以及一组关联的处理过程。按交互方式，可以分为交互式作业和非交互式作业；按资源使用，可以分为串行作业和并行作业。
**queue**：队列，带名称的作业容器，用户访问控制，资源使用限制。
**Job Schedule System**：作业调度系统，负责监控和管理集群中资源和作业的软件系统。
**job step**：作业步，单个作业可以有多个作业步。
**partition**：分区，根据用户的权限，作业需要被提交到特定的分区中运行。
**tasks**：任务数，默认一个任务使用一个CPU核，可理解为job需要的CPU核数。

## Slurm常用命令
sbatch：提交作业脚本使其运行。
squeue：显示队列中的作业及作业状态。
scancel：取消排队或运行中的作业。
sinfo：显示节点状态。
scontrol：现实或设定slurm作业、队列、节点等状态。
salloc：为实时处理的作业分配资源：典型场景为分配资源并启动一个shell，然后用此shell执行srun命令去执行并行任务。
srun：交互式运行并行作业，一般用于短时间测试。

## Slurm作业提交
slurm 有三种模式提交作业，分别为交互模式，批处理模式，分配模式，这三种方式只是作业提交方式的区别，在管理、调度、机时计算同等对待。

### srun
```
srun -J JOBNAME -p debug -N 2 -c 1 -n 32 --ntasks-per-node=16 -w node[3,4] -x node[1,5-6] --time=dd-hh:mm:ss --output=file_name --error=file_name --mail-user=address --mail-type=ALL mpirun -n 64 ./iPic3D ./inputfile/test.inp
```

### sbatch

批处理作业是指用户编写作业脚本，指定资源需求约束，提交后台执行作业。提交批处理作业的命令为 sbatch，用户提交命令即返回命令行窗口，但此时作业在进入调度状态，在资源满足要求时，分配完计算结点之后，系统将在所分配的第一个计算结点（而不是登录结点）上加载执行用户的作业脚本。批处理作业的脚本为一个文本文件，脚本第一行以 “#!” 字符开头，并制定脚本文件的解释程序，如 sh，bash。

运行 sbatch filename 来提交任务；计算开始后，工作目录中会生成以 slurm 开头的.out 文件为输出文件（不指定输出的话）。

保存在运行程序目录下即可，文件名随意（可以无后缀，内容文本格式即可）；作业提交命令sbatch filename

简洁版:

确保 nodes * ntasks-per-node = ntasks

```
#!/bin/bash

#SBATCH -J test
#SBATCH -p g1_user
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH -o partition.out
```
详细版:


```
#!/bin/bash                     %指定运行shell
#提交单个作业
#SBATCH --job-name=JOBNAME      %指定作业名称
#SBATCH --partition=debug       %指定分区
#SBATCH --nodes=2               %指定节点数量
#SBATCH --cpus-per-task=1       %指定每个进程使用核数，不指定默认为1
#SBATCH -n 32       %指定总进程数；不使用cpus-per-task，可理解为进程数即为核数
#SBATCH --ntasks-per-node=16    %指定每个节点进程数/核数,使用-n参数（优先级更高），变为每个节点最多运行的任务数
#SBATCH --nodelist=node[3,4]    %指定优先使用节点
#SBATCH --exclude=node[1,5-6]   %指定避免使用节点
#SBATCH --time=dd-hh:mm:ss      %作业最大运行时长，参考格式填写
#SBATCH --output=file_name      %指定输出文件输出
#SBATCH --error=file_name       %指定错误文件输出
#SBATCH --mail-type=ALL         %邮件提醒,可选:END,FAIL,ALL
#SBATCH --mail-user=address     %通知邮箱地址

source /public/home/user/.bashrc   #导入环境变量文件

mpirun -n 32 ./iPic3D ./inputfiles/test.inp #运行命令
```


## 节点信息查看
```
sinfo									# 查看所有分区状态
sinfo -a 							    # 查看所有分区状态
sinfo -N								# 查看节点状态
sinfo -n node-name			            # 查看指定节点状态
sinfo --help					    	# 查看帮助信息

# 节点状态信息
alloc：节点满载
idle：节点空闲
mix：节点部分被占用
down：节点下线
drain：节点故障

```

## 作业列表查询
```
squeue				# 查看运行中作业列表
squeue -l 		# 查看列表细节信息
squeue -j job-id 	# 查看指定运行中的作业信息

# 作业状态
R：正在运行
PD：正在排队
CG：已完成
CD：已完成
```

## 作业信息查询
```
scontrol show job JOBID         #查看作业的详细信息
scontrol show node              #查看所有节点详细信息
scontrol show node node-name    #查看指定节点详细信息
scontrol show node | grep CPU   #查看各节点cpu状态
scontrol show node node-name | grep CPU #查看指定节点cpu状态
```

## 更新作业
作业提交后，但相关作业属性错误，取消任务修改作业后需要重新排队，在作业运行开始前可以使用scontrol更新作业的运行属性。
```
scontrol update jobid=JOBID ATTRIBUTE=INFO # ATTRIBUTE为下列属性名，INFO修改的属性值
partition=<name>
name=<name>
numcpus=<min_count-max_count>
numnodes=<min_count-max_count>
numtasks=<count>
reqnodelist=<nodes>
reqcores=<count>
nodelist=<nodes>
excnodelist=<nodes>
starttime=yyyy-mm-dd
timelimit=d-h:m:s
mincpusnode=<count>
minmemorycpu=<megabytes>
minmemorynode=<megabytes>
```

## 取消作业
```
scancel JOBID  # 终止作业
```