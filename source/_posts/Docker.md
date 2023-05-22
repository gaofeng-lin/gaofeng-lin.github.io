---
title: Docker
date: 2022/3/6
categories:
  - 运维
tags:
  - Docker
  - 运维
abbrlink: 40991
---



##  docker下载

###  Docker安装
1）卸载旧版本
yum list installed | grep docker 列出当前所有docker的包
yum -y remove docker的包名称 卸载docker包
rm -rf /var/lib/docker 删除docker的所有镜像和容器
2）安装必要的软件包
sudo yum install -y yum-utils \ device-mapper-persistent-data \ lvm2
3）设置下载的镜像仓库
sudo yum-config-manager \ --add-repo \ https://download.docker.com/linux/centos/docker-ce.repo
如果下载失败，采用阿里源和清华源。（详见菜鸟教程）
4）列出需要安装的版本列表
yum list docker-ce --showduplicates | sort -r
5）安装指定版本（这里使用18.0.1版本）
sudo yum install docker-ce-18.06.1.ce
6）查看版本
docker -v
7）启动Docker
sudo systemctl start docker 启动
sudo systemctl enable docker 设置开机启动
```
yum list docker-ce --showduplicates | sort -r
```
列出版本列表，看看是否下载成功

添加镜像地址：

```
vi /etc/docker/daemon.json //没有这个文件也无妨，直接创建就好
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/cecd311ce895425cafdd7a8edf9a376a.png)
这个地址的来源：
访问阿里云这个网址，要先登录：[镜像加速页面](https://cr.console.aliyun.com/?spm=a2c6h.12873639.0.0.7aec4073HlA7e2#/accelerator)

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522150025.png)
###  docker启动失败
**错误1：**
如图所示：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522150048.png)
原因：

当时在 /etc/docker/daemon.json  添加了一行，但是忘了在第一行后面添加 "逗号"，加上就好。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522150106.png)



**错误2：**
docker启动失败，有一个可能就是包（jar,war）有问题。可以先单独检测下包是否可以运行。如果包不能运行，就是代码有问题。
**如果代码逻辑没有问题，甚至没有改动。可能要注意格式问题，比如少敲或多敲空格这种，这种错误往往看不出来，或者编译器没有明显的错误提示（idea对于这个问题就是标黄，但有时候又不影响，很容易不注意）**

## 镜像、仓库的关系
docker可以把服务和需要的库一起打包

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522150124.png)
1.	拉取镜像
2.	Docker build
3.	镜像->容器 docker run
4.	容器->镜像 docker commit。

上面这图说明了三个得到镜像的途径
1．	从docker官方仓库拉取。
2．	使用dockerfile构建。
3．	从已有的镜像构建容器，进入容器里面（docker -it 容器名称 /bin/bash），做修改，再提交（docker commit）。//这里面 /bin/bash 是进入容器内部，交互运行，和前面的-it也有关系。

**可以做什么？**
比如我拉取一个centos7镜像，进入里面把私有云那一堆东西全部装好。下次我就可以直接拿来用，把服务扔上去就好。
这个过程或者我可以用dockerfile来实现。


## docker基本操作
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522150146.png)
 
### 镜像命令

```bash
docker search 镜像名称
docker pull 镜像名 
docker pull 镜像名:tag
docker images   //查看本地所有镜像

//提交镜像
docker commit 容器id 镜像:版本号

//删除镜像
docker rmi -f 镜像名称  
##删除多个 其镜像ID或镜像用用空格隔开即可 
docker rmi -f 镜像名/镜像ID 镜像名/镜像ID 镜像名/镜像ID

##删除全部镜像  -a 意思为显示全部, -q 意思为只显示ID
docker rmi -f $(docker images -aq)

//强制删除镜像
docker image rm 镜像名称/镜像ID

//保存镜像
//将我们的镜像 保存为tar 压缩文件 这样方便镜像转移和保存 ,然后 可以在任何一台安装了docker的服务器上 加载这//个镜像
docker save 镜像名/镜像ID -o 镜像保存在哪个位置与名字
```

### 容器命令
容器是由镜像创建而来。容器是Docker运行应用的载体，每个应用都分别运行在Docker的每个 容器中

```bash
docker run -i 镜像名称:标签   //运行容器（默认是前台运行） 
docker ps  //查看运行的容器 
docker ps -a  //查询所有容器
```
实际命令分析：

```bash
docker run -d -it --hostname phdev -p 90:80 -p 8899:8899 -v /sys/fs/cgroup:/sys/fs/cgroup --privileged “镜像名字” /usr/sbin/init

//-d 容器以后台方式运行，不会直接进入到容器里面
//hostname 指定主机名称；
//-p 是端口映射。90:80 访问服务器90端口就是访问容器80端口
//-v 是挂载到指定目录
//  privileged  /usr/sbin/init  是给容器赋予更高的权限
```

```bash
//以shell方式进入到一个已经运行的容器当中，和上一条命令搭配起来使用
docker exec -it “容器id” /bin/bash
```

### 传输文件命令
传输文件命令——本地传到docker

```bash
docker cp “文件”  镜像id：“路径”
```

### 导出/导入镜像
方法1：save

```bash
//导出
docker save imagesID > /存放位置/打包文件名.tar

//导入
docker load < 打包文件名.tar
```

方法2：export

```bash
//导出
docker export 容器名 > /位置/打包名.tar

//导入
docker import < 打包名.tar
```

区别：
(1).export导出的镜像文件大小 小于 save保存的镜像

(2).export 导出（import导入）是根据容器拿到的镜像，再导入时会丢失镜像所有的历史，所以无法进行回滚操作（docker tag ）；而save保存（load加载）的镜像，没有丢失镜像的历史，可以回滚到之前的层（layer）。（查看方式：docker images --tree）

### 删除镜像或容器
[原文链接](https://blog.csdn.net/qq_42006301/article/details/105102020)
方法一：删除所有未运行的容器（已经运行的删除不了，未运行的就一起被删除了）

```bash
docker rm $(docker ps -a -q)
```
方法二：根据容器的状态，删除Exited状态的容器

```bash
docker rm $(docker ps -qf status=exited)
```
方法三：docker 1.13版本以后，可以使用 docker system 或 docker container命令清理容器。

```bash
//docker container prune 删除已停用容器
docker container prune

//删除关闭的容器、无用的数据卷和网络，以及dangling镜像
docker system prune 
//命令清理得更加彻底，可以将没有容器使用Docker的镜像都删掉
docker system prune -a 
```
### 查看docker信息

```bash
docker info
```
可以看到docker的根路径是 /var/lib/docker
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522150209.png)
查看docker根路径的磁盘占用率

```bash
df -Th /var/lib/docker
```
