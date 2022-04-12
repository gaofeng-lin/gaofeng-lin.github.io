---
title: Go
date: 2022/3/6
categories:
  - Go
  
tags:
  - Go
---



# 环境变量

```
go version  //查看版本
go env   //查看环境变量
```


# 语法


## 占位符
[原文链接](https://zhuanlan.zhihu.com/p/139758275)
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/1298ce4931252dd9582b2d7571ab97c4.png#pic_center)
输出为：

```
{Aric 21 3-1}
{Name:Aric Age:21 Class:3-1}
main.Student{Name:"Aric", Age:21, Class:"3-1"}
main.Student
676f6c616e67
676F6C616E67
0xc000062150
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/566b6c8f51f9f93e95c631aac7e69778.png#pic_center)


## 下划线  “_”

“_”是特殊标识符，用来忽略结果。

**1.下划线在import中**

在Golang里，import的作用是导入其他package。
　　 import 下划线（如：import _ hello/imp）的作用：当导入一个包时，该包下的文件里所有init()函数都会被执行，然而，有些时候我们并不需要把整个包都导入进来，仅仅是是希望它执行init()函数而已。这个时候就可以使用 import _ 引用该包。即使用【import _ 包路径】只是引用该包，仅仅是为了调用init()函数，所以无法通过包名来调用包中的其他函数。
示例：

```
src 
|
+--- main.go            
|
+--- hello
       |
       +--- hello.go
```
main.go

```
package main

import _ "./hello"

func main() {
    // hello.Print() 
    //编译报错：./main.go:6:5: undefined: hello
}
```
hello.go

```
package hello

import "fmt"

func init() {
    fmt.Println("imp-init() come here.")
}

func Print() {
    fmt.Println("Hello!")
}
```
输出结果：

```
imp-init() come here.
```
**2.下划线在代码中**

```
package main

import (
    "os"
)

func main() {
    buf := make([]byte, 1024)
    f, _ := os.Open("/Users/***/Desktop/text.txt")
    defer f.Close()
    for {
        n, _ := f.Read(buf)
        if n == 0 {
            break    

        }
        os.Stdout.Write(buf[:n])
    }
}
```
解释1：

```
下划线意思是忽略这个变量.

比如os.Open，返回值为*os.File，error

普通写法是f,err := os.Open("xxxxxxx")

如果此时不需要知道返回的错误值

就可以用f, _ := os.Open("xxxxxx")

如此则忽略了error变量
```
解释2：

```
占位符，意思是那个位置本应赋给某个值，但是咱们不需要这个值。
所以就把该值赋给下划线，意思是丢掉不要。
这样编译器可以更好的优化，任何类型的单个值都可以丢给下划线。
这种情况是占位用的，方法返回两个结果，而你只想要一个结果。
那另一个就用 "_" 占位，而如果用变量的话，不使用，编译器是会报错的。
```
补充：

```
import "database/sql"
import _ "github.com/go-sql-driver/mysql"
```
第二个import就是不直接使用mysql包，只是执行一下这个包的init函数，把mysql的驱动注册到sql包里，然后程序里就可以使用sql包来访问mysql数据库了。


## = 和 :=的区别
```
// = 使用必须使用先var声明例如：
var a
a=100
//或
var b = 100
//或
var c int = 100
 
// := 是声明并赋值，并且系统自动推断类型，不需要var关键字
d := 100
```

## String()方法
对于定于了String()方法的类型，默认输出的时候会调用该方法，实现字符串的打印。例如下面代码：

```
package main
 
import "fmt"
 
type Man struct {
    name string
}
 
func (m Man) String() string {
    return "My name is :" + m.name
}
 
func main() {
    var m Man
    m.name = "SNS"
    fmt.Println(m)
}
 
输出：
My name is :SNS
```
**使用指针**
然而，如果使用func (m *Man) String() string方式定义函数，那么就不会自动调用该函数输出（go version go1.12.1 windows/amd64）。

```
package main
 
import "fmt"
 
type Man struct {
    name string
}
 
func (m *Man) String() string {
    return "My name is :" + m.name
}
 
func main() {
    var m Man
    m.name = "SNS"
    fmt.Println(m)
}
 
输出:
{SNS}
```

> String方法是接口方法，存在于fmt包里print.go文件下的Stringer接口。go使用fmt包的输出方法会自动调用String()方法。当重写的String是指针方法时，只有指针类型调用的时候才会正常调用，值类型调用的时候实际上没有执行重写的String方法；当重写的String方法是值方法时，无论指针类型和值类型均可调用重写的String方法。其实跟接口的实现有关，当值类型实现接口的时候，相当于值类型和该值的指针类型均实现了该接口；相反，当指针类型实现了该接口的时候，只有指针类型实现了接口，值类型是没有实现的。


> 最后一句改成`fmt.Println(&m)`
> 因为你只为`*Man`这个Man的指针类型重新定义了String()方法，所以只有在输出`*Man`类型的数据时才会调用自定义的String()方法。
> 而你定义的m是Man类型的，所以才不会调用你定义的String方法。
> 所要么向楼上那位一样定义*Man类型。要么就是在输出时，向Print函数传递*Man类型的数据(改成`fmt.Println(&m)`)


## 方法接受者
[原文链接](https://www.jianshu.com/p/316617954070)
在go语言中，没有类的概念但是可以给类型（结构体，自定义类型）定义方法。所谓方法就是定义了接受者的函数。接受者定义在func关键字和函数名之间:

```
type Person struct {
    name string
    age int
}

func (p Person) say() {
    fmt.Printf("I'm %s,%d years old\n",p.name,p.age)
}
```
有了对方法及接受者的简单认识之后，接下来主要谈一下接受者的类型问题。
接受者类型可以是struct,也可以是指向struc的指针。
**情况一：接受者是struct**

```
package main

import "fmt"

type Person struct {
name string
age int
}
func (p Person) say() {
fmt.Printf("I'm %s,%d years old\n",p.name,p.age)
}
func (p Person) older(){
    p.age = p.age +1
}
func main() {
    var p1 Person = Person{"zhansan",16}
    p1.older()
    p1.say()
    //output: I'm zhangsan，16 years old
    var p2 *Person = &Person{"lisi",17}
    p2.older()
    p2.say()
    //output: I'm lisi，17 years old
}
```
对于p1的调用，读者应该不会有什么疑问。
对于p2的调用可能存在这样的疑问，p2明明是个指针，为什么再调用了older方法之后，打印结果还是17 years old?
方法的接受者是Person而调用者是*Person ，其实在p2调用时存在一个转换p2.older() -> *p2.older(); p2.say() -> *p2.say()
*p2是什么想必读者也是明白的（就一个p2指向Person实例）。那么疑问也就自然的解开了,方法执行时的接受者实际上还是一个值而非引用。

**情况二：接受者是指针**

```
package main

import "fmt"

type Person struct {
name string
age int
}
func (p *Person) say() {
fmt.Printf("I'm %s,%d years old\n",p.name,p.age)
}
func (p *Person) older(){
    p.age = p.age +1
}
func main() {
    var p1 Person = Person{"zhansan",16}
    p1.older()
    p1.say()
    //output: I'm zhangsan，17 years old
    var p2 *Person = &Person{"lisi",17}
    p2.older()
    p2.say()
    //output: I'm lisi，18 years old
}
```
p1的调用中也存在一个转换，
p1.older -> *p1.older
p1.say() -> *p1.say()

**用例：**

```
package main

import (
    "fmt"
)

//面向对象
//go仅支持封装，不支持继承和多态
//go语言中没有class，只要struct
//不论地址还是结构本身，一律使用.来访问成员
//要改变内容必须使用指针接收者
//结构过大考虑指针接收者
//值接收者是go语言特有
//封装
//名字一般使用CamelCase
//首字母大写： public
//首字母小写：private

//包
//每个目录一个包，包名可以与目录不一样
//main包包含可执行入口，只有一个main包
//为结构定义的方法必须放在同一个包内，但是可以是不同文件


type treeNode struct {
    value int
    left, right *treeNode
}

func (node treeNode) print() {  //显示定义和命名方法接收者（括号里）

    fmt.Print(node.value)  //只有使用指针才可以改变结构内容
    fmt.Println()
}

func (node *treeNode) setValue ( value int) {  //使用指针作为方法接收者
    if node == nil {
        fmt.Println("setting value to nil node") //nil指针也可以调用方法
        return
    }
    node.value = value
}

func (node *treeNode ) traverse(){
    if node == nil{
        return
    }
    node.left.traverse()
    node.print()
    node.right.traverse()
}

func main() {
    var  root  treeNode
    fmt.Println(root)  //{0 <nil> <nil>}

    root = treeNode{value:3}
    root.left = &treeNode{}
    root.right = &treeNode{5,nil,nil}
    root.right.left = new(treeNode)

    nodes := []treeNode {
        {value: 3},
        {},
        {6,nil,&root},
    }
    fmt.Println(nodes)  //[{3 <nil> <nil>} {0 <nil> <nil>} {6 <nil> 0xc04205a3e0}]

    root.print()  // 3
    fmt.Println()
    root.right.left.setValue(100)
    root.right.left.print()  //100
    fmt.Println()

    var pRoot *treeNode
    pRoot.setValue(200)   //setting value to nil node
    pRoot = &root
    pRoot.setValue(300)
    pRoot.print()  //300

    root.traverse()  //300 0 300 100 5
}
```



## 结构体定义中的 json 单引号（``）

```
package main

import (
    "encoding/json"
    "fmt"
)

//在处理json格式字符串的时候，经常会看到声明struct结构的时候，属性的右侧还有小米点括起来的内容。`TAB键左上角的按键，～线同一个键盘`

type Student struct {
    StudentId      string `json:"sid"`
    StudentName    string `json:"sname"`
    StudentClass   string `json:"class"`
    StudentTeacher string `json:"teacher"`
}

type StudentNoJson struct {
    StudentId      string
    StudentName    string
    StudentClass   string
    StudentTeacher string
}

//可以选择的控制字段有三种：
// -：不要解析这个字段
// omitempty：当字段为空（默认值）时，不要解析这个字段。比如 false、0、nil、长度为 0 的 array，map，slice，string
// FieldName：当解析 json 的时候，使用这个名字
type StudentWithOption struct {
    StudentId      string //默认使用原定义中的值
    StudentName    string `json:"sname"`           // 解析（encode/decode） 的时候，使用 `sname`，而不是 `Field`
    StudentClass   string `json:"class,omitempty"` // 解析的时候使用 `class`，如果struct 中这个值为空，就忽略它
    StudentTeacher string `json:"-"`               // 解析的时候忽略该字段。默认情况下会解析这个字段，因为它是大写字母开头的
}

func main() {
    //NO.1 with json struct tag
    s := &Student{StudentId: "1", StudentName: "fengxm", StudentClass: "0903", StudentTeacher: "feng"}
    jsonString, _ := json.Marshal(s)

    fmt.Println(string(jsonString))
    //{"sid":"1","sname":"fengxm","class":"0903","teacher":"feng"}
    newStudent := new(Student)
    json.Unmarshal(jsonString, newStudent)
    fmt.Println(newStudent)
    //&{1 fengxm 0903 feng}
    //Unmarshal 是怎么找到结构体中对应的值呢？比如给定一个 JSON key Filed，它是这样查找的：
    // 首先查找 tag 名字（关于 JSON tag 的解释参看下一节）为 Field 的字段
    // 然后查找名字为 Field 的字段
    // 最后再找名字为 FiElD 等大小写不敏感的匹配字段。
    // 如果都没有找到，就直接忽略这个 key，也不会报错。这对于要从众多数据中只选择部分来使用非常方便。

    //NO.2 without json struct tag
    so := &StudentNoJson{StudentId: "1", StudentName: "fengxm", StudentClass: "0903", StudentTeacher: "feng"}
    jsonStringO, _ := json.Marshal(so)

    fmt.Println(string(jsonStringO))
    //{"StudentId":"1","StudentName":"fengxm","StudentClass":"0903","StudentTeacher":"feng"}

    //NO.3 StudentWithOption
    studentWO := new(StudentWithOption)
    js, _ := json.Marshal(studentWO)

    fmt.Println(string(js))
    //{"StudentId":"","sname":""}

    studentWO2 := &StudentWithOption{StudentId: "1", StudentName: "fengxm", StudentClass: "0903", StudentTeacher: "feng"}
    js2, _ := json.Marshal(studentWO2)

    fmt.Println(string(js2))
    //{"StudentId":"1","sname":"fengxm","class":"0903"}

}
```

# 常用操作
## 变量类型转换

```c
string转成int：

int, err := strconv.Atoi(string)

string转成int64：

int64, err := strconv.ParseInt(string, 10, 64)

int转成string：

string := strconv.Itoa(int)

int64转成string：

string := strconv.FormatInt(int64,10)
```
具体例子：

```c
package main

import (
	"fmt"
	"strconv"
)

func main() {
	cfdversion :="100"
	newcfd,_ :=strconv.Atoi(cfdversion)
	fmt.Println(newcfd)

}
```

**注意事项：
1.要导入包
2.转换变量类型后要重新用一个名字，不能用之前的变量名
3.下划线那个地方是err，被省略了**

## 判断变量类型
方法一：

```
package main

import (
 "fmt"
)

func main() {

        v1 := "123456"
        v2 := 12

        fmt.Printf("v1 type:%T\n", v1)
        fmt.Printf("v2 type:%T\n", v2)
}

```

方法二：

```
package main

import (
 "fmt"
 "reflect"
)

func main() {
        v1 := "123456"
        v2 := 12

        // reflect
        fmt.Println("v1 type:", reflect.TypeOf(v1))
        fmt.Println("v2 type:", reflect.TypeOf(v2))
}
```

## 解析json文件

```
package main

import (
	// "bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	// "reflect"
)

func con_var_name (key string) string {
	var res string
	bytes,_:=ioutil.ReadFile("C:/Users/76585/Desktop/para_compare_ver2.json")

	m :=make(map[string]interface{})
	err := json.Unmarshal([]byte(bytes),&m)

	if err != nil {
		fmt.Println("err=",err)
		return ""
	}
	for _, value :=range m{
		// fmt.Println(reflect.TypeOf(value.([]interface{})[1].(map[string]interface{})["name"]))	
		if key==value.([]interface{})[0].(map[string]interface{})["name"]{
			res=key
			return res
			
		}
		if key==value.([]interface{})[1].(map[string]interface{})["name"]{
			tmp :=value.([]interface{})[0].(map[string]interface{})["name"]
			res=tmp.(string)
			return res

		}
	}

	res=key

	return res
}
```
## 解析json文件，interface转int
**因为json解析得到的数据是map[string]interface，里面的字段可能是数字，有时候需要取出来比较，
就需要将interface转为int。**
![在这里插入图片描述](https://img-blog.csdnimg.cn/1b607816b68645c5b5ceaebe1859abdc.png)
需要先转为string，在用 `strconv.Atoi`，将string转为int。

## 字符串操作

```
package main
​
import (
    "fmt"
    "strings"
)
​
func main() {
    s := "smallming"
    //第一次出现的索引
    fmt.Println(strings.Index(s, "l"))
    //最后一次出现的索引
    fmt.Println(strings.LastIndex(s, "l"))
    //是否以指定内容开头
    fmt.Println(strings.HasPrefix(s, "small"))
    //是否以指定内容结尾
    fmt.Println(strings.HasSuffix(s, "ming"))
    //是否包含指定字符串
    fmt.Println(strings.Contains(s, "mi"))
    //全变小写
    fmt.Println(strings.ToLower(s))
    //全大写
    fmt.Println(strings.ToUpper(s))
    //把字符串中前n个old子字符串替换成new字符串,如果n小于0表示全部替换.
    //如果n大于old个数也表示全部替换
    fmt.Println(strings.Replace(s, "m", "k", -1))
    //把字符串重复count遍
    fmt.Println(strings.Repeat(s, 2))
    //去掉字符串前后指定字符
    fmt.Println(strings.Trim(s, " ")) //去空格可以使用strings.TrimSpace(s)
    //根据指定字符把字符串拆分成切片
    fmt.Println(strings.Split(s, "m"))
    //使用指定分隔符把切片内容合并成字符串
    arr := []string{"small", "ming"}
    fmt.Println(strings.Join(arr, ""))
}
```

## 正则表达式
### 常用的元字符：

```
. 匹配除换行符以外的任意字符

\w 匹配字母或数字或下划线或汉字

\s 匹配任意的空白符

\d 匹配数字

\b 匹配单词的开始或结束

^ 匹配字符串的开始

$ 匹配字符串的结束
```
字符转义：

如果你想查找元字符本身的话，比如你查找.,或者*,就出现了问题：你没办法指定它们，因为它们会被解释成别的意思。这时你就得使用\来取消这些字符的特殊意义。因此，你应该使用\.和\*。当然，要查找\本身，你也得用\\。

### 重复
![在这里插入图片描述](https://img-blog.csdnimg.cn/ed775dff59f64772a5e4b0c1339e55d5.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)


如果你想匹配没有预定义元字符的字符集合(比如元音字母a,e,i,o,u),应该怎么办？

很简单，你只需要在方括号里列出它们就行了，像[aeiou]就匹配任何一个英文元音字母，[.?!]匹配标点符号(.或?或!)。

**分枝条件：**

正则表达式里的分枝条件指的是有几种规则，如果满足其中任意一种规则都应该当成匹配，具体方法是用 “|”  把不同的规则分隔开。

**分组：**

重复单个字符（直接在字符后面加上限定符就行了）；但如果想要重复多个字符又该怎么办？你可以用小括号来指定子表达式(也叫做分组)，然后你就可以指定这个子表达式的重复次数了，你也可以对子表达式进行其它一些操作。

### 反义字符
![在这里插入图片描述](https://img-blog.csdnimg.cn/b44bde0b2c634cac8c39987e26e035b1.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
例子：\S+匹配不包含空白符的字符串。

<a[^>]+>匹配用尖括号括起来的以a开头的字符串。

### 常用的正则表达式函数：

```
reg = regexp.MustCompile(`匹配模式`)
reg.FindAllString( )
reg.ReplaceAllString(）
```

### 例子
```
func main() {
	text := `Hello 世界！123 Go.`
 
	// 查找连续的小写字母
	reg := regexp.MustCompile(`[a-z]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["ello" "o"]
 
	// 查找连续的非小写字母
	reg = regexp.MustCompile(`[^a-z]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["H" " 世界！123 G" "."]
 
	// 查找连续的单词字母
	reg = regexp.MustCompile(`[\w]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello" "123" "Go"]
 
	// 查找连续的非单词字母、非空白字符
	reg = regexp.MustCompile(`[^\w\s]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["世界！" "."]
 
	// 查找连续的大写字母
	reg = regexp.MustCompile(`[[:upper:]]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["H" "G"]
 
	// 查找连续的非 ASCII 字符
	reg = regexp.MustCompile(`[[:^ascii:]]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["世界！"]
 
	// 查找连续的标点符号
	reg = regexp.MustCompile(`[\pP]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["！" "."]
 
	// 查找连续的非标点符号字符
	reg = regexp.MustCompile(`[\PP]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello 世界" "123 Go"]
 
	// 查找连续的汉字
	reg = regexp.MustCompile(`[\p{Han}]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["世界"]
 
	// 查找连续的非汉字字符
	reg = regexp.MustCompile(`[\P{Han}]+`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello " "！123 Go."]
 
	// 查找 Hello 或 Go
	reg = regexp.MustCompile(`Hello|Go`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello" "Go"]
 
	// 查找行首以 H 开头，以空格结尾的字符串
	reg = regexp.MustCompile(`^H.*\s`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello 世界！123 "]
 
	// 查找行首以 H 开头，以空白结尾的字符串（非贪婪模式）
	reg = regexp.MustCompile(`(?U)^H.*\s`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello "]
 
	// 查找以 hello 开头（忽略大小写），以 Go 结尾的字符串
	reg = regexp.MustCompile(`(?i:^hello).*Go`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello 世界！123 Go"]
 
	// 查找 Go.
	reg = regexp.MustCompile(`\QGo.\E`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Go."]
 
	// 查找从行首开始，以空格结尾的字符串（非贪婪模式）
	reg = regexp.MustCompile(`(?U)^.* `)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello "]
 
	// 查找以空格开头，到行尾结束，中间不包含空格字符串
	reg = regexp.MustCompile(` [^ ]*$`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// [" Go."]
 
	// 查找“单词边界”之间的字符串
	reg = regexp.MustCompile(`(?U)\b.+\b`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello" " 世界！" "123" " " "Go"]
 
	// 查找连续 1 次到 4 次的非空格字符，并以 o 结尾的字符串
	reg = regexp.MustCompile(`[^ ]{1,4}o`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello" "Go"]
 
	// 查找 Hello 或 Go
	reg = regexp.MustCompile(`(?:Hell|G)o`)
	fmt.Printf("%q\n", reg.FindAllString(text, -1))
	// ["Hello" "Go"]
 
	// 查找 Hello 或 Go，替换为 Hellooo、Gooo
	reg = regexp.MustCompile(`(?PHell|G)o`)
	fmt.Printf("%q\n", reg.ReplaceAllString(text, "${n}ooo"))
	// "Hellooo 世界！123 Gooo."
 
	// 交换 Hello 和 Go
	reg = regexp.MustCompile(`(Hello)(.*)(Go)`)
	fmt.Printf("%q\n", reg.ReplaceAllString(text, "$3$2$1"))
	// "Go 世界！123 Hello."
 
	// 特殊字符的查找
	reg = regexp.MustCompile(`[\f\t\n\r\v\123\x7F\x{10FFFF}\\\^\$\.\*\+\?\{\}\(\)\[\]\|]`)
	fmt.Printf("%q\n", reg.ReplaceAllString("\f\t\n\r\v\123\x7F\U0010FFFF\\^$.*+?{}()[]|", "-"))
	// "----------------------"
}
```
## 结构体解析为json

先上代码

**最为关键的是结构体里面的成员变量名，首字母必须是大写，否则无法解析，解析出来的是空。**

```
package main

import (

	"encoding/json"
	"fmt"
)


type Product struct {
	Name string
	ProductId int64
	Number int
	Price float64
	IsOnSale bool
}


func main()  {
	var p Product
	// p := Product{}
	p.Name="apple"
	p.ProductId=1
	p.Number=100
	p.Price=3.45
	p.IsOnSale=false
	data, _ := json.Marshal(&p)
	fmt.Println(string(data))

}

```
## 将json字符串解码到相应的数据结构

```
type StuRead struct {
    Name  interface{} `json:"name"`
    Age   interface{}
    HIgh  interface{}
    sex   interface{}
    Class interface{} `json:"class"`
    Test  interface{}
}

type Class struct {
    Name  string
    Grade int
}

func main() {
    //json字符中的"引号，需用\进行转义，否则编译出错
    //json字符串沿用上面的结果，但对key进行了大小的修改，并添加了sex数据
    data:="{\"name\":\"张三\",\"Age\":18,\"high\":true,\"sex\":\"男\",\"CLASS\":{\"naME\":\"1班\",\"GradE\":3}}"
    str:=[]byte(data)

    //1.Unmarshal的第一个参数是json字符串，第二个参数是接受json解析的数据结构。
    //第二个参数必须是指针，否则无法接收解析的数据，如stu仍为空对象StuRead{}
    //2.可以直接stu:=new(StuRead),此时的stu自身就是指针
    stu:=StuRead{}
    err:=json.Unmarshal(str,&stu)

    //解析失败会报错，如json字符串格式不对，缺"号，缺}等。
    if err!=nil{
        fmt.Println(err)
    }

    fmt.Println(stu)
}
```



## 按行读文件
**注意下这里的第二个方法，读到最后字符串为空，有时候可能会报错（被坑过），加一个判断条件，判断长度是否为0。（代码里面自己已经加了）**
```
func Readlines(filename string) {
	// go 按行读取文件的方式有两种，
	// 第一 将读取到的整个文件内容按照 \n 分割
	// 使用bufio
	// 第一种
	lines, err := ioutil.ReadFile(filename)

	if err != nil {
		fmt.Println(err)
	} else {
		contents := string(lines)
		lines := strings.Split(contents, "\n")
		for _, line := range lines {
			fmt.Println(line)
		}
	}
	// 第二种
	fd, err := os.Open(filename)
	defer fd.Close()
	if err != nil {
		fmt.Println("read error:", err)
	}
	buff := bufio.NewReader(fd)

	for {
		data, _, eof := buff.ReadLine()
		if eof == io.EOF {
			break
		}
		if(len(data)==0){
           break
        }
		fmt.Println(string(data))
	}
}

```


## 字符串与切片的转换

```
package main

import (
	"fmt"
	"strings"
)

func main() {
	s := []string{"1", "2", "3"}
	ss := fmt.Sprintf(strings.Join(s, ","))
	fmt.Println(ss)
	slice := strings.Split(ss, ",")
	fmt.Println(slice)
	//r := gin.Default()
	//r.GET("/", func(context *gin.Context) {
	//	context.JSON(http.StatusOK,gin.H{
	//		"message":"demo",
	//	})
	//})

	//r.Run()
}
//D:\GoProject\gin-demo>go run main.go
//1,2,3
//[1 2 3]


```

## 读写文件
[原文链接](https://www.cnblogs.com/believepd/p/10951763.html)
### 打开关闭文件

```
import (
    "fmt"
    "os"
)

func main() {
    // 打开文件
    file, err := os.Open("e:/a.txt")
    if err != nil {
        fmt.Printf("打开文件出错：%v\n", err)
    }
    fmt.Println(file) // &{0xc00006a780}
    // 关闭文件
    err = file.Close()
    if err != nil {
        fmt.Printf("关闭文件出错：%v\n", err)
    }
}
```
### 读文件
**法一：带缓冲**

```
import (
    "bufio"
    "fmt"
    "io"
    "os"
)

func main() {
    // 打开文件
    file, err := os.Open("e:/a.txt")
    if err != nil {
        fmt.Printf("打开文件出错：%v\n", err)
    }
    // 及时关闭文件句柄
    defer file.Close()
    // bufio.NewReader(rd io.Reader) *Reader
    reader := bufio.NewReader(file)
    // 循环读取文件的内容
    for {
        line, err := reader.ReadString('\n') // 读到一个换行符就结束
        if err == io.EOF { // io.EOF表示文件的末尾
            break
        }
        // 输出内容
        fmt.Print(line)
    }
}
```
**法二：一次性读入，不适用于大文件**

```
import (
    "fmt"
    "io/ioutil"
)

func main() {
    // 使用 io/ioutil.ReadFile 方法一次性将文件读取到内存中
    filePath := "e:/.txt"
    content, err := ioutil.ReadFile(filePath)
    if err != nil {
        // log.Fatal(err)
        fmt.Printf("读取文件出错：%v", err)
    }
    fmt.Printf("%v\n", content)
    fmt.Printf("%v\n", string(content))
}
```
### 写文件
示例1：
创建一个新文件，写入3行："Hello World"
打开一个存在的文件，将原来的内容覆盖成新的内容，3行："你好，世界"
打开一个存在的文件，在原来的内容基础上，追加3行："你好，Golang"
打开一个存在的文件，将原来的内容读出显示在终端，并且追加3行："你好，World"

```
import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    filePath := "e:/a.txt" // 此文件事先不存在
    file, err := os.OpenFile(filePath, os.O_WRONLY | os.O_CREATE, 0666) // O_CREATE 能创建文件
    if err != nil {
        fmt.Printf("打开文件出错：%v", err)
        return
    }
    // 及时关闭文件句柄
    defer file.Close()
    // 准备写入的内容
    str := "Hello World\r\n"
    // 写入时，使用带缓冲方式的 bufio.NewWriter(w io.Writer) *Writer
    writer := bufio.NewWriter(file)
    // 使用for循环写入内容
    for i := 0; i < 3; i++ {
        _, err := writer.WriteString(str) // func (b *Writer) WriteString(s string) (int, error)
        if err != nil {
            fmt.Printf("文件写入出错：%s", err)
        }
    }
    // 因为 writer 是带缓存的，所以需要 Flush 方法将缓冲中的数据真正写入到文件中
    _ = writer.Flush()
}


```
将 O_CREATE 修改为 O_TRUNC 模式即可，表示：打开文件并清空内容
将 O_TRUNC 修改为 O_APPEND 模式即可，表示：打开文件并在最后追加内容

```
import (
    "bufio"
    "fmt"
    "io"
    "os"
)

func main() {
    filePath := "e:/a.txt"
    file, err := os.OpenFile(filePath, os.O_RDWR | os.O_APPEND, 0666)
    if err != nil {
        fmt.Printf("打开文件出错：%v", err)
        return
    }
    defer file.Close()

    // 先读取原来文件的内容，并显示在终端
    reader := bufio.NewReader(file)
    for {
        str, err := reader.ReadString('\n') // 读到一个换行符就结束
        if err == io.EOF { // io.EOF表示文件的末尾
            break
        }
        // 输出内容
        fmt.Print(str)
    }

    // 准备写入的内容
    str := "你好，World\r\n"
    // 写入时，使用带缓冲方式的 bufio.NewWriter(w io.Writer) *Writer
    writer := bufio.NewWriter(file)
    // 使用for循环写入内容
    for i := 0; i < 3; i++ {
        _, err := writer.WriteString(str) // func (b *Writer) WriteString(s string) (int, error)
        if err != nil {
            fmt.Printf("文件写入出错：%s", err)
        }
    }
    // 因为 writer 是带缓存的，所以需要 Flush 方法将缓冲中的数据真正写入到文件中
    _ = writer.Flush()
}

4：读写模式（O_RDWR）
```
示例二：将一个文件写道另一个文件（两个文件均存在）

```
import (
    "fmt"
    "io/ioutil"
)

func main() {
    filePath1 := "e:/a.txt"
    filePath2 := "e:/b.txt"
    content, err := ioutil.ReadFile(filePath1)
    if err != nil {
        fmt.Printf("读取文件出错：%v", err)
        return
    }
    err = ioutil.WriteFile(filePath2, content, 0666)
    if err != nil {
        fmt.Printf("写入文件出错：%v", err)
        return
    }
}
```

### 判断文件是否存在
golang判断文件或文件夹是否存在的方法为使用 os.Stat() 函数返回的错误值进行判断：

如果返回的错误为 nil，说明文件或文件夹存在；
如果返回的错误类型使用 os.IsNotExist() 判断为 true，说明文件或文件夹不存在；
如果返回的错误为其他类型，则不确定是否存在。

```
package main

import (
    "fmt"
    "os"
)

// 判断文件或文件夹是否存在
func PathExist(path string) (bool, error) {
    _, err := os.Stat(path)
    if err == nil {
        return true, nil
    }
    if os.IsNotExist(err) {
        return false, nil
    }
    return false, err
}

func main() {
    filePath := "e:/a.txt"
    flag, err := PathExist(filePath)
    if err != nil {
        fmt.Println(err)
    }
    fmt.Println(flag) // true
}

```

### 拷贝文件
将src的数据拷贝到dst，直到在src上到达EOF或发生错误。返回拷贝的字节数和遇到的第一个错误。

对成功的调用，返回值err为nil而非EOF，因为Copy定义为从src读取直到EOF，它不会将读取到EOF视为应报告的错误。如果src实现了WriterTo接口，本函数会调用src.WriteTo(dst)进行拷贝；否则如果dst实现了ReaderFrom接口，本函数会调用dst.ReadFrom(src)进行拷贝。
```
package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
)

// 将 srcFilePath 拷贝到 dstFilePath
func CopyFile(dstFilePath string, srcFilePath string) (written int64, err error) {
    // 打开srcFilePath
    srcFile, err := os.Open(srcFilePath)
    if err != nil {
        fmt.Printf("打开文件出错：%s\n", err)
        return
    }
    defer srcFile.Close()
    // 通过 bufio/NewReader，传入 srcFile，获取到 reader
    reader := bufio.NewReader(srcFile)
    // 打开dstFilePath
    dstFile, err := os.OpenFile(dstFilePath, os.O_WRONLY | os.O_CREATE, 0666)
    if err != nil {
        fmt.Printf("打开文件出错：%s\n", err)
        return
    }
    defer dstFile.Close()
    // 通过 bufio/NewWriter，传入 dstFile，获取到 writer
    writer := bufio.NewWriter(dstFile)
    return io.Copy(writer, reader)
}

func main() {
    srcFilePath := "e:/a.mp4"
    dstFilePath := "f:/b.mp4"
    _, err := CopyFile(dstFilePath, srcFilePath)
    if err != nil {
        fmt.Printf("拷贝文件出错：%s", err)
    }
    fmt.Println("拷贝文件完成")
}

自己写一个函数完成拷贝文件
```
### 遍历目录

```
package main

import (
    "fmt"
    "os"
)

func main() {
    fmt.Println("请输入一个目录的路径：")
    var path string
    _, _ = fmt.Scan(&path)
    // 打开目录
    f, err := os.OpenFile(path, os.O_RDONLY, os.ModeDir)
    if err != nil {
        fmt.Printf("Open file failed:%s.\n", err)
        return
    }
    defer f.Close()
    // 读取目录
    info, err := f.Readdir(-1) // -1 表示读取目录中所有目录项
    // 遍历返回的切片
    for _, fileInfo := range info {
        if fileInfo.IsDir() {
            fmt.Printf("%s是一个目录\n", fileInfo.Name())
        } else {
            fmt.Printf("%s是一个文件\n", fileInfo.Name())
        }
    }
}
```

### 其它
统计一个文件中含有的英文、数字、空格以及其他字符数量。

```
package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
)

// 定义一个结构体，用于保存统计结果
type CharCount struct {
    AlphaCount     int // 记录英文个数
    NumCount     int // 记录数字的个数
    SpaceCount     int // 记录空格的个数
    OtherCount     int // 记录其它字符的个数
}

func main() {
    // 思路: 打开一个文件, 创一个 reader
    // 每读取一行，就去统计该行有多少个 英文、数字、空格和其他字符
    // 然后将结果保存到一个结构体
    filePath := "e:/a.txt"
    file, err := os.Open(filePath)
    if err != nil {
        fmt.Printf("打开文件出错：%s\n", err)
        return
    }
    defer file.Close()
    // 定义一个 CharCount 实例
    var count CharCount
    //创建一个Reader
    reader := bufio.NewReader(file)
    // 开始循环的读取文件的内容
    for {
        line, err := reader.ReadString('\n')
        if err == io.EOF { // 读到文件末尾就退出
            break
        }
        // 遍历每一行（line），进行统计
        for _, v := range line {
            switch {
                case v >= 'a' && v <= 'z':
                    fallthrough // 穿透
                case v >= 'A' && v <= 'Z':
                    count.AlphaCount++
                case v >= '0' && v <= '9':
                    count.NumCount++
                case v == ' ' || v == '\t':
                    count.SpaceCount++
                default :
                    count.OtherCount++
            }
        }
    }
    // 输出统计的结果看看是否正确
    fmt.Printf("字符的个数为：%v\n数字的个数为：%v\n空格的个数为：%v\n其它字符个数：%v\n",
        count.AlphaCount, count.NumCount, count.SpaceCount, count.OtherCount)
}
```
