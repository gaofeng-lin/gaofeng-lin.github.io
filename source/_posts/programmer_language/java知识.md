---
title: Java知识
date: 2022/2/28
categories:
  - 编程语言
tags:
  - 动态规划
  - 数据结构
  - Java
  - SpringBoot
abbrlink: 53165
---


## Java基础知识
### 反射
[原文链接](https://blog.csdn.net/weixin_43271086/article/details/106023108?spm=1001.2101.3001.6650.1&depth_1-utm_relevant_index=2)

**JAVA反射机制是在运行状态中，对于任意一个实体类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意方法和属性；这种动态获取信息以及动态调用对象方法的功能称为java语言的反射机制。**

**反射的好处：
      1.可以在程序运行过程中，操作这些对象。
      2.可以进行解耦，提高程序的扩展性。**
      
Java代码在计算机中的三个阶段

 - 1.Sources源代码阶段：*.java被编译成*.class字节码文件。
 - 2.Class类对象阶段：*.class字节码文件被类加载器加载进内存，并将其封装成Class对象（用于描述在内存中描述字节码文件），Class对象将原字节码文件中的成员变量，构造函数，方法等的做了封装。
 - 3.Runtime运行阶段：创建对象的过程new

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509170218257.png)


#### 获取Class对象
获取Class对象的三种方式对应着java代码在计算机中的三个阶段：

1.源代码阶段
Class.forName("全类名")：将字节码文件加载进内存，返回Class对象。

2.Class类对象阶段
类名.class:通过类名的属性class获取

3.Runtime运行时阶段
对象.getClass():getClass()方法是定义在Object类中的方法。

**结论：同一个字节码文件(*.class)在一次程序运行过程中，只会被加载一次，无论通过哪一种方式获取的Class对象都是同一个。**

测试代码：

```java
package com.company.reflect;
 
import com.company.reflect.domain.Person;
 
/**
 * ⊙﹏⊙&&&&&&⊙▽⊙
 *
 * @Auther: pangchenbo
 * @Date: 2020/5/9 10:37
 * @Description:
 */
public class ReflectDemo {
    public static void main(String[] args) throws ClassNotFoundException {
        //方式一：Class.forName("全类名")
        Class<?> aClass = Class.forName("com.company.reflect.domain.Person");
        System.out.println(aClass);
        //方式二：类名.class
        Class<Person> personClass = Person.class;
        System.out.println(personClass);
        //方式三：对象.getClass()
        Person person = new Person();
        Class<? extends Person> aClass1 = person.getClass();
        System.out.println(aClass1);
        //比较 == 三个对象
        System.out.println(aClass == aClass1);
        System.out.println(personClass==aClass1);
    }
}
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509171516530.png)
两个true表示Class对象是同一个。



#### 获取Class对象功能

```java
（1）获取成员变量们
		Field[] getFields() ：获取所有public修饰的成员变量
		Field getField(String name)   获取指定名称的 public修饰的成员变量
 
		Field[] getDeclaredFields()  获取所有的成员变量，不考虑修饰符
		Field getDeclaredField(String name)
（2）获取构造方法们
		Constructor<?>[] getConstructors()  
		Constructor<T> getConstructor(类<?>... parameterTypes)  
 
		Constructor<?>[] getDeclaredConstructors()  
		Constructor<T> getDeclaredConstructor(类<?>... parameterTypes)  
（3）获取成员方法们
		Method[] getMethods()  
		Method getMethod(String name, 类<?>... parameterTypes)  
 
		Method[] getDeclaredMethods()  
		Method getDeclaredMethod(String name, 类<?>... parameterTypes)
```
 **Field：成员变量**
先写一个测试类

```java
public class Person {
    private String name;
    private int age;
    public String a;
    protected String b;
    String c;
    private String d;
 
    public Person() {
 
    }
 
    public Person(String name, Integer age) {
        this.name = name;
        this.age = age;
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
 
    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", a='" + a + '\'' +
                ", b='" + b + '\'' +
                ", c='" + c + '\'' +
                ", d='" + d + '\'' +
                '}';
    }
    //无参方法
    public void eat(){
        System.out.println("eat...");
    }
 
    //重载有参方法
    public void eat(String food){
        System.out.println("eat..."+food);
    }
}
```

**获取所有的public修饰的成员变量**

```java
//0.获取Person对象
        Class<Person> personClass = Person.class;
        //1.获取所有public修饰的成员变量
        Field[] fields = personClass.getFields();
        for (Field field : fields) {
            System.out.println(field);
        }
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/2020050917325871.png)
**获取特定的成员变量（public）**

```java
//2.Field getField(String name)
        Field a = personClass.getField("a");
        //获取成员变量a 的值 [也只能获取公有的，获取私有的或者不存在的字符会抛出异常]
        Person person = new Person();
        Object o = a.get(person);
        System.out.println("o  value: "+o);
        //设置属性a的值
        a.set(person,"haha");
        System.out.println(person);
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509173350461.png)

**获取全部的成员变量**

```java
//Field[] getDeclaredFields()：获取所有的成员变量，不考虑修饰符
        Field[] declaredFields = personClass.getDeclaredFields();
        for (Field declaredField : declaredFields) {
            System.out.println(declaredField+" ");
        }
        System.out.println("==============================");
```

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509173421562.png)
**获取特定的成员变量，在这里如果需要对private进行修改，就必须进行暴力反射，将d.setAccessible(true);设置为true**

```java
System.out.println("==============================");
        Field d = personClass.getDeclaredField("d");
        d.setAccessible(true);//暴力反射
        d.get(person);
        d.set(person,"222");
        System.out.println(person);
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509173436455.png)
 **普通方法获取**
获取指定名称的方法（不带参数的获取）

```java
Class<Person> personClass = Person.class;
        //获取指定名称的方法
        Method eat = personClass.getMethod("eat");
        Person person = new Person();
        eat.invoke(person);//执行方法
```

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/202005091739379.png)
获取指定名称的方法（带参数获取）

```java
//获取具有参数的构造方法
        Method eat1 = personClass.getMethod("eat", String.class);
        eat1.invoke(person,"fans");
        System.out.println("===============================");
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509173946494.png)
获取方法列表

```java
Method[] methods = personClass.getMethods();
        for (Method method : methods) {
            System.out.println(method);//继承的方法也会被访问（前提是方法是public）
        }
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509174104725.png)
如果设置的方法中含有私有的方法，也可以设置d.setAccessible(true);设置为true，然后就可以访问私有方法。

**构造方法**
获取无参数的构造器

```java
Class<Person> personClass = Person.class;
        //Constructor<?>[] getConstructors()
        Constructor<?>[] constructors = personClass.getConstructors();
        for (Constructor<?> constructor : constructors) {
            System.out.println(constructor);
        }
        //Constructor<T> getConstructor(类<?>... parameterTypes)
        //获取无参
        Constructor<Person> constructor1 = personClass.getConstructor();
        System.out.println(constructor1);
            //利用获取的构造器创建对象
        Person person = constructor1.newInstance();
        System.out.println(person);
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509174551558.png)
获取有参数的构造器
```java
//获取有参
        Constructor<Person> constructor = personClass.getConstructor(String.class,Integer.class);
        System.out.println(constructor);
        Person person1 = constructor.newInstance("PCB",100);
        System.out.println(person1);
        //理应Class类对象进行对象的构建获取
        Person person2 = personClass.newInstance();
        System.out.println(person2);
        //对于getDeclaredConstructor方法和getDeclaredConstructors方法,此外在构造器的对象内也有setAccessible(true);方法，并设置成true就可以操作了。
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509174655701.png)

#### 简单框架设计、理解反射好处
准备测试类

```java
package com.company.reflect.domain;
 
/**
 * ⊙﹏⊙&&&&&&⊙▽⊙
 *
 * @Auther: pangchenbo
 * @Date: 2020/5/9 13:27
 * @Description:
 */
public class Student {
    public void sleep(){
        System.out.println("sleep...");
    }
}
```
 准备文件properties文件
 

