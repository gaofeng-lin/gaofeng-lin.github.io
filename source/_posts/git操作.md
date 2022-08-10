---
title: git操作
date: 2022/1/14
update: 2022/1/16
categories:
  - git
tags:
  - git
  - Linux
  - 运维
  - 代码管理
abbrlink: 3828
---



## config相关命令
###  查看配置信息
 1. 查看系统config

```
 git config --system --list
```

 2. 查看当前用户（global）配置


```
git config --global  --list
```

 3. 查看当前仓库配置信息



```
git config -- local    --list
```

###  设置/修改配置信息
设置用户名：

```
git config --global user.name "github用户名"
```

设置邮箱

```
git config --global user.email "github注册邮箱"
```
##  查看提交记录+commit相关操作
###  查看指定文件的历史提交记录
```
git log -- <file>  //主要，这个文件要在当前目录才能直接输文件名，否则要给出路径
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/b1dc02f3dc8d4c888f7d98443524a64f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)

###  查看每次提交的内容差异

```
git log -p -2 -- <file>
```

> 参数：-p 表示每次提交的内容差异，-2 则表示显示最近的两次更新。
> 
> 说明：该选项除了显示基本信息之外，还在附带了每次 commit 的变化。

![在这里插入图片描述](https://img-blog.csdnimg.cn/381402cab6344a00b05b3a42fe128a60.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
###  根据哈希值查看修改代码细节

```
git show 哈希值
```

```
git show 哈希值 文件名 //具体某个文件的变化
```

### 根据分支或用户查看提交信息
```
git log 分支名

git log --authot='用户名'
//这两个命令可以通过 | xargs  与 git show搭配用

```

###  单词层面上的对比

```
git log --word-diff -- <file>
```

> 参数：--word-diff 表示获取单词层面上的对比。

> 说明：进行单词层面的对比常常是没什么用的。不过当你需要在书籍、论文这种很大的文本文件上进行对比的时候，这个功能就显出用武之地了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/dbf8557886aa4e16905b75a0fc368c29.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
**提示：新增加的单词被 {+ +} 括起来，被删除的单词被 [- -] 括起来。**

###  图形化查看提交历史

```
gitk -- <file>
```

> 说明：随 Git 一同发布的 gitk 就是这样一种工具。它是用 Tcl/Tk 写成的，基本上相当于 git log 命令的可视化版本，凡是
> git log 可以用的选项也都能用在 gitk 上。

![在这里插入图片描述](https://img-blog.csdnimg.cn/b981ba602f044894b93bf19d74116145.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
**

> gitk中文乱码问题

**
解决办法：
打开git的配置文件(根据自己安装的git目录，此处为安装在D盘)：D:\Program Files\Git\etc\gitconfig

在文件内追加以下内容：

```
[gui]
  encoding = utf-8
