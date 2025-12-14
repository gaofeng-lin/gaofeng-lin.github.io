---
title: Shell 命令
date: 2022/3/6
categories:
  - Linux
tags:
  - Linux
  - 运维
  - sed
abbrlink: 20005
---


## 实用/高效命令

守护进程命令：

nohup bash /root/CycleNet/scripts/rolling1.sh > app.log 2>&1 &

批量修改某个目录下面的文件名：

我想复制这个目录下所有的文件，并给新生成的文件按照统一规则命名文件名。比如给新生成的文件文件名后面加上"_fftv5.sh"

for file in *.sh; do cp "$file" "${file%.sh}_fftv5.sh"; done


## 基本知识/命令
### 变量赋值语句不能有空格
**1、shell脚本变量名和等号及等号和值之间不能有空格，这可能和我们熟悉的所有编程语言都不一样，变量命名须遵循如下规则：**
•首个字符必须为字母（a-z，A-Z）。
•中间不能有空格，可以使用下划线（_）。
•不能使用标点符号。
•不能使用bash里的关键字（可用help命令查看保留关键字）。

赋值语句等号两边不能有空格，中间有空格时，shell是把变量当一个命令执行的，如：

PROV = anhui

执行时会提示：./tt.sh: line 14: PROV: command not found

正确的写法是：

PROV=anhui

如果所赋的值包含空格，可以用引号括起来（没有空格时也可以用引号，效果和不用一样），例如：

PROV="anhui province"

**2、变量的引用是用$符号加上变量名，例如：**

echo  ../${PROV}/${DATDIR}

变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界，建议给所有变量加上花括号，这是个好习惯，既便于阅读，又不易出错。 

**最后想说明一下，shell脚本对空格有严格的规定，赋值语句等号两边不能有空格，而字符串比较，等号两边必须有空格，如：**

if [ "${sdpt}" = "sdpt_js" ]; then

### 将命令的输出结果赋值给变量
Shell 中有两种方式可以完成命令替换，一种是反引号` `，一种是$()，使用方法如下：

```typescript
variable=`commands`
variable=$(commands)
```
**但有种情况比较特殊**

```typescript
file_path="/home/yskj/phopt/work/2/100/209/Ma0.8395H0α3.06"

version_num=`echo ${file_path} | cut -d / -f 8`
```
version_num 那一行是一个字符串的分割，最终得到209，我想把这个值作为变量。
如果不加echo是会报错，因为单独运行，会去执行`${file_path}这条命令，因为后面是管道`，而加上echo，就是输出，是一个正常的命令。
最后相当于把输出的结果赋值给了version_num这个变量


### shell脚本中登录mysql,执行sql
**方式一：mysql -u root -pmysql <<EOF sql语句 EOF**
注：密码与-p之间不能有空格，否则不能识别密码，EOF中间的sql语句，与mysql正常语句无异

```bash
  1 #!/bin/bash
  2 echo "链接mysql"
  3 mysql -u root -pmysql <<EOF
  4 use shelltest;
  5 select * from student;
  6 EOF
  7 echo "连接成功"

```
执行结果：

```bash
python@ubuntu:~/shellscrip$ ./mys_connec.sh 
链接mysql
mysql: [Warning] Using a password on the command line interface can be insecure.
id	name
1	tom
连接成功
```
方式二：mysql -u root -pmysql -e “${sql}”

```bash
  1 #!/bin/bash
  2 echo "链接mysql"
  3 sql="use shelltest;
  4 select * from student;"
  5 mysql -u root -pmysql -e "${sql}"
  6 echo "连接成功"
```
执行结果：

```bash
python@ubuntu:~/shellscrip$ ./mys_connec.sh 
链接mysql
mysql: [Warning] Using a password on the command line interface can be insecure.
+------+------+
| id   | name |
+------+------+
|    1 | tom  |
+------+------+
连接成功
```


### 读取文件每一行并输出
方案一：