```java
className = com.company.reflect.domain.Student
methodName = sleep
```

 **需求**
写一个"框架"，不能改变该类的任何代码的前提下，可以帮我们创建任意类的对象，并且执行其中任意方法。

**实现**
（1）配置文件 （2）反射

**步骤**

（1）将需要创建的对象的全类名和需要执行的方法定义在配置文件中 （2）在程序中加载读取配置文件 （3）使用反射技术来加载类文件进内存 （4）创建对象 （5）执行方法

```java
package com.company.reflect.反射案例;
 
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Properties;
 
/**
 * ⊙﹏⊙&&&&&&⊙▽⊙
 *
 * @Auther: pangchenbo
 * @Date: 2020/5/9 13:30
 * @Description:
 */
public class ReflectTest {
    public static void main(String[] args) throws Exception {
        /**
         * 前提：不能改变该类的任何代码。可以创建任意类的对象，可以执行任意方法
         */
        //1.加载配置文件
        //1.1创建Properties对象
        Properties properties = new Properties();
        //1.2加载配置文件，转换为一个集合
        //1.2.1获取class目录下的配置文件  使用类加载器
        ClassLoader classLoader = ReflectTest.class.getClassLoader();
        InputStream resourceAsStream = classLoader.getResourceAsStream("pro.properties");
        properties.load(resourceAsStream);
        //2.获取配置文件中定义的数据
        String className = properties.getProperty("className");
        String methodName = properties.getProperty("methodName");
 
        //加载类到内存中
        Class<?> aClass = Class.forName(className);
        //创建对象
        Object o = aClass.newInstance();
        //获取对象方法
        Method method = aClass.getMethod(methodName);
        //执行方法
        method.invoke(o);
 
    }
}
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/2020050917521036.png)
改变配置文件

```java
className = com.company.reflect.domain.Person
methodName = eat
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20200509175301411.png)

好处
我们这样做有什么好处呢，对于框架来说，是人家封装好的，我们拿来直接用就可以了，而不能去修改框架内的代码。但如果我们使用传统的new形式来实例化，那么当类名更改时我们就要修改Java代码，这是很繁琐的。修改Java代码以后我们还要进行测试，重新编译、发布等等一系列的操作。而如果我们仅仅只是修改配置文件，就来的简单的多，配置文件就是一个实实在在的物理文件。


### String类与StringBuilder类的区别
[原文链接](https://www.cnblogs.com/huameitang/p/10528646.html)

#### StringBuilder类介绍

**StringBuilder类是一个可变的字符序列。**

StringBuilder() 
          构造一个不带任何字符的字符串生成器，其初始容量为 16 个字符。
StringBuilder(CharSequence seq) 
          构造一个字符串生成器，它包含与指定的 CharSequence 相同的字符。
StringBuilder(int capacity) 
          构造一个不带任何字符的字符串生成器，其初始容量由 capacity 参数指定。
StringBuilder(String str) 
          构造一个字符串生成器，并初始化为指定的字符串内容。

#### StringBuilder类的几个常用方法

```
append(任意类型)  追加到字符串后面

reverse 反转字符串

insert(int offset, 任意类型)  在某个index后插入字符串

toString()  返回String类的对象
```

先看一段String类的字符串拼接的代码。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/388de719a9f6ee002b965e622dc87c46.png)

String s = "hello" 会在常量池开辟一个内存空间来存储”hello"。

s += "world"会先在常量池开辟一个内存空间来存储“world"。然后再开辟一个内存空间来存储”helloworld“。

这么以来，001与002就成为了垃圾内存空间了。这么简单的一个操作就产生了两个垃圾内存空间，如果有大量的字符串拼接，将会造成极大的浪费。

#### StringBuilder的作用

上面的例子可以知道String类的字符串拼接会产生大量的垃圾内存空间。但是StringBuilder的字符串拼接是直接在原来的内存空间操作的，即直接在hello这个内存空间把hello拼接为helloworld。

来证明下：

```
public class StringBuilderTest {
    public static void main(String[] args){
        StringBuilder sb = new StringBuilder();
        StringBuilder sb2 = sb.append("hello");
        System.out.println(sb);
        System.out.println(sb2);
        // 引用类型，判断的是他们的内存地址是否一样
        System.out.println(sb == sb2);
    }
}
```
输出结果是：

hello
hello
true

#### String类与StringBuilder类的相互转换
**1.String类转换为StringBuilder类**

```
public class String12 {
    public static void main(String[] args){
        String s = "hello";
        StringBuilder sb = new StringBuilder(s);
        System.out.println(sb);
    }
}
```
**2.StringBuilder类转换为String类**

```
public class String12 {
    public static void main(String[] args){
        StringBuilder sb = new StringBuilder();
        sb.append("abc").append("efg");
        String s = sb.toString();
        System.out.println(s);
    }
}
```

### 接口

#### 接口的作用

接口的最主要的作用是达到统一访问，就是在创建对象的时候用接口创建，```【接口名】 【对象名】=new 【实现接口的类】```，这样你像用哪个类的对象就可以new哪个对象了，不需要改原来的代码，就和你的USB接口一样，插什么读什么，就是这个原理。如果我用接口，```one.method1();``` 那样我```new a()；```就是用```a```的方法，```new b()```就是用```b```的方法

这个就叫统一访问，因为你实现这个接口的类的方法名相同，但是实现内容不同。


#### 为什么使用接口
**解耦，可扩展这是设计接口的主要原因之一**

如果你开发业务逻辑代码，当你好不容易的实现了它全部的功能，突然用户需求要改，你在修改你代码的同时，调用你代码的其它人也会改，如果代码关联性强的话，会有很多人都要改动代码，这样一来二去，程序会变得相当的不稳定，而且可能还会出现更多的新Bug,所有人都可能会陷入混乱。

但如果使用接口的话，在你使用它之前，就要想好它要实现的全部功能（接口实际上就是将功能的封装）。确定下这个接口后，如果用户需求变了，你只要重新写它的实现类，而其它人只会调用你的接口，他不管你是怎么实现的，它只需要接口提供的功能。这样，很可能只需要把你的代码修改就可以了，其他人什么都不用做。

同时：
这样做的话，使得开发人员能够分工明确，只要确定下来接口了，就可以同时进行开发，提高开发效率。另外，使用接口还有使用方便，可读性强，结构清晰等优点。

## Java内存分配
[原文链接](https://blog.csdn.net/shimiso/article/details/8595564)

### 内存表示图
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/02e0fdf7e9d05a24f1b00895c1726f04.png)

 - l 寄存器：JVM内部虚拟寄存器，存取速度非常快，程序不可控制。
 - l 栈：保存局部变量的值，包括：1.用来**保存基本数据类型的值**；2.保存**类的实例**，即堆区对象的引用(指针)。也可以用来保存加载方法时的帧。
 - | 堆：用来存放动态产生的数据，比如new出来的对象。注意创建出来的对象只包含属于各自的成员变量，并不包括成员方法。因为同一个类的对象拥有各自的成员变量，存储在各自的堆中，但是他们共享该类的方法，并不是每创建一个对象就把成员方法复制一次。
 - l 常量池：JVM为每个已加载的类型维护一个常量池，常量池就是这个类型用到的常量的一个有序集合。包括直接常量(基本类型，String)和对其他类型、方法、字段的符号引用(1)。池中的数据和数组一样通过索引访问。由于常量池包含了一个类型所有的对其他类型、方法、字段的符号引用，所以常量池在Java的动态链接中起了核心作用。常量池存在于堆中。
 - l 代码段：用来存放从硬盘上读取的源程序代码。
 - l 数据段：用来存放static定义的静态成员。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20180607221353561.png)


 - Byte Short Double等包装类也是类，属于引用数据类型。
 
 - 除了8个基本数据类型，其余都是引用。包括String(只是编译器对其做了特殊处理（使其和基本数据类型一样）)

