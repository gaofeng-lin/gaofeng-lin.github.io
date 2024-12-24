---
title: C++命令
date: 2024/12/23
categories:
  - programming-language
tags:
  - cpp
abbrlink: '55264222'
---

## 构建流程

### 命令解释

| 阶段  | 功能                 | 输入       | 输出    | 对应命令                          |
|-----|--------------------|----------|-------|-------------------------------|
| 预处理 | 处理宏、条件编译、头文件插入     | .cpp文件   | .i文件  | g++ -E source.cpp -o source.i |
| 编译  | 翻译为汇编代码，检查语法和语义错误  | .i文件     | .s文件  | g++ -S source.i -o source.s   |
| 汇编  | 转换为机器指令，生成目标文件     | .s文件     | .o文件  | g++ -c source.s -o source.o   |
| 链接  | 合并目标文件和库文件，生成可执行程序 | .o文件，库文件 | 可执行文件 | g++ source.o -o program       |

**一般来说，我们不会这样每个步骤的执行，都是直接一步到位，以下面的命令为例：**

```
mpicxx -o svd_example svd_example.cpp \
    -I/usr/lib/slepc/include -I/usr/lib/petsc/include \
    -L/usr/lib/slepc/lib -L/usr/lib/petsc/lib \
    -Wl,-rpath=/usr/lib/slepc/lib -Wl,-rpath=/usr/lib/petsc/lib \
    -lpetsc -lslepc -lm -lblas -llapack -llapacke
```

1. mpicc: mpi的c++编译器
2. -o svd_example svd_example.cpp：编译的源文件为svd_example.cpp，输出的可执行程序名称为svd_example
3. -I/usr/lib/slepc/include -I/usr/lib/petsc/include: -I 表示“Include”，告诉编译器到这些路径下查找头文件。
4. -L/usr/lib/slepc/lib -L/usr/lib/petsc/lib： 表示“Library”，告诉编译器到这些路径下查找库文件。
5. -Wl,-rpath=/usr/lib/slepc/lib -Wl,-rpath=/usr/lib/petsc/lib： -Wl 表示将选项传递给链接器（ld）；-rpath 指定运行时库的搜索路径
6. -l 表示链接一个库，后面接库名，编译器会在指定路径中查找名为 lib<name>.so 或 lib<name>.a 的文件。
-lpetsc：链接 PETSc 库，用于数值计算和稀疏矩阵操作。


### -Wl,-rpath 的作用

-L的作用：
- -L<path> 告诉链接器在编译时到指定的路径中查找库文件（.so 或 .a）。
- 它只影响链接阶段，不会影响程序运行时的动态库加载。
- 在运行生成的可执行文件时，系统会根据动态链接器的默认规则查找动态库，默认的搜索路径包括：
  -   系统默认的库路径（如 /usr/lib，/lib）。
  - 环境变量 LD_LIBRARY_PATH 指定的路径。

-Wl,-rpath 的作用:
- -Wl,-rpath=<path> 告诉编译器将指定路径嵌入到可执行文件的运行时搜索路径中。
- 在运行时，动态链接器会优先在 rpath 中查找库文件，而不依赖 LD_LIBRARY_PATH 或默认的搜索路径。
- 优点：不需要用户设置额外的环境变量（如 LD_LIBRARY_PATH），即可确保可执行文件运行时找到所有依赖库。


是否必须使用 -Wl,-rpath：

- 如果系统默认路径能找到库文件：不需要 -Wl,-rpath。
  -   如果所有依赖库都在系统默认的路径（如 /usr/lib、/lib），只用 -L 即可，动态链接器能在运行时自动找到这些库。
- 如果库文件不在默认路径，且你不想设置 LD_LIBRARY_PATH：需要 -Wl,-rpath。
  - 当库文件位于非标准路径（如 /usr/local/lib 或用户自定义路径），运行时无法找到这些库时，-Wl,-rpath 是最方便的解决方案。

替代方案：
如果你不想使用 -Wl,-rpath，可以通过以下方式解决运行时找不到库的问题

- 设置环境变量：
```
export LD_LIBRARY_PATH=/usr/lib/slepc/lib:/usr/lib/petsc/lib:$LD_LIBRARY_PATH
```
- 使用ldconfig 添加路径：将非标准库路径添加到 /etc/ld.so.conf，然后运行 ldconfig 更新缓存。 缺点是需要管理员权限，对系统全局产生影响。

### 编译器VS链接器
- 编译器（如 g++）主要负责前 三 个阶段（预处理、编译、汇编）。
- 链接器（如 ld）负责最后的链接阶段，将目标文件和库文件整合为可执行文件。

### 库文件的作用

- 静态库（.a）：在链接阶段直接复制代码到可执行文件中。
- 动态库（.so 或 .dll）：在运行时加载，减少可执行文件的体积。


## 头文件

头文件一般形如：

```
#ifndef MFL_UTILITY_FUNCTIONS_H
#define MFL_UTILITY_FUNCTIONS_H

#include <string>

namespace mflow
{
    void PrintVersion(); 
}

#endif //~MFL_UTILITY_FUNCTIONS_H
```

1. #ifndef MFL_UTILITY_FUNCTIONS_H 和 #define MFL_UTILITY_FUNCTIONS_H

这是一种防止 头文件重复包含 的常见机制，叫做 include guard：

- #ifndef：检查 MFL_UTILITY_FUNCTIONS_H 宏是否未定义。
- #define：如果未定义，就定义MFL_UTILITY_FUNCTIONS_H 宏。

- #endif：对应于 #ifndef，表示 include guard 的结束。

2. namespace mflow
- 定义了一个名为 mflow 的命名空间（namespace）。
- 命名空间用于将代码进行逻辑分组，避免不同模块中名称冲突。
- 在 mflow 命名空间内，可以定义函数、类、变量等。