```bash
##!/bin/bash

while read line
do
    echo $line
done < test.txt
```
方案二：

```bash
##!/bin/bash

cat test.txt | while read line
do
    echo $line
done
```

方案三：

```bash
for line in `cat  test.txt`
do
    echo $line
done
```

for 逐行读和 while 逐行读是有区别的，如:

```bash
$ cat test.txt
Google
Runoob
Taobao

$ cat test.txt | while read line; do echo $line; done
Google
Runoob
Taobao


$ for line in $(<test.txt); do echo $line; done
Google
Runoob
Taobao
```

### if 与 for 循环
```
getfilesordir(){
    for file in `ls $1`
    do
        if test -f $file
        then
            echo "file:  $file"
        elif test -d $file
        then
            echo "path: $file"
        fi
    done
}
 
path="./"
getfilesordir $path
```

### 遍历文件夹
**遍历文件夹下所有文件，不包含子目录：**
```
getfilesordir(){
    for file in `ls $1`
    do
        if test -f $file
        then
            echo "file:  $file"
        elif test -d $file
        then
            echo "path: $file"
        fi
    done
}
 
path="./"
getfilesordir $path
```

**遍历文件夹下所有文件不包含子目录**
```
dir="/home/fut/Desktop/"
ls $dir | while read line
do
 
    file=${dir}${line}
    echo file
  fi
done
```

**遍历目录包含子目录**
```
##!/bin/bash
function getdir(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
            echo $dir_or_file
        fi  
    done
}
root_dir="/home/test"
getdir $root_dir
```
以下命令均不包含"."，".."目录，以及"."开头的隐藏文件，如需包含，ll 需要加上 -a参数#当前目录下文件个数，不包含子目录ll |grep "^-"|wc -l#当前目录下目录个数，不包含子目录ll |grep "^d"|wc -l#当前目录下文件个数，包含子目录ll -R|grep "^-"|wc -l#当前目录下目录个数，包含子目录ll -R|grep "^d"|wc -l

### 字符串与整数比较
```
##!/bin/sh
##字符串比较(比较大小以及是否相等)
a=hello
b=hello
c=how
if [[ "$a" == "$b" ]];then  #注意对于字符串的相等比较，使用=或==都可以，二者是等价的
	echo 'same'
else
	echo not same
fi

if [[ "$a"!="$c" ]];then
	echo "a!=c"
fi


if [[ "$a" < "$c" ]];then
	echo "a<c"
fi

##整数比较
a=1
b=2
if(($a<=$b));then
	echo "a<=b"
fi

if((a<=b));then
	echo "a<=b"
fi

## 整数运算
d=$(($a+$b))
echo $d

c=$((a+b))
echo $c

## 整数运算
c=$((a+b))
echo $c

##浮点数运算
a=1.223
b=2.3
c=$(echo $a+$b|bc)
echo $c
```

### 将shell命令的执行结果放入数组
```
arr=( `git branch | xargs` )
echo ${arr[@]}
```
### 自动填充密码
有时候执行一些命令会要求输入密码，但是比较麻烦，想把密码放在命令中。

**法一：**
```
echo "123" | sudo -S sntp -sS 182.92.12.11
```
**法二：**
```
sudo -S sntp -sS 182.92.12.11 << EOF 
123
EOF
```

注意点：
1. sudo -S不能少
2. 使用EOF要小心，最后一个EOF要贴紧，否则会报错


### ssh密钥登录并执行脚本
```
ssh -t username@ip -i C:/Users/76585/.ssh/phcloudYSKJ "/home/yskj/lgf/cfdplatform/change_cfdplatform.sh"
```
1. usernam和ip要换成实际的
2. -i后面的是本地的密钥文件全路径

### scp加速传输与下载
本地传输至服务器：
```
scp -i "这是本地密钥全路径" -c aes192-cbc -o "Compression yes" "本地要上传的东西的全路径" username@ip:"上传到服务器那个位置"
```
1. 上述目录引号里面的内容换位实际的后，不要引号。关键在于 -c aes192-cbc -o "Compression yes" 。-c后面的是压缩算法，自己也是试了几个选了个最快的。可以google搜索下scp下载慢