```

###  提取git中某个文件的所有版本并按顺序命名

```
git log --follow --pretty=format:%H 文件名 | xargs -I{} sh -c 'git show {}:文件名 > 文件名.{}'
```

**文件名需要进行替换，不可直接输入 文件名 三个字**

<br/>

**如果出现** 

> Did you menan '哈希值：路径' aka '哈希值：路径'

字眼的错误

给第二个文件名添加 `./`

###  git将远程分支按分支名在本地建立文件夹

```
git branch -r | xargs -d/ -n1 | grep -v 'origin' | xargs -I{} sh -c 'mkdir "C:\Users\76585\Desktop\try\{}" '
```

命令分线见 **博客--Linux Shell命令总结**


### 撤回git commit 操作
写完代码后，我们一般这样

git add .

git commit -m “msg”

执行完commit后，想撤回commit，怎么办？
1. 撤回操作

**git reset --soft HEAD^** 
（ps：如果控制台出现More?，则将命令改成 git reset --soft HEAD^^即可）

这样就成功的撤销了你的commit

注意，仅仅是撤回commit操作，您写的代码仍然保留。

**说一下个人理解：**
HEAD^的意思是上一个版本，也可以写成HEAD~1

如果你进行了2次commit，想都撤回，可以使用HEAD~2

2. 参数：
**--mixed**
意思是：不删除工作空间改动代码，撤销commit，并且撤销git add . 操作
这个为默认参数,git reset --mixed HEAD^ 和 git reset HEAD^ 效果是一样的。

**--soft**
不删除工作空间改动代码，撤销commit，不撤销git add .

**--hard**
删除工作空间改动代码，撤销commit，撤销git add .

注意完成这个操作后，就恢复到了上一次的commit状态。



3. 修改注释

顺便说一下，如果commit注释写错了，只是想改一下注释，只需要：
git commit --amend

此时会进入默认vim编辑器，修改注释完毕后保存就好了。

### 比较两个分支的commit
比如我们有 2 个分支：master, dev，现在想查看这两个 branch 的区别，有以下几种方式：
1. 查看 dev 有，而 master 中没有的
```
git log dev ^master
```

查看 master 中有，而 dev 中没有的内容:
```
git log master ^dev
```

2. 查看 dev 中比 master 中多提交了哪些内容
```
git log master..dev
```

3. 不管谁提交的多谁提交的少，单纯想知道有什么不一样

```
git log dev...master
```

4. 在上述情况下，再显示出每个提交是在哪个分支上：

```
git log --left-right dev...master
```


## 分支操作


###  分支的使用

**mster代表主分支，最终的代码都整合到这里面去，我们可以看下**
![在这里插入图片描述](https://img-blog.csdnimg.cn/fcc0d993653e42e7a48a10d25328f11e.png)

**这里只有一个主分支master。
有一种情况就是，一个项目多人开发，我的任务需要开发一个功能，我没办法短时间内就开发测试等等一系列完成。所以我可以新建一个分支，然后把每次完成的代码都上传到这个分支里面去，最后等到所有操作都完成后，我再把这个分支整合到master中去。下面看步骤**

1.首先查看当前分支

```
git branch -a
```

-a代表查看本地和远程的分支，此时我们看到都只有一个master分支
![在这里插入图片描述](https://img-blog.csdnimg.cn/8e219832c5df4eef8c7da9dce7cd1829.png)


2.新建分支dev

```
git checkout -b dev
```
**执行该命令，会在本地创建一个新分支。该分支是从当前分支上生成的，所有内容和当前分支一样。**

-b代表同时切换到dev分支下面去，这时你可以再去查看分支

3.然后我们重新写一个b.js文件，再执行add，commit，最后push

```
git add b.js

git commit -m "dev"

git push origin dev
```


**注意push时要到dev分支**

成功后我们去coding看已经有了dev，并且dev下有b.js，而master没有b.js
![在这里插入图片描述](https://img-blog.csdnimg.cn/ca05925c026f48d4af3cc08ced1632da.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_12,color_FFFFFF,t_70,g_se,x_16)


master：
![在这里插入图片描述](https://img-blog.csdnimg.cn/abc1cba6a233436a8a4731ec90324646.png)


我们可以再去看看分支情况，

git branch -a
![在这里插入图片描述](https://img-blog.csdnimg.cn/5323471b84664e88b25f3f6228da4e74.png)


此时已经有了两个分支，且当前位于dev分之下
切换分支可以用 **git checkout [branch-name]**

### 将远程git仓库里的指定分支拉取到本地（本地不存在的分支）

```bash
git checkout -b
```
上述命令虽然能生成新分支，但是会复制当前分支。但有时从远程仓库拉取分支，我只想要远程那个分支，不想先复制别的，这样拉下来会有冲突。
方法如下：

```bash
git checkout -b 本地分支名 origin/远程分支名
```
这个将会自动创建一个新的本地分支，并与指定的远程分支关联起来。

如果出现提示：

```bash
fatal: Cannot update paths and switch to branch 'dev2' at the same time.
Did you intend to checkout 'origin/dev2' which can not be resolved as commit?
```

或者：
```
fatal: 'origin/xlh' is not a commit and a branch 'xlh' cannot be created from it

