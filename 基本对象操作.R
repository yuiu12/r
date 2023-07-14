#使用原函数
#检查对象类型

#为了创建这样的函数，分析一下可能的逻辑流
#函数的输出取决于输入对象的类型，使用is.*函数来判别输入
#对象是否属于某个类型
take_it <- function(x){
  if(is.atomic(x)){
    x[[1]]
  }else if (is.list(x)){
    x$data[[x$index]]
  }else{
    stop("Not supported input type")
  }
}

#x为原子向量（数值向量），函数提取原子向量的第一个元素
#x为一个包含数据和索引的列表是，函数根据索引index的取值来抽取数据x$data的响应元素
take_it(c(1,2,3))
take_it(list(data=c("a","b","c"),index=3))
take_it(mean)

take_it(list(input=c("a","b","c")))

NULL[[1]]

NULL[[NULL]]

take_it(list(data=c("a","b","c")))

c("a","b","c")[[NULL]]

take_it(list(index=2))


take_it2 <- function(x){
  if(is.atomic(x)){
    x[[1]]
  }else if(is.list(x)){
    if(!is.null(x$data) && is.atomic(x$data)){
      if(is.atomic(x$index) && length(x)==1){
        x$data[[x$index]]
      }else{
        stop("Invalid Index")
      }
    }else{
      stop("invalid Index")
    }
  }else{
    stop("Not supported input type")
  }
}

take_it2(list(data=c("a","b","c")))

take_it2(list(index=2))


#识别对象的类和类型
#class或者typeof实现这个功能
x <- c(1,2,3)
class(x)
typeof(x)
str(x)

x<- 1:3
class(x)
typeof(x)
str(x)

x<- c("a","b","c")
class(x)
typeof(x)
str(x)

x <- data.frame(a = c(1,2),b=c(TRUE,FALSE))

class(x)
typeof(x)
str(x)

#typeof返回对象的低级内部类型
#class返回对象的高级类，
#识别数据维度
#1.获取数据维度
vec <- c(1,2,3,2,3,4,3,4,5,4,5,6)
class(vec)
typeof(vec)
#同一地层数据可用被表示成多维数据结构，dim，nrow或ncol识别
#matrix是矩阵  ncol返回指定矩阵的列数
sample_matrix <- matrix(vec,ncol=4)
sample_matrix

class(sample_matrix)

typeof(sample_matrix)
#3排四列
dim(sample_matrix)
#矩阵的行数
nrow(sample_matrix)
#矩阵的列数
ncol(sample_matrix)
#dim是维度2排三行  2个区域
sample_array <- array(vec,dim=c(2,3,2))
sample_array
class(sample_array)
typeof(sample_array)
dim(sample_array)
nrow(sample_array)
ncol(sample_array)
sample_data_frame <- data.frame(a=c(1,2,3),b=c(2,3,4))
class(sample_data_frame)
typeof(sample_data_frame)
dim(sample_data_frame)
sample_data_frame
nrow(sample_data_frame)
ncol(sample_data_frame)

#重塑数据结构
vec
sample_data <- vec
dim(sample_data) <- c(3,4)
sample_data
class(sample_data)
typeof(sample_data)


dim(sample_data) <- c(4,3)
sample_data


dim(sample_data) <- c(3,2,2)
sample_data



class(sample_data)


#prod(y)等于length(x)时，表达式dim(x)<- y才会其作用，也就是说，所有维度值的乘积必须等于数据元素的长度，否则，就会出现错误
dim(sample_data)<- c(2,3,4)
sample_data


#在一个维度进行迭代
sample_data_frame


for(i in 1:nrow(sample_data_frame)){
  #sample text:
  #row #1,a:1,b:2
  cat("row #",i,",","a: ",sample_data_frame[i,"a"],", b: ",sample_data_frame[i, "b"],"\n",sep="")
  
}

#使用逻辑函数
#逻辑运算符
#&     c(T,T)&c(T,F) TRUE,FALSE
# |   c(T,T)|c(T,F) TRUE,TRUE
#&&    c(T,T)&&c(F,T) FALSE
# ||    c(T,T) || c(F,T) TRUE
# ！      !c(T,F)  FALSE,TRUE
# %in%   c(1,2)%in%c(1,2,3,4) TRUE,FALSE
test_direction <- function(x,y,z){
  if(x<y&y<z) 1
  else if(x>y&y>z) -1
  else 0
}
test_direction(1,2,3)

