---
title: Docker
date: 2022/3/6
categories:
  - Docker
  
tags:
  - Docker
  - 运维

---



#  docker下载

##  Docker安装
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
![在这里插入图片描述](https://img-blog.csdnimg.cn/cecd311ce895425cafdd7a8edf9a376a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
这个地址的来源：
访问阿里云这个网址，要先登录：[镜像加速页面](https://cr.console.aliyun.com/?spm=a2c6h.12873639.0.0.7aec4073HlA7e2#/accelerator)

![在这里插入图片描述](https://img-blog.csdnimg.cn/641489fc54e74da0b71ef979826d1a3f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
##  docker启动失败
**错误1：**
如图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/56ed8bac9f524db3b2dbf64efaff96a0.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
原因：

当时在 /etc/docker/daemon.json  添加了一行，但是忘了在第一行后面添加 "逗号"，加上就好。
![在这里插入图片描述](https://img-blog.csdnimg.cn/7c623f0bb0114b33a4f91a93a9da0450.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)



**错误2：**
docker启动失败，有一个可能就是包（jar,war）有问题。可以先单独检测下包是否可以运行。如果包不能运行，就是代码有问题。
**如果代码逻辑没有问题，甚至没有改动。可能要注意格式问题，比如少敲或多敲空格这种，这种错误往往看不出来，或者编译器没有明显的错误提示（idea对于这个问题就是标黄，但有时候又不影响，很容易不注意）**