```
**git remote发现远程仓库的新分支没有显示出来，git fetch就好**


表示拉取不成功或远程仓库信息没有更新。我们需要先执行

```bash
git fetch
```
然后再执行

```bash
git checkout -b 本地分支名 origin/远程分支名
```

### 删除分支
**查看分支**

```
git branch -a //远程的是红色
```

**删除本地分支**

```
git branch -d <BranchName>
```
**删除远程分支**

```
git push origin --delete <BranchName>
```


###  整合分支
**当我们在dev下折腾完成后，最终要整合到master中去，看步骤**

1.切换本地分支到master

```
git checkout master
```


2.将远程仓库的最新代码pull下来！！因为期间其他人可能已经提交代码到远程master了，所以你首先得更新下自己本地的master代码

```
git pull origin master
```


假如有改动过，那么执行后会显示改动的信息

3.然后再把本地的dev代码整合到master，输入

```
git merge dev
```

merge整合操作，把dev整合到当前分之下（当前分支为master）。会提示增加了东西
![在这里插入图片描述](https://img-blog.csdnimg.cn/249f2d65516c483a9517f8ce5affb72f.png)


4.由于当前的东西已经在本地仓库里面了，所以最后我们再执行push，到远程仓库的master

```
git push origin master
```


成功后你可看到，master下已经有b.js文件了
![在这里插入图片描述](https://img-blog.csdnimg.cn/1f2c3d8b692b42619534a683d2c3f21a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_11,color_FFFFFF,t_70,g_se,x_16)



### 本地从远程仓库拉取代码，只在某分支开发
远程仓库有master，dev1两个分支。本地用git clone拉取代码，`git branch -a`查看，本地只有一个分支。此时用`git checkout dev1` 切换到dev1分支。代码和远程仓库一致。可以用`git log`来确认是否是该分支（因为git log 只能看到当前分支的提交记录）

### 合并分支--git merge应用的三种情况

[原链接](https://blog.csdn.net/qq_42780289/article/details/97945300?spm=1001.2101.3001.6650.2&depth_1-utm_relevant_index=5)

1. “快进”(无冲突)
![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly93czEuc2luYWltZy5jbi9sYXJnZS8wMDZWckpBSmd5MWc1ajRqMXFodjNqMzBrdzBiYmRmdy5qcGc)

**合并dev和master**
由于当前 master 分支所指向的提交是你当前提交（dev的提交）的直接上游，所以 Git 只是简单的将 master 指针向前移动。 换句话说，当你试图合并两个分支时，如果顺着一个分支走下去能够到达另一个分支，那么 Git 在合并两者的时候，只会简单的将指针向前推进（指针右移），因为这种情况下的合并操作没有需要解决的分歧——这就叫做 “快进（fast-forward）”。合并结果如下：
![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly93czEuc2luYWltZy5jbi9sYXJnZS8wMDZWckpBSmd5MWc1ajRyZms0NjFqMzBrcTBhYjN5ay5qcGc)

2. 非“快进”，修改不同文件。(无冲突)

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly93czEuc2luYWltZy5jbi9sYXJnZS8wMDZWckpBSmd5MWc1ajVsbXViOXhqMzBndjBhb2FhNS5qcGc)

在 master 分支和 dev 分支的公共祖先 B2 后，master 和 dev 的提交是对不同文件或者同一文件的不同部分进行了修改，Git 可以合并它们。（比如说原来有 test-1 和 test-2 两个文件，B4修改的是 test-1 文件，而B3修改的是 test-2 文件，然后合并两个分支。）

合并是成功的。

3. 非“快进”，修改相同文件。(有冲突)

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly93czEuc2luYWltZy5jbi9sYXJnZS8wMDZWckpBSmd5MWc1ajVsbXViOXhqMzBndjBhb2FhNS5qcGc)


在 master 分支和 dev 分支的公共祖先 B2 后，master 和 dev 的提交是对同一个文件的同一个部分进行了不同的修改，Git 就没法干净的合并它们。（比如说原来有 test-1 和 test-2 两个文件，B4修改的是 test-1 文件，而B3修改的也是 test-1 文件的同一部分，然后合并两个分支。）

**合并是失败的。**

此时 Git 做了合并，但是没有自动地创建一个新的合并提交。 Git 会暂停下来，等待你去解决合并产生的冲突。

### 分支改名

1. 修改本地分支名
```
git branch -m oldBranchName newBranchName
```

##  git 常用操作

###  git pull 与 git push 详解
1.git remote
```
git remote add origin url  //这里面的origin 是给远程仓库起名字，不是给本地仓库！
```

2.git pull
```
git pull 其实就是 git fetch 和 git merge FETCH_HEAD 的简写。 命令格式如下：

