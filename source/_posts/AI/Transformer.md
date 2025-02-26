---
title: Transformer
date: 2025/02/26
categories:
  - AI
tags:
  - 循环神经网络（RNN）
  - Transformer
mathjax: true
---

## 参考资料：

https://zhouyifan.net/2022/11/12/20220925-Transformer/

https://zhuanlan.zhihu.com/p/505105707


## Transformer的诞生

总结：机器翻译领域，过去都是用RNN或基于RNN的架构来处理。**但是RNN本轮的输入状态取决于上一轮的输出状态，这使RNN的计算必须串行执行。因此，RNN的训练通常比较缓慢。**

### RNN的发展历史

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-71652d6a1eee9def631c18ea5e3c7605_r.jpg)

RNN的循环机制使得上一时间步产生的结果, 能够作为当下时间步输入的一部分，能够很好利用序列之间的关系, 因此针对自然界具有连续性的输入序列, 如人类的语言, 语音等进行很好的处理, 广泛应用于NLP领域的各项任务, 如文本分类, 情感分析, 意图识别, 机器翻译等。

### 传统RNN的缺陷

这种简单的RNN架构仅适用于输入和输出等长的任务。然而，大多数情况下，机器翻译的输出和输入都不是等长的。因此，人们使用了一种新的架构。前半部分的RNN只有输入，后半部分的RNN只有输出（上一轮的输出会当作下一轮的输入以补充信息）。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/encoder-decoder-rnn.jpg)

### 传统encoder-decoder的缺陷


但是这种架构存在不足：**编码器和解码器之间只通过一个隐状态来传递信息。在处理较长的文章时，这种架构的表现不够理想。**
为此，有人提出了基于注意力的架构。这种架构依然使用了编码器和解码器，只不过解码器的输入是编码器的状态的加权和，而不再是一个简单的中间状态。每一个输出对每一个输入的权重叫做注意力，注意力的大小取决于输出和输入的相关关系。这种架构优化了编码器和解码器之间的信息交流方式，在处理长文章时更加有效。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/%E6%B3%A8%E6%84%8F%E5%8A%9B%E5%9B%BE.jpg)

**即便如此，因为依赖上一轮的输出状态，还是只能串行，所以RNN的训练通常比较慢。**

### Transformer的设计动机

1. 提升训练的并行度
2. 规避RNN的使用，完全使用注意力机制来捕捉序列之间的依赖关系

### 注意力机制

“注意力“这个名字取得非常不易于理解。这个机制应该叫做“全局信息查询”。

做一次“注意力”计算，其实就跟去数据库了做了一次查询一样。假设，我们现在有这样一个以人名为key（键），以年龄为value（值）的数据库：

```
{
    张三: 18,
    张三: 20,
    李四: 22,
    张伟: 19
}
```

现在，我们有一个query（查询），问所有叫“张三”的人的年龄平均值是多少。让我们写程序的话，我们会把字符串“张三”和所有key做比较，找出所有“张三”的value，把这些年龄值相加，取一个平均数。这个平均数是(18+20)/2=19。

但是，很多时候，我们的查询并不是那么明确。比如，我们可能想查询一下所有姓张的人的年龄平均值。这次，我们不是去比较key == 张三,而是比较key[0] == 张。这个平均数应该是(18+20+19)/3=19。

或许，我们的查询会更模糊一点，模糊到无法用简单的判断语句来完成。因此，最通用的方法是，把query和key各建模成一个向量。之后，对query和key之间算一个相似度（比如向量内积），以这个相似度为权重，算value的加权和。这样，不管多么抽象的查询，我们都可以把query, key建模成向量，用向量相似度代替查询的判断语句，用加权和代替直接取值再求平均值。“注意力”，其实指的就是这里的权重。

把这种新方法套入刚刚那个例子里。我们先把所有key建模成向量，可能可以得到这样的一个新数据库：

```
{
    [1, 2, 0]: 18, # 张三
    [1, 2, 0]: 20, # 张三 
    [0, 0, 2]: 22, # 李四
    [1, 4, 0]: 19 # 张伟 
}
```

假设key[0]==1表示姓张。我们的查询“所有姓张的人的年龄平均值”就可以表示成向量[1, 0, 0]。用这个query和所有key算出的权重是：

```
dot([1, 0, 0], [1, 2, 0]) = 1
dot([1, 0, 0], [1, 2, 0]) = 1
dot([1, 0, 0], [0, 0, 2]) = 0
dot([1, 0, 0], [1, 4, 0]) = 1
```