test_direction(c(1,2),c(2,3),c(3,4))


test_direction2 <- function(x,y,z){
  if(x<y && y<z) 1
  else if(x>y && y>z) -1
  else 0
}

test_direction2(1,2,3)

test_direction2(C(1,2),C(2,3),C(3,4))

#逻辑函数
#1.聚合逻辑向量
#any和all，给定逻辑向量的任何一个元素是TRUE，函数any就返回TRUE，函数any返回FALSE
#只要给定逻辑向量的所有元素都是TRUE，函数all才返回TRUE，all返回FALSE
x <- c(-2,-3,2,3,1,0,0,1,2)
any(x>1)
all(x<=1)


test_all_direction<- function(x,y,z){
  if(all(x<y & y <z))1
  else if(all(x>y & y>z)) -1
  else 0
}

test_all_direction(1,2,3)

test_all_direction(c(1,2),c(2,3),c(3,4))

test_all_direction(c(1,2),c(2,4),c(3,4))

test_any_direction<- function(x,y,z){
  if(any(x<y & y<z)) 1
  else if (any(x>y & y>z)) -1
  else 0
}
test_all_direction2 <- function(x,y,z){
  if(all(x<y) && all(y<z)) 1
  else if(all(x>y) && all(y>z)) -1
  else 0
}
test_any_direction2 <- function(x,y,z){
  if(any(x<y) &&any(y<z)) 1
  else if(any(x>y) &&any(y>z)) -1
  else 0
}

#询问哪个元素为真
#which函数返回逻辑向量中元素TRUE的位置
x
abs(x) >= 1.5

which(abs(x) >= 1.5)

#which函数的运算机制与使用逻辑条件筛选向量或列表中的元素非常类似
x[x>=1.5]
x[x>=100]
#处理缺失值
x<-c(-2,-3,NA,2,3,1,NA,0,1,NA,2)
x+2

x>2

x

any(x>2)
any(x<-2)
any(x<-3)


#any任意一个元素是TRUE，返回TRUE，没有元素为TRUE，包含缺失值，返回NA，输入向量包含FALSE，返回FALSE
any(c(TRUE,FALSE,NA))
any(c(FALSE,FALSE,NA))
any(c(FALSE,FALSE))

#直接忽略所有的缺失值，调用函数时指定na.rm=TRUE
x
any(x< -3,na.rm=TRUE)

x
#all 任意一个元素是FALSE，返回FALSE没有元素为FALSE，包含缺失值，返回NA，包含TRUE，返回TRUE
x<-c(-2,-3,NA,2,3,1,NA,0,1,NA,2)
all(x>-3)
all(x>=-3)
all(x<4)

all(c(TRUE,FALSE,NA))
all(c(TRUE,TRUE,NA))
all(c(TRUE,TRUE))

all(x>= -3,na.rm=TRUE)


x
x[x>=0]
#which不会保留输入逻辑向量中的缺失值
which(x >= 0)
x[which(x>=0)]

#逻辑强制转换
if(2) 3

if(0) 0 else 1

if("a") 1 else 2

#数字函数
#基础函数
# sqrt(2)   1.4142136
# exp(1)    2.7182818
#log(1)  0
#log10(10)  1
#log2(8)   3
#sqrt作用与实数，如果提供了一个负数，就会产生NaN
sqrt(-1)
#正无穷
1/0
#负无穷
log(0)
#检查函数一个数值是有限的
is.finite(1/0)

is.finite(log(0))

#is.infinite判断某个值是不是无穷大
1 /0 <0
1 / 0 > 0
log(0) <0 
log(0)>0

#is.infinite将值与0比较
is.pos.infinite <- function(x){
  is.infinite(x) & x > 0
}
is.neg.infinite <- function(x){
  is.infinite(x) & x< 0
}
is.pos.infinite(1/0)
is.neg.infinite(log(0))

log(-1)


#取整函数
#ceiling(10,6)  11
#floor(9.5)  9
#trunc(1.5)  1
#round(pi,3) 3.142
#signif(pi,3) 3.14
#三角函数