### 预备知识
1.一个Java文件，只要有main入口方法，我们就认为这是一个Java程序，可以单独编译运行。

2.无论是普通类型的变量还是引用类型的变量(俗称实例)，都可以作为局部变量，他们都可以出现在栈中。只不过普通类型的变量在栈中直接保存它所对应的值，而引用类型的变量保存的是一个指向堆区的指针，通过这个指针，就可以找到这个实例在堆区对应的对象。因此，普通类型变量只在栈区占用一块内存，而引用类型变量要在栈区和堆区各占一块内存。


### 案例1
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/e66638ef11aa279b0b6fd9cd9d559044.png)
1.JVM自动寻找main方法，执行第一句代码，创建一个Test类的实例，在栈中分配一块内存，存放一个指向堆区对象的指针110925。

2.创建一个int型的变量date，由于是基本类型，直接在栈中存放date对应的值9。

3.创建两个BirthDate类的实例d1、d2，在栈中分别存放了对应的指针指向各自的对象。他们在实例化时调用了有参数的构造方法，因此对象中有自定义初始值。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/705d238bc74dcccff8b69184132da30c.png)
调用test对象的change1方法，并且以date为参数。JVM读到这段代码时，检测到i是局部变量，因此会把i放在栈中，并且把date的值赋给i。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/352eb6cc1d1356088c01eff85f968f29.png)

把1234赋给i。很简单的一步。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/17a915e436d6d65fac2429a7a11b8866.png)
change1方法执行完毕，立即释放局部变量i所占用的栈空间。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/c26f92c212ed59baec902643ce847cdb.png)
调用test对象的change2方法，以实例d1为参数。JVM检测到change2方法中的b参数为局部变量，立即加入到栈中，由于是引用类型的变量，所以b中保存的是d1中的指针，此时b和d1指向同一个堆中的对象。在b和d1之间传递是指针。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/de5ed94481f833da822dae4b0ba7829c.png)

change2方法中又实例化了一个BirthDate对象，并且赋给b。在内部执行过程是：在堆区new了一个对象，并且把该对象的指针保存在栈中的b对应空间，此时实例b不再指向实例d1所指向的对象，但是实例d1所指向的对象并无变化，这样无法对d1造成任何影响。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/a5962e6481115a3701e9af607d7dbef5.png)
change2方法执行完毕，立即释放局部引用变量b所占的栈空间，注意只是释放了栈空间，堆空间要等待自动回收。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/320c1cc9ffa2cb1765dce52ab4e78512.png)

调用test实例的change3方法，以实例d2为参数。同理，JVM会在栈中为局部引用变量b分配空间，并且把d2中的指针存放在b中，此时d2和b指向同一个对象。再调用实例b的setDay方法，其实就是调用d2指向的对象的setDay方法。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/7085e0609e9a98b2cd813f7321083938.png)
调用实例b的setDay方法会影响d2，因为二者指向的是同一个对象。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/20781e5bcd02ed64fce2f1f20a8f4c8d.png)
change3方法执行完毕，立即释放局部引用变量b。



以上就是Java程序运行时内存分配的大致情况。其实也没什么，掌握了思想就很简单了。无非就是两种类型的变量：基本类型和引用类型。二者作为局部变量，都放在栈中，基本类型直接在栈中保存值，引用类型只保存一个指向堆区的指针，真正的对象在堆里。作为参数时基本类型就直接传值，引用类型传指针。

小结：

1.分清什么是实例什么是对象。Class a= new Class();此时a叫实例，而不能说a是对象。实例在栈中，对象在堆中，操作实例实际上是通过实例的指针间接操作对象。多个实例可以指向同一个对象。

2.栈中的数据和堆中的数据销毁并不是同步的。方法一旦结束，栈中的局部变量立即销毁，但是堆中对象不一定销毁。因为可能有其他变量也指向了这个对象，直到栈中没有变量指向堆中的对象时，它才销毁，而且还不是马上销毁，要等垃圾回收扫描时才可以被销毁。

3.以上的栈、堆、代码段、数据段等等都是相对于应用程序而言的。每一个应用程序都对应唯一的一个JVM实例，每一个JVM实例都有自己的内存区域，互不影响。并且这些内存区域是所有线程共享的。这里提到的栈和堆都是整体上的概念，这些堆栈还可以细分。

4.类的成员变量在不同对象中各不相同，都有自己的存储空间(成员变量在堆中的对象中)。而类的方法却是该类的所有对象共享的，只有一套，对象使用方法的时候方法才被压入栈，方法不使用则不占用内存。


以上分析只涉及了栈和堆，还有一个非常重要的内存区域：常量池，这个地方往往出现一些莫名其妙的问题。常量池是干嘛的上边已经说明了，也没必要理解多么深刻，只要记住它维护了一个已加载类的常量就可以了。接下来结合一些例子说明常量池的特性。

### 预备知识2
基本类型和基本类型的包装类。基本类型有：byte、short、char、int、long、boolean。基本类型的包装类分别是：Byte、Short、Character、Integer、Long、Boolean。注意区分大小写。二者的区别是：基本类型体现在程序中是普通变量，基本类型的包装类是类，体现在程序中是引用变量。因此二者在内存中的存储位置不同：基本类型存储在栈中，而基本类型包装类存储在堆中。上边提到的这些包装类都实现了常量池技术，另外两种浮点数类型的包装类则没有实现。另外，String类型也实现了常量池技术。

### 案例2

```bash
public class test {
    public static void main(String[] args) {    
        objPoolTest();
    }
 
    public static void objPoolTest() {
        int i = 40;
        int i0 = 40;
        Integer i1 = 40;
        Integer i2 = 40;
        Integer i3 = 0;
        Integer i4 = new Integer(40);
        Integer i5 = new Integer(40);
        Integer i6 = new Integer(0);
        Double d1=1.0;
        Double d2=1.0;
        
        System.out.println("i=i0\t" + (i == i0));
        System.out.println("i1=i2\t" + (i1 == i2));
        System.out.println("i1=i2+i3\t" + (i1 == i2 + i3));
        System.out.println("i4=i5\t" + (i4 == i5));
        System.out.println("i4=i5+i6\t" + (i4 == i5 + i6));    
        System.out.println("d1=d2\t" + (d1==d2)); 
        
        System.out.println();        
    }
}
```
结果：

```bash
i=i0    true
i1=i2   true
i1=i2+i3        true
i4=i5   false
i4=i5+i6        true
d1=d2   false
```

**结果分析：**

1.i和i0均是普通类型(int)的变量，所以数据直接存储在栈中，而栈有一个很重要的特性：栈中的数据可以共享。当我们定义了int i = 40;，再定义int i0 = 40;这时候会自动检查栈中是否有40这个数据，如果有，i0会直接指向i的40，不会再添加一个新的40。

2.i1和i2均是引用类型，在栈中存储指针，因为Integer是包装类。由于Integer包装类实现了常量池技术，因此i1、i2的40均是从常量池中获取的，均指向同一个地址，因此i1=12。

3.很明显这是一个加法运算，Java的数学运算都是在栈中进行的，Java会自动对i1、i2进行拆箱操作转化成整型，因此i1在数值上等于i2+i3。

4.i4和i5均是引用类型，在栈中存储指针，因为Integer是包装类。但是由于他们各自都是new出来的，因此不再从常量池寻找数据，而是从堆中各自new一个对象，然后各自保存指向对象的指针，所以i4和i5不相等，因为他们所存指针不同，所指向对象不同。

5.这也是一个加法运算，和3同理。

6.d1和d2均是引用类型，在栈中存储指针，因为Double是包装类。但Double包装类没有实现常量池技术，因此Doubled1=1.0;相当于Double d1=new Double(1.0);，是从堆new一个对象，d2同理。因此d1和d2存放的指针不同，指向的对象不同，所以不相等。


