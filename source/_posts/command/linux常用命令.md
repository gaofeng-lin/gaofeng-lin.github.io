---
title: Linux常用命令
date: 2022/3/6
categories:
  - Linux
tags:
  - Linux
  - 运维
  - ssh
  - Vim
abbrlink: 48230
---


## 修改权限
### 修改文件用户组
chgrp： change group的简写，修改文件所属的用户组。
```
chgrp users test.log
```

如果要修改该目录下所有文件和目录，使用-R参数。
```
chgrp -R users test
```

### 修改文件所有者
chown ：change owner的简写， 修改文件的所有者。
```
chown [-R] 账号名称  文件或目录
```

将所有者和组名称都修改为root。
```
chown root:root test.log
```
### 修改文件权限
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/f08c5be5513c4aea88cb3c13b3a2b3d7.png)

## 运行sh文件命令
**第一种（这种办法需要用chmod使得文件具备执行条件(x): chmod u+x datelog.sh）：**

```
/xx/xxx/xxx.sh   //任意路径 

./XXX.sh  //当前路径
```
**第二种（这种办法不需要文件具备可执行的权限也可运行）：**

```
sh xxx.sh
```

## 解压缩命令
### ZIP

```
zip [选项] 压缩包名 源文件或源目录
-r：压缩目录

示例：
zip ana.zip anaconda-ks.cfg

压缩多个文件：
zip test.zip abc abcd
```

```
zip对应的解压缩命令为unzip：命令所在目录为/usr/bin/unzip，所有用户可执行
unzip [选项] 压缩包名
-d：指定解压缩位置
-o:不必先询问用户，unzip执行后覆盖原有文件。
//其它参数可自行查看

unzip -d /tmp/ test.zip
unzip -d /tmp -o test.zip //这条命令和上一条相比，可以不用询问直接覆盖
```

### gz
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604225601664.png)
注意：使用gzip压缩文件后会将原文件删除，如果想保留原文件则可以使用-c选项将压缩过程产生的标准输出写入一个新的文件中，示例如下：>的作用是覆盖内容，>>的作用是追加内容
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604230304985.png)
压缩目录下的每个文件：下述命令会将123这个目录下的每个文件分别进行压缩，而不是将整个123目录进行压缩，也就是说**gzip命令不会打包压缩**

解压缩也可以使用gunzip：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604225930966.png)

### bz2
.bz2格式是Linux中的另一种常用压缩格式，该格式的压缩算法更先进，压缩比更高，但是压缩的时间要比.gz长，.bz2格式的压缩命令是bzip2，**注意bzip2不能压缩目录，会报错**

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604231244456.png)
解压时如果原文件已存在则会报错，因此最好先将原文件删除

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604231835998.png)
### tar
**只是打包并不会压缩文件，.gz，.xz。这些才是压缩**
.tar格式的打包和解打包都是使用tar命令，区别只是选项不同
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604232717559.png)
打包示例：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604232744240.png)
打包多个文件：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604232921456.png)
解打包：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604232957741.png)

### .tar.gz和.tar.bz2
**tar 压缩、解压缩都可以使用多线程**

.tar.gz格式和.tar.bz2格式：使用tar命令后跟选项的方式实现tar命令和gzip或者bzip2命令的组合，实现同时进行打包和压缩，这也是最经常使用的压缩和解压缩方式
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604233644257.png)

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604233704887.png)

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604234051220.png)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20190604234541328.png)

### .tar.xz
默认压缩后的文件后缀为 xz，速度慢一些，但是压缩的会更小。

```bash
//常用参数
-z	强制执行压缩, 默认不保留源文件。压缩后的文件名为源文件.xz
-d	强制执行解压缩
-l	列出压缩文件的信息
-k	保留源文件不要删除
-f	强制覆盖输出文件和压缩链接
-c	写入到标准输出，输入文件不要删除
-0..-9	压缩比例，默认为6
-e  使用更多的 CPU time 来进行压缩，提高压缩率。不会影响解压时所需要的内存。
-T  指定线程数，默认是 1 ，当设置为 0 时使用和机器核心一样多的线程。
--format=  指定压缩输出格式，可以是 raw、xz、lzma
-v	显示更详细的信息
```
注意点： 压缩后的文件时在和源文件同一个目录。当我们压缩的文件为 /home/nginx/logs/error.log-20191126 ，当我们在任意目录执行完 xz /home/nginx/logs/error.log-20191126 后，压缩后的文件路径是 /home/nginx/logs/error.log-20191126.xz.