之后，我们该用这些权重算平均值了。注意，算平均值时，权重的和应该是1。因此，我们可以用softmax把这些权重归一化一下，再算value的加权和。

```
softmax([1, 1, 0, 1]) = [1/3, 1/3, 0, 1/3]
dot([1/3, 1/3, 0, 1/3], [18, 20, 22, 19]) = 19
```

这样，我们就用向量运算代替了判断语句，完成了数据库的全局信息查询。那三个1/3，就是query对每个key的注意力。



### Scaled Dot-Product Attention

Transformer里的注意力就叫Scaled Dot-Product Attention

我们刚刚完成的计算差不多就是Transformer里的注意力，这种计算在论文里叫做放缩点乘注意力（Scaled Dot-Product Attention）。它的公式是：

$\operatorname{Attention}(Q, K, V)=\operatorname{softmax}\left(\frac{Q K^{T}}{\sqrt{d_{k}}}\right) V$

K就是key向量的数组，也就是：

```
K = [[1, 2, 0], [1, 2, 0], [0, 0, 2], [1, 4, 0]] 
```

V是value向量数组

刚才的例子只做了一次查询，操作写为：

$MyAttention(q, K, V)=softmax(qK^T)V$

其中，query q就是[1, 0, 0]了。


实际上，我们可以一次做多组query。把所有
打包成矩阵Q，就得到了公式

$Attention(Q, K, V)=softmax(\frac{QK^T}{\sqrt{d_k}})V$

$d_k$就是query和key向量的长度。由于query和key要做点乘，这两种向量的长度必须一致。value向量的长度倒是可以不一致，
论文里把value向量的长度叫做$d_v$


为什么要用一个和$d_k$成比例的项来放缩$QK^T$呢？这是因为，softmax在绝对值较大的区域梯度较小，梯度下降的速度比较慢。因此，我们要让被softmax的点乘数值尽可能小。而一般在$d_k$较大时，也就是向量较长时，点乘的数值会比较大。除以一个和$d_k$相关的量能够防止点乘的值过大。

计算相似度不止点乘这一个方法，另一种常用的注意力函数叫做加性注意力，它用一个单层神经网络来计算两个向量的相似度。相比之下，点乘注意力算起来快一些。出于性能上的考量，论文使用了点乘注意力。

### 自注意力机制

自注意力也是一种注意力机制，只不过它计算序列中某个词和其他所有词的权重。
这个查询query，不是来自外部（数据库的例子），而是从序列本身出发，所以叫self。


![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-c2dce4bd78f5bce82ded5757f56dc0a7_1440w.jpg)

如何产生 b1 这个向量？需要衡量输入向量之间的关联度 α。

计算 attention 的模组算出α（关联度大小），有很多方法，比如 Dot-product 方法和 Additive 方法。

下文主要是讲 Dot-product 方法，这是最常用的方法，也是 Transformer 中用的方法。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-e6121217c9a613c99ba4830a96302758_1440w.jpg)

$q^1=W^q . \alpha^1$

$k^2=W^k . \alpha^2$

$\alpha_{1,2}=q^1 . k^2$

$W^q$和$W^k$都是权重矩阵

这个过程要重复进行，在实际中，每个向量向量和自己、和其他向量都要做一次。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-39b7e423ba3bfe911b907c4765768b41_1440w.jpg)

得出所有的$\alpha_{i,j}^`$之后，这些数需要通过激活函数比如 Soft-max 函数，输出激活后的 α'，也就是我们需要的注意力权重。这里的激活函数使用的是 Soft-max，目的是做 Normalization。至于为什么使用 soft-max 并没有定论，也可以使用别的激活函数，比如 ReLU。

最后还需要一个v来抽取信息。


![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-f28102dcc1812a8784981a0da494dad8_1440w.jpg)

上面计算b的过程，可以并行计算。

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-b8409fc56a03ee56f5ae2eda988ebc20_1440w.jpg)

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-d70be2b5a56ab773f798d5da2615713e_1440w.jpg)

### 多头注意力机制

一种 relevance 还不够，需要多种 relevance。也即是需要多个 q,k,v

![](https://cdn.jsdelivr.net/gh/gaofeng-lin/picture_bed/img1/v2-fb5641b01ecfbe5c540c60a5ba10e6e8_1440w.jpg)

$\begin{aligned}
&head_i = Attention(EW^Q_i, EW^K_i, EW^V_i) \\
&MultiHeadSelfAttention(E) = Concat(head_1, ...head_h)W^O
\end{aligned}$

其中h是”头“数，$W^o$是另一个参数矩阵