**小结：**


1.以上提到的几种基本类型包装类均实现了常量池技术，但他们维护的常量仅仅是【-128至127】这个范围内的常量，如果常量值超过这个范围，就会从堆中创建对象，不再从常量池中取。比如，把上边例子改成Integer i1 = 400; Integer i2 = 400;，很明显超过了127，无法从常量池获取常量，就要从堆中new新的Integer对象，这时i1和i2就不相等了。

2.String类型也实现了常量池技术，但是稍微有点不同。String型是先检测常量池中有没有对应字符串，如果有，则取出来；如果没有，则把当前的添加进去。


## 并发编程

### synchronized

#### 三种使用方式

Java 中每一个对象都可以作为锁，这是 synchronized 实现同步的基础。synchronized 的三种使用方式如下：

- 普通同步方法（实例方法）：锁是当前实例对象 ，进入同步代码前要获得当前实例的锁；
- 静态同步方法：锁是当前类的 class 对象 ，进入同步代码前要获得当前类对象的锁；
- 同步方法块：锁是括号里面的对象，对给定对象加锁，进入同步代码库前要获得给定对象的锁。



1. 类锁所有对象一把锁
2. 对象锁一个对象一把锁，多个对象多把锁
3. 同步是对同一把锁而言的，同步这个概念是在多个线程争夺同一把锁的时候才能实现的，如果多个线程争夺不同的锁，那多个线程是不能同步的
4. 两个线程一个取对象锁，一个取类锁，则不能同步
5. 两个线程一个取a对象锁，一个取b对象锁，则不能同步

#### 修饰普通方法：
1. 修饰普通方法锁的是当前对象实例，但是如果两个线程调用的是同一个对象的普通synchronized方法，持有的是不同的锁，是不会block的。
```
public static void main(String[] args) throws InterruptedException {
        DemoTest test = new DemoTest();
        DemoTest testNew = new DemoTest();
        Thread t1 = new Thread(test);
        Thread t2 = new Thread(testNew);
        t1.setName("threadOne");
        t2.setName("threadTwo");
        t1. start();
        t2. start();
    }
```

结果：
```
threadTwo 获取到锁，其他线程在我执行完毕之前，不可进入。
threadOne 获取到锁，其他线程在我执行完毕之前，不可进入。
threadTwo: 1
threadOne: 2
```

如果把 ``` DemoTest testNew = new DemoTest();```删掉，调用同一个对象，那么就能阻塞


#### 修饰静态方法
**静态方法不属于任何一个实例对 象，是属于类成员。所以当线程A访问调用一个实例对象的synchronized方法，线程B调用这个实例对象的静态synchronized方法是允许的，即synchronized修饰静态方法，会对该类的所有实例加同步锁**
```
public static synchronized void increase() throws InterruptedException {
        System.out.println(Thread.currentThread().getName() + "获取到锁，其他线程在我执行完毕之前，不可进入。" );
        sleep(1000);
        count++;
        System.out.println(Thread.currentThread().getName() + ": " + count);
    }

```

#### 修饰代码块

**对于 synchronized 作用于同步代码，锁为任何我们创建的对象，只要是个对象即可，如 new Object () 可以作为锁，new String () 也可作为锁，当然如果传入 this，那么此时代表当前对象。**

### volatile

1. 只能修饰变量，被修饰的变量，线程读写都会直接和主内存打交道，绕过缓存。
2. 该关键字可以确保当一个线程更新共享变量时，更新操作对其他线程马上可见

#### volatile & synchronized

- volatile 本质是在告诉 jvm 当前变量在寄存器（工作内存）中的值是不确定的，需要从主存中读取；
- synchronized 则是锁定当前变量，只有当前线程可以访问该变量，其他线程被阻塞住；
- volatile 仅能使用在变量级别；synchronized 则可以使用在变量、方法、和类级别的；
- volatile 仅能实现变量的修改可见性，不能保证原子性；而 synchronized 则可以保证变量的修改可见性和原子性；
- volatile 不会造成线程的阻塞；synchronized 可能会造成线程的阻塞；




## 辅助知识
### JAVA环境变量JAVA_HOME、CLASSPATH、PATH配置说明
首先明白一个基础概念：

#### current directory(当前目录)：当前在用的目录就是当前目录


比如说当你打开NOTEPAD，并处于运行状态时候，当前目录就是c:/windows；
如果你用cmd命令打开命令行窗口，    当前目录就是c:/windows/system32;

如果你在用java这条指令，当前目录就是JAVA下的BIN目录所在的路径，因为java.exe在bin里面。在java开发配置环境变量时，系统默认(我们对classpath不做任何设定时)的路径也是当前目录。


#### JAVA_HOME：它是指jdk的安装目录

   
像D:/j2sdk1.4.2_16，在这路径下你应该能够找到bin、lib等目录。
 为什么要设置它呢，不设定可不可以呢？不设定也是可以滴，但是最好还是设置一下。
 我们现在就当它是一个变量代换 JAVA_HOME = D:/j2sdk1.4.2_16，就是为了避免多写字，它还有一个好处就是当我们需要改变某个jdk时，只需要改JAVA_HOME的值就可以了。等在后面看了Tomcat的启动分析时你就明白了。当在环境变量中引用它的时候要用%JAVA_HOME%来表示      D:/j2sdk1.4.2_16。


#### Path：系统变量Path告诉操作系统可执行文件(*.exe、*.bat等)所在的路径

  
 
 当OS(操作系统)发现某个*.exe时，windows默认从当前目录开始查找这      个命令，若查不到，OS就会到Path所设定的路径中去寻找该命令，然后执行。

   系统默认的系统变量为：Path = %SystemRoot%;%SystemRoot%/system32;%SystemRoot%/System32/Wbem
   就是说处于上面3个目录(多个变量用分号隔开)中的*.exe文件，可以在任意地方被执行(在 运行 窗口能直接执行的命令，像cmd、notepad等，基本都    在上面的3个目录里面)，所以他们可以直接运行。
   上面的%SystemRoot%是什么意思呢？%SystemRoot%就是安装操作系统的时候，系统默认的安装路径
    若你的windows xp装在C:/WINDOWS 
    则你的%systemRoot%路径就是c:/windows 
     %systemRoot%只是一个符号,代表你的系统安装目录 
     下面是常见系统默认安装路径: 
    98----c:/windows 
    2000--c:/winnt 
    2003--c:/windows 
    xp----c:/windows 
     当我们要进行java开发时，OS经常需要用到java.exe、javac.exe等，（若jdk安装在D:/j2sdk1.4.2_16）因此应该将      D:/j2sdk1.4.2_16/bin（%JAVA_HOME%/bin）加入到系统的path中去。
    注意：如果你加入的位置不是在最后，那还需要在bin后面加上英文状态下的分号：%JAVA_HOME%/bin；多个变量之间要用分号隔开，如果它前面    没有，你就加一个。
   明确一下：%JAVA_HOME%/jre/bin 这个路径是不需要加入Path的。参考：http://java.sun.com/javase/6/docs/technotes/tools/windows/jdkfiles.html
   
 

#### CLASSPATH：告诉java虚拟机(jvm)要使用或执行的*.class文件放在什么地方


CLASSPATH是专门针对java的，它相当于windows的path；path是针对整个windows的。
所谓的JVM就好像是在微软OS上面再激活另外一个OS，对JVM来说CLASSPATH就好像是对微软OS来说的PATH，所以要用jvm开运行程序就需要设定classpath，然而jvm像windows一样它也有个默认的查找class文件的路径，对刚开始学习java的我们来说，默认的已经够我们用了，那就是当前路径，因此不设置classpath也可以。

