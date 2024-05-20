---
title: Linux知识点+问题
date: 2022/3/6
categories:
  - Linux
tags:
  - Linux
  - 运维
  - 持续集成
  - gcc
  - Linux权限用法
  - make&cmake
abbrlink: 54220
---

## 问题汇总
### error while loading shared libraries错误解决办法
**背景：求解器执行的适合报找不到libmpiexec.so.12这个东西，但是在/opt/mpich/lib下面有这个东西。路径什么的也都加入到了 环境变量里面 （~/.bash_profile或~/.bashrc）。还是无法解决问题**
[原文链接](https://blog.csdn.net/dumeifang/article/details/2963223?spm=1001.2101.3001.6650.1&depth_1-utm_relevant_index=2)
出现这类错误表示，系统不知道xxx.so放在哪个目录下，这时候就要在/etc/ld.so.conf中加入xxx.so所在的目录。

运行命令 `sudo gedit /etc/ld.so.conf` 在第一行后面空一格 添加/usr/local/lib 保存。运行`sudo /sbin/ldconfig`更新

### 新建用户之后不显示用户名和路径问题解决
先说一下如何新建用户并指定目录为根目录:
1. 新建用户，当前用户必须为root用户
```
useradd -d /home/cron/log -m bbee
```

-d指定目录文件夹

-m新账号名

-c comment 指定一段注释性描述。
-d 目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
-g 用户组 指定用户所属的用户组。
-G 用户组，用户组 指定用户所属的附加组。
-s Shell文件 指定用户的登录Shell。
-u 用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。

2. 设置密码
   ```passwd bbee```
接下来会提示你输入两次密码

**使用新用户登录的时候，出现了问题**
在Linux下新增的用户登录后只有一个$，没有显示用户名和主机名，如下：
```
$ cd ~    
$ ls
$ ls -a
```

原因是新建的用户未指定shell。我们只需将其指定为一个shell即可。下面提供两种办法：
**方法一（成功）**
查看下当前用户使用的是什么shell
```echo $SHELL```
查看系统支持shell类型
```cat /etc/shells```

使用usermod命令修改shell类型
```root@iZ2zeijeb6un95h:~# usermod -s /bin/bash bbee```

**方法二（为尝试）**

在新建用户的时候指定shell
```useradd -d /home/cron/log -s /bin/bash -m bbee```

## make命令
[原文链接](https://www.ruanyifeng.com/blog/2015/02/make.html)

## make 和 cmake
[原文链接](https://blog.csdn.net/KP1995/article/details/109569787)

### 什么是make
make工具可以看成是一个智能的批处理工具，它本身并没有编译和链接的功能，而是用类似于批处理的方式—通过调用makefile文件中用户指定的命令来进行编译和链接。

### 什么是Makefile
简单的说就像一首歌的乐谱，make工具就像指挥家，指挥家根据乐谱指挥整个乐团怎么样演奏，make工具就根据makefile中的命令进行编译和链接。makefile命令中就包含了调用gcc（也可以是别的编译器）去编译某个源文件的命令。makefile在一些简单的工程完全可以用人工手写，但是当工程非常大的时候，手写makefile也是非常麻烦的，如果换了个平台makefile又要重新修改。这时候就出现了Cmake工具。

### 什么是Cmake
cmake可以更加简单的生成makefile文件给上面那个make用。当然cmake还有其他功能，就是可以跨平台生成对应平台能用的makefile，你就不用再自己去修改了。cmake根据什么生成makefile呢？它又要根据一个叫CMakeLists.txt文件（学名：组态档）去生成makefile。到最后CMakeLists.txt文件谁写啊？亲，是你自己手写的。

当然如果你用IDE，类似VS这些一般它都能帮你弄好了，你只需要按一下那个三角形。

```bash
简单总结
cmake用来转译CMakeLists.txt，在linux下它会生成Makefile，来给make执行。

Makefile+make可理解为类unix环境下的项目管理工具， 而cmake是抽象层次更高的项目管理工具。
```

下面给出其关系图：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20201109214319194.png)


## CMake项目调试技巧

### 如何开启调试

很多大型C++项目都是通过CMake来构建项目，通过编译为可执行程序，然后运行。调试的话需要在CMakeLists.txt或者Config.txt中找到**Debug**这个选项，然后设置为ON。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2024-05-15_16-30-02.png)

然后运行的时候在命令中加入gdb

例如之前的命令是：
```mpirun -n 1 ./xxx```
现在是：
```mpirun -n 1 gdb ./xxx```

然后命令行前面会出现(gdb)这样的情况，代表进入了gdb调试。

### 打断点

先开始打断点，break xxx.cpp:200
上面的表示在xxx.cpp文件的200行处打断点

然后就可以输入run，然后回车。

c:继续
q:退出

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

## Linux 权限

### 目录、文件夹的权限如何分配
linux系统上面权限是一个很重要的问题，每一个目录(/opt,/home,/usr)权限到底该如何设置，什么时候使用sudo。

以单个用户(以yskj为例)为例，每一个用户自能在指定的目录拥有读、写、执行权限，不能访问别人的目录。一般来说是在/home/yskj/

/opt等目录拥有者和组几乎全是root。比如mpi在/opt，普通用户登录可以使用吗？答案是可以的。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/cfa86e15e98542dd9f83683b8ac5a85f.png)

