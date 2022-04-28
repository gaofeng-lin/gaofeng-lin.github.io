---
title: Java框架+工具
date: 2022/4/28

categories:
  - Java
  
tags:
  - Spring
  - Java
  - SpringBoot
---

# SSM
**springboot 只是组装了spring和springmvc。SSM中的SS指的是Spring SpringMVC，M是指MyBatis。**
## SSM（Spring+SpringMVC+MyBatis）架构
### 工作原理
1.SSM系统架构
![在这里插入图片描述](https://img-blog.csdnimg.cn/fd51aa6838fd4315ac1df679eb3500e5.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

2.执行流程
![在这里插入图片描述](https://img-blog.csdnimg.cn/0a57266814cb4fe395124ce40ea590a4.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

## MSCM(model ,service, controller ,mapper)
***mapper的中文意思是映射器；mapper和dao是一个东西，叫法不同。***

**业务逻辑：**
 Controller-->service接口-->serviceImpl-->dao接口-->daoImpl-->mapper-->db

**一：Dao(Data Access Object):数据存储对象**
       DAO = Data Access Object = 数据存取对象. 不管是什么框架，我们很多时候都会与数据库进行交互。如果遇到一个场景我们都要去写SQL语句，那么我们的代码就会很冗余。所以，我们就想到了把数据库封装一下，让我们的数据库的交道看起来像和一个对象打交道，这个对象通常就是DAO。当我们操作这个对象的时候，这个对象会自动产生SQL语句来和数据库进行交互，我们就只需要使用DAO就行了。
       
   通常我们在DAO层里面写接口，里面有与数据打交道的方法。SQL语句通常写在mapper文件里面的。
    
   优点：结构清晰，Dao层的数据源配置以及相关的有关数据库连接的参数都在Spring配置文件中进行配置。

**二：Service：服务**
       服务是一个相对独立的功能模块，主要负责业务逻辑应用设计。首先也要设计接口，然后再设计其实现该接口的类。这样我们就可以在应用中调用service接口进行业务处理。service层业务实现，具体调用到已经定义的DAO的接口，封装service层的业务逻辑有利于通用的业务逻辑的独立性和重复利用性 。
     如果把Dao层当作积木，则Service层则是对积木的搭建。

**三：Controller：控制器**
       主要负责具体业务模块流程的控制，此层要调用到Service层的接口去控制业务流程，控制的配置同样在Spring配置文件中配置。针对不同的业务流程有不同的控制器。在设计的过程可以设计出重复利用的子单元流程模块。

 

 **四：model：模型**
 模型就是指视图的数据Model，模型，通常来讲，我们会把模型和另一个东西放在一起来说：View，视图。

模型通常认为是视图的内核，何谓之视图？我们正在与之交互的网站的界面就是视图，而模型是指他的内核：数据。

   将Model和View的概念拆分开来，有助于我们关注不同的方面，也可以更有效的分工。有些工程师更关注于内核也就是模型，通常来说，他们被称之为后端工程师。有些工程师更关注于用户界面的交互和展示，通常来说，他们被称之为前端工程师。

**五: View层：**
       与Controller层关系紧密，View层主要负责前台jsp页面的表示。

 

**六: 它们之间的关系：**
      建立了DAO层后才可以建立Service层，而Service层又是在Controller层之下的，因而Service层应该既调用DAO层的接口，又要提供接口给Controller层的类来进行调用，它刚好处于一个中间层的位置。每个模型都有一个Service接口，每个接口分别封装各自的业务处理方法。

![在这里插入图片描述](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9zczMuYmRzdGF0aWMuY29tLzcwY0Z2OFNoX1ExWW54R2twb1dLMUhGNmhoeS9pdC91PTY1ODc1NzYzNCwzMTUzMjQ0OTA1JmZtPTI2JmdwPTAuanBn?x-oss-process=image/format,png#pic_center)
另一个图的解释：
实体类这一层，有的开发写成pojo，有的写成model，也有domain，也有dto（这里做参数验证，比如password不能为空等），实体类如果你不懂什么东西的话，那你就想成是范围。

mapper 是Mybatis 操作数据库的那一层，就是dao层。

service包含了serviceImpl（service接口的实现类） 是提供给controller 使用的，针对于某些业务将 dao 的对于某些表的crud进行组合，也就是说间接的和数据库打交道。

controller 通过调用service来完成业务逻辑。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190806101012614.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNjQ3OTk5,size_16,color_FFFFFF,t_70#pic_center)

## JavaWeb三层架构
**（Servlet(Controller),service,dao）**
![在这里插入图片描述](https://img-blog.csdnimg.cn/1f793bb259964619876d3efb18303f2e.png)

第一层Servlet,也叫controller层，处理JSP页面传输的数据，一般通过request.getParameter获取表单中属性为name参数中的value值，在Servlet层中一般会通过new的方式创建一个Service。如

UserService userService = new UserServiceimpl();因为一般Service层会创建一个接口写一些方法（userService）,并创建一个实现类实现这个接口(UserServiceImpl)。

![在这里插入图片描述](https://img-blog.csdnimg.cn/a9a95bf4b1204f3cb542a1f22bb5094a.png)
service层用来处理一些前端传输过来一些数据进行数据库的增删改查，或者处理DAO层从数据库获取的数据，例如对数据进行分页。因为需要调用DAO层，所以也需要new一个DAO层。

![在这里插入图片描述](https://img-blog.csdnimg.cn/9ef53b31f1034ac1bb14e47506482bed.png)

对数据进行分页

![在这里插入图片描述](https://img-blog.csdnimg.cn/7ae167596761457c991e6dd569b2cc2b.png)

UserDao userDao = new UserDaoImpl;

![在这里插入图片描述](https://img-blog.csdnimg.cn/9d1e342190fd41a7882915823fc74508.png)
Dao层是用来与数据库进行交互，也就是增删改查。可以通过前端传输过来的数据对用户的信息进行增删改查。

![在这里插入图片描述](https://img-blog.csdnimg.cn/92f11628821e46c48e9dbedc1901b23d.png)

## Spring IOC
1.xml配置文件利用反射获取class对象
![在这里插入图片描述](https://img-blog.csdnimg.cn/4a0f6bab3f814b2eb88ce5bf7a0752dd.png)
2. 获取容器、获得bean对象、使用方法。
![在这里插入图片描述](https://img-blog.csdnimg.cn/6a34e9ded1434451bd7a166d18c3aa5e.png)

## Spring AOP
[原文](https://blog.51cto.com/u_14625481/3485049)

**IOC让模块之间解耦，AOP让JAVA动起来。**
AOP相对应的一个词叫OOP，AOP（Aspect Oriented Programming），即面向切面编程。OOP主要是为了实现编程的重用性、灵活性和扩展性。它的几个特征分别是继承、封装、多态和抽象。OOP重点体现在编程架构，强调的是类之间的层次关系。
![在这里插入图片描述](https://img-blog.csdnimg.cn/0f7647b2c8414917924b5be5a50f2f69.png)
看到上面的图，我们暂时还不能发现有什么问题。为了大家便于理解，接下来我来给大家讲解一下上面类图的实现过程。描述如下：马戏团有一条表演的小狗，这条小狗可以跑和跳，但是它完成跑和跳两个动作之前必须是在接到驯兽师发出的命令后，同时完成跑和跳的动作之后，驯兽师会给与响应的奖励，比如一块肉。

了解了实现过程之后，我们在来看一下具体的代码。 

![在这里插入图片描述](https://img-blog.csdnimg.cn/5b3feb96c994426fbc8f89aab82a3e38.png)
仔细看上面的代码，我们可以看出在run方法和jump方法中，存在一些相同的内容（驯兽师发出命令和给与奖励），这些内容并不能完全进行抽象，即不能按照OOP编程思想进行处理。类似这样的情况同样会出现在我们编程中的很多地方，例如：日志记录、性能统计、安全控制、事务处理、异常处理等等。但是这样的情况该如何解决呢？这就引入了AOP编程思想。


AOP为Aspect Oriented Programming的缩写，即面向切面编程（也叫面向方面），是一种可以通过预编译方式和运行期动态代理实现在不修改源代码的情况下给程序动态统一添加功能的一种技术。

**AOP实现实例**
为了大家更好的理解AOP如何实现，接下来我们优化一下上述代码。
首先是Dog类
![在这里插入图片描述](https://img-blog.csdnimg.cn/2332d45a5bb1451aa65977fca95a6f03.png)

对比之前的代码我们可以明显看出，我们将关于驯兽师的相关内容从run和jump中进行了抽取，接下来，我们如何在程序运行中将关于驯兽师的动作加入到程序中呢？这就是我们这次用到的AOP实现的核心技术动态代理（Dynamic Proxy）。具体代码如下：


# 常见缩写
## JSP
[详情](https://www.runoob.com/jsp/jsp-tutorial.html)
JSP 与 PHP、ASP、ASP.NET 等语言类似，运行在服务端的语言。

JSP（全称Java Server Pages）是由 Sun Microsystems 公司倡导和许多公司参与共同创建的一种使软件开发者可以响应客户端请求，而动态生成 HTML、XML 或其他格式文档的Web网页的技术标准。

JSP 技术是以 Java 语言作为脚本语言的，JSP 网页为整个服务器端的 Java 库单元提供了一个接口来服务于HTTP的应用程序。

JSP文件后缀名为 *.jsp 。

JSP开发的WEB应用可以跨平台使用，既可以运行在 Linux 上也能运行在 Windows 上。

## POJO、JAVABean、Entity
**1.POJO**
  （Plain Ordinary Java Object）简单的Java对象，实际就是普通JavaBeans，是为了避免和EJB混淆所创造的简称。
  其中有一些属性及其getter、setter方法的类，没有业务逻辑，有时可以作为VO（value-object）或DTO（Data Transfer Object）来使用。不允许有业务方法，也不能携带connection之类的方法，实际就是普通JavaBeans。POJO类中有属性和get、set方法，但是没有业务逻辑。
  

```
/**
 * POJO类代码示例
 */  
public class UserInfoPojoDemo {

    private int userId;// 用户帐号
    private String pwd;// 用户密码

    /**
     * Constructor
     */
    public UserInfoPojoDemo() {
    }

    public UserInfoPojoDemo(String pwd) {
        this.pwd = pwd;
    }

    public UserInfoPojoDemo(int userId) {
        this.userId = userId;
    }

    public UserInfoPojoDemo(int userId, String pwd) {
        this.userId = userId;
        this.pwd = pwd;
    }

    /**
     *Access 
     */
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

}
```
**2.JAVABean**
一种JAVA语言写成的可重用组件。JavaBean符合一定规范编写的Java类，不是一种技术，而是一种规范。大家针对这种规范，总结了很多开发技巧、工具函数。符合这种规范的类，可以被其它的程序员或者框架使用。它的方法命名，构造及行为必须符合特定的约定：

1、所有属性为private。

2、这个类必须有一个公共的缺省构造函数。即是提供无参数的构造器。

3、这个类的属性使用getter和setter来访问，其他方法遵从标准命名规范。

4、这个类应是可序列化的。实现serializable接口。

因为这些要求主要是靠约定而不是靠实现接口，所以许多开发者把JavaBean看作遵从特定命名约定的POJO。

```
public class UserInfo implements java.io.Serializable{  

//实现serializable接口。  
private static final long serialVersionUID = 1L;  

private String name;  
private int age;  

//无参构造器  
public UserInfo() {  

}  

public String getName() {  
    return name;  
}  

public void setName(String name) {  
    this.name = name;  
}  

public int getAge() {  
    return age;  
}  

public void setAge(int age) {  
    this.age = age;  
}  

//javabean当中可以有其它的方法  
public void userInfoPrint(){  
    System.out.println("");  
 } 
}
```
**区别
POJO其实是比javabean更纯净的简单类或接口。POJO严格地遵守简单对象的概念，而一些JavaBean中往往会封装一些简单逻辑。
POJO主要用于数据的临时传递，它只能装载数据， 作为数据存储的载体，而不具有业务逻辑处理的能力。
Javabean虽然数据的获取与POJO一样，但是javabean当中可以有其它的方法。**


**3.entity（实体类）**
对java实体类的众多理解：

A .就是属性类，通常定义在model层里面

B. 一般的实体类对应一个数据表，其中的属性对应数据表中的字段。
好处：
1.对对象实体的封装，体现OO思想。
2.属性可以对字段定义和状态进行判断和过滤
3.把相关信息用一个实体类封装后，我们在程序中可以把实体类作为参数传递，更加方便。

C. 说白了就是为了让程序员在对数据库操作的时候不用写SQL语句

D. 就是一个数据库表生成一个类
这样做对数据库操作起来方便
编写代码较少 提高效率 可以使程序员专注逻辑关系

E. 实体类就是把对某一个表的操作全写在一个类中.

F. 在Java开发中经常要定义一些实体类，这些类的定义的好坏会直接影响，编写代码的质量和难易程度，以下是别人总结的一些经验。

一、实体类的名字尽量和数据库的表的名字对应相同。

二、实体类应该实现java.io.Serializable接口。

三、实体类应该有个无参的构造方法。

四、实体类应该有个有参（所有的参数）的构造方法。

五、实体类有属性和方法，属性对应数据库中表的字段，主要有getter和setter方法。

六、实体类还应该有个属性serialVersionUID。例如：private static final long serialVersionUID = -6125297654796395674L;

七、属性一般是private类型，方法位public类型，对于数据库自动生成的ID字段对应的属性的set方法应为private。