#基本对象
#向量
#一组相同类性的原始值构成的序列，一组数字，一组逻辑值，一组文本或者是其他类型的值
#数值向量
#数值向量由数值组成的向量，单个数值就是简单的数值向量
#1.5就是
#数值向量有许多方法，调用numeric创建一个由0组成的指定长度的向量
numeric(10)
# [1] 0 0 0 0 0 0 0 0 0 0
#用c把多个向量组合成一个向量
c(1,2,3,4,5)
#[1] 1 2 3 4 5
#多个单元素向量和多元素向量链接起来构成一个向量
c(1,2,c(3,4,5))
#[1] 1 2 3 4 5
#整数值向量而不是数值向量
#产生一个数值序列，使用seq，一个数值向量，从1开始，到10结束，步长为2
seq(1,10,2)
#[1] 1 3 5 7 9
#seq很多参数，所有的参数调用这个参数，
#length.out这个参数创建另外一个从3开始，长度为10的数值向量
seq(3,length.out = 10)
#[1]  3  4  5  6  7  8  9 10 11 12
1 + 1:5
#是从2~6的序列
#逻辑向量
TRUE
1 > 2
c(1,2) >2
c(1,2) > c(2,1)
c(2,3) > c(1,2,-1,3)
#2>1,3>2,2>-1,3>3
#==相等，%in% 判断运算符左侧向量的每一个元素是否都包含在运算符右侧的向量中
1 %in% c(1,2,3)
c(1,4) %in% c(1,2,3)
#字符向量
"hello,world!"
'hello,world!'
#c创建一个多元素的字符向量
c("Hello","World")
c("Hello","World") == c('Hello','World')
c("Hello","World") == "Hello,World"
#cat生成指定文本
cat('Is \"You\"a Chinese name?')
#Is "You"a Chinese name?
cat('Is "You" a Chinese name?')
#构成向量子集
#简单的数值向量并且赋值给v1
v1 <- c(1,2,3,4)
v1[2]
v1[2:4]
#排除第3个意外的其他所有元素
v1[-3]
#1,2,4
a<- c(1,3)
#不能同时使用正数和负数
v1[c(1,2,-3)]
v1[3:6]
#逻辑向量
#分别代表着1是正确，2是错误，3是正确，4是错误
v1[c(TRUE,FALSE,TRUE,FALSE)]
#赋值
v1[2]<-0
v1
v1[c(TRUE,FALSE,TRUE,FALSE)] <- c(3,2)
v1
v1[v1 <=2]
v1[v1 ^ 2 - v1 + 1 >=0]
#x**2-x+1 >=0
v1[v1 <=2] <- 0
v1
v1[10] <-8
v1
#命令向量
#不同于数值向量或逻辑向量的特定向量类型
#该向量中的每一个元素都有对应的名称
x <- c(a=1,b=2,c=3)
x
x["a"]
x[c("a","c")]
x[c("a","a","c")]
#names获取向量中的元素名称
names(x)
names(x) <- c("x","y","z")
x["z"]
#null移除原来的名称，null一个未定义值的特殊对象
names(x) <- NULL
x
x <- c(a=1,b=2,c=3)
x["d"]
#NA
names(x["d"])
x[c("a","d")]
#提取向量元素
#[]创建一个向量子集，[[]]提取向量中的元素，
x <- c(a=1,b=2,c=3)
x["a"]
x[["a"]]
#[[]]提取一个元素，不适合提取多个元素的情况
x[[c(1,2)]]
#不能用于负整数，提取除特定位置之外的所有元素
x[[-1]]
#提取一个位置超出范围或者对应名称不存在的元素时，容易造成误用
#识别向量类型
#class函数判断任意R对象的类型
class(c(1,2,3))
class(c(TRUE,TRUE,FALSE))
class(c("Hello","World"))
#转换向量类别
#不同类型的向量可以被强制转换成一个特定类别的向量
strings <- c("1","2","3")
class(strings)
strings + 10
#as.numeric字符向量转换成数值向量
numbers <- as.numeric(strings)
numbers
class(numbers)
numbers  + 10
#is.*函数is.numeric,is.logical,is.character检验给定对象的类别
#as.*转换向量的类别
as.numeric(c("1","2","3","a"))
as.logical(c(-1,0,1,2))
as.character(c(1,2,3))
as.character(c(TRUE,FALSE))
c(2,3) + as.character(c(1,2))
#数值向量的算术运算符
#对相应位置的元素进行计算，并自动循环利用较短的向量
c(1,2,3,4) +2
c(1,2,3) - c(2,3,4)
c(1,2,3) * c(2,3,4)
c(1,2,3) / c(2,3,4)
#2**2,3**2
c(1,2,3) ^ 2
c(1,2,3) ^c(2,3,4)
#1**2,2**3,3**4
#余值
c(1,2,3,14) %% 2
c(a=1,b=2,c=3) + c(b=2,c=3,d=4)
c(a=1,b=2,3) + c(b=2,c=3,d=4)
#矩阵
#两个维度表示和访问的向量
#创建一个矩阵
#matrix函数一个向量编程矩阵，设定矩阵的其中一个维度
matrix(c(1,2,3,2,3,4,3,4,5),ncol=3)
#ncol=3意味着提供的向量应该被当作应该列数为3的矩阵
#nrow行数，false按照列
matrix(c(1,2,3,4,5,6,7,8,9),nrow = 3,byrow = FALSE)
#nrow是行数，true按照行
matrix(c(1,2,3,4,5,6,7,8,9),nrow=3,byrow=TRUE)
#对角矩阵，diag函数
diag(1,nrow=5)
#为行和列命令
matrix(c(1,2,3,4,5,6,7,8,9),nrow=3,byrow=TRUE,dimnames = list(c("r1","r2","r3"),c("c1","c2","c3")))
m1 <- matrix(c(1,2,3,4,5,6,7,8,9),ncol = 3)
rownames(m1) <- c("r1","r2","r3")
colnames(m1) <- c("c1","c2","c3")
#构建矩阵子集
#需要创建矩阵，从中抽取数据，构建矩阵子集
#矩阵两个维度表示和访问的向量，一个二维存取器，[ , ]访问，构建向量子集时用的一维存取器
m1
m1[1,2]
m1[1:2,2:3]
m1[1,]
m1[,2]
m1[1:2,]
m1[,2:3]
m1[-1,]
m1[,-2]
m1[c("r1","r3"),c("c1","c3")]
m1[1]
m1[9]
m1[3:7]
m1 > 3
m1[m1 > 3]
#矩阵运算符的使用
m1 + m1
m1 -2 * m1
m1 * m1
m1 / m1
m1 ^ 2
m1 %*% m1
#t函数对矩阵进行转置  行变列，列变成行
t(m1)

