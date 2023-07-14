#函数时编程
#创建和使用闭包
#函数内部定义的函数定义为闭包，特点是其函数体中，使用局部参数，也可以使用其父环境中的变量
#创建一个简单的闭包
addn<- function(y){
  function(x){
    x+y
  }
}

add1 <- addn(1)
add2<- addn(2)

add1(10)
add2(10)


add1
environment(add1)$y
#add1调用environment函数访问其封闭环境，捕获到y，就是闭包的工作方式
environment(add2)$y

#创建专用函数
color_line <- function(col){
  function(...){
    plot(...,type="l",lty=1,col=col)
  }
}
red_line <- color_line("red")
red_line(rnorm(30),main="Red line plot")

plot(rnorm(30),type="l",lty=1,col="red",main="Red line plot")

#极大拟然估计拟合正太分布
#统计学中，很对参数估计问题本质上就是最优化问题。极大拟然估计是演示闭包的一个很好的例子。
#MLE  https://en.wikipedia.org/wiki/Maximum_likelihood
#对参数进行极大拟然估计时，我们需要一个函数来衡量在给定模型下观测到一组给定模型下观测到一组给定数据的可能性，运用最优化技术找到上述概率最大化的参数值
nloglik <- function(x){
  n <- length(x)
  function(mean,sd){
    log(2 * pi) * n/2 + log(sd^2) * n/2+sum((x-mean) ^2) / (2 * sd ^2)
  }
}
#rnorm生成10000个均值为1，标准差为2的正太分布随机数。mean=1和sd=2就是分布参数的真实值
data <- rnorm(1000,1,2)

#stats4包的mle函数，多种数值方法求解给定参数的负对数拟然函数的最小值。
library("stats4")
fit <- stats4::mle(nloglik(data), 
                   start = list(mean = 0, sd = 1), method = "L-BFGS-B", 
                   lower = c(-5, 0.01), upper = c(5, 10))
fit@coef

(fit@coef - c(1,2)) / c(1,2)
#设置直方图纵轴时表示频数还是概率密度，FALSE展示概率密度，默认为FALSE
#y轴的限制
hist(data,freq=FALSE,ylim=c(0,0.25))
#curve(expr, from = NULL, to = NULL, n = 101, add = FALSE, type = "l", xname = "x", xlab = xname, ylab = NULL, log = NULL, xlim = NULL, ...)
#expr：函数名称或一个关于变量x的函数表达式；
#from，to：表示绘图的起止范围；
#n：一个整数值，表示x取值的数量；
#add：是一个逻辑值，当为TRUE时，表示将绘图添加到已存在的绘图中；
#type：与plot函数中type含义相同；
#xname：用于x轴变量的名称。
#xlab，ylab：x轴和y轴的标签名称。
curve(dnorm(x,1,2),add=TRUE,col=rgb(1,0,0,0.5),lwd=6)
curve(dnorm(x,fit@coef[["mean"]],fit@coef[["sd"]]),add=TRUE,col="blue",lwd=2)
#使用高阶函数
#1.为函数创建别名
f1<- function(){
  cat("[f1] executing in")
  print(environment())
  cat("[f1] enclosed by")
  print(parent.env(environment()))
  cat("[f1] calling from ")
  print(parent.frame())
}
f2 <- function(){
  cat("[f2] executing in ")
  print(environment())
  cat("[f2] enclosed by")
  print(parent.env(environment()))
  cat("[f2] calling from ")
  print(parent.frame())
  p <- f1
  p()
}
f1()

f2()

#将函数当作变量使用
f1<- function(x,y){
  if(x > y){
    x + y
  }else{
    x - y
  }
}
f2 <- function(x,y){
  op <- if(x > y) `+` else `-`
  op(x,y)
}
#将函数当作参数传递
add <- function(x,y,z){
  x + y + z
}
product <- function(x,y,z){
  x * y * z
}
#combine参数f指定的某种方式将x、y和z组合起来。f是一个函数，调用时需要3个参数。combine函数就会更灵活。没有限定必须以某种特定的方式来组合输入，而是允许用户指定组合方式
combine <- function(f,x,y,z){
  f(x,y,z)
}
#定义的函数add和product传递给combine
combine(add,3,4,5)
combine(product,3,4,5)

#高阶函数的另一个原因是它使代码在更高的抽象化层次下读写起来更容易。使用高阶函数会使代码更短，表达力更强。
result <- list()
for(i in seq_along(x)){
  result[[i]] <- f(x[[i]])
}
result
#seq_along从1开始，与x等长的整数序列，效果等价于1：1ength(x)
#lapply将一个函数f作用于向量或列表x的每个元素上
lapply(x, f)

lapply <- function(x,f,...){
  result <- list()
  for(i in seq_along(x)){
    result[[i]] <- f(x[i],...)
  }
  
}