```bash
//不保留源文件
xz   /home/nginx/logs/error.log-20191126

//保留源文件
xz -k /home/nginx/logs/error.log-20191126

//解压缩文件
xz -d  /home/nginx/logs/error.log-20191126.xz

//指定多线程数来进行压缩
xz -T 4  /home/nginx/logs/error.log-20191126
```

## 查询或查看命令汇总

### 查看某个软件对应的软连接
```
ls -l "xxxx"
```
使用```ls -al```也可也，那就是查看整个目录下面的。

### which 与 whereis
which和whereis命令都是Linux操作系统下查找可执行文件路径的命令

#### which
这条命令主要是用来查找系统***PATH目录下***的可执行文件。说白了就是查找那些我们已经安装好的可以直接执行的命令，比如
```
swq123459@swq123459PC:~$ which ls
/bin/ls
```
注意上述斜体字， which 查找的可执行文件，必须是要在 PATH 下的可执行文件，而不能是没有加入 PATH 的可执行文件，即使他就是可执行文件，但是没有加入到系统搜索路径，他仍然无法被 which 发现（好吧，有点啰嗦了）。

#### whereis
这个命令可以用来查找二进制（命令）、源文件、man文件。与which不同的是这条命令可以是通过文件索引数据库而非PATH来查找的，所以查找的面比which要广。例如：
```
swq123459@swq123459PC:~$ whereis ls
ls: /bin/ls
 /usr/share/man/man1/ls.1.gz
```
可以看到，whereis不仅找到了 ls 可执行文件的位置，还找到了其 man 帮助文件，可见其搜索范围比较广，不局限于PATH。

### 查看某个进程或者服务是否存在
```
ps -aux ｜ grep xxx
```

### 查找文件及文件夹

```
find的主要用来查找文件，查找文件的用法我们比较熟悉，也可用它来查找文件夹，用法跟查找文件类似，只要在最后面指明查找的文件类型 -type d,如果不指定type类型，会将包含查找内容的文件和文件夹一起输出。

find基本语法如下：

find [PATH] [Option] [action]

-newer file:file为一个存在的文件，列出比file还要新的文件名

find / -mtime 0———0代表当前的时间，即从现在开始到24小时前，有改动过内容的文件都会被列出来

find /etc -newer /etc/passwd———寻找/etc下面的文件，如果文件日期比/etc/passwd新就列出

find / -name file——/代表全文搜索

find /home -user Anmy——查找/home下属于Anmy的文件

find / -nouser—— 查找系统中不属于任何人的文件，可以轻易找出那些不太正常的文件

find / -name passed—— 查找文件名为passed的文件
```

若不指定查找类型，使用命令：find / -name AnmyTest 则会将目录和文件一同输出
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20180918104346399.png)
若指定查找类型，使用命令：find / -name AnmyTest -type d 则只会将目录输出
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20180918104448278.png)


### 查看文件最后几行
```
//显示filename最后20行。
tail -n 20 filename
```


###  查看端口
####  查看某个服务的状态

```
service ‘servicename’ status
//centos7以上用 systemctl
```

例子

```
service sshd status //查看sshd服务的状态，可以看到它的进程号，如果不需要可以kill 杀死
```

####   lsof -i:端口号 
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/76c06a2619c04918af8a7331869739fd.png)
可以看到 8000 端口已经被轻 nodejs 服务占用。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/a9bdaa252c8c4083baf16c1e664416ac.png)

####   netstat -tunlp | grep 端口号  <br/>
**用于显示 tcp，udp 的端口和进程等相关情况**

> -t (tcp) 仅显示tcp相关选项
> -u (udp)仅显示udp相关选项
> -n 拒绝显示别名，能显示数字的全部转化为数字
> -l 仅列出在Listen(监听)的服务状态
> -p 显示建立相关链接的程序名

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/b16427d1c6cc430080b1dae37360358c.png)

####  kill(杀死进程)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/e228676961554ebaa0725d3cad3b14c6.png)
####  telnet(检测端口是否可用)
有时我们想知道端口是否开启。

```
tenlet ip 端口
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/46ee47447ace457e95d472fef5ea9ea8.png)
上图表示：80端口开放，8899端口未开放。



### 查看系统情况
#### cpu
```
lscpu //cpu架构、每个核的线程数都能看到
```
#### 磁盘
```
lsblk //命令用来查看接入到系统中的块设备，默认输出分区、大小、挂载点等信息

df -h //查看硬盘的使用情况
```
#### 内存
```
free -h
```
####  系统版本
centos:

```
cat /etc/redhat-release
```

### 删除除了某个文件外的其他文件
```
shopt -s extglob      （打开extglob模式）
rm -fr !(file1)