#数组
#创建一个数组
#向量，调用array函数创建一个数组，指定数组的不同维度
#dim函数指定数组的维度
a1 <- array(c(0,1,2,3,4,5,6,7,8,9),dim=c(1,5,2))
a1
a1 <- array(c(0,1,2,3,4,5,6,7,8,9),dim=c(1,5,2),dimnames = list(c("r1"),c("c1","c2","c3","c4","c5"),c("k1","k2")))
a1
#dimnames对数组的各个维度命名
a0 <- array(c(0,1,2,3,4,5,6,7,8,9,10),dim=c(1,5,2))
dimnames(a0) <- list(c("r1"),c("c1","c2","c3","c4","c5"),c("k1","k2")) 
a0
#构建数组子集
a1[1,,]
a1[,2,]
a1[,,1]
a1[1,1,1]
a1[1,2:4,1:2]
a1[c("r1"),c("c1","c3"),"k1"]
#原子向量、矩阵和数组的性质和操作方式几乎完全相同。
#最基本的共同特征就是它们都属于同质数据类，存储的一定是相同类型的元素
#异质数据类，存储不同类型的元素

#列表
#创建一个列表
#list创建一个列表
IO <- list(1,c(TRUE,FALSE),c("a","b","c"))
IO
l1 <- list(x=1,y=c(TRUE,FALSE),z=c("a","b","c"))
l1
#从列表中提取元素
l1 <- list(x=1,y=c(TRUE,FALSE),z=c("a","b","c"),m=NULL)
l1$x
l1$y
l1$m
l1[[2]]
l1[["y"]]
number <- "z"#你可以随时改变想要取出的成分
l1[[number]]
#构建列表子集
l1["x"]
l1[c("x","y")]
l1[1]
l1[c(1,2)]
l1[c(TRUE,FALSE,TRUE)]
#[[]]提取向量或列表中的一个元素
#[]用来提取一个向量或列表的子集
#命名列表
names(l1) <- c("A","B","C")
l1
names(l1) <- NULL
l1
#赋值
l1 <-list(x=1,y=c(TRUE,FALSE),z=c("a","b","c"))
l1$x <- 0
l1$m <- 4
l1
l1[c("y","z")] <- list(y="new value for y",z=c(1,2))
l1
l1$x <- NULL
l1
l1[c("z","m")]<-NULL
l1
#其他函数
#不能确定一个对象是否是列表
l2 <- list(a = c(1,2,3),b = c("x","y","z","w"))
is.list(l2)
is.list(l2$a)