lapply(1:3, `+` ,3)

list(1 +3,2 +3,3 +3)

lapply(1:3, addn(3))


#向量形式返回
sapply(1:3,addn(3))

#vapply函数加上类型检验
vapply(1:3,addn(3), numeric(1))

#?Filter
result <- list()
for(i in seq_along(x)){
  #heavy computing task
  result[[i]] <- f(x[[i]])
}
result

result <- lapply(x, f)

#parallel::mclapply多核计算将f作用到x的每个元素
result <- parallel::mclapply(x,f)
#基于语言的计算
#创建一个新函数fun，也同时创建一个与函数相关联的环境，这个环境被称作函数的封闭环境，通过environment(fun)访问
iris[iris$Sepal.Length > quantile(iris$Sepal.Length,0.8)&
       iris$Sepal.Width > quantile(iris$Sepal.Width,0.8)&
       iris$Petal.Length > quantile(iris$Petal.Length,0.8)&
       iris$Petal.Width > quantile(iris$Petal.Width,0.8), ]

#quantile函数，某列设置一个80%的阈值
#内置函数subset有效简化上述问题
subset(iris,Sepal.Length > quantile(Sepal.Length,0.8) &
         Sepal.Width > quantile(Sepal.Width,0.8) &
         Petal.Length > quantile(Petal.Length,0.8) &
         Petal.Width > quantile(Petal.Width,0.8))

iris[Sepal.Length > quantile(Sepal.Length,0.8) &
       Sepal.Width > quantile(Sepal.Width,0.8) &
       Petal.Length > quantile(Petal.Length,0.8) &
       Petal.Width > quantile(Petal.Width,0.8), ]

#subset使用元编程技术调整其参数的计算环境，使表达式Sepal.Length>quantile(Sepal.Length,0.8)在包含iris所有列的环境中被计算
#subset不仅适用于行的选取，同样适用于列的选取
subset(iris,Sepal.Length > quantile(Sepal.Length,0.8) &
         Sepal.Width > quantile(Sepal.Width,0.8) &
         Petal.Length > quantile(Petal.Length,0.8) &
         Petal.Width > quantile(Petal.Width,0.8),
       select=c(Sepal.Length,Petal.Length,Species))

#捕获和修改表达式
rnorm(5)

#subset 调整参数被计算的环境，首先捕获表达式，调整表达式计算
#1.表达式捕获为语言对象
#捕获表达式意味着防止表达式被执行，而将本身存储为变量的形式。具备这个功能函数就是quote，调用quote捕获表达式
call1<- quote(rnorm(5))
call1

#typeof和class查看结果对象
typeof(call1)
class(call1)

name1 <- quote(rnorm)
name1

typeof(name1)
class(name1)

#quote捕获到函数调用时会返回调用，捕获到变量名时则会返回一个符号
#代码的有效性，即只要代码语法正确，quote就会返回表示被捕获表达本身的语言对象
#函数不存在或变量未定义，捕获表达式本身
quote(pvar)
quote(xfun(a=1:n))

#调用对象转换成列表，查看它的内部结构
as.list(call1)
call1[[1]]

typeof(call1[[1]])

class(call1[[1]])

call1[[2]]

typeof(call1[[2]])

class(call1[[2]])

num1 <- 100
num2 <- quote(100)
num1
num2
identical(num1,num2)

call2 <- quote(c("a","b"))
call2

#as.list查看调用的列表,c也是一个函数，值和向量组合一起
as.list(call2)
#调用内部的元素类型通过str查看
str(as.list(call2))

call3 <- quote(1 + 1)
call3

is.call(call3)
str(as.list(call3))

call4 <- quote(sqrt(1 + x ^ 2))
call4

#pryr扩展包的一个函数查看调用的递归结果，
install.packages("pryr")
library("pryr")
pryr::call_tree(call4)
#\-()运算符是指调用，`var`代表一个符号对象var，其他部分是字面值
#2.修改表达式
call1
call1[[1]] <- quote(runif)
call1

call1 <- quote(rnorm(5))
call1[[1]] <- quote(runif)
call1

call1[[3]] <- 1
names(call1)[[3]] <- "min"
call1
#3.捕获函数参数表达式
#substitute作用于任意的用户输入表达式
fun1 <- function(x){
  quote(x)
  
}

#rnorm为参数调用函数时，fun1能不能捕获输入表达式
fun1(rnorm(5))

#quote只能捕获x，而不是输入表达式rnorm。substitute，捕获表达式，捕获到的表达式替换现有符号。
fun2 <- function(x){
  substitute(x)
}
fun2(rnorm(5))

substitute(x + y + x ^ 2,list(x=1))

substitute(f(x+f(y)),list(f=quote(sin)))

