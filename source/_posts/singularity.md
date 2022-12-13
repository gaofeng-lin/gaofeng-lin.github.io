---
title: singularity
date: 2022/12/11
categories:
  - 运维
tags:
  - 运维
  - singularity
abbrlink: 23912
---

## def文件
如果我们要在singularity当中使用mpi，mpi需要加载环境变量才行。需要将用到的环境变量放到def文件中的%environment部分。

说一下%environment与%post的区别：
%environment里面的环境变量会在运行时加载；%post里面的环境变量会在build时加载

**官方给的mpich例子中的def文件中的%environment环境变量有误，需要更改其中的路径，否在会报错，找不到lib库。**

官方例子：
```
%environment
    # Point to MPICH binaries, libraries man pages
    export MPICH_DIR=/opt/mpich-3.3.2
    export PATH="$MPICH_DIR/bin:$PATH"
    export LD_LIBRARY_PATH="$MPICH_DIR/lib:$LD_LIBRARY_PATH"
    export MANPATH=$MPICH_DIR/share/man:$MANPATH
```
正确的例子：
```
%environment
    # Point to MPICH binaries, libraries man pages
    export MPICH_DIR=/opt/mpich
    export PATH="$MPICH_DIR/bin:$PATH"
    export LD_LIBRARY_PATH="$MPICH_DIR/lib:$LD_LIBRARY_PATH"
    export MANPATH=$MPICH_DIR/share/man:$MANPATH
```