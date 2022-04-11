---
title: Jenkins知识点
date: 2022/1/14
update: 2022/1/16

categories:
  - Jenkins
  
tags:
  - Jenkins
  - 运维
  - 持续集成
---





#  流水线语法找不到模板
![在这里插入图片描述](https://img-blog.csdnimg.cn/e93ad73b8c094398bdfc1b49f5388317.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
有时候在“流水线语言”板块找不到模板，即使安装了相对于的插件。如上图，安装了**publish over ssh插件**就会出现这个选项，但是当时没有。

**解决办法：**
重启jenkins。初始域名后面加/restart

```
ip:port/restart
```
#  Publish over ssh连接失败
![在这里插入图片描述](https://img-blog.csdnimg.cn/72c9e5709ded45fcadfc75afc94e0baf.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
**解决办法：**
这里要填密钥的密码

#  无法执行远程脚本

> 背景： 
> 创建一个jenkins作业，通过ssh在另一台服务器上运行脚本，实现从harbor仓库拉取docker镜像，并运行。
> <br>
> 问题： 运行jenkins作业/流水线，在对应的服务器没有镜像和运行的容器，且构建过程没有错误输出。

![在这里插入图片描述](https://img-blog.csdnimg.cn/833850a8163b42f79d14e14b9551c356.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

> 分析：
> 由于是照着黑马程序员的视频和资料来的，由于输出的信息不太一样，以为是哪里操作有问题，或者脚本不对，但是重复所有过程和按照网上教程修改脚本均没有成功。然后单独运行脚本，发现出错，类似于下图。

![在这里插入图片描述](https://img-blog.csdnimg.cn/635aed74d26a41bc84833f34bef37f50.png)

> **反应过来是因为Docker没有把Harbor加入信任列表中**，
> 
><br> 加入就好
> 
> ```vim /etc/docker/daemon.json ```
> 
>
><br> 再次构建出现了错误信息，搜索得知是因为这个命令默认有个时间限制，超过这个时间限制就会出错，断开，类似于联网超时。

![在这里插入图片描述](https://img-blog.csdnimg.cn/cf2801f8c63a42bb8e91adf61a3f8590.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

> **把时间改为0就好**

![在这里插入图片描述](https://img-blog.csdnimg.cn/30e99ed138474b01800e583e61389dfd.png)