#as.list函数将一个向量转换成一个列表
l3 <- as.list(c(a=1,b=2,c=3))
l3
#unlist容易的将一个列表强制转换成一个向量
l4 <- list(a=1,b=2,c=3)
unlist(l4)

l4 <- list(a=1,b=2,c="hello")
unlist(l4)

#数据框
#data.frame函数，对每一列提供相应类型的列向量来创建一个数据框
persons <- data.frame(Name=c("Ken","Ashley","Jennifer"),Gender = c("Male","Female","Female"),Age=c(24,25,23),Major = c("Finance","Statistics","Computer Science"))
persons

#对一个列表直接调用data.frame或as.data.frame将其转换换成数据框
l1 <- list(x=c(1,2,3),y=c("a","b","c"))
data.frame(l1)
as.data.frame(l1)
#列数排序
m1 <- matrix(c(1,2,3,4,5,6,7,8,9),nrow=3,byrow=FALSE)
data.frame(m1)
as.data.frame(m1)
#对行和列命名
df1 <- data.frame(id=1:5,x=c(0,2,1,-1,-3),y=c(0.5,0.2,0.1,0.5,0.9))
df1

colnames(df1) <-c("id","level","score")
rownames(df1) <- letters[1:5]
df1

#构建数据框子集
#以列表形式构建数据框子集
#$按列明提取某一列的值，用[[符号按照位置提取]]
df1$id
df1[[1]]
#数值向量表示列的位置
df1[1]
df1[1:2]
df1["level"]
df1[c("id","score")]
df1[c(TRUE,FALSE,TRUE)]


#以矩阵形式构建数据框子集
#[,]数值向量、字符向量或者逻辑向量
df1[,"level"]
df1[,c("id","level")]
df1[,1:2]
df1[1:4,]
df1[c("c","e"),]
df1[1:4,"id"]
df1[1:3,c("id","score")]
df1[1:4,]["id"]
#drop=FALSE避免简化结果
df1[1:4,"id",drop=FALSE]
#数据框的子集总是保留数据框的形式，设置drop=FALSE

#筛选数据
df1$score >= 0.5
df1[df1$score >= 0.5,c("id","level")]
#判断前面一个向量内的元素是否在后面一个向量中，返回布尔值。
rownames(df1) %in% c("a","d","e")
df1[rownames(df1) %in% c("a","d","e"),c("id","score")]
#赋值
#以列表方式赋值
df1$score <- c(0.6,0.3,0.2,0.4,0.8)
df1
df1["score"] <- c(0.8,0.5,0.2,0.4,0.8)
df1