git pull <远程主机名> <远程分支名>:<本地分支名>
```

```
将远程主机 origin 的 master 分支拉取过来，与本地的 brantest 分支合并。

git pull origin master:brantest

如果远程分支是与当前分支合并，则冒号后面的部分可以省略。

git pull origin master
```


3.git push 
```
git push <远程主机名> <本地分支名>:<远程分支名>

如果本地分支名与远程分支名相同，则可以省略冒号：

git push <远程主机名> <本地分支名>

```

实例：
以下命令将本地的 master 分支推送到 origin 主机的 master 分支。

```
git push origin master

相等于：

git push origin master:master

如果本地版本与远程版本有差异，但又要强制推送可以使用 --force 参数：

git push --force origin master

删除主机的分支可以使用 --delete 参数，以下命令表示删除 origin 主机的 master 分支：

git push origin --delete master

```

###  将本地代码上传到远程仓库
1.（电脑里得先下载git）登录coding，新建一个仓库，点击代码浏览可以看到
![在这里插入图片描述](https://img-blog.csdnimg.cn/dfad51be62a440cd86b764c2e4f16487.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/7063830ad8194b8792977f5750a8d1d4.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6IiU54uXMeWPtw==,size_20,color_FFFFFF,t_70,g_se,x_16)
2.在本地新建一个文件夹，作为项目根目录，再此启动 Git Bash ，进入目录，并输入

```
 git init
```
3.将本地仓库和我们在coding上创建的远程仓库对接起来，输入

```
git remote add *yourname* *git_url*  //不用输这条，输下面那条
```
add 后面输入你的仓库名字，自定义。git_url代表你的git地址，这里我命名为origin

```
git remote add origin *url* //这条指令是上面的详细版，输入这个就好。
```

> （这里可能会出现叫你设置邮箱，和姓名，跟着提示设置就行了，或者可以选择以SSH公钥进行连接，不过得先去配置公钥）

回车成功后可以输入

```
git remote -v
```
4.为了我们的代码是最新的状态 和 提交时不会产生冲突，我们先执行下pull操作，将远程仓库最新代码拉到我们本地来，输入

```
git pull origin master
```

> （origin就是我们上面设置的仓库名，master代表主分支，你可以把分支理解为一块区域，我们最终编写完成的代码都要整合到master分支里面去。然后，我们还可创建一些其他分支，去保存我们正在编写中，或者尚未测试的代码。）


执行完后，你可以查看目录下的文件，这时我们本地的文件就和远程仓库里面master分支里的文件一样了。

5.接下来我们来模拟写代码并上传到远程仓库去。
我们新建一个 a.js文件，并编辑一些内容进去。首先将a文件添加到暂存区

```
git add a.js //（add后面可以带多个文件名字，用空格隔开；或者输入 . 代表全部）

//然后再提交到本地仓库中去

git commit -m "first commit"

//然后我们需要把它push到远程仓库中去。输入

