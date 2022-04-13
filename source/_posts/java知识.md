临时文件
还需要输入1个字
保存草稿
发布文章
weixin_43187737
未选择文件
---
title: Java知识
date: 2022/2/28

categories:
  - Java
  
tags:
  - 动态规划
  - 数据结构
  - Java
  - SpringBoot
---





# 常用方法
## 返回两个参数的最大值，最小值
```
Math.max(12.123, 18.456) //括号内两个数为相同数据类型
Math.min(a,b)
```

## 哈希表
**HashMap 是一个散列表，它存储的内容是键值对(key-value)映射。**

> HashMap 的 key 与 value 类型可以相同也可以不同，可以是字符串（String）类型的 key 和value，也可以是整型（Integer）的 key 和字符串（String）类型的 value。

```
// 引入 HashMap 类      
import java.util.HashMap;

public class RunoobTest {
    public static void main(String[] args) {
        // 创建 HashMap 对象 Sites
        HashMap<Integer, String> Sites = new HashMap<Integer, String>();
        // 添加键值对
        Sites.put(1, "Google");
        Sites.put(2, "Runoob");
        Sites.put(3, "Taobao");
        Sites.put(4, "Zhihu");
        System.out.println(Sites.get(3));
    }
}
```
## String类
### substring() 返回字符串字串

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
## 字符串操作
### 字符串某个位置插入一个字符

```
StringBuffer sb = new StringBuffer("原字符串");
 
sb.insert(index,"需要插入的字符串");
```
### 字符串长度

```
s.length()
//数组长度是 num.length
```

### 字符串修改
当对字符串进行修改的时候，需要使用 StringBuffer 和 StringBuilder 类。

和 String 类不同的是，StringBuffer 和 StringBuilder 类的对象能够被多次的修改，并且不产生新的未使用对象。