上图看出两个事情。
1. 拥有者和组都是root
2. 其他用户（yskj）是拥有读和执行权限


### 使用者、目录、文件
[原文链接](https://blog.csdn.net/sinat_36118270/article/details/63683393)

首先，我们需要知道Linux中的权限是十分重要的，而且权限分为两类：一类是使用者的权限，一类是文件以及目录的是否可读、写、执行的权限。

 1. 拥有者–所属组–other

  首先很多人不明白这三个使用者的权限是什么意思。一般情况下，拥有者是这个文件的创建者，即哪个用户创建的这个文件。并且在创建新用户的时候会创建出一个同名的组，这个拥有者默认包含在这个所属组中。我们先来理一理这三者的联系去区别，对于初学者来说，我们可以把这三者想象成数学中的集合，拥有者是元素，整个Linux大环境是全集，而所属组是一个一个的小集合，看张图吧。
  ![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/df5e37bc8da24291985501de3a71f207.png)

拥有者就是一个一个的小红点，每个都在自己的所属组里，而且一个拥有者可以在多个所属组里。例如：1可以在所属组1，也可以在所属组2，也可以在所属组3…可以自定义设置。other就是对于所属组1来说，除所属组1中的所有拥有者外，其他的拥有者、所属组都是other。
　　值得注意的是，在Linux下，有一个超级用户–root，有全部的权限，凌驾一切之上。
　　下面是刚才所讲操作的具体命令：

```
## user1是生成的用户名

创建一个用户：useradd user

给他加上密码：password user1

删除一个用户：userdel user1

写作 userdel -r user1  时会删除user1上的文件

创建新增组：groupadd group1

删除组：groupdel group1

让user1用户归为usergroup1组：useradd -g usergroup1 user1

让user1用户也归为usergroup2组：useradd -G usergroup2 user1

切换用户：su user1
```
有时，可能我们会需要更改一个用户，或者更改一个所属组，以使其他拥有者或者其他所属组没有权限打开读写执行这个文件或目录。这时我们需要拥戴的命令是：

```
修改拥有者：chmod 用户名 文件名/目录名
   但注意：普通用户的操作命令要加上sudo chmod 用户名 文件名
sudo的作用是仅当前操作暂时为超级权限。当然，回车过后要输入当前拥有者的密码
修改所属组：普通用户--sudo chgrp 所属组名 文件名/目录名
```
Linux中，输入”ll”（小写L）或者”ls -l”可以显示文件的详细信息。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/1169c2fb3ee24cf7bc749ce312dfc6a4.png)



若sudo失败，则进入超级用户权限，再执行chown root test.c
sudo失败的原因，需要将用户添加进sudoers文件:
报错信息为：dlm is not in the sudoers file. This incident will be reported.
解决方法可以看我的另一篇博客：
http://blog.csdn.net/sinat_36118270/article/details/62899093

**2.读、写、执行**
　　Linux中，一个文件或目录的权限有四种
　　分别是无、读、写、执行权限
　　分别用“-”“r”“w”“x”表示
　　在文件列表中，使用”ll”或者”ls -l”命令查看文件详细信息，如图：

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/d56f4f128b6949d3b4707ec5dab42696.png)

一个文件或者目录前面共有10位前置字符，第一位表示文件类型，说到这，插一句，在Linux中可以认为“一切皆文件”，且Linux下文件不以文件后缀名区分，而是以第一个字符区分。在细分一下，文件分为:


```

普通文件：第一个字符为“ -  ”；

目录：第一个字符为“d”；---directory


链接文件：第一个字符为“l”，常见的有两类：软链接(相当于windows中的快捷方式)、硬链接；   ---link

设备和设备文件

　　块设备（硬盘）：第一个字符为“b”，最小单位为块（字节），支持随机访问。

　　字符设备（键盘，显示器）：第一个字符为“c”，最小单位为字节，只允许按顺序
读取。---char

套接字：第一个字符为“s”；---sockets

管道：第一个字符为“p”；---pine
```