#[]允许在一个语句进行多重修改，[[]]只能修改一列
df1["score"] <- c(0.8,0.5,0.2,0.4,0.8)
df1

df1[["score"]] <- c(0.4,0.5,0.2,0.8,0.4)
df1
df1[c("level","score")]<-list(level=c(1,2,1,0,0),score=c(0.1,0.2,0.3,0.4,0.5))
df1
#以矩阵方式赋值
df1[1:3,"level"] <- c(-1,0,1)
df1

df1[1:2,c("level","score")] <- list(level=c(0,0),score=c(0.9,1.0))
df1
#因子
#str来说明
persons <- data.frame(Name=c("Ken","Ashley","Jennifer"),Gender = c("Male","Female","Female"),Age=c(24,25,23),Major = c("Finance","Statistics","Computer Science"))
str(persons)
persons[1,"Name"] <- "John"
persons
stringAsFactors = FALSE:
  persons <- data.frame(Name=c("Ken","Ashley","Jennifer"),Gender = factor(c("Male","Female","Female")),Age=c(24,25,23),Major=c("Finance","Statistics","Computer Science"),stringsAsFactors = FALSE)
  str(persons)
#数据框的实用函数
#summary作用在数据框上吗，生成一个汇总表来显示每一列的情况
summary(persons)
#rbind和cbind按行合并和按列合并
rbind(persons,data.frame(Name="John",Gender="Male",Age=25,Major="Statistics"))
cbind(persons,Registered=c(TRUE,TRUE,FALSE),Projects=c(3,2,3))
#rbind和cbind生成一个添加了行或列的新数据框
#expand.grid()生成一个包含所有劣质组合的数据框
expand.grid(type=c("A","B"),class=c("M","L","XL"))

#在硬盘上读取数据
#read.table()或read.csv()
#数据读入R环境中，调用read.csv(file)是文件的路径，getwd找到该目录
read.csv("E:/ryuyanxuexi/persons.csv")
#row.names=FALSE避免存储不必要的行名，quote=FALSE避免输出中的文本加引号
write.csv(persons,"E:/ryuyanxuexi/person.csv",row.names=FALSE,quote=FALSE)

#函数
#可调用的对象，is.numeric函数输入任意一个R对象，返回一个判断对象是否为数值向量的逻辑值
#is.function函数，判断一个给定的R对象是否为函数
#创建函数
add <-function(x,y){
  x+y
}
add

#调用函数
add(2,3)

#动态类型
add(c(2,3),4)

add(as.Date("2014-06-01"),1)
#as.Date创建一个Date对象，日期，
add(list(a=1),list(a=2))

#泛化函数
#解决一些特定问题的特定逻辑或者过程的集合的一种合理抽象
#泛化是使函数具有更广泛的适用性。
#使用控制流执行该函数，
calc <- function(x,y,type){
  if(type=='add'){
    x+y
  }else if(type=="minus"){
    x-y
  }else if (type=='multiply'){
    x*y
  }else if (type=="divide"){
    x / y
  }else{
    stop("Unknown type of operation")
  }
}

calc(2,3,"minus")

calc(c(2,5),c(3,6),"divide")
calc(as.Date("2014-06-01"),3,"add")
calc(1,2,"what")

calc(1,2,c("add","minus"))

calc <- function(x,y,type){
  if (length(type>1L)) stop("Only a single type is accepted")
  if (type=="add"){
    x+y
  }else if (type=="minus"){
    x-y
  }else if (type=="multiply"){
    x*y
  }else if (type=="divide"){
    x /y
  }else{
    stop("UnKnown of operation")
  }
}
calc(1,2,c("add","minus"))
#函数参数的默认值
increase <- function(x.y=1){
  x+y
}
increase(1)

increase(c(1,2,3))