在windows中 classpath 大小写没有关系，其他的环境变量名称也一样。
 当我们不设定classpath时，系统默认的classpath是当前目录，如果你个人想设置classpath的话，那么务必在classpath中加入"."，这个英文状态下的点就表示当前目录。至于classpath中要不要加入其他的路径(包括文件目录、包的根目录等)，这要看开发的需要，一般我们初学者是用不到的。

JAVA_HOME = D:/j2sdk1.4.2_16
Path 环境变量中在最前面加入(若系统原来没有就新建) %JAVA_HOME%/bin; （加在最前面可以提高查找速度）
CLASSPATH = . 这一步可以不用设。

### JDK 和 JRE 的区别

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/7b9ff76b66e949fc9a04515e960b9de4.png)
从图中可以看出JDK包含JRE包含JVM...

 

JDK：java development kit （java开发工具）

JRE：java runtime environment （java运行时环境）

引申出JVM

JVM：java virtual machine （java虚拟机）

 

一、JDK——开发环境（核心）

java development kit 的缩写，意思是JAVA开发工具，我们写文档做PPT需要office 办公软件，开发当然需要开发工具了，说到开发工具大家肯定会想到Eclipse，但是如果直接安装Eclipse你会发现它是运行不起来 是会报错的，只有安装了JDK，配置好了环境变量和path才可以运行成功。这点相信很多人都深有体会。

 

JDK主要包含三部分，

第一部分就是Java运行时环境，JVM。

第二部分就是Java的基础类库，这个类库的数量还是非常可观的。

第三部分就是Java的开发工具，它们都是辅助你更好的使用Java的利器。

详寻《玩好JDK，面试不用愁》

二、JRE——运行环境

 

java runtime environment （java运行时环境）的缩写

 

1,1_JDK中的JRE

如下图：jdk中包含的jre，在jre的bin目录里有个jvm.dll，既然JRE是运行时环境，那么运行在哪？肯定是JVM虚拟机上了。另，jre的lib目录中放的是一些JAVA类库的class文件，已经打包成jar文件。



1.2_第二个JRE（独立出来的运行时环境）

如下图，不管是JDK中的JRE还是JRE既然是运行时环境必须有JVM。所以JVM也是有两个的。



 

三、JVM——转换环境

 

java virtual machine （java虚拟机）的缩写。

大家一提到JAVA的优点就会想到：一次编译，随处运行，说白了就是跨平台性好，这点JVM功不可没。

JAVA的程序也就是我们编译的代码都会编译为Class文件，Class文件就是在JVM上运行的文件，

只有JVM还不能成class的执行，因为在解释class的时候JVM需要调用解释所需要的类库lib，而jre包含lib类库。

JVM屏蔽了与具体操作系统平台相关的信息，使得Java程序只需生成在Java虚拟机上运行的目标代码（字节码），就可以在多种平台上不加修改地运行。



## 常用方法
### Math方法
1： java取整

     a：floor向下取整

       用法：Math.floor(num)

       Math.floor(1.9)//1                      Math.floor(-1.9)//-2

    b:  round四舍五入

      用法：Math.round(num)实际上是等价于Math.floor(num+0.5)

      Math.round(1.5)//2                     Math.round(1.4)//1

      Math.round(-1.4)//-1                  Math.round(-1.5)//-1               Math.round(-1.6)//-2

    c:  ceil取不小于num的最小整数

       用法: Math.ceil(num)

       Math.ceil(1.4)//2      Math.ceil(1.5)//2             Math.ceil(1.6)//2

       Math.ceil(-1.4)//-1   Math.ceil(-1.5)//-1           Math.ceil(-1.6)//-1

    d:  神级方法直接加(int)强制转换，直接去掉小数点位，没有任何向上向下，需要时最好用的方法

 

2： java求绝对值

     Math.abs(num)

     Math.abs(-30.5)//30.5

3:   java随机数

     Math.random()随机去0~1的数

     (int)(100*Math.random())这样就可以取0~100随机整数

4： java幂函数

     Math.pow(a,b)a的b次方

     Math.pow(x,2)就是平方

     Math.pow(x,3)就是立方

5： java开根号

     Math.sqrt(num)num的平方根


### 随机数
使用步骤：

1.导入包

import java.util.Random;

2.创建对象

Random r = new Random();

3.产生随机数

int num = r.nextInt(10);
代码解析：10代表的是一个范围，如果括号写10，产生的随机数就是0-9，括号写20，参数的随机数则是0-19

```java
import java.util.Random; //1. 导入包

public class Demo1Random {

	public static void main(String[] args){
		// 2. 创建对象
		Random r = new Random();
		
		for(int i = 1; i <= 10; i++){
			// 3. 获取随机数
			int num = r.nextInt(10) + 1;		// 1-10
			System.out.println(num);
		}
		
		
		
	}
}
```

 

### String类
#### substring() 返回字符串字串

```
public String substring(int beginIndex)

或

public String substring(int beginIndex, int endIndex)
```
参数
beginIndex -- 起始索引（包括）, 索引从 0 开始。

endIndex -- 结束索引（不包括）。

```
public class RunoobTest {
    public static void main(String args[]) {
        String Str = new String("This is text");
 
        System.out.print("返回值 :" );
        System.out.println(Str.substring(4) );
 
        System.out.print("返回值 :" );
        System.out.println(Str.substring(4, 10) );
    }
}
```
结果：
返回值 : is text
返回值 : is te
### 字符串操作
#### 字符串某个位置插入一个字符

```
StringBuffer sb = new StringBuffer("原字符串");
 
sb.insert(index,"需要插入的字符串");
```
#### 字符串长度

```
s.length()
//数组长度是 num.length
```

#### 字符串修改
当对字符串进行修改的时候，需要使用 StringBuffer 和 StringBuilder 类。

和 String 类不同的是，StringBuffer 和 StringBuilder 类的对象能够被多次的修改，并且不产生新的未使用对象。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/cdb4cc2d3e374b40bdb8a0a5897606c1.png)

在使用 StringBuffer 类时，每次都会对 StringBuffer 对象本身进行操作，而不是生成新的对象，所以如果需要对字符串进行修改推荐使用 StringBuffer。

StringBuilder 类在 Java 5 中被提出，它和 StringBuffer 之间的最大不同在于 StringBuilder 的方法不是线程安全的（不能同步访问）。

**由于 StringBuilder 相较于 StringBuffer 有速度优势，所以多数情况下建议使用 StringBuilder 类。**

```
public class RunoobTest{
    public static void main(String args[]){
        StringBuilder sb = new StringBuilder(10);
        //也可以直接 new StringBuilder()
        sb.append("Runoob..");
        System.out.println(sb);  
        sb.append("!");
        System.out.println(sb); 
        sb.insert(8, "Java");
        System.out.println(sb); 
        sb.delete(5,8);
        System.out.println(sb);  
    }
}
```

#### 返回指定索引处的字符

实例：

```
public class Test {
    public static void main(String args[]) {
        String s = "www.runoob.com";
        char result = s.charAt(6);
        System.out.println(result);
    }
}

```

#### 删除字符串首尾空白符

```
str=str.trim();
```

#### 返回字符串的子字符串

```
public String substring(int beginIndex, int endIndex)

beginIndex -- 起始索引（包括）, 索引从 0 开始。
endIndex -- 结束索引（不包括）。
```

```
public class RunoobTest {
    public static void main(String args[]) {
        String Str = new String("This is text");
 
        System.out.print("返回值 :" );
        System.out.println(Str.substring(4) );
 
        System.out.print("返回值 :" );
        System.out.println(Str.substring(4, 10) );
    }
}

//结果
返回值 : is text
返回值 : is te
```

#### 字符串反转
使用`StringBuilder`

```
Scanner in = new Scanner(System.in);
        String str = in.nextLine();
        StringBuffer strb = new StringBuffer(str);
        strb.reverse();
        System.out.println(strb.toString());  //要求返回String类可用这句
        System.out.println(strb);
```

### 数组

