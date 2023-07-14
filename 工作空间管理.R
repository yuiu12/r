objects()
x <- c(1,2,3)
y <- c("a","b","c")
z <- list(m=1.5,n=c("x","y","z"))
objects()
ls()
x
#环境窗口中，对象紧凑形式来自于str函数，指定对象结果
#str作用于一个简单的数值向量时，返回向量的类型、位置，预览前几位元素
str(x)
str(1:30)
z
#str它的类型，长度和各个成分的结构预览情况
str(z)
nested_list <- list(m=1:15,n=list("a",c(1,2,3)),p=list(x=1:10,y=c("a","b")),q=list(x=0:9,y=c("c","d")))
nested_list
#查看和操作的紧凑形式，对列表调用str函数
str(nested_list)
#ls.str当前环境的结构
ls.str()
#ls.str充当过滤器的是mode参数，mode=list查看所有列表对象的值结构
ls.str(mode="list")
#过滤器pattern参数，指定匹配的名称模式，以正则表达式的形式表诉
ls.str(pattern="^\\w$")
ls.str(pattern = "^\\w$",mode="list")
#^\\w$匹配所有具有（字符开始）（任意一个字母，例如a,b,c）(字符结束)形式的字符串
#删除符号
#remove函数或其等价形式rm从环境中删除现有符号
ls()
rm(x)
ls()
rm(y,z)
ls()
rm(x)
#rm删除通过字符向量指定的对应符号
p <-1:10
q <- seq(1,20,5)
v <- c("p","q")
rm(list=v)
ls()
#清除环境中所有绑定物,rm和ls
rm(list=ls())
ls()
#修改全局选项
#getOption查看某一给定选项的值
#options修改它的值
#修改输出位数
#输入getOption(<TAB>)可以看到一列可用选项极其描述
#getOption("digits") 输出为7
123.12345678
0.10000002
0.10000002 - 0.1
1234567.12345678
getOption("digits")
1e10 + 0.5
options(digits = 15)
1e10 + 0.5
#options被调用，修改的选项即刻生效，影响后续的命令
options(digits = 7)
1e10 + 0.5
#修改警告级别
#指定warn选项的值管理警告级别
getOption("warn")
as.numeric("hello")
options(warn=-1)
as.numeric("hello")
f <- function(x,y){
  as.numeric(x) + as.numeric(y)
}
options(warn=0)
f("hello","world")

options(warn=1)
f("hello","world")

options(warn=2)
f("hello","world")

options(warn=0)

#管理扩展包库
#https://cran.rstudio.com/web/packages
#https://cran.rstudio.com/web/views/
#认识扩展包
#包的描述页 https://cran.rstudio.com/web/packages/ggplot2/
#包的网站 http://ggplot.org/
#包的源代码 https://github.com/hadley/ggplot2

install.packages(c("ggplot2","shiny","knitr","dplyr","data.table"))
#update.packages()
install.packages("devtools")
install_github("hadley/ggplot2")
#使用包的函数
#package::function只使用函数，而不将整个包加载到环境中
#计算数值向量x 的偏度
install.packages("moments")
library(moments)
skewness(x)

moments::skewness(x)
#sessionInfo查看使用的包是非常有用的
sessionInfo()
moments::skewness(c(1,2,3,2,1))
sessionInfo()
library(moments)
sessionInfo()

search()

loaded <- require(moments)
loaded

if(!require(moments)){
  install.packages("moments")
  library(moments)
}


require(moments)

require(testPkg)
library(testPkg)

#屏蔽和同名冲突
#dplyr简化表格数据的操作
library(dplyr)
fun1 <- package1::some_function
fun2 <- package2::some_function
#载入一个包，想要解除绑定
unloadNamespace("moments")
skewness(c(1,2,3,2,1))
moments::skewness(c(1,2,3,2,1))
#检查是否已安装扩展包
pkgs <- install.packages()
colnames(pkgs)

installed.packages()["moments","Version"]

packageVersion("moments")

packageVersion("moments") >= package_version("0.14")

packageVersion("moments") >="0.14"




































