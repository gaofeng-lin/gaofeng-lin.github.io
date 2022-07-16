---
title: Mysql
date: 2022/3/6
categories:
  - 数据库
  
tags:
  - 数据库
  - Linux
  - 运维
  - MySQL
---


# Mysql变量定义与赋值
[原链接](https://blog.csdn.net/H900302/article/details/123735007?spm=1001.2101.3001.6650.5&depth_1-utm_relevant_index=10)

## 局部变量
### 变量声明
```
declare a int default value 0;
```
### 变量赋值
```
//法一
set a=10;

//法二
select user_name into uname from t_user where id = 2;
```
## 用户变量
使用set或select直接赋值，变量名以 @ 开头.
### 变量赋值
```
SET @a=1,@b=2;

//法二
select @变量名:=变量值
select @变量名:=字段名 from table where ... limit 1;
```
## 系统变量

# MySQL理论知识
##  事务并发异常

SQL 标准共定义了 3 种并发异常，这三种异常分别是脏读（Dirty Read）、不可重复读（Nnrepeatable Read）和幻读（Phantom Read）。

1. 脏读 

脏读指的是读到了其他事务未提交的数据，未提交意味着这些数据可能会回滚，也就是可能最终不会存到数据库中，也就是不存在的数据。读到了并一定最终存在的数据，这就是脏读。

![在这里插入图片描述](https://pics7.baidu.com/feed/d01373f082025aaf5be5454896a1dd6d024f1a37.jpeg?token=15d738bce1e19daf55fa99c5fc036539)

**脏读最大的问题就是可能会读到不存在的数据。**

2. 不可重复读

不可重复读指的是在一个事务内，最开始读到的数据和事务结束前的任意时刻读到的同一批数据出现不一致的情况。

![](https://pics1.baidu.com/feed/cf1b9d16fdfaaf51b5c3d1cbe318e2e7f01f7a73.jpeg?token=0a1d7df4e2f9fae479bc98bd763fd2ee)

事务 A 多次读取同一数据，但事务 B 在事务A多次读取的过程中，对数据作了更新并提交，导致事务A多次读取同一数据时，结果 不一致。

3. 幻读
幻读侧重的方面是某一次的 select 操作得到的结果所表征的数据状态无法支撑后续的业务操作。更为具体一些：select 某记录是否存在，不存在，准备插入此记录，但执行 insert 时发现此记录已存在，无法插入，此时就发生了幻读。

**不可重复读侧重表达 读-读，幻读则是说 读-写，用写来证实读的是鬼影。**


举例：
假设有张用户表,这张表的 id 是主键。表中一开始有4条数据。
![](https://pics6.baidu.com/feed/d52a2834349b033be131703c798240dad439bd75.jpeg?token=3e013deb540b45db9ad7ab03563d06ef)


我们再来看下出现 幻读 的场景

![](https://pics3.baidu.com/feed/8435e5dde71190efb4aa7a77bb57eb1ffcfa609f.jpeg?token=5b271d6e820ca8770d6d6caf3955937c)

这里是在RR级别下研究(可重复读),因为 RU / RC 下还会存在脏读、不可重复读，故我们就以 RR 级别来研究 幻读，排除其他干扰。

1、事务A,查询是否存在 id=5 的记录，没有则插入，这是我们期望的正常业务逻辑。

2、这个时候 事务B 新增的一条 id=5 的记录，并提交事务。

3、事务A,再去查询 id=5 的时候,发现还是没有记录（因为这里是在RR级别下研究(可重复读)，所以读到依然没有数据）

4、事务A,插入一条 id=5 的数据。

最终 事务A 提交事务，发现报错了。这就很奇怪，查的时候明明没有这条记录，但插入的时候 却告诉我 主键冲突，这就好像幻觉一样。这才是所有的幻读。

## 事务隔离级别
![Snipaste_2022-05-21_23-28-56.png](https://s2.loli.net/2022/05/21/A3Gb6Rtfmr571yE.png)
上面的隔离级别由上往下，级别依次会提高，但消耗的性能也会依次提高。我们总结一下四种隔离级别：

1. 读未提交：允许读未提交数据，可能会发生脏读、不可重复读和幻读异常；
2. 读已提交：只能读已经提交的数据，避免了脏读，但可能会出现不可重复读和幻读；
3. 可重复读：即能保证在一个事务中多次读取，数据一致，但可能会出现幻读；
4. 可串行化：最高的隔离级别，串行的执行事务，可以避免 3 种异常，但性能耗损最高。

# Mysql语句
## 数据类型
MySQL 支持多种类型，大致可以分为三类：数值、日期/时间和字符串(字符)类型。
### 数值类型
![在这里插入图片描述](https://img-blog.csdnimg.cn/c1dbf744928b4225aca0777923efbdb9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
### 日期和时间
![在这里插入图片描述](https://img-blog.csdnimg.cn/dca2d56f9cf9450e92c8ecec362a8d05.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
### 字符串类型
![在这里插入图片描述](https://img-blog.csdnimg.cn/96f697d0ac234fb8b92b4b72a3da027e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)


## 创建数据表

```
CREATE TABLE table_name (column_name column_type);
```

实例1：
```bash
CREATE TABLE IF NOT EXISTS `runoob_tbl`(
   `runoob_id` INT UNSIGNED AUTO_INCREMENT,
   `runoob_title` VARCHAR(100) NOT NULL,
   `runoob_author` VARCHAR(40) NOT NULL,
   `submission_date` DATE,
   PRIMARY KEY ( `runoob_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

如果你不想字段为 NULL 可以设置字段的属性为 NOT NULL， 在操作数据库时如果输入该字段的数据为NULL ，就会报错。
AUTO_INCREMENT定义列为自增的属性，一般用于主键，数值会自动加1。
PRIMARY KEY关键字用于定义列为主键。 您可以使用多列来定义主键，列间以逗号分隔。
ENGINE 设置存储引擎，CHARSET 设置编码。

实例2：
![在这里插入图片描述](https://img-blog.csdnimg.cn/ff323136692f4472847f83481071002e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
int(10)的意思是假设有一个变量名为id，它的能显示的宽度能显示10位。在使用id时，假如我给id输入10，那么mysql会默认给你存储0000000010。当你输入的数据不足10位时，会自动帮你补全位数。假如我设计的id字段是int(20)，那么我在给id输入10时，mysql会自动补全18个0，补到20位为止。

**int(M)的作用于int的范围明显是无关的，int(M)只是用来显示数据的宽度，我们能看到的宽度。当字段被设计为int类型，那么它的范围就已经被写死了（看上面的1.1节的内容），与M无关。**




**以上面这个为例，有几个注意事项：
1.表名和字段名外面的符号 ` 不是单引号，而是英文输入法状态下的反单引号，也就是键盘左上角 esc 按键下面的那一个 ~ 按键。
2.comment 后面的字段用单引号括起来**



注意：MySQL命令终止符为分号 ; 。

## 查看数据表
法一：

```c
DESCRIBE 表名;
```

或简写成：

```c
DESC 表名;
```

法二：

```c
SHOW CREATE TABLE 表名;
```
在 SHOW CREATE TABLE 语句的结尾处（分号前面）添加\g或者\G参数可以改变展示形式。
## 插入数据
### 1.插入一行
```bash
INSERT INTO table_name ( field1, field2,...fieldN )
                       VALUES
                       ( value1, value2,...valueN );
```

**注意：这个是添加一行数据，不是添加一列。添加一列要增加新的字段。**

```
 INSERT INTO teacher (name,age,id_number) VALUES ('秦小贤',18,'42011720200604088X');
```
**注意：表名后面的字段没有引号，插入的数据，如果是字符串，要加引号**

### 2.插入多行

```
INSERT INTO teacher
(name,age,id_number)
VALUES
('王小花',19,'42011720200604077X'),
('张晓丽',18,'42011720200604099X'),
('刘美丽',20,'42011720200604020X'),
('吴帅',21,'42011720200604022X'),
('张平',22,'42011720200604033X')
```



### 3.插入一列
前提是这一列已经建好（通过ALTER），如果不加where，那是这个字段（一列）全部更新。

```c
UPDATE table_name SET field1=new-value1, field2=new-value2
[WHERE Clause]
```

## 修改表名和字段（增、删、改）
### 删除、添加、修改字段

```
//删除字段i
//如果数据表中只剩余一个字段则无法使用DROP来删除字段。
mysql> ALTER TABLE testalter_tbl  DROP i;
```

添加字段：
```c
mysql> ALTER TABLE testalter_tbl ADD i INT;
```

如果你需要指定新增字段的位置，可以使用MySQL提供的关键字 FIRST (设定位第一列)， AFTER 字段名（设定位于某个字段之后）。

尝试以下 ALTER TABLE 语句, 在执行成功后，使用 SHOW COLUMNS 查看表结构的变化：

```c
ALTER TABLE testalter_tbl DROP i;
ALTER TABLE testalter_tbl ADD i INT FIRST;
ALTER TABLE testalter_tbl DROP i;
ALTER TABLE testalter_tbl ADD i INT AFTER c;
```

**指定位置插入字段**
```
//添加到第一个
alter table 表名 add column 字段名 varchar(255) FIRST;

//添加到指定字段后，记得加上符号，那个符号是esc按键下面的
alter table person_param add column `module_name` VARCHAR(20) after `product_id`
```

### 修改字段类型及名称
![在这里插入图片描述](https://img-blog.csdnimg.cn/3b1fe134a6ee4169be9014e24667eced.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)



## 创建用户
默认用户为root，但是在Linux和mysql中，可以认为root用户就是各自系统的皇帝，对其它用户的数据有生杀大权，所以最好创建其它的用户来执行。
1.先登录

```bash
mysql -uroot -p
```
2.创建一个只能在mysql服务器所在主机使用的用户，此处为localuser

```bash
create user '用户名'@'localhost' identified by '用户的密码';
```
localuser可以在mysql服务器所在主机正常使用


3.在另外一台主机登陆时，会报错

```bash
本机登陆：mysql -ulcocaluser -p

远程登陆：mysql -h mysql服务器ip -ulocaluser -p
```
4、创建一个只能由特定远程主机使用的帐户，此处为limituser。

limituser只能在指定的主机使用。

```bash
create user 'limituser'@'远程主机ip' identified by '123';
```
本机登陆：mysql -ulcocaluser -p

远程登陆：mysql -h mysql服务器ip -ulocaluser -p

5、创建一个可以在本地和远程都可以登陆的用户，此处为unlimituser。

对，就是在创建用户时，host使用通配符%

```bash
create user 'unlimituser'@'%' identified by '123';
```
unlimituser用户服务器主机和远程主机登陆

6.删除用户

```bash
drop user 'mysqluser'@'host'
```

## 创建外键

### 创建表时增加外键
首先创建第一张被关联表Vendors商品供应商表。
```
-- 供应商列表
CREATE TABLE Vendors (
	-- 供应商ID：主键列，自增长
	vend_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '供应商ID',
	-- 供应商名：可变字符，非空
	vend_name VARCHAR (30) NOT NULL COMMENT '供应商名',
	-- 供应商地址
	vend_address VARCHAR (100) NOT NULL COMMENT '地址',
	-- 供应商城市
	vend_city VARCHAR (20) NOT NULL COMMENT '城市',
	-- 供应商州
	vend_state VARCHAR (20) NOT NULL COMMENT '州',
	-- 供应商邮编
	vend_zip VARCHAR (20) NOT NULL COMMENT '邮编',
	-- 供应商国家
	vend_country VARCHAR (20) NOT NULL COMMENT '国家'
);
```

然后创建第二张关联表Products产品表。

```
-- 产品目录表
CREATE TABLE Products (
	-- 产品ID：主键列，自增长
	prod_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	-- 供应商ID：外键
	vend_id INT NOT NULL COMMENT '供应商ID',
	-- 产品名
	prod_name VARCHAR (30) NOT NULL COMMENT '产品名',
	-- 产品价格
	prod_price DOUBLE NOT NULL COMMENT '产品价格',
	-- 产品描述
	prod_desc VARCHAR (100) COMMENT '产品描述',
	FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id)
);
```

### 已存在表增加外键

首先删除刚才两张表所创建的外键。
然后通过下面指令对已经存在的表增加外键。语法如下：
```
-- 已存在表增加外键
//(主键字段)和 (外键字段)没有加括号会报错
ALTER TABLE ZDZ ADD FOREIGN KEY (sd) REFERENCES Ws_para (snum);
```

## 连表查询
[详细介绍网址](https://juejin.cn/post/7043811976270577672)
```
SELECT * from `products` a RIGHT JOIN `person_param` b ON a.product_id=b.product_id WHERE a.product_id=338;
```
连表查的第一步就是两个表要关连起来，在上面的代码就是 ON 后面的``` a.product_id=b.product_id```


#  Mysql常见问题
##  mysql官网下载老版本
[下载网址，可选操作系统](https://dev.mysql.com/downloads/mysql/)

进入后依次选择：DOWNLOADS（下载）——>Community(社区)——MySQL Community Downloads
![在这里插入图片描述](https://img-blog.csdnimg.cn/d11d8469ebcd411faf3c9b67c4f4e02b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
进入后往下拉，如下图选择Looking for previous GA versions（寻找以前的GA版本）
![在这里插入图片描述](https://img-blog.csdnimg.cn/1371dd641c0e4c3ab54e10660e5907ed.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  centos安装mysql
本地下载mysql，但是xftp上传太慢，暂未找到解决的办法，所以尝试下面这个方法。

**1 下载并安装MySQL官方的 Yum Repository**

```
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
```
使用上面的命令就直接下载了安装用的Yum Repository，大概25KB的样子，然后就可以直接yum安装了。

```
yum -y install mysql57-community-release-el7-10.noarch.rpm
```
 之后就开始安装MySQL服务器。

```
yum -y install mysql-community-server
```
这步可能会花些时间，安装完成后就会覆盖掉之前的mariadb。
![在这里插入图片描述](https://img-blog.csdnimg.cn/000f9e71988a495bb16d7f886050e5f7.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_18,color_FFFFFF,t_70,g_se,x_16)
至此MySQL就安装完成了，然后是对MySQL的一些设置。

**2 MySQL数据库设置**

```
systemctl start  mysqld.service // 首先启动MySQL

systemctl status mysqld.service //查看MySQL运行状态
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/acda61b3da8b4837ad7bdf9020468ea1.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
此时MySQL已经开始正常运行，不过要想进入MySQL还得先找出此时root用户的密码，通过如下命令可以在日志文件中找出密码：

```
grep "password" /var/log/mysqld.log
```

 如下命令进入数据库：

```
 mysql -u root -p
```

输入初始密码，此时不能做任何事情，因为MySQL默认必须修改密码之后才能操作数据库：

```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'new password';
//密码需要设置复杂点，不然会报错。原因是因为MySQL有密码设置的规范，具体是与validate_password_policy的值有关：
```

**3.密码修改**
***上面那一步修改是必须的，否则没法二次修改密码***

先进入mysql

查看 mysql 初始的密码策略
```
 SHOW VARIABLES LIKE 'validate_password%';
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/0d3db11aae794c05adf48c94ade4094b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
首先需要设置密码的验证强度等级，设置 validate_password_policy 的全局参数为 LOW 即可

```
set global validate_password_policy=LOW; 
```

当前密码长度为 8 ，如果不介意的话就不用修改了，按照通用的来讲，设置为 6 位的密码，设置 validate_password_length 的全局参数为 6 即可

```
set global validate_password_length=6;
```

现在可以为 mysql 设置简单密码了，只要满足六位的长度即可

```
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
```

> 注：在默认密码的长度最小值为 4 ，由 大/小写字母各一个 + 阿拉伯数字一个 + 特殊字符一个， 只要设置密码的长度小于 3
> ，都将自动设值为 4 ，如下图：
> 
> 
> <br>
> 
> 关于 mysql 密码策略相关参数；
>  1）、validate_password_length  固定密码的总长度；
> 2）、validate_password_dictionary_file 指定密码验证的文件路径；
> 3）、validate_password_mixed_case_count  整个密码中至少要包含大/小写字母的总个数；
> 4）、validate_password_number_count  整个密码中至少要包含阿拉伯数字的个数；
> 5）、validate_password_policy 指定密码的强度验证等级，默认为 MEDIUM； 关于
> validate_password_policy 的取值： 0/LOW：只验证长度； 1/MEDIUM：验证长度、数字、大小写、特殊字符；
> 2/STRONG：验证长度、数字、大小写、特殊字符、字典文件；
> 6）、validate_password_special_char_count 整个密码中至少要包含特殊字符的个数；


## 重置密码（centos7）
[原文链接](https://blog.csdn.net/cgtcsdn/article/details/101530671)
### 忘记密码
**1.设置MySQL为免密码登录**
`vi /etc/my.cnf` (部分Linux安装了vim，其命令则改为`vim /etc/my.cnf`)按【i】键进入编辑模式，在[mysqld]下面加上“skip-grant-tables”，按【Esc】键，然后输入“:wq”保存并退出vi。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190927141449601.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NndGNzZG4=,size_16,color_FFFFFF,t_70#pic_center)

**重新启动MySQL服务（使配置生效，此步骤不能省略）**

```
service mysqld restart
```

**清空旧密码**

```
mysql -u root –p （无需输入密码，直接按回车键进入）

use mysql

update user set authentication_string = '' where user = 'root';

quit
```
**删除免密码登录代码“skip-grant-tables”**

vi /etc/my.cnf，按【i】键进入编辑模式，删除[mysqld]下面的代码“skip-grant-tables”，按【Esc】键，然后输入“:wq”保存并退出vi。

**重设密码**

```
service mysqld restart

mysql -u root –p （无需输入密码，直接按回车键进入）

use mysql

ALTER USER 'root'@'%' IDENTIFIED BY 'snaiL_12';  //密码要用引号括起来
```
### 报错
***问题1***
```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'snaiL_123';
```
报错：`ERROR 1819 (HY000): Your password does not satisfy the current policy requirements`

**解决：**

```
SHOW VARIABLES LIKE 'validate_password%';
```
1.2调整MySQL密码验证规则，修改 policy 和 length 的值。

```
set global validate_password——policy=0;（“0”等价于“LOW”，含义是只验证密码长度）

set global validate_password.length=8;（因为我之前动过密码长度，这里我将密码长度设为8）

```
***问题2***

```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'snaiL_123';

```
报错：`ERROR 1396 (HY000): Operation ALTER USER failed for 'root'@'localhost'`

**查看root账户的host**

```
select user,host from user;
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190927141940582.png#pic_center)

2.2注意看，我的host是“%”，你输入的命令可能是：

```
ALTERUSER 'root'@'localhost' IDENTIFIED BY 'Snail@10'; 
```
将命令改成：

```
ALTER USER 'root'@'%' IDENTIFIED BY 'Snail@10'; 
```

##  Navicat连接mysql出现1130 - Host XXX is not allowed to connect to this MySQL server
接上一条，安装完成后，navicat无法正常连接，这是由于Mysql配置了不支持远程连接引起的。

**1.在安装Mysql数据库的主机上登录root用户**

```
mysql -u root -p
```
2.依次执行如下命令：

```
use mysql;
 
select host from user where user='root';
```
可以看到当前主机配置信息为localhost.
![在这里插入图片描述](https://img-blog.csdnimg.cn/e4dee3a582374c6eba09244e9b947247.png)
3.将Host设置为通配符%

Host列指定了允许用户登录所使用的IP，比如user=root Host=192.168.1.1。这里的意思就是说root用户只能通过192.168.1.1的客户端去访问。 user=root Host=localhost，表示只能通过本机客户端去访问。而%是个通配符，如果Host=192.168.1.%，那么就表示只要是IP地址前缀为“192.168.1.”的客户端都可以连接。如果Host=%，表示所有IP都有连接权限。 



**注意：在生产环境下不能为了省事将host设置为%，这样做会存在安全问题，具体的设置可以根据生产环境的IP进行设置；**

```
update user set host = '%' where user ='root';
```

Host设置了“%”后便可以允许远程访问。

![在这里插入图片描述](https://img-blog.csdnimg.cn/8a3b8bb5074a4f8b9132a2eebdec3301.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_14,color_FFFFFF,t_70,g_se,x_16)

4..Host修改完成后记得执行flush privileges使配置立即生效

```
flush privileges;
```

## 批量插入数据很慢
[原文链接](https://www.jianshu.com/p/127e79e20d1b)

### 批量提交事务
```
# 3、批量提交事务
drop procedure if exists insertIntoUser;

delimiter $$
 
create procedure insertIntoUser(in num int, in batchNum int)
    begin
        declare i int default 0;
        
        while i < num do
            set i = i + 1;
            set @username = concat('beigua', LPAD(i, 9, 0));
            set @nickname = concat('北瓜', LPAD(i, 9, 0));
            set @password = replace(uuid(), "-", "");
            set @password_salt = replace(uuid(), "-", "");
            set @user_no = i;

            set autocommit = 0;

            INSERT INTO user(username, password, password_salt, nickname, user_no, ip, mobile, mail, gender, type, status, is_deleted, created_time, updated_time) 
            VALUES (@username, @password, @password_salt, @nickname, @user_no, '192.168.1.1', '18888888888', '18888888888@163.com', '0', '0', '0', '0', now(), now());
        
            if i mod batchNum = 0 then
                commit;
            end if;
        end while;
    end $$
```
### 一次性提交所有事务
```
# 4、一次性提交事务
drop procedure if exists insertIntoUser;

delimiter $$
 
create procedure insertIntoUser(in num int)
    begin
        declare i int default 0;

        set autocommit = 0;
        
        while i < num do
            set i = i + 1;
            set @username = concat('beigua', LPAD(i, 9, 0));
            set @nickname = concat('北瓜', LPAD(i, 9, 0));
            set @password = replace(uuid(), "-", "");
            set @password_salt = replace(uuid(), "-", "");
            set @user_no = i;

            INSERT INTO user(username, password, password_salt, nickname, user_no, ip, mobile, mail, gender, type, status, is_deleted, created_time, updated_time) 
            VALUES (@username, @password, @password_salt, @nickname, @user_no, '192.168.1.1', '18888888888', '18888888888@163.com', '0', '0', '0', '0', now(), now());
        end while;
        
        commit;
    end $$
```
### 数据插入前加索引与数据插入后加索引对比
在插入数据的时候不要加过多索引，插完再加

### 修改参数
set global innodb_flush_log_at_trx_commit = 0;

<br>

# 如何设计数据库
[原文链接](https://blog.csdn.net/LLLLQZ/article/details/110231569)

# 游标、存储过程、函数
存储过程是为了完成特定功能的SQL语句集，经编译创建并保存在数据库中，用户可通过指定存储过程的名字并给定参数(需要时)来调用执行。

存储过程思想上很简单，就是数据库 SQL 语言层面的代码封装与重用。



**使用存储过程需要注意一些问题**
1. 注意分号的使用，语句后面没加分号会报错
2. 存储过程既可以放查询里面，也可以放存储里面（工具栏-》函数-》存储）
3. mysql存储过程每一句后面必须用;结尾，使用的**临时字段**需要在定义游标之前进行声明。

上面第三点的解释如下：
```
DECLARE s int DEFAULT 0;
declare p_t_id bigint(20);
declare varmodule int DEFAULT 0;
declare varparam int DEFAULT 0; 

declare pid cursor for select product_id from products;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET s=1;
```
所有的declare必须放在游标声明前面（declare pid cursor这句）