服务下载至本地：
上面命令把username@ip:xxx与本地路径交换即可。
```
scp -i C:/Users/76585/.ssh/phcloudYSKJ -c aes192-cbc username@ip:/home/yskj/phserver/cfdplatform.log C:/Users/76585/Desktop
```


### 判断上一条命令是否执行成功
```
##!/bin/bash
CGO_ENABLED=0 GOOS=GOARCH=amd64 go buicfdplatform main.go 
if [[ $? -eq $'\n' ]]; then
	echo "编译成功"
else
	echo "编译失败"
    exit 1
fi
```

##  实际命令分析

### shell脚本登录mysql并执行语句

```bash
##!/bin/bash

## get 7 days ago according to input date. e.g. if input date is 20180410,it will delete those records on or before 20180403
wanted_date=`date -d "$1 7 days ago" +%Y%m%d`

echo "0==}=========> CAUTION! Those records on or before $wanted_date will be removed!"
echo "0==}=========> Are you sure to continue? yes/no"
read option
if [ "$option" == "yes" ]; then
  echo You made a good choice.
  echo ----------
elif [ "$option" == "no" ];then
  echo Goodbye~
  exit 0
else
  echo PLASE INPUT yes OR no THEN TRY AGAIN!
  exit 0
fi

## to call SQL statement at MySQL prompt
mysql -h 172.33.101.123 -P 3306 -u tony -pYourPassword -D YourDbName <<EOF
select current_date();
use tony_db;
desc confirmed_order_data;
select count(*) from confirmed_order_data where paid_date<="$wanted_date";
delete from confirmed_order_data WHERE paid_date<="$wanted_date";
select count(*) from confirmed_order_data where paid_date<="$wanted_date";

EOF
```

### 提取git中某个文件的所有版本并按顺序命名

```
git log --follow --pretty=format:%H 文件名 | xargs -I{} sh -c 'git show {}:文件名 > 文件名.{}'
```
简略解释版本：

```
git log --follow --pretty=format:%H 
//按照一定的格式输出 ，--pretty=format:%H 输出某个文件的历史提交哈希值。
//如果不加--pretty=format:%H，会输出哈希值，作者，时间等信息。
//--pretty=format后面还可以跟其它值，
//'%H': commit hash
//'%h':abbreviated commit hash
//'%T': tree hash



| xargs -I{} 

//xargs 一般是和管道(I)一起使用
 //-I{} //xargs 的一个选项 -I，使用 -I 指定一个替换字符串 {}，这个字符串在 xargs 扩展时会被替换掉；对应这里，前面输出的是哈希值，这里面"{}"代表的就是哈希值，后面的"{}"也是前面的哈希值。

sh -c 
//暂时不清，下面有解释

git show {}:文件名 > 文件名.{} 
 //git show '哈希值':文件名：输出这次提交，这个文件夹的内容， ">" 将内容输出到 后面的文件中，并覆盖后面文件内容。
```



> 2. | xargs -I{} sh c

```
|  //表示管道，上一条命令的输出，作为下一条命令参数，如 echo ‘yes’ | wc -l

xargs -I //


```

```
sh -c

Linux使用 echo 并配合命令重定向是实现向文件中写入信息的快捷方式。
【新建空文件】
方式一 : $ touch test.sh
方式二 : $ echo “” > test.sh
【写内容到文件】
如 test.sh 文件中内容：
$ echo “信息” > test.sh

但有时会出现权限不够的问题，这时就可以使用 sh -c

利用 “sh -c” 命令，它可以让 bash 将一个字串作为完整的命令来执行，这样就可以将 sudo 的影响范围扩展到整条命令。具体用法如下：
$ sudo sh -c ‘echo “第二条内容” >> test.sh’

```

