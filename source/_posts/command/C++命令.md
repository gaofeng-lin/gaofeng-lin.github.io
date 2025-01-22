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


## cmake、make、Makefile

### 基本概念

- cmake

- make
make工具可以看成是一个智能的批处理工具，它本身并没有编译和链接的功能，而是用类似于批处理的方式—通过调用makefile文件中用户指定的命令来进行编译和链接。

- Makefile
简单的说就像一首歌的乐谱，make工具就像指挥家，指挥家根据乐谱指挥整个乐团怎么样演奏，make工具就根据makefile中的命令进行编译和链接。makefile命令中就包含了调用gcc（也可以是别的编译器）去编译某个源文件的命令。makefile在一些简单的工程完全可以用人工手写，但是当工程非常大的时候，手写makefile也是非常麻烦的，如果换了个平台makefile又要重新修改。这时候就出现了Cmake工具。

- cmake
cmake可以更加简单的生成makefile文件给上面那个make用。当然cmake还有其他功能，就是可以跨平台生成对应平台能用的makefile，你就不用再自己去修改了。cmake根据什么生成makefile呢？它又要根据一个叫CMakeLists.txt文件（学名：组态档）去生成makefile。CMakeLists.txt目前可以由IDE，类似VS这些一般它都能帮你弄好了。

```bash
简单总结
cmake用来转译CMakeLists.txt，在linux下它会生成Makefile，来给make执行。

Makefile+make可理解为类unix环境下的项目管理工具， 而cmake是抽象层次更高的项目管理工具。
```

下面给出其关系图：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20201109214319194.png)


### cmake相关问题

一般来说，如果是在一个已有的项目上进行更改，这个项目之前能顺利编译，更改后无法编译，一般来说是没有找到相关的库或者头文件，或者没有链接到库。

这些既可以在CMakeLists.txt里面指出，也可以在终端里面指出，具体的命令可以用