![在这里插入图片描述](https://img-blog.csdnimg.cn/cdb4cc2d3e374b40bdb8a0a5897606c1.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

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

### 返回指定索引处的字符

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

### 删除字符串首尾空白符

```
str=str.trim();
```

### 返回字符串的子字符串

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

### 字符串反转
使用`StringBuilder`

```
Scanner in = new Scanner(System.in);
        String str = in.nextLine();
        StringBuffer strb = new StringBuffer(str);
        strb.reverse();
        System.out.println(strb.toString());  //要求返回String类可用这句
        System.out.println(strb);
```

## 数组

### 数组长度
```
num.length
//字符串长度是 s.length()
```
### 二维数组
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
### 数组排序

```
Arrays.sort(arr);
Arrays.sort()重载了四类方法
sort(T[] a)：对指定T型数组按数字升序排序。
sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
sort(T[] a, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。
```

### 数组拷贝
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
## 构造函数（方法）
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

## String类与StringBuilder类的区别
[原文链接](https://www.cnblogs.com/huameitang/p/10528646.html)

### StringBuilder类介绍

**StringBuilder类是一个可变的字符序列。**

StringBuilder() 
          构造一个不带任何字符的字符串生成器，其初始容量为 16 个字符。
StringBuilder(CharSequence seq) 
          构造一个字符串生成器，它包含与指定的 CharSequence 相同的字符。
StringBuilder(int capacity) 
          构造一个不带任何字符的字符串生成器，其初始容量由 capacity 参数指定。
StringBuilder(String str) 
          构造一个字符串生成器，并初始化为指定的字符串内容。

### StringBuilder类的几个常用方法

```
append(任意类型)  追加到字符串后面

reverse 反转字符串

insert(int offset, 任意类型)  在某个index后插入字符串

toString()  返回String类的对象
```

先看一段String类的字符串拼接的代码。
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/388de719a9f6ee002b965e622dc87c46.png#pic_center)

String s = "hello" 会在常量池开辟一个内存空间来存储”hello"。

s += "world"会先在常量池开辟一个内存空间来存储“world"。然后再开辟一个内存空间来存储”helloworld“。

这么以来，001与002就成为了垃圾内存空间了。这么简单的一个操作就产生了两个垃圾内存空间，如果有大量的字符串拼接，将会造成极大的浪费。

### StringBuilder的作用

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

### String类与StringBuilder类的相互转换
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
## 字母大小写判断与转换

```
Character.isDigit(char c)　//判断字符c是否是数字字符，如‘1’，‘2’，是则返回true，否则返回false

Character.isLetter(char c)  //判断字符c是否是字母

Character.isLowerCase(char c)　//判断c是否是小写字母字符

Character.isUpperCase(char c)　//判断c是否是大写字母字符

Character.isLetterOrDigit(char c)　判断c是否是字母或数字字符

Character.toLowerCase(char c)　//字母转换为小写字母字符

Character.toUpperCase(char c)　//字母转换为大写字母字符

```

## 集合
Java 中集合主要分为java.util.Collection和java.util.Map两大接口。

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/87ff2a104a409b2942cbb33fd43efeee.png#pic_center)

图表最下方的ArrayList、LinkedList、HashSet以及HashMap都是常用实现类。

### 初始化

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
### Collections之间相互转换
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

## ArrayList数据去重
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

## Collections.sort()
[原文链接](https://www.jianshu.com/p/32f9578b9acc)

> Collections类中的sort方法可以对实现了List接口的集合进行排序。这个方法假定列表元素实现了Comparable接口。

### sort常用形式

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
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/ccfb2d08efa818a82b206d9ed8054630.png#pic_center)


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
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/5bce696faab5422217b9fd87c15c610b.png#pic_center)
看到这里，对 `Comparator`这个词多关注下

### 排序对象不是基本数据类型

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
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/2a13ef90ac25d9d1c73a21f774ce4611.png#pic_center)

**sort方法小结：**
实现了Comparable接口的类都可以用sort方法进行排序，默认的排序方法是升序；如果想进行降序排序，只需把Collections.reverseOrder作为第二个参数传给sort方法。

### Comparator接口
上面反复提到的Collections.reverseOrder方法返回的是一个Comparator对象。其实Comparator接口并不陌生，常用的equals方法就来自这个接口。Comparator接口用来定义两个对象之间的比较方法，它有一个叫做compare的方法，函数签名如下：

```
int compare(T o1,T o2)
```
o1 > o2，返回正数；o1 = o2，返回0；o1 < o2，返回负数。
  从前面的例子可以看出，可以使用Comparator对象来控制sort的排序方法，这是如何实现的？查看sort方法的相关源码，我发现其中有这样一段代码：

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/da415407eb899af9aab66f06ba75028a.png#pic_center)
注意看图中用红线框起来的部分。经分析可知，这段代码实现了这样的逻辑：如果compare的返回值为正数，就交换进行比较的两个元素的位置。于是可以得出这样一个结论，如果让 x > y 时compare(x,y)返回正数，那么交换 x 和 y 的位置后大的元素在后，这就实现了升序排序；反之，如果让 x < y 时compare(x,y)返回正数，那么交换位置后小的元素在后，这就实现了降序排序。这就是Comparator对象控制排序方式的原理。

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/69bf5bc0fb7fa88c13d7a45defa84b1c.png#pic_center)

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
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/997282c1a828c3c32ff7ed4600419ccd.png#pic_center)
## Arrays.sort()
[原文](https://www.cnblogs.com/SupremeBoy/p/12717532.html)
Arrays.sort()是经过调优排序算法，性能能达到n*log(n)

**Arrays.sort()重载了四类方法**

 - sort(T[] a)：对指定T型数组按数字升序排序。 
 - sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
 - sort(T[] a, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
 - sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。

### sort(T[] a)
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
### sort(T[] a,int formIndex, int toIndex)
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

### sort(T[] a, Comparator<? supre T> c)
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
### sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c)
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
## 判断变量类型
1.使用反射的方法： `变量名.getClass().getSimpleName()`来判断。
2.使用 instanceof 来判断：`变量名 instanceof 类型`来判断。

1.使用反射的方法来判断
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/2c5f884df06f5761442c47f2e648a233.png#pic_center)
2.使用 instanceof 来判断
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/911efc74c4904e65843c8411be1308d1.png#pic_center)



# 牛客网输入
**牛客网输入为了方便一律采用nextLine()作为接受**

1.读取单个整数，字符串数字转int数字
```java
//        读取单个整数，字符串数字转int数字
        int n = Integer.parseInt(sc.nextLine());
```

2.读取一行整数，以空格分开
```java
//        读取一行整数，以空格分开
        String[] s = sc.nextLine().split(" ");
        int[] num = new int[s.length];
        for(int i=0;i<s.length;i++){
            num[i] = Integer.parseInt(s[i]);
            System.out.println(num[i]);
        }
```
3.单个char数字转int数字,减去'0'

```java
//                单个char数字转int数字,减去'0'
                res[i][j] = c-'0';
```

4.遍历字符串的每个字符，charAt(i)
```java
//        遍历字符串的每个字符，charAt(i)
        for(int i=0;i<s.length();i++){
            System.out.println(s.charAt(i));
        }
```

# 辅助知识
## JAVA环境变量JAVA_HOME、CLASSPATH、PATH配置说明
首先明白一个基础概念：

### current directory(当前目录)：当前在用的目录就是当前目录


比如说当你打开NOTEPAD，并处于运行状态时候，当前目录就是c:/windows；
如果你用cmd命令打开命令行窗口，    当前目录就是c:/windows/system32;

如果你在用java这条指令，当前目录就是JAVA下的BIN目录所在的路径，因为java.exe在bin里面。在java开发配置环境变量时，系统默认(我们对classpath不做任何设定时)的路径也是当前目录。


### JAVA_HOME：它是指jdk的安装目录

   
像D:/j2sdk1.4.2_16，在这路径下你应该能够找到bin、lib等目录。
 为什么要设置它呢，不设定可不可以呢？不设定也是可以滴，但是最好还是设置一下。
 我们现在就当它是一个变量代换 JAVA_HOME = D:/j2sdk1.4.2_16，就是为了避免多写字，它还有一个好处就是当我们需要改变某个jdk时，只需要改JAVA_HOME的值就可以了。等在后面看了Tomcat的启动分析时你就明白了。当在环境变量中引用它的时候要用%JAVA_HOME%来表示      D:/j2sdk1.4.2_16。


### Path：系统变量Path告诉操作系统可执行文件(*.exe、*.bat等)所在的路径

  
 
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
   
 

### CLASSPATH：告诉java虚拟机(jvm)要使用或执行的*.class文件放在什么地方


CLASSPATH是专门针对java的，它相当于windows的path；path是针对整个windows的。
所谓的JVM就好像是在微软OS上面再激活另外一个OS，对JVM来说CLASSPATH就好像是对微软OS来说的PATH，所以要用jvm开运行程序就需要设定classpath，然而jvm像windows一样它也有个默认的查找class文件的路径，对刚开始学习java的我们来说，默认的已经够我们用了，那就是当前路径，因此不设置classpath也可以。

在windows中 classpath 大小写没有关系，其他的环境变量名称也一样。
 当我们不设定classpath时，系统默认的classpath是当前目录，如果你个人想设置classpath的话，那么务必在classpath中加入"."，这个英文状态下的点就表示当前目录。至于classpath中要不要加入其他的路径(包括文件目录、包的根目录等)，这要看开发的需要，一般我们初学者是用不到的。

JAVA_HOME = D:/j2sdk1.4.2_16
Path 环境变量中在最前面加入(若系统原来没有就新建) %JAVA_HOME%/bin; （加在最前面可以提高查找速度）
CLASSPATH = . 这一步可以不用设。

## JDK 和 JRE 的区别

![在这里插入图片描述](https://img-blog.csdnimg.cn/7b9ff76b66e949fc9a04515e960b9de4.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_18,color_FFFFFF,t_70,g_se,x_16)
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

# SpringBoot
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
title: Java知识
date: 2022/2/28

categories:

Java
tags:

动态规划
数据结构
Java
SpringBoot
常用方法
返回两个参数的最大值，最小值
Math.max(12.123, 18.456) //括号内两个数为相同数据类型
Math.min(a,b)
哈希表
HashMap 是一个散列表，它存储的内容是键值对(key-value)映射。

HashMap 的 key 与 value 类型可以相同也可以不同，可以是字符串（String）类型的 key 和value，也可以是整型（Integer）的 key 和字符串（String）类型的 value。

// 引入 HashMap 类      
import java.util.HashMap;

public class RunoobTest {
    public static void main(String[] args) {
        // 创建 HashMap 对象 Sites
        HashMap<Integer, String> Sites = new HashMap<Integer, String>();
        // 添加键值对
        Sites.put(1, "Google");
        Sites.put(2, "Runoob");
        Sites.put(3, "Taobao");
        Sites.put(4, "Zhihu");
        System.out.println(Sites.get(3));
    }
}
String类
substring() 返回字符串字串
public String substring(int beginIndex)

或

public String substring(int beginIndex, int endIndex)
参数
beginIndex – 起始索引（包括）, 索引从 0 开始。

endIndex – 结束索引（不包括）。

public class RunoobTest {
    public static void main(String args[]) {
        String Str = new String("This is text");
 
        System.out.print("返回值 :" );
        System.out.println(Str.substring(4) );
 
        System.out.print("返回值 :" );
        System.out.println(Str.substring(4, 10) );
    }
}
结果：
返回值 : is text
返回值 : is te

字符串操作
字符串某个位置插入一个字符
StringBuffer sb = new StringBuffer("原字符串");
 
sb.insert(index,"需要插入的字符串");
字符串长度
s.length()
//数组长度是 num.length
字符串修改
当对字符串进行修改的时候，需要使用 StringBuffer 和 StringBuilder 类。

和 String 类不同的是，StringBuffer 和 StringBuilder 类的对象能够被多次的修改，并且不产生新的未使用对象。

在这里插入图片描述

在使用 StringBuffer 类时，每次都会对 StringBuffer 对象本身进行操作，而不是生成新的对象，所以如果需要对字符串进行修改推荐使用 StringBuffer。

StringBuilder 类在 Java 5 中被提出，它和 StringBuffer 之间的最大不同在于 StringBuilder 的方法不是线程安全的（不能同步访问）。

由于 StringBuilder 相较于 StringBuffer 有速度优势，所以多数情况下建议使用 StringBuilder 类。

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
返回指定索引处的字符
实例：

public class Test {
    public static void main(String args[]) {
        String s = "www.runoob.com";
        char result = s.charAt(6);
        System.out.println(result);
    }
}

删除字符串首尾空白符
str=str.trim();
返回字符串的子字符串
public String substring(int beginIndex, int endIndex)

beginIndex -- 起始索引（包括）, 索引从 0 开始。
endIndex -- 结束索引（不包括）。
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
字符串反转
使用StringBuilder

Scanner in = new Scanner(System.in);
        String str = in.nextLine();
        StringBuffer strb = new StringBuffer(str);
        strb.reverse();
        System.out.println(strb.toString());  //要求返回String类可用这句
        System.out.println(strb);
数组
数组长度
num.length
//字符串长度是 s.length()
二维数组
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
数组排序
Arrays.sort(arr);
Arrays.sort()重载了四类方法
sort(T[] a)：对指定T型数组按数字升序排序。
sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
sort(T[] a, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。
数组拷贝
Arrays.copyOf方法

Arrays.copyOf(array, to_index);// to_index是1，就是拷贝从头往后数的1个数，5就是从头往后数的5个数
Arrays.fill(array, from_index, to_index);
第一个方法其实就是返回一个数组，而这个数组就等于数组array的前to_index个数，也就是array[0] ~ array[to_index - 1]。

而第二种方法也只是加了一个初始的位置，即返回一个数组等于array[from_index] ~ array[to_index - 1]。

这里要注意一下，不管是上面哪种使用方法，都务必记住时不包含array[to_index]这个数。

还有一点差点忘了说了，这里得提前导入Arrays类，即在开头写如下代码
import java.utl.Arrays;

构造函数（方法）
作用：一般用来初始化成员属性和成员方法的，即new对象产生后，就调用了对象了属性和方法。

一个对象建立，构造函数只运行一次。

而一般函数可以被该对象调用多次。

特点：
1、函数名与类名相同

2、不用定义返回值类型。（不同于void类型返回值，void是没有具体返回值类型；构造函数是连类型都没有）

3、不可以写return语句。（返回值类型都没有，也就不需要return语句了）

注：一般函数不能调用构造函数，只有构造函数才能调用构造函数。

示例：
1、无参构造函数中只定义了一个方法。new对象时，就调用与之对应的构造函数，执行这个方法。不必写“.方法名”。

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
2、有参构造函数，在new对象时，将实参值传给private变量，相当于完成setter功能。

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
以上代码，我们也可以将show()方法中的输出语句直接放在构造函数中，new对象时，即可直接输出值，如下

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
一个对象建立后，构造函数只运行一次。

如果想给对象的值再赋新的值，就要使用set和get方法，此时是当做一般函数使用

如下：

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
String类与StringBuilder类的区别
原文链接

StringBuilder类介绍
StringBuilder类是一个可变的字符序列。

StringBuilder()
构造一个不带任何字符的字符串生成器，其初始容量为 16 个字符。
StringBuilder(CharSequence seq)
构造一个字符串生成器，它包含与指定的 CharSequence 相同的字符。
StringBuilder(int capacity)
构造一个不带任何字符的字符串生成器，其初始容量由 capacity 参数指定。
StringBuilder(String str)
构造一个字符串生成器，并初始化为指定的字符串内容。

StringBuilder类的几个常用方法
append(任意类型)  追加到字符串后面

reverse 反转字符串

insert(int offset, 任意类型)  在某个index后插入字符串

toString()  返回String类的对象
先看一段String类的字符串拼接的代码。
在这里插入图片描述

String s = “hello” 会在常量池开辟一个内存空间来存储”hello"。

s += “world"会先在常量池开辟一个内存空间来存储“world”。然后再开辟一个内存空间来存储”helloworld“。

这么以来，001与002就成为了垃圾内存空间了。这么简单的一个操作就产生了两个垃圾内存空间，如果有大量的字符串拼接，将会造成极大的浪费。

StringBuilder的作用
上面的例子可以知道String类的字符串拼接会产生大量的垃圾内存空间。但是StringBuilder的字符串拼接是直接在原来的内存空间操作的，即直接在hello这个内存空间把hello拼接为helloworld。

来证明下：

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
输出结果是：

hello
hello
true

String类与StringBuilder类的相互转换
1.String类转换为StringBuilder类

public class String12 {
    public static void main(String[] args){
        String s = "hello";
        StringBuilder sb = new StringBuilder(s);
        System.out.println(sb);
    }
}
2.StringBuilder类转换为String类

public class String12 {
    public static void main(String[] args){
        StringBuilder sb = new StringBuilder();
        sb.append("abc").append("efg");
        String s = sb.toString();
        System.out.println(s);
    }
}
字母大小写判断与转换
Character.isDigit(char c)　//判断字符c是否是数字字符，如‘1’，‘2’，是则返回true，否则返回false

Character.isLetter(char c)  //判断字符c是否是字母

Character.isLowerCase(char c)　//判断c是否是小写字母字符

Character.isUpperCase(char c)　//判断c是否是大写字母字符

Character.isLetterOrDigit(char c)　判断c是否是字母或数字字符

Character.toLowerCase(char c)　//字母转换为小写字母字符

Character.toUpperCase(char c)　//字母转换为大写字母字符

集合
Java 中集合主要分为java.util.Collection和java.util.Map两大接口。

在这里插入图片描述

图表最下方的ArrayList、LinkedList、HashSet以及HashMap都是常用实现类。

初始化
// 无参构造实例化，初始容量为10
List arrayList1 = new ArrayList();
// 实例化一个初始容量为20的空列表
List arrayList2 = new ArrayList(20);
// 实例化一个集合元素为 arrayList2 的列表（由于 arrayList2 为空列表，因此其实例化的对象也为空列表）
List arrayList3 = new ArrayList(arrayList2);

上面的方法可能会报错，所以引入泛型。

List<Integer> arrayList = new ArrayList<Integer>(); // () “括号”里面如果什么都不写，会采取默认容量，也可以复制，也可以将同类型的元素直接放进去
Collections之间相互转换
背景：ArrayList元素去重

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

输出结果：

[1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 7, 8]
[1, 2, 3, 4, 5, 6, 7, 8]
ArrayList数据去重
原文链接

法一：
LinkedHashSet是在一个ArrayList删除重复数据的最佳方法。

LinkedHashSet在内部完成两件事：

1 删除重复数据
2 保持添加到其中的数据的顺序

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

法二：
要从arraylist中删除重复项，我们也可以使用java 8 stream api。使用steam的distinct()方法返回一个由不同数据组成的流，通过对象的equals（）方法进行比较。
收集所有区域数据List使用Collectors.toList()。
Java程序，用于在不使用Set的情况下从java中的arraylist中删除重复项。

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

法三：
利用HashSet不能添加重复数据的特性 由于HashSet不能保证添加顺序，所以只能作为判断条件保证顺序：

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

法四：
利用List的contains方法循环遍历,重新排序,只添加一次数据,避免重复：

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

法五：双重for循环去重

for (int i = 0; i < list.size(); i++) { 
	for (int j = 0; j < list.size(); j++) { 
		if(i!=j&&list.get(i)==list.get(j)) { 
			list.remove(list.get(j)); 
		 } 
	} 
}

Collections.sort()
原文链接

Collections类中的sort方法可以对实现了List接口的集合进行排序。这个方法假定列表元素实现了Comparable接口。

sort常用形式
sort有两种重载形式，第一种（默认升序）：

static <T extends Comparable<? super T>> void sort(List<T> list)
根据官方文档的描述，这个方法将列表元素进行升序排序，但是列表要满足以下条件：
  1.列表元素实现了Comparable接口，且任意两个列表元素都是可比的。
  2.列表必须支持set方法。

实现代码如下：

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
结果：
在这里插入图片描述

sort第二种重载（降序）：

public static <T> void sort(List<T> list,Comparator<? super T> c)
如果想采用其他方式进行排序，那么可将一个Comparator对象作为sort方法的第二个参数。当要进行逆序排序时，最简便的方法是将Collections.reverseOrder()作为第二个参数。

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
结果：
在这里插入图片描述
看到这里，对 Comparator这个词多关注下

排序对象不是基本数据类型
定义一个点类，其中有整型属性x和y，代表其坐标；除了这两个属性以外没有其他属性。随机产生10个点，并按照这些点与原点(0,0)之间的距离大小对点进行降序排序。

如果仍想通过sort方法进行排序的话，首先点类就必须满足上面曾经提过的约束条件：点对象是可比的，因此点类必须实现Comparable接口。查看官方文档可知，Comparable接口中只有一个方法：

int compareTo(T o)
调用这个方法的对象将会与参数o进行比较，小于o、等于o和大于o分别对应的返回值为负数、0和正数。对象之间相对大小的判断方法是自定义的，在这个问题中，就是通过比较各点与原点之间的距离来判断大小，所以点类的实现如下：

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
因为要进行降序排序，所以可以通过将Collections.reverseOrder()作为sort方法的第二个参数来实现：

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
结果：
在这里插入图片描述

sort方法小结：
实现了Comparable接口的类都可以用sort方法进行排序，默认的排序方法是升序；如果想进行降序排序，只需把Collections.reverseOrder作为第二个参数传给sort方法。

Comparator接口
上面反复提到的Collections.reverseOrder方法返回的是一个Comparator对象。其实Comparator接口并不陌生，常用的equals方法就来自这个接口。Comparator接口用来定义两个对象之间的比较方法，它有一个叫做compare的方法，函数签名如下：

int compare(T o1,T o2)
o1 > o2，返回正数；o1 = o2，返回0；o1 < o2，返回负数。
  从前面的例子可以看出，可以使用Comparator对象来控制sort的排序方法，这是如何实现的？查看sort方法的相关源码，我发现其中有这样一段代码：

在这里插入图片描述
注意看图中用红线框起来的部分。经分析可知，这段代码实现了这样的逻辑：如果compare的返回值为正数，就交换进行比较的两个元素的位置。于是可以得出这样一个结论，如果让 x > y 时compare(x,y)返回正数，那么交换 x 和 y 的位置后大的元素在后，这就实现了升序排序；反之，如果让 x < y 时compare(x,y)返回正数，那么交换位置后小的元素在后，这就实现了降序排序。这就是Comparator对象控制排序方式的原理。

在这里插入图片描述

通过Comparator对象来实现点对象的降序排序，一种可行的实现方式如下：

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
结果：
在这里插入图片描述

Arrays.sort()
原文
Arrays.sort()是经过调优排序算法，性能能达到n*log(n)

Arrays.sort()重载了四类方法

sort(T[] a)：对指定T型数组按数字升序排序。
sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
sort(T[] a, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。
sort(T[] a)
对指定T型数组按数字升序排序。

import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[] a={2,5,4,3,1,8};
        Arrays.sort(a);
        System.out.println(Arrays.toString(a));
    }
}// 结果// [1, 2, 3, 4, 5, 8]
sort(T[] a,int formIndex, int toIndex)
对指定T型数组的指定范围按数字升序排序。

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
sort(T[] a, Comparator<? supre T> c)
（1）按第一维元素比较二维数组
代码：

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
（2）按第二维元素比较二维数组

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
其实这个方法最重要的还是类对象的比较

由于我们可以自定义比较器，所以我们可以使用策略模式，使得在运行时选择不同的算法

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
那么在参数中会出现super呢？这意味着这类型可以是T或者它的父类型。这就是的该方法可以允许所有子类使用相同的比较器。详细见代码：

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
sort(T[] a, int formIndex, int toIndex, Comparator<? supre T> c)
根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。

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
判断变量类型
1.使用反射的方法： 变量名.getClass().getSimpleName()来判断。
2.使用 instanceof 来判断：变量名 instanceof 类型来判断。

1.使用反射的方法来判断
在这里插入图片描述
2.使用 instanceof 来判断
在这里插入图片描述

牛客网输入
牛客网输入为了方便一律采用nextLine()作为接受

1.读取单个整数，字符串数字转int数字

//        读取单个整数，字符串数字转int数字
        int n = Integer.parseInt(sc.nextLine());
2.读取一行整数，以空格分开

//        读取一行整数，以空格分开
        String[] s = sc.nextLine().split(" ");
        int[] num = new int[s.length];
        for(int i=0;i<s.length;i++){
            num[i] = Integer.parseInt(s[i]);
            System.out.println(num[i]);
        }
3.单个char数字转int数字,减去’0’

//                单个char数字转int数字,减去'0'
                res[i][j] = c-'0';
4.遍历字符串的每个字符，charAt(i)

//        遍历字符串的每个字符，charAt(i)
        for(int i=0;i<s.length();i++){
            System.out.println(s.charAt(i));
        }
辅助知识
JAVA环境变量JAVA_HOME、CLASSPATH、PATH配置说明
首先明白一个基础概念：

current directory(当前目录)：当前在用的目录就是当前目录
比如说当你打开NOTEPAD，并处于运行状态时候，当前目录就是c:/windows；
如果你用cmd命令打开命令行窗口， 当前目录就是c:/windows/system32;

如果你在用java这条指令，当前目录就是JAVA下的BIN目录所在的路径，因为java.exe在bin里面。在java开发配置环境变量时，系统默认(我们对classpath不做任何设定时)的路径也是当前目录。

JAVA_HOME：它是指jdk的安装目录
像D:/j2sdk1.4.2_16，在这路径下你应该能够找到bin、lib等目录。
为什么要设置它呢，不设定可不可以呢？不设定也是可以滴，但是最好还是设置一下。
我们现在就当它是一个变量代换 JAVA_HOME = D:/j2sdk1.4.2_16，就是为了避免多写字，它还有一个好处就是当我们需要改变某个jdk时，只需要改JAVA_HOME的值就可以了。等在后面看了Tomcat的启动分析时你就明白了。当在环境变量中引用它的时候要用%JAVA_HOME%来表示 D:/j2sdk1.4.2_16。

Path：系统变量Path告诉操作系统可执行文件(.exe、.bat等)所在的路径
当OS(操作系统)发现某个*.exe时，windows默认从当前目录开始查找这 个命令，若查不到，OS就会到Path所设定的路径中去寻找该命令，然后执行。

系统默认的系统变量为：Path = %SystemRoot%;%SystemRoot%/system32;%SystemRoot%/System32/Wbem
就是说处于上面3个目录(多个变量用分号隔开)中的*.exe文件，可以在任意地方被执行(在 运行 窗口能直接执行的命令，像cmd、notepad等，基本都 在上面的3个目录里面)，所以他们可以直接运行。
上面的%SystemRoot%是什么意思呢？%SystemRoot%就是安装操作系统的时候，系统默认的安装路径
若你的windows xp装在C:/WINDOWS
则你的%systemRoot%路径就是c:/windows
%systemRoot%只是一个符号,代表你的系统安装目录
下面是常见系统默认安装路径:
98----c:/windows
2000–c:/winnt
2003–c:/windows
xp----c:/windows
当我们要进行java开发时，OS经常需要用到java.exe、javac.exe等，（若jdk安装在D:/j2sdk1.4.2_16）因此应该将 D:/j2sdk1.4.2_16/bin（%JAVA_HOME%/bin）加入到系统的path中去。
注意：如果你加入的位置不是在最后，那还需要在bin后面加上英文状态下的分号：%JAVA_HOME%/bin；多个变量之间要用分号隔开，如果它前面 没有，你就加一个。
明确一下：%JAVA_HOME%/jre/bin 这个路径是不需要加入Path的。参考：http://java.sun.com/javase/6/docs/technotes/tools/windows/jdkfiles.html

CLASSPATH：告诉java虚拟机(jvm)要使用或执行的*.class文件放在什么地方
CLASSPATH是专门针对java的，它相当于windows的path；path是针对整个windows的。
所谓的JVM就好像是在微软OS上面再激活另外一个OS，对JVM来说CLASSPATH就好像是对微软OS来说的PATH，所以要用jvm开运行程序就需要设定classpath，然而jvm像windows一样它也有个默认的查找class文件的路径，对刚开始学习java的我们来说，默认的已经够我们用了，那就是当前路径，因此不设置classpath也可以。

在windows中 classpath 大小写没有关系，其他的环境变量名称也一样。
当我们不设定classpath时，系统默认的classpath是当前目录，如果你个人想设置classpath的话，那么务必在classpath中加入"."，这个英文状态下的点就表示当前目录。至于classpath中要不要加入其他的路径(包括文件目录、包的根目录等)，这要看开发的需要，一般我们初学者是用不到的。

JAVA_HOME = D:/j2sdk1.4.2_16
Path 环境变量中在最前面加入(若系统原来没有就新建) %JAVA_HOME%/bin; （加在最前面可以提高查找速度）
CLASSPATH = . 这一步可以不用设。

JDK 和 JRE 的区别
在这里插入图片描述
从图中可以看出JDK包含JRE包含JVM…

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

SpringBoot
springboot 只是组装了spring和springmvc。SSM中的SS指的是Spring SpringMVC，M是指MyBatis。

SSM（Spring+SpringMVC+MyBatis）架构
工作原理
1.SSM系统架构
在这里插入图片描述

2.执行流程
在这里插入图片描述

MSCM(model ,service, controller ,mapper)
mapper的中文意思是映射器；mapper和dao是一个东西，叫法不同。

业务逻辑：
Controller–>service接口–>serviceImpl–>dao接口–>daoImpl–>mapper–>db

一：Dao(Data Access Object):数据存储对象
DAO = Data Access Object = 数据存取对象. 不管是什么框架，我们很多时候都会与数据库进行交互。如果遇到一个场景我们都要去写SQL语句，那么我们的代码就会很冗余。所以，我们就想到了把数据库封装一下，让我们的数据库的交道看起来像和一个对象打交道，这个对象通常就是DAO。当我们操作这个对象的时候，这个对象会自动产生SQL语句来和数据库进行交互，我们就只需要使用DAO就行了。

通常我们在DAO层里面写接口，里面有与数据打交道的方法。SQL语句通常写在mapper文件里面的。

优点：结构清晰，Dao层的数据源配置以及相关的有关数据库连接的参数都在Spring配置文件中进行配置。

二：Service：服务
服务是一个相对独立的功能模块，主要负责业务逻辑应用设计。首先也要设计接口，然后再设计其实现该接口的类。这样我们就可以在应用中调用service接口进行业务处理。service层业务实现，具体调用到已经定义的DAO的接口，封装service层的业务逻辑有利于通用的业务逻辑的独立性和重复利用性 。
如果把Dao层当作积木，则Service层则是对积木的搭建。

三：Controller：控制器
主要负责具体业务模块流程的控制，此层要调用到Service层的接口去控制业务流程，控制的配置同样在Spring配置文件中配置。针对不同的业务流程有不同的控制器。在设计的过程可以设计出重复利用的子单元流程模块。

四：model：模型
模型就是指视图的数据Model，模型，通常来讲，我们会把模型和另一个东西放在一起来说：View，视图。

模型通常认为是视图的内核，何谓之视图？我们正在与之交互的网站的界面就是视图，而模型是指他的内核：数据。

将Model和View的概念拆分开来，有助于我们关注不同的方面，也可以更有效的分工。有些工程师更关注于内核也就是模型，通常来说，他们被称之为后端工程师。有些工程师更关注于用户界面的交互和展示，通常来说，他们被称之为前端工程师。

五: View层：
与Controller层关系紧密，View层主要负责前台jsp页面的表示。

六: 它们之间的关系：
建立了DAO层后才可以建立Service层，而Service层又是在Controller层之下的，因而Service层应该既调用DAO层的接口，又要提供接口给Controller层的类来进行调用，它刚好处于一个中间层的位置。每个模型都有一个Service接口，每个接口分别封装各自的业务处理方法。

在这里插入图片描述
另一个图的解释：
实体类这一层，有的开发写成pojo，有的写成model，也有domain，也有dto（这里做参数验证，比如password不能为空等），实体类如果你不懂什么东西的话，那你就想成是范围。

mapper 是Mybatis 操作数据库的那一层，就是dao层。

service包含了serviceImpl（service接口的实现类） 是提供给controller 使用的，针对于某些业务将 dao 的对于某些表的crud进行组合，也就是说间接的和数据库打交道。

controller 通过调用service来完成业务逻辑。
在这里插入图片描述

常见缩写
JSP
详情
JSP 与 PHP、ASP、ASP.NET 等语言类似，运行在服务端的语言。

JSP（全称Java Server Pages）是由 Sun Microsystems 公司倡导和许多公司参与共同创建的一种使软件开发者可以响应客户端请求，而动态生成 HTML、XML 或其他格式文档的Web网页的技术标准。

JSP 技术是以 Java 语言作为脚本语言的，JSP 网页为整个服务器端的 Java 库单元提供了一个接口来服务于HTTP的应用程序。

JSP文件后缀名为 *.jsp 。

JSP开发的WEB应用可以跨平台使用，既可以运行在 Linux 上也能运行在 Windows 上。

POJO、JAVABean、Entity
1.POJO
  （Plain Ordinary Java Object）简单的Java对象，实际就是普通JavaBeans，是为了避免和EJB混淆所创造的简称。
  其中有一些属性及其getter、setter方法的类，没有业务逻辑，有时可以作为VO（value-object）或DTO（Data Transfer Object）来使用。不允许有业务方法，也不能携带connection之类的方法，实际就是普通JavaBeans。POJO类中有属性和get、set方法，但是没有业务逻辑。

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
2.JAVABean
一种JAVA语言写成的可重用组件。JavaBean符合一定规范编写的Java类，不是一种技术，而是一种规范。大家针对这种规范，总结了很多开发技巧、工具函数。符合这种规范的类，可以被其它的程序员或者框架使用。它的方法命名，构造及行为必须符合特定的约定：

1、所有属性为private。

2、这个类必须有一个公共的缺省构造函数。即是提供无参数的构造器。

3、这个类的属性使用getter和setter来访问，其他方法遵从标准命名规范。

4、这个类应是可序列化的。实现serializable接口。

因为这些要求主要是靠约定而不是靠实现接口，所以许多开发者把JavaBean看作遵从特定命名约定的POJO。

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
区别
POJO其实是比javabean更纯净的简单类或接口。POJO严格地遵守简单对象的概念，而一些JavaBean中往往会封装一些简单逻辑。
POJO主要用于数据的临时传递，它只能装载数据， 作为数据存储的载体，而不具有业务逻辑处理的能力。
Javabean虽然数据的获取与POJO一样，但是javabean当中可以有其它的方法。

3.entity（实体类）
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

发文助手
发文助手会检测您的文章标题、错别字、内容质量，助您提升文章质量。【创作规范】
1 条建议

重新检测
标题格式不规范
标题长度小于5个字符，请进行修改！
牛客网输入
0 of 2
Markdown 28524 字数 1545 行数 当前行 1189, 当前列 22 文章已保存20:17:44HTML 25363 字数 1017 段落
已成功保存至草稿箱