图中所示，一个文件前有10个前缀字符，除第一个为文件类型外，剩下的9个都是文件的权限
　　三三一组，分别对应拥有者、所属组、other
　　即拥有者拥有三个权限，读写执行，所属组和other也相同
　　排列顺序为：读写执行
　　每个权限有则用对应的字母表示，无则使用“-”
　　例如：读写权限：“rw-”；写执行权限：“-wx”
　　且权限也可使用数字表示：每个位就相当于一个2进制数字，有此权限则为“1”，无则为“0”
　　例如：读写权限：“rw-”= 6；写执行权限：“-wx”= 3；
　　在命令输入时，更改拥有者的权限为“u (+/-) (r/w/x)”,括号是为了区分，“+”为增加权限，“-”为去除权限，还可对一个文件或者目录的不同权限修改“u+r-w+x”即为增加读、执行权限，去除写权限。
　　相关命令为：

```
首先，给定一个文件，默认权限为"rw- rw- r--",即为"664"

增加拥有者的执行权限：chmod u+x file(file为文件名)
                  chmod 764 file

增加other的写权限：chmod o+w file
                chmod 666 file

去除所属组的读权限：chmod o-r file
                chmod 624 file

增加拥有者的读权限，去除写。执行权限：chmod u+r-w-x file
                               chmod 464 file
```

那么对于目录呢？对于一个目录来说，照上图来看，也有拥有者、 所素组、other，而每一个也有自己的读、写、执行权限，有什么用呢？
　　目录的读权限决定进入这个目录后，使用“ls”、“ll”以及这个家族的命令是否可以显示该目录的内容；
　　目录的写权限决定进入这个目录后，是否可以使用“mkdir”创建目录，是否可以使用“touch”创建文件…;
　　目录的执行权限决定是否可以进入这个目录。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/0f4aa69a622d433392e9bbad7f6e347b.png)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/a0b3663e0d2b4875a0b233142dcf8ea4.png)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/7484fbcf90034a62801d298698bc0629.png)



那么，剩下的对于一个目录权限的多种操作就不用多少了吧。

**umask**
　　最后，还有个umask很重要，需要我们去理解记忆
　　umask是我们linux系统里面的默认权限的补集，一般在我们的系统中，umask=002。表示我们创建的文件的默认权限是664。
　　注意，我们创建的所有文件的默认权限为664，即“rw-rw-r–”。
　　不包含拥有者和所属组的执行权限以及other的写和执行权限。
　　所以我们要在更改umask后，计算文件权限时，基础上也不能加上拥有者和所属组的执行权限以及other的写和执行权限，除非更改的权限值给他们中的一个或多个赋上了相应的权限。
　　umask可以自己更改，直接敲出来umask “0xxx”就ok。此后，我们的权限就为“664-xxx”
　　
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/3de223ac270642e6a5781b23c68da8d1.png)

初始值为：“rw-rw-r–”即为“664”
　　我们设置的umask=032，即为“— -wx -w- ”,
　　因为二者是互补的关系，所以umask中出现的权限不能出现在新创建的文件中，又因为默认情况下新创建的文件没有拥有者和所属组的执行权限以及other的写和执行权限。
　　所以file_1的文件权限为：“rw- r– r–”。
### 文件权限符含义

1. 文件权限符以 d 开头的代表是文件夹
drwxrwxrwx

2. 文件权限符以 - 开头的代表是文件（包括硬链接文件，硬链接文件相当于原文件的备份，可以与原文件做到同步更新）也有可能是可执行程序
-rwxrwxrwx

3. 文件权限符以 l 开头的代表是软链接文件，软链接文件相当于原文件的快捷方式
4. 文件权限符以 c 开头的代表是字符设备文件，例：鼠标、键盘；
5. 文件权限符以 b 开头的代表是块设备文件，例：硬盘；

## gcc升级到最新版本
### Centos7
Centos 7默认gcc版本为4.8，有时需要更高版本的，这里以升级至8.3.1版本为例，分别执行下面三条命令即可，无需手动下载源码编译

1、安装centos-release-scl

```bash
sudo yum install centos-release-scl
```


2、安装devtoolset，注意，如果想安装7.*版本的，就改成devtoolset-7-gcc*，以此类推


```bash
sudo yum install devtoolset-8-gcc*
```


3、激活对应的devtoolset，所以你可以一次安装多个版本的devtoolset，需要的时候用下面这条命令切换到对应的版本


```bash
scl enable devtoolset-8 bash
```


大功告成，查看一下gcc版本


```bash
gcc -v
```


显示为 gcc version 8.3.1 20190311 (Red Hat 8.3.1-3) (GCC)

补充：这条激活命令只对本次会话有效，重启会话后还是会变回原来的4.8.5版本，要想随意切换可按如下操作。

首先，安装的devtoolset是在 /opt/rh 目录下的，如图

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/ffc7754914805bcf1ad41891e9405fa5.png)
每个版本的目录下面都有个 enable 文件，如果需要启用某个版本，只需要执行