### 给每一个远程分支在本地建立单独的文件夹，文件名就是分支名  

```bash
git branch -r | xargs -d/ -n1 | grep -v 'origin' | xargs -I{} sh -c 'mkdir "C:\Users\76585\Desktop\try\{}" '
```


分析：

```
1.  git branch -r //显示远程分支。注意，本地分支可能只有一个，master这种。但远程分支可能有很多个。
```

```
2. | xargs -d/ -n1 // -d -n都是xargs的参数，详细可以去查文档。-d/  以"/"为分隔符；-n1，每行输出一个。
```

```
3. grep -v 'origin' // 遇到origin就不显示（删除这个字符串）。
```

冷知识：在Windows下运行sh文件，在当前路径下，`./`;
如果是非当前路径，`c/xx/xxx/1.sh  //绝对路径到sh文件就好，前面不用加./` 


### 按提交信息来过滤提交 --grep 
按提交信息来过滤提交，你可以使用--grep标记。它和上面的--author标记差不多，只不过它搜索的是提交信息而不是作者。

背景：提取主干某文件的提交，因为主干都是其它author合并上去的，所有没有主干这个author，无法使用--author这个参数来过滤。但是每次合并到主干的commit 都有一句 "into avtivebranch"，根据这一句筛选即可。


例子：
```
git log --grep="JRA-224:" 
//也可以传入-i参数来忽略大小写匹配
```

### 获取for循环中按条件筛选出的变量值
**将这个功能写成一个函数，函数内部用echo输出这个值，外部用一个变量接受这个值。**

```bash
##!/bin/bash

function func(){
cat cfd.log | while read line
do

    OLD_IFS="$IFS"
    IFS=" "
    array=($line)
    IFS="$OLD_IFS"
    if [ "${array[0]}" = "cfdversion" ] ; then
       echo ${array[2]}
       break
    fi

done
}

res=$(func)

echo $res
```

### whlie循环菜单
```
#!/bin/bash

while :
do
    echo "--------------------cfdplatform------------------"
    echo '输入 1 到 4 之间的数字:'
    echo '1: 编译'
    echo '2: 编译 + 传输'
    echo '3: 传输'
    echo '4: 下载日志到本地'
    echo '5: 执行远程脚本'
    echo '6: 退出'
    echo '你输入的数字为:'
    read aNum

    case $aNum in
        1)  
            echo '你选择了 "编译"'
            ;;
        2)  
            echo '你选择了 "编译 + 传输"'
            ;;
        3)  
            echo '你选择了 "传输"'
            ;;
        4)  
            echo '你选择了 "下载日志到本地"'
            ;;
        5)  
            echo '你选择了 "执行远程脚本"'
            ;;
        6)  
            echo '你选择了 "退出"'
            exit 1
            ;;
        *)  
            echo '你没有输入 1 到 5 之间的数字，请重新输入'
            ;;
    esac
    echo -e "\n"
done
```

##  代码分析
###  读取文件夹中的文件名，并存入列表

```
##!/bin/bash
##读取文件夹中的文件名，并存入列表

i=0
for dir in $(ls 'C:\Users\76585\Desktop\cfdname1')
do
    
    # echo $dir >> arr[$i]
    arr[$i]=$dir
    i=$(($i+1))
done

echo "${arr[@]}"
```

**注意的点：**

```
1.for 循环循环体只能卸载do done之间，之前把 i 写在了for 和 do之间报错

2.变量初始化不要放在函数体，不然每次循环都清 0 了。

3.变量自增加方法：
a=\$(($a+1))

a=$[$a+1]

a=\`expr $a + 1`

let a++

let a+=1

((a++))