#sin(0) 0
#cos(0)  1
#tan(0)  1
#asin(1)  1.5707963
#acos(1) 0   
#atan(1)  0.7853982
pi

sin(pi)

#比较两个数字近似相等,all.equal(),1.5*10的-8成倍数
#sin(pi)==0 返回FALSE，all.equal(sin(pi),0)返回TRUE
#sinpi(1)  0
#cospi(0)  1
#tanpi(1) 0
#双曲函数
#sinh(1)  1.1752012
#cosh(1)  1.5430806
#tanh(1) 0.7615942
#asinh(1) 0.8813736
#acosh(1) 0
#atanh(0) 0

#最值函数
# max(1,2,3)  3
#min(1,2,3)  1
max(c(1,2,3))

max(c(1,2,3),
    c(2,1,2),
    c(1,3,4))

min(c(1,2,3),
    c(2,1,2),
    c(1,3,4))

#想获得全部向量的每个相同位置对应值的最大值或最小值
pmax(c(1,2,3),
     c(2,1,2),
     c(1,3,4))
#是找列的最大值
x <- list(c(1,2,3),
          c(2,1,2),
          c(1,3,4))
c(max(x[[1]][[1]],x[[2]][[1]],x[[3]][[1]]),
  max(x[[1]][[2]],x[[2]][[2]],x[[3]][[2]]),
  max(x[[1]][[3]],x[[2]][[3]],x[[3]][[3]]))
#1  2 1
# 2 1 3
#3 2 4

pmin(c(1,2,3),
     c(2,1,2),
     c(1,3,4))

#spread是一个分段函数，输入值小于-5，取值为-5，输入值介于-5~5之间，取值就是输入值，输入值大于5，取值为5
spread<- function(x){
  if(x < -5) -5
  else if(x > 5) 5
  else x 
}

spread(1)

spread(seq(-8,8))

spread2 <- function(x){
  pmin(5,pmax(-5,x))
}
spread2(seq(-8,8))

spread3<- function(x){
  ifelse(x < -5,-5,ifelse(x>5,5,x))
}
spread3(seq(-8,8))

#应用数值方法
#根查找
#polyroot
#-2x的平方+x+1=0
polyroot(c(-2,1,1))

#Re从负数根中提取实数部分
Re(polyroot(c(-2,1,1)))
#输出类型表名函数ployroot可以寻找多项式的复数根，
#x的3次方-x的2次方-2x-1=0
polyroot(c(1,0,1))
r <- polyroot(c(-1,-2,-1,1))
r
r ^3 -r ^2 - 2*r-1

round(r^3-r^2-2*r-1,8)
#x在【-2，1】有根
#uniroot指定求解函数和查找区间
#uniroot返回一个列表
uniroot(function(x) x ^ 2-exp(x),c(-2,1))

f<-function(x) exp(x) - 3 * exp(-x ^ 2 +x) +1
uniroot(f,c(-2,2))
uniroot(f,c(-2,0))$root
uniroot(f,c(0,2))$root
uniroot(function(x) x^2-2*x+4*cos(x^2)-3,c(0,1))$root

#微积分
#D计算一个函数对给定变量的导数，表达式的形式返回
dx的2次方/dx
D(quote(x^2),"x")

#dsin(x)cos(xy)/dx
D(quote(sin(x)*cos(x*y)),"x")

z <- D(quote(sin(x) * cos(x*y)),"x")
z
eval(z,list(x=1,y=2))

#quote创建一个表达式对象，eval基于给定的参数值执行了这个表达式。表达式对象赋予R元编程的能力。
#积分
#r支持数值积分，内置函数integrate
result <- integrate(function(x) sin(x),0,pi/2)
result

str(result)

#使用统计函数
#向量中抽样
#sample从一个给定向量或列表中随机抽取一个样本。进行不放回随机抽样
sample(1:6,size=5)
#replace=TRUE有放回随机抽样
sample(1:6,size=5,replace=TRUE)

sample(letters,size=3)

sample(list(a=1,b=c(2,3),c=c(3,4,5)),size=2)

#sample所有可以使用方括号构建子集的对象
#prob是概率
grades <- sample(c("A","B","C"),size=20,replace=TRUE,prob=c(0.25,0.5,0.25))
grades
table(grades)