# 如果是多个要排除的，可以这样：
rm -rf !(file1|file2)
```

##  复制/移动文件、文件改名
Linux 将一个文件夹的所有内容拷贝到另外一个文件夹

cp 命令使用 -r 参数可以将 packageA 下的所有文件拷贝到 packageB 中：

```
cp -r /home/packageA/* /home/cp/packageB/
```
将一个文件夹复制到另一个文件夹下，以下实例 packageA 文件会拷贝到 packageB 中：

```
cp -r /home/packageA /home/packageB
```
运行命令之后 packageB 文件夹下就有 packageA 文件夹了。

1. `cp /xx/xx(a)  /xx/xx(a)`   :复制   ~~~~  //将a复制到b
2. `mv /xx /xx /xx/xx` :剪切
3. `mv 旧文件夹名 新文件夹名`   //更改名字


## 批量操作
### 批量删除高相似度文件
某个文件夹下，有很多文件名形如：checkpoint\_{epoch}\_{loss}.pth；其中epoch和loss是变量；我现在希望把epoch小于400的删除

```
ls checkpoint_*.pth | awk -F'_' '{if ($2 < 400) print $0}' | xargs rm -rf
```
命令解释：
1. ls checkpoint_*.pth：列出当前目录下所有匹配 checkpoint_*.pth 格式的文件。
2. awk -F'_' '{if ($2 < 400) print $0}'：是一种强大的文本处理工具，这里用来处理 ls 命令的输出。；-F'_' 设置字段分隔符为下划线 _。这意味着 awk 将每行（每个文件名）按 _ 分割成多个字段。；{if ($2 < 400) print $0} 是 awk 的动作部分，检查每个文件名的第二部分（$2）是否小于 400。如果是，则打印整个文件名（$0）。假设文件名是 checkpoint_350_0.5.pth，则 $2 是 350。

3. xargs 用于构建并执行命令行，它从标准输入读取数据，将其作为参数传递给指定的命令；这里，xargs 会把 awk 输出的文件名作为参数传递给 rm -rf，从而删除这些文件。

### 批量删除多个子目录下高相似度文件

在上一条命令的基础上稍微调整下：
```
find /path/to/top-level-directory -type f -name "checkpoint_*.pth" | awk -F'_' '{if ($2 < 400) print $0}' | xargs rm -rf
```

命令解释：
1. find /path/to/top-level-directory ;指定从哪个目录开始搜索，包括所有子目录。
2. -type f;限制搜索只查找文件，不包括目录。
3. -name "checkpoint_*.pth";只查找文件名符合给定模式的文件。* 表示任何序列的字符，确保匹配如 checkpoint_123.pth 或 checkpoint_456_789.pth 这样的文件名。

**一般我们使用的时候是达到指定目录下，该目录下有很多子目录，子目录里面有很多命名类似的文件，然后开始执行命令，所以/path/to/top-level-directory 一般就是./**



## 替换rm命令

一般删除命令都是rm，但是有时候会出现用rm误删的情况，这种时候还不好恢复。所以想替换一个命令，即使删除后，还可以恢复。

**trash-cli**

1. 安装 trash-cli

ubuntu/debian
```
sudo apt-get update
sudo apt-get install trash-cli
```

Fedora:
```
sudo dnf install trash-cli
```

2. 常用命令
```
//删除放入回收站
trash-put filename

//查看回收站内容
trash-list

//从回收站恢复文件
trash-restore

//清空回收站
trash-empty

```
3. 替换rm
```
alias rm='trash-put'

source ~/.bashrc

```


## 文件操作

###  touch命令(创建文件)
`touch`命令用于修改文件或者目录的时间属性，包括存取时间和更改时间，若文件不存在，系统会建立一个新的文件。

创建一个空白文件，如果文件已经存在，它将更改文件的访问时间。

```shell
touch /tmp/file.txt
```

创建多个文件。

```shell
touch /tmp/file1.txt /tmp/file2.txt /tmp/file3.txt
```

修改文件的修改时间并查看文件属性。

```shell
touch -m /tmp/file.txt && stat /tmp/file.txt
```

同时修改访问时间和修改时间并设置一个特定的访问与修改时间。

```shell
touch -am -t 202007010000.00 /tmp/file.txt && stat /tmp/file.txt
```

### cat命令(显示文件内容)
`cat`命令属于文件管理，用于连接文件并打印到标准输出设备上，`cat`经常用来显示文件的内容，注意，当文件较大时，文本在屏幕上迅速闪过，会出现滚屏现象，此时往往看不清所显示的内容，为了控制滚屏，可以按`Ctrl+S`键停止滚屏，按`Ctrl+Q`键可以恢复滚屏，此外可以用`more`等命令进行读文件并分页显示。

使用`cat`命令创建一个文件，输入文件信息后按`Ctrl+D`输出`EOF`标识后结束输入。

```shell
cat > file.txt
```

输出`file.txt`文件中的内容。

```shell
cat file.txt
```

同时输出`file.txt`与`file2.txt`文件中的内容。

```shell
cat file.txt file2.txt
```

把`file.txt`文件的内容加上行号后追加到`file2.txt`文件中。

```shell
cat -n file.txt >> file2.txt
```

清空`file2.txt`文件，`/dev/null`称为空设备，是一个特殊的设备文件，其会丢弃一切写入其中的数据，但报告写入操作成功，读取它则会立即得到一个`EOF`。

```shell
cat /dev/null > file2.txt
```

将`file.txt`与`file2.txt`文件内容合并输出到`file3.txt`。

```shell
cat file.txt file2.txt > file3.txt
```

### 文件内容覆盖/追加内容（cat命令）

```
cat  textfile1 > textfile2 //使用“>” 重定向后 文件 中原本的内容会被覆盖

cat  textfile1 >> textfile2 //">>" 代表 将输出的内容已追加的方式重定向到文件

```
cat 原单词concatenate(用途是连接文件或标准输入并打印。)
cat 命令用于将所有文件内容打印到屏幕上。
语法:

```
cat 文件
```

##  Centos7特性
服务相关命令使用systemctl，之前的版本是service

> systemctl (stop/restart/start)  (服务)
> systemctl restart nginx

##  防火墙
### 开启端口（以80为例）
> firewall-cmd --zone=public --add-port=80/tcp --permanent
> //zone add permanent前面是两个横杠

###  重启防火墙
> systemctl restart firewalld.service

### 关闭防火墙
```
systemctl stop firewalld.service
```

### 开机禁用防火墙
```
systemctl disable firewalld.service
```

**不同的系统命令可能不同**


### 防火墙限制ip访问
可以使用ufw或iptables。

**ufw**

1. 添加允许进入的规则:
```
sudo ufw allow in on <网卡> from <ip>

```

2. 添加允许输出的规则
```
sudo ufw allow out on <网卡> to <ip>
```

这些规则将确保你的系统只能通过指定的网卡与指定的 IP 地址通信。

某个例子：
```
sudo ufw allow in on eth0 from 192.168.1.100
sudo ufw allow out on eth0 to 192.168.1.100
```

3. 一旦添加了规则，需要重新加载 ufw 以应用更改：
```
sudo ufw reload
```

4. 如果想删除某个规则
```
# 查看当前规则:
sudo ufw status numbered

# 使用 ufw delete 命令，后跟规则编号
sudo ufw delete 1

# 重启
sudo ufw reset


```

**iptables**

完全允许某个网口的流量：
```
sudo iptables -A INPUT -i eth0 -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -j ACCEPT
```

允许与特定 IP 的所有通信（不限制端口）：
```
sudo iptables -A OUTPUT -o wlan0 -d 192.168.1.100 -j ACCEPT
sudo iptables -A INPUT -i wlan0 -s 192.168.1.100 -j ACCEPT
```

阻止与其他ip的通信：
```
sudo iptables -A OUTPUT -o wlan0 -j DROP
sudo iptables -A INPUT -i wlan0 -j DROP
```

删除规则：
```
# 查看规则号
sudo iptables -L --line-numbers

# 根据显示的行号来删除对应的规则

sudo iptables -D INPUT 3


```


##  修改主机名
###  debian/ubuntu系列

```
第一步：
vi /etc/hostname
写入

HOSTNAME=yourhostname
保存后执行以下：

hostname yourhostname
 查看设置后的hostname
hostname
```

```
第二步：
vi /etc/hosts
修改成新的主机名
```

###  redhat/centos系列

```
vi /etc/sysconfig/network
输入以下：

HOSTNAME=yourhostname
保存后执行以下：

hostname yourhostname
 查看设置后的hostname
hostname
```


##  vim相关操作
###  复制

1）单行复制

在命令模式下，将光标移动到将要复制的行处，按“yy”进行复制；

2）多行复制 在命令模式下，将光标移动到将要复制的首行处，按“nyy”复制n行；其中n为1、2、3……

【yy】 复制光标所在的那一行
【nyy】 复制光标所在的向下n行

###  粘贴

在命令模式下，将光标移动到将要粘贴的行处，按“p”进行粘贴

【p,P】 p为将已经复制的数据在光标下一行粘贴；P为将已经复制的数据在光标上一行粘贴

###  删除

删除一行：dd

删除一个单词/光标之后的单词剩余部分：dw

删除当前字符：x

光标之后的该行部分：d$

文本删除

dd 删除一行

d$ 删除以当前字符开始的一行字符

ndd 删除以当前行开始的n行

dw 删除以当前字符开始的一个字

ndw 删除以当前字符开始的n个字

###  查找

【/word】 在文件中查找内容为word的字符串（向下查找）
【?word】 在文件中查找内容为word的字符串（向上查找）
【[n]】 表示重复查找动作，即查找下一个
【[N]】 反向查找下一个

### 取消高亮

搜索后，我们打开别的文件，发现也被高亮了，怎么关闭高亮？

命令模式下，输入:nohlsearch  也可以:set nohlsearch； 当然，可以简写，noh或者set noh。
PS：nohlsearch是（no highlight search缩写）

###  设置行号

如果编辑后，又想显示行号，同样操作按一下esc键，并输入:（冒号），输入set number    ，并按回车键，完成后即显示行号

###  跳到指定行

在知道所查找的内容在文件中的具体位置时可以使用以下命令直接定位：
跳到文件指定行：比如跳到66行

66+G（也就是66+shift+g）
当然你可以选择另一种跳转方式：

命令行输入“ : n ” 然后回车
跳到文件第一行：gg （两个小写的G）

跳到文件最后一行：shift+g （也就是G）
###  文件上下翻转

页翻转可以直接使用PgUp和PgDn

向前滚动一屏：Ctrl+F

向后滚动一屏：Ctrl+B

向前滚动半屏：Ctrl+D（向下）

向后滚动半屏：Ctrl+U（向上）

向下滚动一行，保持当前光标不动：Ctrl+E

向上滚动一行，保持当前光标不动：Ctrl+Y

当前行滚动：
当前行移动到屏幕顶部并滚动：Z+Enter
滚动指定行到屏幕顶部： 10Z+Enter（指定第十行）
当前行移动到屏幕中央并滚动：Z + .
当前行移动到屏幕底部并滚动：Z + -
当前屏幕操作：
H：大写h，移动到当前屏幕首行；nH移动到首行下的第n行
M：大写m，移动到当前屏幕中间行
L：大写l，移动到当前屏幕末行；nL移动到末行上面的第n行
###  撤销上一步操作

【u】 撤消上一个操作
【[Ctrl] + r】 多次撤消
【.】 这是小数点键，重复上一个操作

  缩进：

  插入模式下，ctrl+shift+d 减少缩进，ctrl+shift+t 增加缩进

###  vim编辑

1、进入插入模式（６个命令）
【i】 从目前光标所在处插入
【I】 从目前光标
【a】 从当前光标所在的下一个字符处开始插入
【A】 从光标所在行的最后一个字符处开始插入
【o】 英文小写字母o，在目前光标所在行的下一行处插入新的一行并开始插入
【O】 英文大写字母O，在目前光标所在行的上一行处插入新的一行并开始插入

 2、进入替换模式（2个命令）
【r】 只会替换光标所在的那一个字符一次
【R】 会一直替换光标所在字符，直到按下[ESC]键为止
【[ESC]】 退出编辑模式回到一般模式

  3、一般模式切换到命令行模式
【:w】 保存文件
【:w!】 若文件为只读，强制保存文件
【:q】 离开vi
【:q!】 不保存强制离开vi
【:wq】 保存后离开
【:wq!】 强制保存后离开
【:! command】 暂时离开vi到命令行下执行一个命令后的显示结果
【:set nu】 显示行号
【:set nonu】 取消显示行号
【:w newfile】 另存为
【:set fileencoding】 查看当前文件编码格式
【:set fileencoding=utf-8】 设置当前文件编码格式为utf-8，也可以设置成其他编码格式
【:set fileformat】 查看当前文件的断行格式（dos\windows,unix或macintosh）
【:set fileformat=unix】 将当前文件的断行格式设置为unix格式

###  多窗口功能
【:sp [filename]】 打开一个新窗口，显示新文件，若只输入:sp，则两窗口显示同一个文件
【[Ctrl] + w + j】 光标移动到下方窗口
【[Ctrl] + w + k】 光标移动到上方窗口
【[Ctrl] + w + q】 离开当前窗口

###  缩进

批量缩进

在程序代码界面，按esc，退出编辑模式，到命令模式，并在英语输入法下输入“：”

将所要批量缩进的行号写上，按照格式：“行号1，行号2>”输入命令，如要将2至9行批量缩进一个tab值，则命令为“2,9>”

输入完毕后，按回车可以执行，就可以看到2至9行全部缩进了一个tab值了，同样的，如果要缩回来一个tab值，则用命令“行号1，行号2<”即可

可视模式缩进

方法二是在可视模式下选择要移动的列，操作为，esc从编辑模式退到命令模式，将光标移到需要缩进的行的行首，然后按shift+v，可以看到该行已被选中，且左下角提示为“可视”

此时，按键盘上的上下左右方向键，如这里按向下的箭头，选中所有需要批量缩进的行

选择好了之后，按shift+>,是向前缩进一个tab值，按shift+<，则是缩回一个tab值，


## vscode Remote SSH

ssh登录命令：

```
ssh username@ip -p port  //密码登录 ，-p port可以不用输入，不输默认是22，因为linux默认也确实是22

ssh username@ip -p port –i id_rsa //密钥登录

//密钥生成的时候建议命名，不要使用默认的，否则多了容易分不清。
```

使用Remote SSH 插件访问linux，用密钥登录。需要把公钥放在服务器，私钥放在`.ssh`目录下



![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/300494cec18445139acafaa165d99186.png)
再配置VScode
点击Remote SSH的图标后再点击箭头所指的齿轮
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/a1b38b4440e85b519ea1004ad23ae66f.png)
会弹出菜单让你选择需要编辑的配置文件，一般选第一个
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/112e1d35b8003716395a4ecbcf2946ac.png)
参数的含义分别为：

Host 连接的主机的名称，可自定

Hostname 远程主机的IP地址

User 用于登录远程主机的用户名

Port 用于登录远程主机的端口

IdentityFile 本地的id_rsa的路径

右键点击Connect!
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/78b37be94d60822412e1640e5f980c6a.png)


##  设置 SSH 通过密钥登录

### 注意事项
1. 密钥的制作和用户有关。比如我在服务器上使用xxx制作的密钥，那么登录的话，是让ssh xxx@ip 可以免密登录，其它用户不行的。
2. 如果我想免密登录服务器，那么是在服务器上面把密钥制作出来，将**私钥**传给别人，别人用私钥来访问。（感觉这样做不是很安全，看到的介绍都是把公钥给别人。但如果是公钥给别人，那就只有在本地制作密钥，再把公钥给服务器，但是用户就没法对上，后面有时间再想想吧）


###  制作密钥对

> 我们一般使用 PuTTY 等 SSH 客户端来远程管理 Linux
> 服务器。但是，一般的密码方式登录，容易有密码被暴力破解的问题。所以，一般我们会将 SSH 的端口设置为默认的 22 以外的端口，或者禁用
> root 账户登录。其实，有一个更好的办法来保证安全，而且让你可以放心地用 root 账户从远程登录——那就是通过密钥方式登录。
> 
> 密钥形式登录的原理是：利用密钥生成器制作一对密钥——一只公钥和一只私钥。将公钥添加到服务器的某个账户上，然后在客户端利用私钥即可完成认证并登录。这样一来，没有私钥，任何人都无法通过
> SSH 暴力破解你的密码来远程登录到系统。此外，如果将公钥复制到其他账户甚至主机，利用私钥也可以登录。
> 
> 下面来讲解如何在 Linux 服务器上制作密钥对，将公钥添加给账户，设置 SSH，最后通过客户端登录。


```
首先在服务器上制作密钥对。首先用密码登录到你打算使用密钥登录的账户，然后执行以下命令：

[root@host ~]$ ssh-keygen  <== 建立密钥对
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): <== 按 Enter。如果输入其它字符，比如test，那么生产的私钥是test，公钥是test.pub。说白了就是让你输入密钥文件名，不输入就采用默认的。
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): <== 输入密钥锁码，后续使用私钥登录的时候会要求输密码，建议输入；或直接按 Enter 留空
Enter same passphrase again: <== 再输入一遍密钥锁码
Your identification has been saved in /root/.ssh/id_rsa. <== 私钥
Your public key has been saved in /root/.ssh/id_rsa.pub. <== 公钥
The key fingerprint is:
0f:d3:e7:1a:1c:bd:5c:03:f1:19:f1:22:df:9b:cc:08 root@host
密钥锁码在使用私钥时必须输入，这样就可以保护私钥不被盗用。当然，也可以留空，实现无密码登录。

现在，在 root 用户的家目录中生成了一个 .ssh 的隐藏目录，内含两个密钥文件。id_rsa 为私钥，id_rsa.pub 为公钥。
```

###  在服务器上安装公钥

```
键入以下命令，在服务器上安装公钥：

[root@host ~]$ cd .ssh
[root@host .ssh]$ cat id_rsa.pub >> authorized_keys
如此便完成了公钥的安装。为了确保连接成功，请保证以下文件权限正确：

[root@host .ssh]$ chmod 600 authorized_keys
[root@host .ssh]$ chmod 700 ~/.ssh
```


###  设置 SSH，打开密钥登录功能

```
编辑 /etc/ssh/sshd_config 文件，进行如下设置：

RSAAuthentication yes
PubkeyAuthentication yes
另外，请留意 root 用户能否通过 SSH 登录：

PermitRootLogin yes
当你完成全部设置，并以密钥方式登录成功后，再禁用密码登录：

PasswordAuthentication no
最后，重启 SSH 服务：

[root@host .ssh]$ service sshd restart
```

### 普通用户制作密钥

**如果是用普通用户来制作密钥，需要在普通用户的状态下执行上述命令，生成的密钥会在/home/yskj/.ssh目录下面（这里以yskj用户为例）**

如果遇到无法登录，出现
```
Server refused our key
```
这样的错误，从两个方面出发。一个是authorized_keys与.ssh的权限，一定要按照前面提到的，一个是600，一个是700。
如果这样不行，那就看看/home目录下面或yskj目录下面的权限，有没有拥有者或组是root的，然后改正过来。

###  将私钥下载到客户端，然后转换为 PuTTY 能使用的格式
使用 WinSCP、SFTP 等工具将私钥文件 id_rsa 下载到客户端机器上。然后打开 PuTTYGen，单击 Actions 中的 Load 按钮，载入你刚才下载到的私钥文件。如果你刚才设置了密钥锁码，这时则需要输入。

载入成功后，PuTTYGen 会显示密钥相关的信息。在 Key comment 中键入对密钥的说明信息，然后单击 Save private key 按钮即可将私钥文件存放为 PuTTY 能使用的格式。

今后，当你使用 PuTTY 登录时，可以在左侧的 Connection -> SSH -> Auth 中的 Private key file for authentication: 处选择你的私钥文件，然后即可登录了，过程中只需输入密钥锁码即可。

### ssh客户端--xshell登录linux服务器
将服务器上生成的私钥，id_rsa下载到本地。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/8aa2ee35095b499c9cddaf21b877ca01.png)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/a96ed4029057488f9ee7a6b9acae0fd3.png)

###  ssh-keygen命令详解
这条命令目的是为了本地机器ssh登录远程服务器无需输入密码

**1.ssh-keygen**

> SSH 为 Secure Shell 的缩写，SSH 为建立在应用层基础上的安全协议。SSH
> 是目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。利用 SSH 协议可以有效防止远程管理过程中的信息泄露问题。 
> <br>		
> 从客户端来看，SSH提供两种级别的安全验证： 
> <br>			
> 第一种级别（基于口令的安全验证）：只要你知道自己帐号和口令，就可以登录到远程主机。所有传输的数据都会被加密，但是不能保证你正在连接的服务器就是你想连接的服务器。可能会有别的服务器在冒充真正的服务器，也就是受到“中间人”这种方式的攻击。
> 	<br>	
> 第二种级别（基于密匙的安全验证）ssh-keygen：需要依靠密匙，你必须为自己创建一对密匙，并把公用密匙放在需要访问的服务器上。如果你要连接到SSH服务器上，客户端软件就会向服务器发出请求，请求用你的密匙进行安全验证。服务器收到请求之后，先在该服务器上你的主目录下寻找你的公用密匙，然后把它和你发送过来的公用密匙进行比较。如果两个密匙一致，服务器就用公用密匙加密“质询”（challenge）并把它发送给客户端软件。客户端软件收到“质询”之后就可以用你的私人密匙解密再把它发送给服务器。用这种方式，你必须知道自己密匙的口令。但是，与第一种级别相比，第二种级别不需要在网络上传送口令。第二种级别不仅加密所有传送的数据，而且“中间人”这种攻击方式也是不可能的（因为他没有你的私人密匙）。但是整个登录的过程可能需要10秒。
> <br>	ssh-keygen有很多的参数，比如这里的-t -b -C都是他的一些参数

**2.-t rsa**

> -t即指定密钥的类型，密钥的类型有两种，一种是RSA，一种是DSA：
> <br>RSA：RSA加密算法是一种非对称加密算法，是由三个麻省理工的牛人弄出来的，RSA是他们三个人姓的开头首字母组合。
> <br>DSA：Digital Signature Algorithm (DSA)是Schnorr和ElGamal签名算法的变种。
> <br>为了让两个linux机器之间使用ssh不需要用户名和密码。所以采用了数字签名RSA或者DSA来完成这个操作。ssh-keygen默认使用rsa密钥，所以不加-t rsa也行，如果你想生成dsa密钥，就需要加参数-t dsa。

**3.-b 4096**

> -b 指定密钥长度。对于RSA密钥，最小要求768位，默认是2048位。命令中的4096指的是RSA密钥长度为4096位。
> <br>DSA密钥必须恰好是1024位(FIPS 186-2 标准的要求)。

**这里额外补充一个知识**

> 命令后面还可以增加-C "注释内容"
> <br>-C表示要提供一个新注释，用于识别这个密钥，可以是任何内容,一个用来识别的key


**小结：当你创建ssh的时候：-t 表示密钥的类型 ，-b表示密钥的长度，-C 用于识别这个密钥的注释 ，这个注释你可以输入任何内容**

##  Centos 启动/停止/重启/开机自启动服务

```
systemctl start sshd //启动ssh服务

systemctl stop sshd //停止ssh服务
 
systemctl restart sshd //重启ssh服务

systemctl enable sshd //开机自启动ssh服务

docker 和其他服务也适用
```




##  linux中的&& 和 &，| 和 ||

> 在linux中，&和&&,|和||介绍如下：
> <br>
> &  表示任务在后台执行，如要在后台运行redis-server,则有  redis-server &
> <br>
> && 表示前一条命令执行成功时，才执行后一条命令 ，如 echo '1‘ && echo '2'    
> <br>
> | 表示管道，上一条命令的输出，作为下一条命令参数，如 echo 'yes' | wc -l
> <br>
> || 表示上一条命令执行失败后，才执行下一条命令，如 cat nofile || echo "fail"

具体案例：
1.rpm -qa | grep mysql

> rpm -qa会输出符合筛选条件的软件套件，然后使用grep 筛选与mysql相关的软件套件

##  rpm命令

> Linux rpm 命令用于管理套件。
> <br>
> rpm（英文全拼：redhat package manager） 原本是 Red Hat Linux 发行版专门用来管理 Linux
> 各项套件的程序，由于它遵循 GPL 规则且功能强大方便，因而广受欢迎。逐渐受到其他发行版的采用。RPM 套件管理方式的出现，让 Linux
> 易于安装，升级，间接提升了 Linux 的适用度。
> <br>因为是redhat的，所以这个命令对ubuntu不适用，一般就是centos用，看看是否安装了或有某个软件的套件


实例：

1.安装软件

```
# rpm -hvi dejagnu-1.4.2-10.noarch.rpm 
警告：dejagnu-1.4.2-10.noarch.rpm: V3 DSA 签名：NOKEY, key ID db42a60e
准备...           
################################################################ [100%]
```

2.显示软件安装信息

```
# rpm -qi dejagnu-1.4.2-10.noarch.rpm

【第1次更新 教程、类似命令关联】
```
3.检查是否已经安装过mysql

```
rpm -qa | grep mysql
```

4.删除mysql

```
rpm -e --nodeps mysql-libs-5.1.73-5.el6_6.x86_64  
//-e<套件档>或--erase<套件档> 　删除指定的套件。
//--nodeps 　不验证套件档的相互关联性。
```




##  更换yum源
[更换为清华源](https://mirrors.tuna.tsinghua.edu.cn/help/centos/)

 1. 建议先备份 /etc/yum.repos.d/ 内的文件（CentOS 7 及之前为 CentOS-Base.repo，CentOS 8 为CentOS-Linux-*.repo）
 2. 然后编辑 /etc/yum.repos.d/ 中的相应文件，在 mirrorlist= 开头行前面加 # 注释掉；并将 baseurl= 开头行取消注释（如果被注释的话），把该行内的域名（例如mirror.centos.org）替换为 mirrors.tuna.tsinghua.edu.cn。
 3. 以上步骤可以被下方的命令一步完成

```
 sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo
```

> 注意其中的*通配符，如果只需要替换一些文件中的源，请自行增删。
> <br>
> 注意，如果需要启用其中一些 repo，需要将其中的 enabled=0 改为 enabled=1。
> <br>

4.最后，更新软件包缓存

```
sudo yum makecache
```