4.打印数组的方法：${my_array[*]} 或者 ${my_array[@]}
```

##  字符串处理

###  获取变量字符串长度
想要知道 "www.baidu.com" 的变量net的长度十分简单。


```
[Neptuneyt]$ net="www.baidu.com"
[Neptuneyt]$ echo ${#net}
13
```
当然，在Shell中获取字符串变量的长度的方法有许多种，但是下图法一作为一种系统内建的方法是最快的。

```
[Neptuneyt]$ echo ${#net}
13
[Neptuneyt]$ echo ${net}|wc -L
13
[Neptuneyt]$ expr length ${net}
13
[Neptuneyt]$ echo ${net}|awk '{print length($0)}'
13
```


###  变量截取

**1.指定位置截取字符串**

```
[Neptuneyt]$ net="www.baidu.com"
[Neptuneyt]$ # 从第4个字符截取到baidu
[Neptuneyt]$ echo ${net:4:5} #从第4个字符.开始截取5个字符
baidu
[Neptuneyt]$ # 截取baidu.com
[Neptuneyt]$ echo ${net:4}   #起始位置后不接截取字符长度则默认截取之后所有的
baidu.com
[Neptuneyt]$ # 用倒数截取com
[Neptuneyt]$ echo ${net:0-3} #从倒数第三个字符截取到末尾
com
[Neptuneyt]$ echo ${net: -3} #另外的写法，一定要注意冒号和-3之间有空格
com
[Neptuneyt]$ echo ${net:-3}  #不加空格，截取失败
www.baidu.com
```

**2.匹配字符串截取**

```
[Neptuneyt]$ echo $net
www.baidu.com

## 删除匹配字符串的左边，留下剩余部分
[Neptuneyt]$ echo ${net#*.} #这里用*.表示匹配到www.，用一个#表示删除匹配到的字符串，留下剩余的部分
baidu.com

## 用2个#号表示尽可能多的删除匹配到的字符串
[Neptuneyt]$ echo ${net##*.}
com

## 同理也可以匹配字符串的右边，留下剩余部分
[Neptuneyt]$ echo ${net%.*} #用.*匹配到.com,用%删除
www.baidu

## 用2个%号表示尽可能多的删除匹配到的字符串
[Neptuneyt]$ echo ${net%%.*}    #因为2个%，这里.*表示匹配到最长的.baidu.com
```
总的来说:
`#*chr`表示删除从左到右第一个遇到的字符chr及其左侧的字符
`##*chr`表示删除从左到右最后一个遇到的字符chr及其左侧的字符（贪婪模式）
`%chr*`表示删除从右向左第一个遇到的字符chr及其右侧的字符
`%%chr*`表示删除从右到左最后一个遇到的字符chr及其右侧的字符（贪婪模式）
在键盘上，#在$符的左边，%号在$符的右边，为了便于记忆，大家因此可以记住#删除左边字符，%删除右边字符

**3.窃取字符串**

```typescript
1.cut

-b ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 -n 标志。
-c ：以字符为单位进行分割。

-d：自定义分隔符，默认为制表符。

-f：与-d一起使用，指定显示哪个区域。

-n：取消分割多字节字符。仅和-b标志一起使用。如果字符的最后一个字节落在由-b标志的List参数指示的范围之内，该字符将被写出；否则，该字符将被排除。
```



**-d**

 cut命令用于列提取，默认分隔符是tab键。

选项：-d指定分隔符，-f指定提取第几列

eg1： 以%作为分隔符 输出第一个%前的区域1的东西，输出区域2的东西     

```typescript
root@ROUTER:~# echo "CPU:  busy 14%  (system=10% user=3% nice=0% idle=85%)" | cut -d \% -f 1
CPU:  busy 14
root@ROUTER:~# echo "CPU:  busy 14%  (system=10% user=3% nice=0% idle=85%)" | cut -d \% -f 2
  (system=10
root@ROUTER:~# echo "CPU:  busy 14%  (system=10% user=3% nice=0% idle=85%)" | cut -b 11-14 | cut -d \% -f 1
 14
root@ROUTER:~# echo "CPU:  busy 14%  (system=10% user=3% nice=0% idle=85%)" | cut -b 11-14 
 14%

```

**-b**
.eg1：然后调用cut，即剪切字符串中的第2和第5个字节。

```typescript
echo"123abc"|cut -b 2,5
```

先输出123abc

输出为2b

**-c**

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151027.png)



###  变量的字符串替换
想要将net的 baidu替换成google怎么写呢？只需`${net/baidu/google}`即可，需要注意的是原变量并未修改

```
[Neptuneyt]$ echo ${net/baidu/google} #/匹配字符/替换字符
www.google.com
[Neptuneyt]$ echo $net  #原变量并未修改
www.baidu.com
```
如果是替换所有匹配到的字符，应该通过`${variable//pattern/sub}`
例如将net的.替换为-或/：

```
[Neptuneyt]$ echo ${net//./-}
www-baidu-com
[Neptuneyt]$ echo ${net//.//}
www/baidu/com
```

除此之外，还有两种专门针对字符串开头和结尾的替换方式
只替换开头匹配的字符串`${variable/#pattern/sub}`
只替换结尾匹配的字符串`${variable/%pattern/sub}`
例如对于`add=www.xiaomi.com.www`的开头或者结尾的`www`替换为`-`：

```
[Neptuneyt]$ add=www.xiaomi.com.www
[Neptuneyt]$ echo ${add/#www/-}
-.xiaomi.com.www
[Neptuneyt]$ echo ${add/%www/-}
www.xiaomi.com.-
```

###  删除字符串

其实学会了替换字符串删除字符串就更简单了，只需将替换部分写成空即可，即`${variable/pattern/null}`，例如将net的第一个.删除，只需

```
[Neptuneyt]$ echo ${net/./}
wwwbaidu.com
[Neptuneyt]$ echo ${net/.}  #最后一个/可以不用写
wwwbaidu.com
```

若要删除所有匹配到的只需即`${variable//pattern}`，例如将`net`的.都删除，只需

```
[Neptuneyt]$ echo ${net//.}
wwwbaiducom
```
###  变量为空时赋默认值
当我们在写脚本时往往需要给脚本传递一些参数，在Shell中传递参数十分简单，只需利用特殊的位置参数变量诸如`$1,$2,$3...${10}...`即可，例如，以下脚本传递2个参数：

```
## PassArgument.sh
##!/bin/env bash
## pass 2 arguments
arg1=$1
arg2=$2
echo $arg1 $arg2

[Neptuneyt]$ bash PassArgument.sh Hello word #参数以空格隔开
Hello word
```
有时候，我们想省掉最后一个参数，让它使用默认值，这个时候只需通过`${variable:='default value'}`即可，即当变量有值的时候则使用原值，若没有值则使用括号中默认定义好的值。例如，如下脚本表示当第二个参数为空时默认使用定义好的值“word”,否则是用户自己传递的参数：

```
## PassArgument.sh
##!/bin/env bash
arg1=$1
arg2=$2
echo $arg1 ${arg2:='word'}  #第二个参数设置默认值

[Neptuneyt]$ bash PassArgument.sh Hello #第二个参数为空时使用默认值
Hello word
[Neptuneyt]$ bash PassArgument.sh Hello Shell   #第二个参数不为空时使用参数传递的值
Hello Shell
```
除了`${variable:='default value'}`外，还有`${variable:-'default value'}`,`${variable:+'default value'}`和`${variable:？'default value'}`，它们有什么区别呢？
对于`${variable:='default value'}`，表示变量为空时把默认值赋值给该变量，例如：

```
[Neptuneyt]$ net=
[Neptuneyt]$ echo ${net:='www.baidu.com'}
www.baidu.com
[Neptuneyt]$ echo $net
www.baidu.com
```
对于`${variable:-'default value'}`,表示变量为空时返回默认值**但是并不把默认值赋值给该变量**， 例如：

```
[Neptuneyt]$ net=
[Neptuneyt]$ echo ${net:-'www.baidu.com'}
www.baidu.com
[Neptuneyt]$ echo $net  #此时，变量依旧为空
```

对于`${variable:+'default value'}`,则表示变量不为空时，返回默认值，并且也不重新赋值，例如：

```
[Neptuneyt]$ net=www.baidu.com
[Neptuneyt]$ echo ${net:+'www.google.com'}
www.google.com
[Neptuneyt]$ echo $net  #不改变变量原值
www.baidu.com
```
最后，对于`${variable:？'default value'}`,则表示当变量为空时，使用bash风格的报错，例如：

```
[Neptuneyt]$ net=
[Neptuneyt]$ echo ${net:?'error:null value'}
-bash: net: error:null value
```

### 字符串拼接
在 PHP 中，使用.即可连接两个字符串；
在 JavaScript 中，使用+即可将两个字符串合并为一个。
在 Shell 中你不需要使用任何运算符，将两个字符串并排放在一起就能实现拼接，非常简单粗暴。请看下面的例子：

```
##!/bin/bash
name="Shell"
url="http://c.biancheng.net/shell/"
str1=$name$url  #中间不能有空格
str2="$name $url"  #如果被双引号包围，那么中间可以有空格
str3=$name": "$url  #中间可以出现别的字符串
str4="$name: $url"  #这样写也可以
str5="${name}Script: ${url}index.html"  #这个时候需要给变量名加上大括号
echo $str1
echo $str2
echo $str3
echo $str4
echo $str5
```

```
运行结果：
Shellhttp://c.biancheng.net/shell/
Shell http://c.biancheng.net/shell/
Shell: http://c.biancheng.net/shell/
Shell: http://c.biancheng.net/shell/
ShellScript: http://c.biancheng.net/shell/index.html
```
对于第 7 行代码，$name 和 $url 之间之所以不能出现空格，是因为当字符串不被任何一种引号包围时，遇到空格就认为字符串结束了，空格后边的内容会作为其他变量或者命令解析，这一点在《Shell字符串》中已经提到。

对于第 10 行代码，加{ }是为了帮助解释器识别变量的边界，这一点在《Shell变量》中已经提到。


### 单引号内引入变量
**方法：单引号内嵌套单引号即可使用变量**

```
##!/bin/bash

i=10
echo $i
echo '$i'
echo '$i is : '$i''

执行结果

## ./test.sh 
10
$i
$i is : 10
```


### shell中判断两个字符串相等

```
##! /bin/bash

read -p "If you want to clean the trash?(y/n):" select
str=y

if [ "$select" = "y" ]
then
    rm -fr $HOME/.local/share/Trash/files/*
    echo "Deleted successfully!"
else
    echo "Undelete!"
fi
```


**注意的几点：**
**1、if和[ ]之间要空格。**

**2、[ ]和“ ”之间要空格**

**3、“ ”和=之间要空格，**
 


### 实战：统计文章单词情况
这里想要统计Martin Luther King在1963年著名的**I have a dream**演讲中都使用了哪些词，哪些是高频词，单词字长如何。
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151123.png)
思路：
高频词统计：将所有单词单行输出，删除空行，删除`,./?`等非字母符号，用sort排序后使用uniq统计即可。
字长频数统计：将所有单词单行输出，删除空行，删除`,./?`等非字母符号，使用while循环遍历每个单词，使用
```
${#variable} //统计单词长读频数。
```

```
## 高频词统计
echo "高频词统计："
echo "频数" "单词"
tr " " "\n" <IHaveADream.txt | \
##使用tr将空格转换成换行符，使得每行一个单词，\续行符表示一行命令未写完可换行书写，切记其后什么字符也不能接，包括空格和注释
sed -e "/[^a-Z]/d;/^$/d" | \
##使用sed匹配非字母字符和空行并删除：-e 表示执行多个操作； /[^a-Z]/，双斜线//表示匹配部分，^表示匹配除开后面a-Z的所有字符，d表示对前面匹配部分删除；/^$/表示匹配空行，^、$分别表示行首和行尾
sort |uniq -c |    \
##排序之后使用uniq统计，-c表示统计单词出现的次数
sort -nr | column -t|head #将次数最多的单词排在前面，-n表示按数值排序，-r从大到小倒序排，column -t表格式输出

## 字长频数统计
echo
echo "字长频数统计："
echo "频数" "单词长度"
tr " " "\n" <IHaveADream.txt | \
sed -e "/[^a-Z]/d;/^$/d" | \
while read word
do
  echo ${#word}
done |\
## 用while和read每次读入一个单词，使用${#word}统计单词长度
sort |uniq -c|sort -nr|column -t|head
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151139.png)


## 字符串切割
将用到字符串切割，即将字符串切割为一个数组
[原文链接](https://blog.csdn.net/u010003835/article/details/80750003?spm=1001.2101.3001.6650.5&depth_1-utm_relevant_index=10)
### 利用shell 中 变量 的字符串替换
原理：

```bash
${parameter//pattern/string} 
```

用string来替换parameter变量中所有匹配的pattern

```bash
##!/bin/bash
 
string="hello,shell,split,test"  
array=(${string//,/ })  
 
for var in ${array[@]}
do
   echo $var
done 
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151159.png)
### 设置分隔符，通过 IFS 变量
原理

自定义IFS变量, 改变分隔符, 对字符串进行切分

IFS介绍
 Shell 脚本中有个变量叫 IFS(Internal Field Seprator) ，内部域分隔符。完整定义是The shell uses the value stored in IFS, which is the space, tab, and newline characters by default, to delimit words for the read and set commands, when parsing output from command substitution, and when performing variable substitution.

     Shell 的环境变量分为 set, env 两种，其中 set 变量可以通过 export 工具导入到 env 变量中。其中，set 是显示设置shell变量，仅在本 shell 中有效；env 是显示设置用户环境变量 ，仅在当前会话中有效。换句话说，set 变量里包含了 env 变量，但 set 变量不一定都是 env 变量。这两种变量不同之处在于变量的作用域不同。显然，env 变量的作用域要大些，它可以在 subshell 中使用。

     而 IFS 是一种 set 变量，当 shell 处理"命令替换"和"参数替换"时，shell 根据 IFS 的值，默认是 space, tab, newline 来拆解读入的变量，然后对特殊字符进行处理，最后重新组合赋值给该变量。

IFS 简单实例

1、查看变量 IFS 的值。

```bash
$ echo $IFS  
  
$ echo "$IFS" | od -b  
0000000 040 011 012 012  
0000004  
```

直接输出IFS是看不到的，把它转化为二进制就可以看到了，"040"是空格，"011"是Tab，"012"是换行符"\n" 。最后一个 012 是因为 echo 默认是会换行的。


**示例：**

```bash
##!/bin/bash
 
string="hello,shell,split,test"  
 
##对IFS变量 进行替换处理
OLD_IFS="$IFS"
IFS=","
array=($string)
IFS="$OLD_IFS"
 
for var in ${array[@]}
do
   echo $var
done
```
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151216.png)

### 利用tr 指令实现字符替换
详细内容可自行查看


## sed


## sed脚本命令
[原文链接](http://c.biancheng.net/view/4028.html)
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151235.png)
###  sed s 替换脚本命令
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151254.png)
### sed d 替换脚本命令
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151312.png)
### sed a 和 i 脚本命令 （插入）
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151328.png)
### sed c 替换

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151344.png)

### sed y 转换
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151402.png)
### sed w 文本指定内容写入文件
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151419.png)
### sed p 搜索符号条件的行，并输出该行的内容
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151435.png)
### sed r 将一个独立文件的数据插入到当前数据流的指定位置
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151451.png)
### sed q 使 sed 命令在第一次匹配任务结束后，退出 sed 程序，不再进行对后续数据的处理
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151508.png)
## sed address 寻址方式
![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img/20230522151525.png)