#应用随机分布
#runif生成n个0~1区间上服从均匀分布的随机数
runif(5)
runif(5,min=-1,max=1)
#rnorm生成服从标准正太分布的随机数
rnorm(5)
#均值mean和标准差sd
rnorm(5,mean=2,sd=0.5)
#https://en.wikipedia.org/wiki/Probability_direction

#计算描述性统计量
x <- rnorm(50)
#mean计算样本x的算术平均值
mean(x)

#mean设定参数trim计算截尾平均数，丢弃了最大5%和最小5%的输入数据后的算术平均数
mean(x,trim=0.05)

median(x)
#计算一个数值向量的标准差
sd(x)

#var计算方差
var(x)

#min和max抓捕数据的极端值
c(min=min(x),max=max(x))
#range得到这两个值
range(x)
#取百分位比用quantile()函数
quantile(x)
#序列百分位比值
quantile(x,probs = seq(0,1,0.1))

#summary直接给定最常用的描述性统计量
#获取描述性统计量，可以提供最小值、最大值、四分位数和数值型变量的均值，以及因子向量和逻辑型向量的频数统计等。
summary(x)
df<- data.frame(score=round(rnorm(100,80,10)),grade=sample(letters[1:3],100,replace = TRUE))
summary(df)

#计算协访差和相关矩阵
y<- 2*x + 0.5*rnorm(length(x))
#协方差
cov(x,y)
#计算相关系数
cor(x,y)
#cbind创建一个3列的矩阵，计算它们的协方差矩阵
z <- runif(length(x))
ml <- cbind(x,y,z)
cov(ml)

cor(ml)
#使用apply函数族
len<- c(3,4,5)
#首先，在环境中创建一个列表
x <- list()
#然后，使用for循环根据各自的长度生成相应的随机向量
for(i in 1:3){
  x[[i]] <- rnorm(len[i])
}
x
#lapply()函数可用于对列表对象执行操作，并返回与原始集合长度相同的列表对象。
lapply(len,rnorm)
students<- list(
  a1 = list(name="James",age=25,gender="M",interest=c("reading","writing")),
  a2 = list(name="Jenny",age=23,gender="F",interest=c("cooking")),
  a3 = list(name="David",age=24,gender="M",interest=c("running","basketball"))
)
#函数sprintf通过将占位符替换成相应的输入参数来格式化文本
lapply(students,function(s){
  type <- switch(s$gender,"M"="man","F"="woman")
  interest <- paste(s$interest,collapse = ", ")
  sprintf("%s,%d year-old %s,loves %s.",s$name,s$age,type,interest)
})

#sapply
sapply(1:10,function(i) i ^2)

sapply(1:10, function(i) c(i,i^2))

#vapply
x <- list(c(1,2),c(2,3),c(1,3))
sapply(x,function(x) x^2)


x1 <- list(c(1,2),c(2,3),c(1,3,3))
sapply(x1,function(x) x^2)

#vapply一个附加参数设定每次迭代返回值 模板，numeric(2)每次迭代返回一个包含2个元素的数值向量
vapply(x1,function(x) x^2,numeric(2))

vapply(x,function(x) x^2,numeric(2))

#mapply在多个向量上进行迭代mapply是sapply的多元版本
mapply(function(a,b,c) a*b+b*c+a*c,a=c(1,2,3),b=c(5,6,7),c=c(-1,-2,-3))
df <- data.frame(x=c(1,2,3),y=c(3,4,5))
df

mapply(function(xi,yi) c(xi,yi,xi+yi),df$x,df$y)


#Map是lapply的多元版本
Map(function(xi,yi) c(xi,yi,xi+yi),df$x,df$y)
#apply一个函数应用带矩阵或数组的某个边际或维度上。
mat <- matrix(c(1,2,3,4),nrow=2)
mat
#加在一起
apply(mat,1,sum)
#列加在一起
apply(mat,2,sum)
mat2<- matrix(1:16,nrow=4)
mat2

#列里面的最大就是第第四行，最小的就是第一行
apply(mat2,2,function(col) c(min=min(col),max=max(col)))
apply(mat2,1,function(col) c(min=min(col),max=max(col)))





