```
source ./enable
```
所以要想切换到某个版本，只需要执行

```
source /opt/rh/devtoolset-8/enable
```
可以将对应版本的切换命令写个shell文件放在配了环境变量的目录下，需要时随时切换，或者开机自启

4、直接替换旧的gcc
旧的gcc是运行的 /usr/bin/gcc，所以将该目录下的gcc/g++替换为刚安装的新版本gcc软连接，免得每次enable

```
mv /usr/bin/gcc /usr/bin/gcc-4.8.5

ln -s /opt/rh/devtoolset-8/root/bin/gcc /usr/bin/gcc

mv /usr/bin/g++ /usr/bin/g++-4.8.5

ln -s /opt/rh/devtoolset-8/root/bin/g++ /usr/bin/g++

gcc --version

g++ --version
```

## 分区+挂载
### 分区
详细信息：[来源该博客](https://blog.csdn.net/qq_30604989/article/details/81163270)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/edd06e4319f24f1092d6f7bba9955937.png)

 1. 在linux下，一个硬盘要先分区，然后才能挂载到目录上。和windows相同。
 
 ![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/a8ef1355fa2f4595a7b69da0b0bb50ec.png)


**问题：如何确定文件或目录在那个磁盘分区？**

```
df -h /home
df -h /home/test.txt
```

通过上面的命令就可以看出文件或目录是在那个磁盘分区里面

![](https://s2.loli.net/2022/05/19/8UEfapmwxb6zjSu.png)

### 挂载
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/0189f5afb0f24dde85c540fc5b8c887f.png)

```
fdisk /dev/sdb
```
这一步是对sdb这个磁盘分区。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/bde5f9eba20b477bbeb551a9cb4bc246.png)
接下来是格式化：

```
mkfs -t ext4 /dev/sdb1
```

挂载：将分区和目录联系起来

```
mount 设备名 目录名
```
   
```
mount /dev/sdb1 /home/newdisk
```

这个方法重启会失效，设置永久挂载。

```
vim /etc/fstab
```
### 解除挂载

```
umount 设备名
```

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/d9ca57a5c9bf44589498a26a8baea9e5.png)


## 远程调用shell脚本找不到库

[原文链接1](http://t.zoukankan.com/GatsbyNewton-p-4776682.html)
[原文链接2](https://feihu.me/blog/2014/env-problem-when-ssh-executing-command-on-remote/#userconsent#)

背景：本地把服务编译完成，通过git bash传到服务器，然后ssh调用服务器上写好的脚本，显示找不到某个库（以安装）。以mobaxterm方式登录服务器，执行脚本没有问题。

原因：配置文件没有被加载

解决方法：
1. 在Remote机上的shell脚本的开头重新配置“需要用到”的环境变量（本文所遇到的是mpi的一个库）
2. 在Remote shell的开头设置，用source使.basn_profile文件生效

## shell脚本中export无效的原分析和解决方法
[原链接](https://blog.csdn.net/fadai1993/article/details/109085231)

### 问题场景：shell脚本中的export怎么都无法起作用

测试需要导入大量临时的环境变量，单个export又比较麻烦，因此创建shell脚本简化场景：
```
#!bin/bash  
export PATH=$PATH:/usr/lib/java/jre  
export PATH=$PATH:/usr/lib/java/bin 
```

就这么个系统环境变量配置，通过./path.sh 或者 sh path.sh怎么执行都无法设置成功，为什么单独执行export一点问题都没有，但是写到shell脚本中执行，export却怎么都不起作用？

### 原因

1. shell是一个进程，每个进程拥有独立的存储空间，进程间数据不可见
一个shell中的系统环境变量（用export定义的变量）只会对当前shell或者他的子shell有效，该shell结束之后，变量生命周期结束（并不能返回到父shell中）
2. export定义的变量，对当前shell及子shell有效；不用export定义的变量，仅对本shell有效
3. 执行脚本时，是创建了一个新的子shell进程运行，脚本执行完成后，该子shell进程自动退出
因此，子shell中定义的系统环境变量是无法作用于父shell的。

### 解决办法
上文可知，父shell可将自己的环境变量写入子shell，但子shell无法将自己空间中的数据写入父shell（至少export不行），如何达到我们的需求，那就不要创建子shell，仅导入shell文件内的内容
```
. path.th
```

或者
```
source path.th
```
### “.”、“source”、“sh”、“./”、“export”的区别

1. source 同“.”， 用于使shell读入指定的shell文件，并依次执行文件中的所有语句（当前shell）
2. sh 创建一个子shell，继承父shell的环境变量，同时在子shell中执行脚本里面的语句
3. ./ 当脚本文件具有可执行属性时，与sh无异，./filename是因为当前目录并未在PATH中
4. export 设置或显示环境变量，临时作用于当前shell