### make命令
[原文链接](https://www.ruanyifeng.com/blog/2015/02/make.html)

### make 和 cmake
[原文链接](https://blog.csdn.net/KP1995/article/details/109569787)

### ccmake

ccmake是CMake提供的一个图形化配置工具，帮助你配置CMake项目，，选择编译选项、设置变量，并生成构建系统。

### 命令分析

1. ccmake -GNinja ..

- -G
-G是CMake中的一个选项，用来指定生成构建系统的生成器。
生成器决定了 CMake 会生成哪种类型的构建系统文件。常见的生成器包括 Unix Makefiles、Ninja、Visual Studio 等。
在这个命令中，-G后面跟随的是Ninja，这表示 CMake 会使用 Ninja 构建工具来生成构建系统。


## CMake项目调试技巧（gdb调试技巧）

### 如何开启调试

很多大型C++项目都是通过CMake来构建项目，通过编译为可执行程序，然后运行。调试的话需要在CMakeLists.txt或者Config.txt中找到**Debug**这个选项，然后设置为ON。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-05-15_16-30-02.png)

然后运行的时候在命令中加入gdb

如果有的例子没有上面的这种写法，需要自己在cmake的时候添加命令。例如，当前在build目录下，CMakeLists在上一级目录。
```cmake -DCMAKE_BUILD_TYPE=Debug ..```

也可以通过```cmake -L ..``` 列出当前项目支持的选项

### gdb如何运行

**情况一：**


例如之前的命令是：
```mpirun -n 1 ./xxx```
现在是：
```mpirun -n 1 gdb ./xxx```

然后命令行前面会出现(gdb)这样的情况，代表进入了gdb调试。

**情况二**

有的程序在运行的时候需要参数才能运行，例如：

```./Temporal_Advection /home/zhpe/lgf/vtk-m-v2.2.0/data/data/rectilinear/DoubleGyre_0.vtk 0.0 /home/zhpe/lgf/vtk-m-v2.2.0/data/data/rectilinear/DoubleGyre_5.vtk 5.0 velocity 500 0.025 pathlines.vtk```


这个时候要使用gdb，有两种方法：

方法1：
启动gdb：```gdb ./Temporal_Advection```

设置运行参数：```set args /home/zhpe/lgf/vtk-m-v2.2.0/data/data/rectilinear/DoubleGyre_0.vtk 0.0 /home/zhpe/lgf/vtk-m-v2.2.0/data/data/rectilinear/DoubleGyre_5.vtk 5.0 velocity 500 0.025 pathlines.vtk```

运行程序：```run```

方法2：
```gdb --args ./Temporal_Advection /home/zhpe/lgf/vtk-m-v2.2.0/data/data/rectilinear/DoubleGyre_0.vtk 0.0 /home/zhpe/lgf/vtk-m-v2.2.0/data/data/rectilinear/DoubleGyre_5.vtk 5.0 velocity 500 0.025 pathlines.vtk```


### 打断点

先开始打断点，break xxx.cpp:200
上面的表示在xxx.cpp文件的200行处打断点

然后就可以输入run，然后回车。

c:继续
q:退出
step:进入这个函数中

### 监控变量

在大型项目中，如果想知道变量的变化情况，可以输入watch
```
(gdb) watch variable_name
```
在程序还没开始运行的时候，可能会出错。可以在断点处停下后，再设置。

**如果这个变量发生变化，也可以看到在哪个代码文件发生变化，很有用**


查看监控变量情况以及删除：
```
(gdb) info watchpoints
(gdb) delete watchpoint_number // 例如：(gdb) delete watchpoint 2 ，删除编号为2的监视点
(gdb) delete watchpoints //删除所有的监视点
```


简单的查看可以通过print 来查看变量的值 

例如：print res[0][1]



### 查看调用栈
代码之间相互调用，想知道调用顺序。

当程序停在断点处时。
```
(gdb) backtrace
```





## ./configure && make && make install
### ./configure
源码的安装一般由3个步骤组成：**配置(configure)、编译(make)、安装(make install)**。

configure文件是一个可执行的脚本文件,是用来检测你的安装平台的目标特征的。比如它会检测你是不是有CC或GCC，并不是需要CC或GCC.
它有很多选项，在待安装的源码目录下使用命令`./configure –help`可以输出详细的选项列表。

其中--prefix选项是配置安装目录，如果不配置该选项，安装后可执行文件默认放在/usr /local/bin，库文件默认放在/usr/local/lib，配置文件默认放在/usr/local/etc，其它的资源文件放在/usr /local/share，比较凌乱。

如果配置了--prefix，如：

$ ./configure --prefix=/usr/local/test

安装后的所有资源文件都会被放在/usr/local/test目录中，不会分散到其他目录。

使用--prefix选项的另一个好处是方便卸载软件或移植软件；当某个安装的软件不再需要时，只须简单的删除该安装目录，就可以把软件卸载得干干净净；而移植软件只需拷贝整个目录到另外一个机器即可（相同的操作系统下）。

当然要卸载程序，也可以在原来的make目录下用一次make uninstall，但前提是Makefile文件有uninstall命令（nodejs的源码包里有uninstall命令，测试版本v0.10.35）。

**关于卸载：**
如果没有配置--prefix选项，源码包也没有提供make uninstall，则可以通过以下方式可以完整卸载：

找一个临时目录重新安装一遍，如：
$ ./configure --prefix=/tmp/to_remove && make install

然后遍历/tmp/to_remove的文件，删除对应安装位置的文件即可（因为/tmp/to_remove里的目录结构就是没有配置--prefix选项时的目录结构）。

### make 
make 是用来编译的，它从Makefile中读取指令，然后编译。可以使用多核来make。`make -j2`
如果是8核，那就用make -j8。
这一步就是编译，大多数的源代码包都经过这一步进行编译（当然有些perl或python编写的软件需要调用perl或python来进行编译）。如果 在 make 过程中出现 error ，你就要记下错误代码（注意不仅仅是最后一行），然后你可以向开发者提交 bugreport（一般在 INSTALL 里有提交地址），或者你的系统少了一些依赖库等，这些需要自己仔细研究错误代码。

可能遇到的错误：make *** 没有指明目标并且找不到 makefile。 停止。问题很明了，没有Makefile，怎么办，原来是要先./configure 一下，再make。

### make install
可以使用多核安装 make -j2 install

这条命令来进行安装（当然有些软件需要先运行 make check 或 make test 来进行一些测试），这一步一般需要你有 root 权限（因为要向系统写入文件）。

这个命令用与安装，可以携带一个参数。`PREFIX=/home/lgf`
表示安装路径，在安装mpi的时候出现过这个参数。

## 虚函数和纯虚函数

参考链接：https://www.cnblogs.com/dijkstra2003/p/17254053.html

在 C++ 中，虚函数（virtual function）是一个可以被子类重写的成员函数，而纯虚函数（pure virtual function）是一个在基类中声明的虚函数，但不会在基类中实现，而是要求派生类中实现的函数。

区别如下：

1. 虚函数是有实现的，而纯虚函数没有实现。虚函数在基类中有默认实现，子类可以重写它，也可以不重写，但纯虚函数必须在子类中实现。

2. 如果一个类中包含至少一个纯虚函数，那么这个类就是抽象类，不能直接实例化对象。而虚函数不会强制一个类成为抽象类。

3. 调用纯虚函数会导致链接错误，除非在派生类中实现该函数。而虚函数可以被调用，如果派生类没有重写该函数，将调用基类的实现。

4. 纯虚函数可以为接口提供一个规范，子类必须实现这些接口。而虚函数则允许子类通过重写来扩展或修改父类的实现。

5. 纯虚函数只能在抽象类中声明，而虚函数可以在任何类中声明

例如，考虑一个基类 Shape，它定义了一个纯虚函数 getArea()，用于计算形状的面积。Shape 类不能直接实例化，因为它是一个抽象类，没有提供 getArea() 函数的具体实现。相反，派生类如 Circle 和 Rectangle 必须实现 getArea() 函数以提供具体的实现，并且可以实例化对象。

```
class Shape {
public:
    virtual double getArea() = 0; // 纯虚函数
};

class Circle : public Shape {
public:
    Circle(double r) : radius(r) {}
    double getArea() { return 3.14 * radius * radius; }

private:
    double radius;
};

class Rectangle : public Shape {
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    double getArea() { return width * height; }

private:
    double width;
    double height;
};

int main() {
    // Shape s; 不能直接实例化
    Circle c(5);
    Rectangle r(4, 6);
    cout << "Circle area: " << c.getArea() << endl;
    cout << "Rectangle area: " << r.getArea() << endl;
    return 0;
}
```

下面定义了一个 Shape 类，它包含一个虚函数 getArea()，该函数计算图形的面积。Circle 和 Rectangle 类派生自 Shape 类，并重写 getArea() 函数以提供自己的具体实现

同时，因为是虚函数，因此Shape并不是抽象类，可以被实例化，并且其getArea()可以被调用：

```
#include <iostream>
using namespace std;

class Shape {
public:
    virtual double getArea() {
        cout << "Shape::getArea() called!" << endl;
        return 0;
    }
};

class Circle : public Shape {
public:
    Circle(double r) : radius(r) {}
    double getArea() {
        cout << "Circle::getArea() called!" << endl;
        return 3.14 * radius * radius;
    }

private:
    double radius;
};

class Rectangle : public Shape {
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    double getArea() {
        cout << "Rectangle::getArea() called!" << endl;
        return width * height;
    }

private:
    double width;
    double height;
};

int main() {
    Shape* pShape = new Shape();
    Circle* pCircle = new Circle(5);
    Rectangle* pRect = new Rectangle(4, 6);

    pShape->getArea();
    pCircle->getArea();
    pRect->getArea();

    delete pShape;
    delete pCircle;
    delete pRect;

    return 0;
}
```