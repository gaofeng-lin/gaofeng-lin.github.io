---
title: NAS实现IPv6和IPv4双栈访问.md
date: 2025/07/04
categories:
  - NAS
tags:
  - null
mathjax: true
abbrlink: a409708a
---

默认情况下IPv4是可以直接访问的，所以我们先打开IPv6的访问功能

# 打开IPv6访问功能

## 光猫改桥接

我是移动的光猫，移动的登录网址在光猫后面。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20250704095435.jpg)


但是修改网络设置，是需要超级管理员的账号和密码，光猫后面那个只是普通用户。网上有教程可以获取超管账号，我是直接和安装宽带的师傅联系获取的（当时安装宽带加了微信）

没有修改之前的：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20250704095440.jpg)

要修改的地方：
- 连接名称：下拉后，选择名字带有"INTERNET"，前面的序号可能不同，但不重要。
- 连接模式：桥接
- IP模式：IPv4&IPv6

保存修改之前，最好把原来的拍个照，出了问题也可以修改回去。

因为我的忘记拍照了，所以这里给一个电信的作为参考：

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/102630z92r5gkappao8p21.webp)


## 路由器该改拨号上网

**光猫修改完毕后，你的电脑已经彻底断网，是没有办法用无线访问路由器/光猫**


如果这个时候你需要访问光猫，需要用网线将电脑和路由器或光猫直接连接。

**坑的地方**：在修改光猫配置后，连接光猫的时候，因为我的光猫配置里面，LAN端口绑定只开了一个（一共四个，另外三个不知道为什么点不动），所以只能插到光猫的LAN1口才行（当时插其他几个口一直访问不上），然后浏览器输入移动的ip才能访问光猫。

因为要修改路由器配置，就用网线连接电脑和路由器。然后浏览器输入小米路由器的ip（192.168.31.1）

然后进去后主要修改的是上网方式修改为拨号上网（PPPoE），之前是DHCP分配

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/102630lcs2cqxkchjwkhmq.webp)

下面要填写的是宽带的账号和密码，这个和光猫账号也不一样。获取方式是**用办理宽带的手机号，发送CZKDMM到10086，然后就会把账号和密码发过来。**

接着就填写进去，配置好这个，此时就可以正常上网了。

在上网设置这一栏，往下面滑动，就能看到IPv6的配置

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/102630gs01k1f14stn41ii.webp)

在上网设置页面顶部就能看到当前的上网信息了，可以看到 WAN 口已经获取到 IPv6 地址，而且还有 公网IPv6 前缀。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/102630ku660g5mm01hs0m6.webp)


可以检查下是否能获取到IPv6，https://test-ipv6.com/index.html.zh_CN或者https://ipw.cn/

如果不行的话，可以先关闭clash，再试试。如果关闭clash可以，那么就去配置文件里面进行修改，修改的思路有两种。原链接：https://github.com/clash-verge-rev/clash-verge-rev/issues/844

第一种：在clash，General页面打开IPv6，然后进入Proxies，编辑配置文件，将dns中的ipv6设置为true。（**不过这个方法我失败了，不知道为什么设置为true，等会看又变为了false，上面两个网址一个显示有ipv6，另一个又没有**）

第二种：编辑配置文件，在 "proxies"项加入"ip-version"，填写值为"ipv6-prefer"

我的如下：

proxies:
    - { name: '🇭🇰 香港 01 | 0.1x', type: ss, server: welfare.yushe-node.top, port: 30001, cipher: aes-128-gcm, password: 省略, udp: true,ip-version:ipv6-prefer  }
    - { name: '🇭🇰 香港 02 | 0.1x', type: ss, server: welfare.yushe-node.top, port: 30002, cipher: aes-128-gcm, password: 省略, udp: true,ip-version:ipv6-prefer }

password后面的被我删除了，在udp后面进行添加。

但是这个时候登录飞牛，进入网络设置，有可能IPv6网络状态还是没通，下图是已经通了的，没通的话那个地方不是勾而是叉。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/Snipaste_2025-07-04_10-38-40.png)

这个时候需要关闭防火墙。

## 小米路由器关闭IPv6防火墙

因为路由器默认打开IPv6防火墙，所以直接从外部用ipv6访问nas是不行的。需要关闭防火墙，或者配置规则。

我的是小米路由器4A千兆版（4A Gigabit），无法登录路由器后台用鼠标点击关闭，只能通过SSH方式修改路由器配置文件，从而关闭V6地址的防火墙。但是小米路由器的SSH是关闭的，需要刷机。需要的步骤如下：

1. 路由器版本降低

我这里使用的版本是2.28.62，需要进入路由器后台里面的常用设置-》系统状态-》系统版本。传入2.28.62的固件。**要注意，最好是用网线将电脑和路由器连接再刷，否则可能不行！！！（固件保存到了onedirve）**


2. 下载开源库


https://github.com/acecilia/OpenWRTInvasion/releases

这个地方要注意几个坑：
- 最新版本不支持windows，只能docker运行，如果不想用docker，就要去下载低版本，推荐0.0.8。
- 我当时因为安装了深信服的某个软件，导致我解压的时候把script_tools里面的某个文件给我删了，但是一直没找到，被弄吐血了!!!。
- 如果是下载的0.0.7版本，代码会从github上下载两个文件，这两个文件在0.0.8版本的script_tools中是有的，但是0.0.7版本没有，直接下载是下不下来的，要注意。

3. ssh连接，关闭ipv6防火墙，并重启路由器

账号和密码都是root，ip就是路由器ip，进去后就把ipv6防火墙关闭就好，关闭的方法比较多，这里提供几个：

方法1：

```
ip6tables -F
ip6tables -X
ip6tables -P INPUT ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -P FORWARD ACCEPT
```
这种方法是关闭全部IPV6防火墙，但是并不安全~

```
ip6tables -I forwarding_rule -p tcp --dport 1234 -j ACCEPT
ip6tables -I forwarding_rule -p tcp --dport 5678 -j ACCEPT
```

**但以上命令会在重启后失效**

方案二：

```
vi /etc/rc.local
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

ip6tables -I forwarding_rule -p tcp --dport 1234 -j ACCEPT
ip6tables -I forwarding_rule -p tcp --dport 5678 -j ACCEPT

exit 0
```

完成后重启防火墙或者重启路由器，然后去飞牛的网络设置里面看下，这个时候应该就可以看到IPv6通了。并且在外面的时候（或者在家里面用流量）用使用飞牛app，可以看到连接方式是P2P，而不是中继模式，虽然有时候还是会变成中继模式。如果一直没有变为P2P，可以考虑用网线连接光猫，把光猫里面的防火墙关闭，然后重启光猫。