#### 数组长度
```
num.length
//字符串长度是 s.length()
```
#### 二维数组
```
//声明int类型的二维数组
int[][] intArray;

//创建一个三行四列的int类型数组
intArray = new int[3][4];

//声明数组的同时进行创建
char[][] ch = new char[3][5];

/二维数组的初始化
int[][] num = {{1,2,3},{4,5,6},{9,8,7}};

//获取行和列
num.length //行数
num[0].length //列数

//循环输出二维数组的内容
for(int i=0;i<num1.length;i++){
    for(int j=0;j<num1[i].length;j++){
         System.out.print(num1[i][j]+" ");
       }
    System.out.println();
 }
```
#### 数组排序

```
Arrays.sort(arr);
Arrays.sort()重载了四类方法
sort(T[] a)：对指定T型数组按数字升序排序。
sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
sort(T[] a, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。
```

#### 数组拷贝
**Arrays.copyOf方法**

```
Arrays.copyOf(array, to_index);// to_index是1，就是拷贝从头往后数的1个数，5就是从头往后数的5个数
Arrays.fill(array, from_index, to_index);
```

第一个方法其实就是返回一个数组，而这个数组就等于数组array的前to_index个数，也就是array[0] ~ array[to_index - 1]。

而第二种方法也只是加了一个初始的位置，即返回一个数组等于array[from_index] ~ array[to_index - 1]。

这里要注意一下，不管是上面哪种使用方法，都务必记住时不包含array[to_index]这个数。

**还有一点差点忘了说了，这里得提前导入Arrays类，即在开头写如下代码
import java.utl.Arrays;**
### 构造函数（方法）
**作用：一般用来初始化成员属性和成员方法的，即new对象产生后，就调用了对象了属性和方法。**

一个对象建立，构造函数只运行一次。

 而一般函数可以被该对象调用多次。

特点：
1、函数名与类名相同

2、不用定义返回值类型。（不同于void类型返回值，void是没有具体返回值类型；构造函数是连类型都没有）

3、不可以写return语句。（返回值类型都没有，也就不需要return语句了）

 注：一般函数不能调用构造函数，只有构造函数才能调用构造函数。

示例：
1、无参构造函数中只定义了一个方法。new对象时，就调用与之对应的构造函数，执行这个方法。不必写“.方法名”。 

```
package javastudy;

public class ConfunDemo {
    public static void main(String[] args) {
        Confun c1=new Confun();            //输出Hello World。new对象一建立，就会调用对应的构造函数Confun()，并执行其中的println语句。
    }
}
class Confun{        
    Confun(){        //定义构造函数，输出Hello World
        System.out.println("Hellow World");
    }
}
```
2、有参构造函数，在new对象时，将实参值传给private变量，相当于完成setter功能。

```
package javastudy;

public class ConfunDemo3 {
    public static void main(String[] args){
        Person z=new Person("zhangsan",3);        //实例化对象时，new Person()里直接调用Person构造函数并转转实参，相当于setter功能
        z.show();
    }
}

class Person{
    private String name;
    private int age;
    public Person(String n,int m){                //有参数构造函数，实现给private成员变量传参数值的功能
        name=n;
        age=m;        
    }
    //getter                                      //实例化对象时，完成了sett功能后，需要getter，获取实参值。
    public String getName(){
        return name;
    }
    public int getAget(){
        return age;
    }
    public void show(){                           //获取private值后，并打印输出
        System.out.println(name+"\n"+age);
    }
}
```
以上代码，我们也可以将show()方法中的输出语句直接放在构造函数中，new对象时，即可直接输出值，如下

```
package javastudy;

public class ConfunDemo3 {
    public static void main(String[] args){
        Person z=new Person("zhangsan",3);        //实例化对象时，new Person()里直接调用Person构造函数并转转实参，同时执行输出语句
    }
}

class Person{
    private String name;
    private int age;
    public Person(String n,int m){                //有参数构造函数，实现给private成员变量传参数值的功能，同时直接输出值
        name=n;
        age=m;
        System.out.println(name+"\n"+age);
    }
}
```
一个对象建立后，构造函数只运行一次。

如果想给对象的值再赋新的值，就要使用set和get方法，此时是当做一般函数使用

如下：

```
package javastudy;

public class ConfunDemo4 {
    public static void main(String[] args) {
            PersonDemo s=new PersonDemo("李三",33);        //new对象时，即调用对应的构造函数，并传值。同时，不能new同一个对象多次，否则会报错。
            s.setName("李五");                            //对象建立后，想变更值时，就要用set/get方法，重新设置新的值
            s.setName("阿尔法狗");                        //并可调用对象多次。
            s.print();
    }
}
class PersonDemo{
    private String name;
    private int age;
    PersonDemo(String n,int m){                //建立有参构造函数，用于给两个private变量name、age赋值，同时输出值
        name=n;
        age=m;
        System.out.println("姓名："+name+"年龄："+age);
    }
    public void setName(String x){            //set方法，用于再次给name赋值
        name=x;        
    }
    public String getName(){                //get方法，用于获取name的赋值
        return name;
    }
    public void print(){
        System.out.println(name);
    }
}
```



### 字母大小写判断与转换

```
Character.isDigit(char c)　//判断字符c是否是数字字符，如‘1’，‘2’，是则返回true，否则返回false

Character.isLetter(char c)  //判断字符c是否是字母

Character.isLowerCase(char c)　//判断c是否是小写字母字符

Character.isUpperCase(char c)　//判断c是否是大写字母字符

Character.isLetterOrDigit(char c)　判断c是否是字母或数字字符

Character.toLowerCase(char c)　//字母转换为小写字母字符

Character.toUpperCase(char c)　//字母转换为大写字母字符

```

### 集合
Java 中集合主要分为java.util.Collection和java.util.Map两大接口。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/87ff2a104a409b2942cbb33fd43efeee.png)

图表最下方的ArrayList、LinkedList、HashSet以及HashMap都是常用实现类。

#### 初始化

```
// 无参构造实例化，初始容量为10
List arrayList1 = new ArrayList();
// 实例化一个初始容量为20的空列表
List arrayList2 = new ArrayList(20);
// 实例化一个集合元素为 arrayList2 的列表（由于 arrayList2 为空列表，因此其实例化的对象也为空列表）
List arrayList3 = new ArrayList(arrayList2);

```
上面的方法可能会报错，所以引入泛型。

```
List<Integer> arrayList = new ArrayList<Integer>(); // () “括号”里面如果什么都不写，会采取默认容量，也可以复制，也可以将同类型的元素直接放进去
```
#### Collections之间相互转换
背景：ArrayList元素去重

```
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
 
public class ArrayListExample {
    public static void main(String[] args) {
        ArrayList<Integer> numbersList = new ArrayList<>(Arrays.asList(1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 7, 8));
        System.out.println(numbersList);
        LinkedHashSet<Integer> hashSet = new LinkedHashSet<>(numbersList);
        ArrayList<Integer> listWithoutDuplicates = new ArrayList<>(hashSet);
        System.out.println(listWithoutDuplicates);
    }
}

```
输出结果：

```
[1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 7, 8]
[1, 2, 3, 4, 5, 6, 7, 8]
```