#4.创建函数调用
call1 <- quote(rnorm(5,mean=3))
call1
#call带有一个相同参数的相同函数的调用
call2 <- call("rnorm",5,mean=3)
call2

#as.call函数将一个调用成分的列表转换为调用
call3 <- as.call(list(quote(rnorm),5,mean=3))
call3

identical(call1,call2)
identical(call2,call3)

#执行表达式
#求值用eval函数完成工作
sin(1)
#quote捕获次表达式，调用eval它进行计算
call1 <- quote(sin(1))
call1
eval(call1)

call2 <- quote(sin(x))
call2

eval(call2)

sin(x)

#eval允许我们提供一个列表来计算给定表达式。
eval(call2,list(x=1))

#eval添加一个用于搜索符号的环境，el创建一个取值为1的变量x，在el中将eval作用在调用call2
e1 <- new.env()
e1$x <- 1
eval(call2,e1)

call3 <- quote(x ^2 + y^2)
call3

eval(call3)

eval(call3,list(x=2))

eval(call3,list(x=2,y=3))

#eval(expr,envir,enclos)的计算模式于调用函数相同。函数体为expr，执行环境为envir，如果envir以列表形式给出，封闭环境是enclos，封闭环境就是envir发夫环境
e1 <- new.env()
e1$x <- 2
eval(call3,e1)

#创建一个新环境，父环境e1，包含变量y
e2 <- new.env(parent = e1)
e2$y <- 3
eval(call3,e2)

pryr::call_tree(call3)

#寻找为+的函数el和e2没能找到+，然后在基础环境（baseenv）找到，所有的基础运算符定义在基础环境中
#+需要对其参数进行计算，另一个名为^的函数，路径于+相同。^同样需要计算参数，e2寻找符号x。e2没有变量x，父环境e1搜索
#找到x，e2符号y
#envir提供一个列表和一个封闭环境
e3 <- new.env()
e3$y <- 3
eval(call3,list(x=2),e3)

eval(quote(z <- x+y+1),list(x=1),e3)
e3$z

#z不是在e3中创建，由列表创建一个临时执行环境中创建的
eval(quote(z <- y+1),e3)
e3$z

#eval允许我们通过调整表达式的执行环境和封闭环境来定制计算过程
eval(quote(1+1),list(`+` = `-`))

#非标准计算
#1.使用非标准计算快速构建子集
x <- 1:10
x[3:(length(x) - 5)]

#.表示输入向量的长度
qs <- function(x,range){
  range <- substitute(range)
  selector <- eval(range,list(. = length(x)))
  x[selector]
}

qs(x, 3:(. -5))

qs(x, . -1)

#qs函数用于修剪向量x两端的n个元素
trim_margin <- function(x,n){
  qs(x, (n +1):(. -n -1))
}

trim_margin(x,3)

#2.动态作用域
eval

#eval的定义说明，给envir提供一个列表，envir默认取parent.frame()，eval的调用环境，调用qs执行环境。qs的执行环境中当然没有n
#trim_margin使用substitute的一个缺点，表达式只有在正确的语境才是完全有意义的。substitute值捕获表达式，而不捕获表达式有意义的环境
#正确的封闭环境，定义被捕获的表达式的环境
qs <- function(x,range){
  range <- substitute(range)
  selector <- eval(range, list(. = length(x)),parent.frame())
  x[selector]
}

trim_margin(x,3)



#3.公式来捕获表达式和环境
#parent.frame追踪substitute捕获的表达式
formula1 <- z ~ x ^2 + y ^2

typeof(formula1)

class(formula1)

str(as.list(formula1))

is.call(formula1)
length(formula1)

formula1[[2]]
formula1[[3]]

#访问创建调用环境，environment
environment(formula1)

formula2 <- ~x+y
str(as.list(formula2))

length(formula2)
formula2[[2]]

qs2 <- function(x,range){
  selector <- if (inherits(range,"formula")){
    eval(range[[2]],list(. = length(x)),environment(range))
  }else range
  x[selector]
}

qs2(1:10, ~3:(. -2))
qs2(1:10, 3)

trim_margin2 <- function(x,n){
  qs2(x, ~ (n+1):(. -n -1))
}

trim_margin2(x,3)

#4,使用元编程构建子集
subset2 <- function(x,subset=TRUE,select=TRUE){
  enclos <- parent.frame()
  subset <- substitute(subset)
  select <-substitute(select) 
  row_selector <- eval(subset,x,enclos)
  col_envir <- as.list(seq_along(x))
  names(col_envir) <- colnames(x)
  col_selector <- eval(select,col_envir,enclos)
  x[row_selector,col_selector]
}

subset2(mtcars,mpg >= quantile(mpg,0.9),c(mpg,cyl,qsec))

subset2(mtcars,mpg >= quantile(mpg,0.9),mpg:drat)