git push origin master  //push到origin的master主分支里面，成功后会显示提示消息

```

### 查看远程仓库的情况
查看当前配置有哪些远程仓库

```bash
git remote
```

本地与远程仓库的取消
**git remote remove "仓库名"**

**可以同时关联多个仓库，名字起的不一样就好，不一定非要用origin。但是要注意的是，git pull 和 git push指定的仓库名字也要改变。不然容易出问题。**



### 回退到某版本

```
git reset --hard 139dcfaa558e3276b30b6b2e5cbbb9c00bbdca96 

//后面的是git提交的历史版本号，上git上面找到复制下来就行
```


### 回退到某版本，且放弃之前的记录

```bash
git reset --hard回退之后，如果直接push会出错，因为我们本地库HEAD指向的版本比远程库的要旧，所以我们要用“git push -f”强制推上去
```



### 将现有代码保存带其它仓库
1. git remote add neworigin **"url"**
2. git push -u neworigin **"分支名"**
3. 如果第二条命令不行就：git push -u neworigin **"分支名"** : **"分支名"**

## git bash扩展命令
[原链接](https://blog.51cto.com/u_15127579/2670631)
总共有三个思路：
### 1.借助winpty调用cmd可以使用的命令
  
**winpty 是一种提供与 cmd 通信的软件包,详情请参考 https://github.com/rprichard/winpty**

git bash 命令行内没有 tree 命令而 cmd 命令行却有 tree 命令.

只不过 cmd 命令中的 tree 命令实际上是 tree.com 并不是 tree.exe 文件.
(tree 命令是以树状结构显示文件目录的一种命令,查看目录结构层次非常直观.)

```
`winpty tree.com` 效果等价于 `cmd` 内直接执行 `tree.com` 命令,瞬间解决了中文乱码问题
```

### 2.gunWin填补（用的最多）
绝大多数命令可以从这里找到，有的是可执行程序，有的是源码，需要先编译。
[访问该网址](https://sourceforge.net/)

### 3.工具--Babun
### 4.工具--gitforwindows

### 扩展实例

### 安装make命令
1. [前往该网址](https://sourceforge.net/projects/ezwinports/files/)，下载 make-4.1-2-without-guile-w32-bin.zip，并解压zip文件
2. 将解压内容放到git-bash安装路径的 mingw64文件夹 Git\mingw64\ （重复文件不要覆盖）

### 安装wget
1. [前往该网址](https://eternallybored.org/misc/wget/)，下载最新的wget可执行文件（下载zip文件，包含document；或者直接下载exe文件）
2. 得到wget.exe（如果可执行文件名称是wget64.exe，将其重命名为wget.exe）
3. 将 wget.exe 移动到你的git-bash安装路径的bin文件夹中 Git\mingw64\bin\

### 安装sshpass
1. 从[网址](http://sourceforge.net/projects/sshpass/)下载1.05版本
2. windows编译需要安装Cygwin编译器，如果安装的是MinGW，那么后面make会出错。[win10 安装Cygwin](https://blog.csdn.net/weixin_42109012/article/details/106060913)。关键就是把编译c语言的相关东西装好。
3. make && make install

4. 把编译好的exe程序放到：C:\Software\git\usr\bin
5. 把上面的路径放到环境变量

#### git bash安装zip
git bash有些话可能没法执行zip命令

1.打开https://sourceforge.net/projects/gnuwin32/files/
2.2.找到zip和bzip2，由于zip依赖bzip2.dll，**下载zip-3.0-bin.zip和bzip2-1.0.5-bin.zip**，解压后，复制zip-3.0-bin的bin目录下的**zip.exe** 和bzip2-1.0.5-bin的bin目录下的**bzip2.dll**到 **git/usr/bin/**

```bash
放置的目录不能放错，一开始放到了git/bin/目录下，结果不行。
```



## git 所遇问题

### ssh: connect to host github.com port 22: Connection refused
[原链接](https://segmentfault.com/a/1190000041909858)