### ArrayList数据去重
[原文链接](https://blog.csdn.net/The_clown/article/details/113339283)

**法一：**
LinkedHashSet是在一个ArrayList删除重复数据的最佳方法。

LinkedHashSet在内部完成两件事：

 1 删除重复数据
 2 保持添加到其中的数据的顺序
```
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
 
public class ArrayListExample {
    public static void main(String[] args) {
        ArrayList<Integer> numbersList = new ArrayList<>(Arrays.asList(1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 7, 8));
        System.out.println(numbersList);
        LinkedHashSet<Integer> hashSet = new LinkedHashSet<>(numbersList);
        ArrayList<Integer> listWithoutDuplicates = new ArrayList<>(hashSet);
        System.out.println(listWithoutDuplicates);
    }
}

```

**法二：**
要从arraylist中删除重复项，我们也可以使用java 8 stream api。使用steam的distinct()方法返回一个由不同数据组成的流，通过对象的equals（）方法进行比较。
收集所有区域数据List使用Collectors.toList()。
Java程序，用于在不使用Set的情况下从java中的arraylist中删除重复项。

```
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
 
public class ArrayListExample {
    public static void main(String[] args) {
        ArrayList<Integer> numbersList = new ArrayList<>(Arrays.asList(1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 7, 8));
        System.out.println(numbersList);
        List<Integer> listWithoutDuplicates = numbersList.stream().distinct().collect(Collectors.toList());
        System.out.println(listWithoutDuplicates);
    }
}

```

**法三：**
利用HashSet不能添加重复数据的特性 由于HashSet不能保证添加顺序，所以只能作为判断条件保证顺序：

```
private static void removeDuplicate(List<String> list) {
    HashSet<String> set = new HashSet<String>(list.size());
    List<String> result = new ArrayList<String>(list.size());
    for (String str : list) {
        if (set.add(str)) {
            result.add(str);
        }
    }
    list.clear();
    list.addAll(result);
}

```
**法四：**
利用List的contains方法循环遍历,重新排序,只添加一次数据,避免重复：
```
private static void removeDuplicate(List<String> list) {
    List<String> result = new ArrayList<String>(list.size());
    for (String str : list) {
        if (!result.contains(str)) {
            result.add(str);
        }
    }
    list.clear();
    list.addAll(result);
}

```

**法五：双重for循环去重**

```
for (int i = 0; i < list.size(); i++) { 
	for (int j = 0; j < list.size(); j++) { 
		if(i!=j&&list.get(i)==list.get(j)) { 
			list.remove(list.get(j)); 
		 } 
	} 
}

```

### Collections.sort()
[原文链接](https://www.jianshu.com/p/32f9578b9acc)

> Collections类中的sort方法可以对实现了List接口的集合进行排序。这个方法假定列表元素实现了Comparable接口。

#### sort常用形式

**sort有两种重载形式，第一种（默认升序）：**

```
static <T extends Comparable<? super T>> void sort(List<T> list)
```
根据官方文档的描述，这个方法将列表元素进行升序排序，但是列表要满足以下条件：
  1.列表元素实现了Comparable接口，且任意两个列表元素都是可比的。
  2.列表必须支持set方法。

实现代码如下：

```
import java.util.*;
public class Sort {

    public static void main(String[] args) {
        
        Scanner scan = new Scanner(System.in);
        List<Integer> list = new ArrayList<>();          
        
        //用户输入10个整数
        System.out.println("请输入10个整数：");
        for(int i = 0; i < 10; i++)                      
        {
            list.add(scan.nextInt());
        }
        scan.close();
        
        //排序
        Collections.sort(list);
        
        //输出排序结果
       System.out.println(list);
    }

}
```
结果：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/ccfb2d08efa818a82b206d9ed8054630.png)


**sort第二种重载（降序）：**

```
public static <T> void sort(List<T> list,Comparator<? super T> c)
```
如果想采用其他方式进行排序，那么可将一个Comparator对象作为sort方法的第二个参数。当要进行逆序排序时，最简便的方法是将Collections.reverseOrder()作为第二个参数。

```
import java.util.*;
public class Sort {

    public static void main(String[] args) {
        
        Scanner scan = new Scanner(System.in);
        List<Integer> list = new ArrayList<>();          
        
        //用户输入10个整数
        System.out.println("请输入10个整数：");
        for(int i = 0; i < 10; i++)                      
        {
            list.add(scan.nextInt());
        }
        scan.close();
        
        //逆序排序
        Collections.sort(list,Collections.reverseOrder());
        
        //输出排序结果
        System.out.println(list);
    }

}
```
结果：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/5bce696faab5422217b9fd87c15c610b.png)
看到这里，对 `Comparator`这个词多关注下

#### 排序对象不是基本数据类型

> 定义一个点类，其中有整型属性x和y，代表其坐标；除了这两个属性以外没有其他属性。随机产生10个点，并按照这些点与原点(0,0)之间的距离大小对点进行降序排序。

如果仍想通过sort方法进行排序的话，首先点类就必须满足上面曾经提过的约束条件：点对象是可比的，因此点类必须实现Comparable接口。查看官方文档可知，Comparable接口中只有一个方法：

```
int compareTo(T o)
```
调用这个方法的对象将会与参数o进行比较，小于o、等于o和大于o分别对应的返回值为负数、0和正数。对象之间相对大小的判断方法是自定义的，在这个问题中，就是通过比较各点与原点之间的距离来判断大小，所以点类的实现如下：

```
class Point implements Comparable<Point>{
    
    private int x;
    private int y;
    
    public Point(int x,int y)
    {
        this.x = x;
        this.y = y;
    }
    
    @Override
    //如果该点到原点的距离大于o点到原点的距离，则该点大于o点
    public int compareTo(Point o) {

        int distance1 = (this.x) * (this.x) + (this.y) * (this.y);
        int distance2 = (o.x) * (o.x) + (o.y) * (o.y);
        
        return (distance1 > distance2) ? 1 : ((distance1 == distance2) ? 0 : -1); 
    }
    
    @Override
    public String toString() {
        return "(" + x + ","+  y + ")";
    }
}
```
因为要进行降序排序，所以可以通过将Collections.reverseOrder()作为sort方法的第二个参数来实现：

```
public class SortDemo {

    private static List<Point> list = new ArrayList<>();
    
    public static void main(String[] args) {
        
        //随机生成10个点
        for(int i = 0; i < 10; i++)
        {
            //点的坐标取值在[1,20]之间
            int x = (int)(Math.random() * 20) + 1;
            int y = (int)(Math.random() * 20) + 1;
            
            list.add(new Point(x,y));
        }
        System.out.print("排序前：");
        System.out.println(list);
        
        //降序排序
        Collections.sort(list,Collections.reverseOrder());
        
        System.out.print("排序后：");
        System.out.println(list);
    }

}
```
结果：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/2a13ef90ac25d9d1c73a21f774ce4611.png)

**sort方法小结：**
实现了Comparable接口的类都可以用sort方法进行排序，默认的排序方法是升序；如果想进行降序排序，只需把Collections.reverseOrder作为第二个参数传给sort方法。

#### Comparator接口
上面反复提到的Collections.reverseOrder方法返回的是一个Comparator对象。其实Comparator接口并不陌生，常用的equals方法就来自这个接口。Comparator接口用来定义两个对象之间的比较方法，它有一个叫做compare的方法，函数签名如下：

```
int compare(T o1,T o2)
```
o1 > o2，返回正数；o1 = o2，返回0；o1 < o2，返回负数。
  从前面的例子可以看出，可以使用Comparator对象来控制sort的排序方法，这是如何实现的？查看sort方法的相关源码，我发现其中有这样一段代码：

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/da415407eb899af9aab66f06ba75028a.png)
注意看图中用红线框起来的部分。经分析可知，这段代码实现了这样的逻辑：如果compare的返回值为正数，就交换进行比较的两个元素的位置。于是可以得出这样一个结论，如果让 x > y 时compare(x,y)返回正数，那么交换 x 和 y 的位置后大的元素在后，这就实现了升序排序；反之，如果让 x < y 时compare(x,y)返回正数，那么交换位置后小的元素在后，这就实现了降序排序。这就是Comparator对象控制排序方式的原理。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/69bf5bc0fb7fa88c13d7a45defa84b1c.png)

通过Comparator对象来实现点对象的降序排序，一种可行的实现方式如下：

