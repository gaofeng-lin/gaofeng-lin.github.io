---
title: Linux知识点
date: 2022/3/6
categories:
  - Linux
  
tags:
  - Linux
  - 运维
  - 持续集成
  - gcc
  - Linux权限用法
---

# Linux 权限的简单用法（使用者、目录、文件）
[原文链接](https://blog.csdn.net/sinat_36118270/article/details/63683393)

首先，我们需要知道Linux中的权限是十分重要的，而且权限分为两类：一类是使用者的权限，一类是文件以及目录的是否可读、写、执行的权限。

 1. 拥有者–所属组–other

  首先很多人不明白这三个使用者的权限是什么意思。一般情况下，拥有者是这个文件的创建者，即哪个用户创建的这个文件。并且在创建新用户的时候会创建出一个同名的组，这个拥有者默认包含在这个所属组中。我们先来理一理这三者的联系去区别，对于初学者来说，我们可以把这三者想象成数学中的集合，拥有者是元素，整个Linux大环境是全集，而所属组是一个一个的小集合，看张图吧。
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/df5e37bc8da24291985501de3a71f207.png)

拥有者就是一个一个的小红点，每个都在自己的所属组里，而且一个拥有者可以在多个所属组里。例如：1可以在所属组1，也可以在所属组2，也可以在所属组3…可以自定义设置。other就是对于所属组1来说，除所属组1中的所有拥有者外，其他的拥有者、所属组都是other。
　　值得注意的是，在Linux下，有一个超级用户–root，有全部的权限，凌驾一切之上。
　　下面是刚才所讲操作的具体命令：

```
# user1是生成的用户名

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
![在这里插入图片描述](https://img-blog.csdnimg.cn/1169c2fb3ee24cf7bc749ce312dfc6a4.png)
6e.png)



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

![在这里插入图片描述](https://img-blog.csdnimg.cn/d56f4f128b6949d3b4707ec5dab42696.png)

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

![在这里插入图片描述](https://img-blog.csdnimg.cn/0f4aa69a622d433392e9bbad7f6e347b.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/a0b3663e0d2b4875a0b233142dcf8ea4.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/7484fbcf90034a62801d298698bc0629.png)



那么，剩下的对于一个目录权限的多种操作就不用多少了吧。

**umask**
　　最后，还有个umask很重要，需要我们去理解记忆
　　umask是我们linux系统里面的默认权限的补集，一般在我们的系统中，umask=002。表示我们创建的文件的默认权限是664。
　　注意，我们创建的所有文件的默认权限为664，即“rw-rw-r–”。
　　不包含拥有者和所属组的执行权限以及other的写和执行权限。
　　所以我们要在更改umask后，计算文件权限时，基础上也不能加上拥有者和所属组的执行权限以及other的写和执行权限，除非更改的权限值给他们中的一个或多个赋上了相应的权限。
　　umask可以自己更改，直接敲出来umask “0xxx”就ok。此后，我们的权限就为“664-xxx”
　　
![在这里插入图片描述](https://img-blog.csdnimg.cn/3de223ac270642e6a5781b23c68da8d1.png)

初始值为：“rw-rw-r–”即为“664”
　　我们设置的umask=032，即为“— -wx -w- ”,
　　因为二者是互补的关系，所以umask中出现的权限不能出现在新创建的文件中，又因为默认情况下新创建的文件没有拥有者和所属组的执行权限以及other的写和执行权限。
　　所以file_1的文件权限为：“rw- r– r–”。

# gcc升级到最新版本
## Centos7
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

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/ffc7754914805bcf1ad41891e9405fa5.png#pic_center)
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

# 分区+挂载
## 分区
详细信息：[来源该博客](https://blog.csdn.net/qq_30604989/article/details/81163270)
![在这里插入图片描述](https://img-blog.csdnimg.cn/edd06e4319f24f1092d6f7bba9955937.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

 1. 在linux下，一个硬盘要先分区，然后才能挂载到目录上。和windows相同。
 
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/a8ef1355fa2f4595a7b69da0b0bb50ec.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 挂载
![在这里插入图片描述](https://img-blog.csdnimg.cn/0189f5afb0f24dde85c540fc5b8c887f.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

```
fdisk /dev/sdb
```
这一步是对sdb这个磁盘分区。
![在这里插入图片描述](https://img-blog.csdnimg.cn/bde5f9eba20b477bbeb551a9cb4bc246.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
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
## 解除挂载

```
umount 设备名
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/d9ca57a5c9bf44589498a26a8baea9e5.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)