```
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

//点类
class Point {
    
    private int x;
    private int y;
    
    public Point(int x,int y)
    {
        this.x = x;
        this.y = y;
    }
    
    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }
    
    @Override
    public String toString() {
        return "(" + x + ","+  y + ")";
    }
}

public class SortDemo {

    private static List<Point> list = new ArrayList<>();
    
    public static void main(String[] args) {
        
        //随机生成10个点
        for(int i = 0; i < 10; i++)
        {
            //点的坐标取值在[1,20]之间
            int x = (int)(Math.random() * 20) + 1;
            int y = (int)(Math.random() * 20) + 1;
            
            list.add(new Point(x,y));
        }
        System.out.print("排序前：");
        System.out.println(list);
        
        //降序排序
        Collections.sort(list,new Comparator<Point>() {

            @Override
            //当 o1 < o2 时返回正数
            public int compare(Point o1, Point o2) {
                int distance1 = (o1.getX()) * (o1.getX()) + (o1.getY()) * (o1.getY());
                int distance2 = (o2.getX()) * (o2.getX()) + (o2.getY()) * (o2.getY());
                
                return (distance1 < distance2) ? 1 : ((distance1 == distance2) ? 0 : -1); 
            }
            
        });
        
        System.out.print("排序后：");
        System.out.println(list);
    }

}
```
结果：
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/997282c1a828c3c32ff7ed4600419ccd.png)
### Arrays.sort()
[原文](https://www.cnblogs.com/SupremeBoy/p/12717532.html)
Arrays.sort()是经过调优排序算法，性能能达到n*log(n)

**Arrays.sort()重载了四类方法**

 - sort(T[] a)：对指定T型数组按数字升序排序。 
 - sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
 - sort(T[] a, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
 - sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。

#### sort(T[] a)
对指定T型数组按数字升序排序。

```
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[] a={2,5,4,3,1,8};
        Arrays.sort(a);
        System.out.println(Arrays.toString(a));
    }
}// 结果// [1, 2, 3, 4, 5, 8]
```
#### sort(T[] a,int formIndex, int toIndex)
对指定T型数组的指定范围按数字升序排序。

```
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[] a={2,5,4,3,1,8};
        Arrays.sort(a,2,5);
        System.out.println(Arrays.toString(a));
    }
}

// 结果
// [2, 5, 1, 3, 4, 8]
```

#### sort(T[] a, Comparator<? supre T> c)
（1）按第一维元素比较二维数组
代码：

```
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[][] nums=new int[][]{{1,3},{1,2},{4,5},{3,7}};
        //方法一
        Arrays.sort(nums,new Comparator<int[]>(){
            @Override
            public int compare(int[] a,int[] b){
                if(a[0]==b[0]){
                    return a[1]-b[1];
                }else{
                    return a[0]-b[0];
                }
            }
        });


        // 方法二，使用匿名表达式
        // (a,b)->a[1]-b[1]会自动转变成上面的形式
        /*Arrays.sort(nums,(a,b)->a[1]-b[1]);*/
        for (int[] num : nums) {
            System.out.println(Arrays.toString(num));
        }

        int[] a={2,5,4,3,1,8};
        Arrays.sort(a,2,5);
        System.out.println(Arrays.toString(a));
    }
}

// 结果
/*
[1, 2]
[1, 3]
[3, 7]
[4, 5]
*/
```

（2）按第二维元素比较二维数组

```
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[][] nums=new int[][]{{1,3},{1,2},{4,5},{3,7}};
        //方法一
        Arrays.sort(nums,new Comparator<int[]>(){
            @Override
            public int compare(int[] a,int[] b){
                if(a[1]==b[1]){
                    return a[0]-b[0];
                }else{
                    return a[1]-b[1];
                }
            }
        });

        //方法二
        /*Arrays.sort(nums,(a,b)->a[1]-b[1]);*/
        for (int[] num : nums) {
            System.out.println(Arrays.toString(num));
        }

    }
}
// 结果
/*
[1, 2]
[1, 3]
[4, 5]
[3, 7]
*/
```

其实这个方法最重要的还是类对象的比较

由于我们可以自定义比较器，所以我们可以使用策略模式，使得在运行时选择不同的算法

```
import java.util.Arrays;
import java.util.Comparator;

class Dog{
    int size;
    int weight;

    public Dog(int s, int w){
        size = s;
        weight = w;
    }
}

class DogSizeComparator implements Comparator<Dog>{

    @Override
    public int compare(Dog o1, Dog o2) {
        return o1.size - o2.size;
    }
}

class DogWeightComparator implements Comparator<Dog>{

    @Override
    public int compare(Dog o1, Dog o2) {
        return o1.weight - o2.weight;
    }
}

public class ArraysSort {
    public static void main(String[] args) {
        Dog d1 = new Dog(2, 50);
        Dog d2 = new Dog(1, 30);
        Dog d3 = new Dog(3, 40);

        Dog[] dogArray = {d1, d2, d3};
        printDogs(dogArray);

        Arrays.sort(dogArray, new DogSizeComparator());
        printDogs(dogArray);

        Arrays.sort(dogArray, new DogWeightComparator());
        printDogs(dogArray);
    }

    public static void printDogs(Dog[] dogs){
        for(Dog d: dogs)
            System.out.print("size="+d.size + " weight=" + d.weight + " ");

        System.out.println();
    }
}

// 结果
/*
size=2 weight=50 size=1 weight=30 size=3 weight=40 
size=1 weight=30 size=2 weight=50 size=3 weight=40 
size=1 weight=30 size=3 weight=40 size=2 weight=50 
*/
```
那么在参数中会出现super呢？这意味着这类型可以是T或者它的父类型。这就是的该方法可以允许所有子类使用相同的比较器。详细见代码：

```
import java.util.Arrays;
import java.util.Comparator;

class Animal{
    int size;
}

class Dog extends Animal{
    public Dog(int s){
        size = s;
    }
}

class Cat extends Animal{
    public Cat(int s){
        size  = s;
    }
}

class AnimalSizeComparator implements Comparator<Animal>{
    @Override
    public int compare(Animal o1, Animal o2) {
        return o1.size - o2.size;
    }
}

public class ArraysSort {
    public static void main(String[] args) {
        Dog d1 = new Dog(2);
        Dog d2 = new Dog(1);
        Dog d3 = new Dog(3);

        Dog[] dogArray = {d1, d2, d3};
        printDogs(dogArray);

        Arrays.sort(dogArray, new AnimalSizeComparator());
        printDogs(dogArray);

        System.out.println();
        
        Cat c1 = new Cat(2);
        Cat c2 = new Cat(1);
        Cat c3 = new Cat(3);

        Cat[] catArray = {c1, c2, c3};
        printDogs(catArray);

        Arrays.sort(catArray, new AnimalSizeComparator());
        printDogs(catArray);
    }

    public static void printDogs(Animal[] animals){
        for(Animal a: animals)
            System.out.print("size="+a.size + " ");
        System.out.println();
    }
}

// 结果
/*
size=2 size=1 size=3 
size=1 size=2 size=3 

size=2 size=1 size=3 
size=1 size=2 size=3 
*/
```
#### sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c)
根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。

```
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[][] nums=new int[][]{{1,3},{1,2},{4,5},{3,7}};
        
        Arrays.sort(nums,2,4,new Comparator<int[]>(){
            @Override
            public int compare(int[] a,int[] b){
                if(a[0]==b[0]){
                    return a[1]-b[1];
                }else{
                    return a[0]-b[0];
                }
            }
        });
    }
}

// 结果
/*
[1, 3]
[1, 2]
[3, 7]
[4, 5]
可以看到只对第三行和第四行排序了
*/
```
### 判断变量类型
1.使用反射的方法： `变量名.getClass().getSimpleName()`来判断。
2.使用 instanceof 来判断：`变量名 instanceof 类型`来判断。

1.使用反射的方法来判断
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/2c5f884df06f5761442c47f2e648a233.png)
2.使用 instanceof 来判断
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/911efc74c4904e65843c8411be1308d1.png)





