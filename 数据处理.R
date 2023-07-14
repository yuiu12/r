#读写数据
#读写文件中的文本格式数据
#内置函数导入数据
readLines("E:/ryuyanxuexi/persons (2).csv")

readLines("E:/ryuyanxuexi/persons (2).csv",n=2)

persons1<-read.csv("E:/ryuyanxuexi/persons (2).csv",stringsAsFactors = FALSE)
str(persons1)

#colClasses明确指定列的类型，col.names替换数据文件的原始列名
persons2 <- read.csv("E:/ryuyanxuexi/persons (2).csv",colClasses =c("character","factor","integer","character"),col.names =c("name","sex","age","major"))
str(persons2)

#read.table导入数据
#readr包导入数据
install.packages("readr")
persons3<- readr::read_csv("E:/ryuyanxuexi/persons (2).csv")
str(persons3)

read.table("E:/ryuyanxuexi/persons.txt",sep=" ")

readr::read_table("E:/ryuyanxuexi/persons.txt")

#readr更多信息   https://github.com/hadley/readr


#将数据框写入文件
some_data<-data.frame(
  id = 1:4,
  grade= c("A","A","B",NA),
  width = c(1.51,1.52,1.46,NA),
  check_date = as.Date(c("2016-03-05","2016-03-06","2016-03-10","2016-03-11")))
some_data
write.csv(some_data,"E:/ryuyanxuexi/some_data.csv")

cat(readLines("E:/ryuyanxuexi/some_data.csv"),sep="\n")

write.csv(some_data,"E:/ryuyanxuexi/some_data.csv",quote=FALSE,na="-",row.names = FALSE)

cat(readLines("E:/ryuyanxuexi/some_data.csv"),sep="\n")

#readr::read_csv导入这个自定义缺失值和日期的csv文件
readr::read_csv("E:/ryuyanxuexi/some_data.csv",na="-")

#读取excel工作表
install.packages("readxl")
readxl::read_excel("E:/ryuyanxuexi/prices.xls")
#openxlsx读取，写入和编辑xlsx文件
install.packages("openxlsx")
install.packages(c("Rcpp", "devtools"), dependencies = TRUE)
library(devtools)
install_github("ycphs/openxlsx")
library("openxlsx")
#openxlsx调用read.xlsx指定工作簿的数据读入数据框
openxlsx::read.xlsx("E:/ryuyanxuexi/prices.xlsx",detectDates = TRUE)
openxlsx::write.xlsx(mtcars,"E:/ryuyanxuexi/mtcars.xlsx")
#XLConnect http://cran.r-project.org/web/packages/XLConnect 跨平台的excel，不依赖于execl，依赖于安装的java运行环境
#RODBC  http://cran.r-project.org/web/packages/RODBC 通用的数据库连接器

#读写原生数据文件
#从原生数据文件读写单个对象
#saveRDSsome_data保存为
saveRDS(some_data,"E:/ryuyanxuexi/some_data.rds")
some_data2 <- readRDS("E:/ryuyanxuexi/some_data.rds")
#identical检验一共数据框是否一样
identical(some_data,some_data2)

rows <- 200000
large_data <- data.frame(id=1:rows,x=rnorm(rows),y=rnorm(rows))
system.time(write.csv(large_data,"E:/ryuyanxuexi/large_data.csv"))
system.time(saveRDS(large_data,"E:/ryuyanxuexi/large_data.rds"))

fileinfo <- file.info("E:/ryuyanxuexi/large_data.csv","E:/ryuyanxuexi/large_data.rds")
fileinfo[, "size",drop=FALSE]

system.time(read.csv("E:/ryuyanxuexi/large_data.csv"))

system.time(readr::read_csv("E:/ryuyanxuexi/large_data.csv"))

system.time(readRDS("E:/ryuyanxuexi/large_data.rds"))


nums<- c(1.5,2.5,NA,3)
list1 <- list(x=c(1,2,3),y=list(a=c("a","b"),b=c(NA,1,2.5)))
saveRDS(nums,"E:/ryuyanxuexi/nums.rds")
saveRDS(list1,"E:/ryuyanxuexi/list1.rds")

readRDS("E:/ryuyanxuexi/nums.rds")
readRDS("E:/ryuyanxuexi/list1.rds")


#保存和恢复工作环境
save(some_data,nums,list1,file="E:/ryuyanxuexi/bundle1.RData")

rm(some_data,nums,list1)
load("E:/ryuyanxuexi/bundle1.RData")

some_data

nums

list1

#加载内置数据集
head(iris)

str(iris)

head(mtcars)

str(mtcars)

install.packages("ggplot2")

data("diamonds",package = "ggplot2")
dim(diamonds)

head(diamonds)

install.packages(c("nycflights13","babynames"))

#数据可视化
plot(1:10)

x<-rnorm(100)
y <- 2*x +rnorm(100)
plot(x,y)

#1.自定义图形元素
plot(x,y,main="Linearly correlated random numbers",xlab="x",ylab="2x+noise",xlim=c(-4,4),ylim = c(-4,4))

plot(x,y,xlim=c(-4,4),ylim=c(-4,4),xlab="x",ylab="2x + noise")
title("Linearly correlated random numbers")

#2.自定义点的类型
#pch参数，更改点的样式
plot(0:25,0:25,pch=0:25,xlim=c(-1,26),ylim=c(-1,26),main="Point styles (pch)")
text(0:25+1,0:25,0:25)

x <- rnorm(100)
y <- 2 *x + rnorm(100)
plot(x,y,pch=16,main="Scatter plot with customized point style")


plot(x,y,pch=ifelse(x * y >1 ,16,1),main="Scatter plot with conditional point styles")

z<- sqrt(1 + x ^2) +rnorm(100)
plot(x,y,pch=1,xlim=range(x),ylim = range(y,z),xlab="x",ylab="value")
points(x,z,pch=17)
title("Scatter plot with two series")


#2.自定义点的颜色
#plot的颜色参数使用不同颜色标记点
#当pch取0~14时，其点为空心点，可以用col(颜色)参数设置其边框的颜色；
#当pch取15~20时，其点是实心点，可以用col参数设置其填充的颜色；
#当pch取21~25时，其点也是实心点，既可以用col参数设置边框的颜色，也可以用bg参数设置其内部的填充颜色。
plot(x,y,pch=16,col="blue",main="Scatter plot with blue points")

plot(x,y,pch=16,col=ifelse(y >=  mean(y),"red","green"),main="Scatter plot with conditional colors")



plot(x,y,col="blue",pch=0,xlim=range(x),ylim=range(y,z),xlab="x",ylab="value")
#现有的绘图中添加一组具有指定形状、大小和颜色的点
points(x,z,col="red",pch=1)
title("scatter plot with two series")

#创建折线图
#plot设置type=“l”
t <- 1:50
y <- 3 * sin(t * pi / 60) + rnorm(t)
plot(t,y,type="l",main="Sample line plot")


#1.自定义线的类型和宽度

lty_values <- 1:6
plot(lty_values,type="n",axes=FALSE,ann=FALSE)
abline(b=lty_values,lty=lty_values,lwd=2)
mtext(lty_values,side=2,at=lty_values)
title("Line types (lty)")

plot(t,y,type="l",lwd=2)
abline(h=mean(y),lty=2,col="blue")
abline(v = t[c(which.min(y),which.max(y))],lty=3,col="darkgray")
title("Line plot with auxiliary lines")


#2.绘制多阶段折线图
p <- 40
plot(t[t <= p],y[t <= p],type="l",xlim=range(t),xlab="t")
lines(t[t >= p],y[t>=p],lty=2)
title("Sample line plot with two periods")


#3.绘制带点的折线图
plot(y,type="l")
points(y,pch=16)
title("Lines with points")

plot(y,pch=16)
lines(y)
title("Lines with points")


#4.绘制带图例的多序列图
x <- 1:30
y <- 2 *x + 6 *rnorm(30)
z <- 3 * sqrt(x) + 8 * rnorm(30)
plot(x,y,type="l",ylim=range(y,z),col="black")
points(y,pch=15)
lines(z,lty=2,col="blue")
points(z,pch=16,col="blue")
title("Plot of two series")
legend("topleft",legend=c("y","z"),col=c("black","blue"),lty=c(1,2),pch=c(15,16),cex=0.8,x.intersp = 0.5,y.intersp = 0.8)

#cex设置图例的字体大小，x.intersp和y.intersp用于图例的微调
plot(x,y,type="s",main="A simple step plot")

#创建柱状图
barplot(1:10,names.arg=LETTERS[1:10])

ints <- 1:10
names(ints)<- LETTERS[1:10]
barplot(ints)

data("flights",package="nycflights13")
carriers <- table(flights$carrier)
carriers

#table计算记录中的每个航空公司的航班数量
sorted_carriers <- sort(carriers,decreasing = TRUE)
sorted_carriers

barplot(head(sorted_carriers,8),
        ylim=c(0,max(sorted_carriers) * 1.1),
        xlab = "Carrier",ylab="Flights",
        main="Top 8 carriers with the most flights in record")


#创建饼状图

#pie创建饼状图pie
grades <- c(A=2,B=10,C=12,D=8)
pie(grades,main="Grades",radius=1)

#创建直方图和密度图
random_normal <- rnorm(10000)
#hist服从正太分布的随机数值向量的直方图
hist(random_normal)

#dnorm 标准正太分布的概率密度函数曲线dnorm
hist(random_normal,probability = TRUE,col="lightgray")
curve(dnorm,add=TRUE,lwd=2,col="blue")

flight_speed <- flights$distance / flights$air_time
hist(flight_speed,main="Histogram of flight speed")

#density估计飞行速度的经验分布
plot(density(flight_speed,from=2,na.rm=TRUE),main="Empirical distribution of flight speed")
abline(v=mean(flight_speed,na.rm=TRUE),col="blue",lty=2)

hist(flight_speed,probability = TRUE,ylim=c(0,0.5),main="Histogram and empirical distribution of flight speed",
     border = "gray",col="lightgray")
lines(density(flight_speed,from=2,na.rm=TRUE),col="darkgray",lwd=2)
abline(v=mean(flight_speed,na.rm=TRUE),col="blue",lty=2)

#创建箱型图
x <- rnorm(1000)
boxplot(x)


#IQR=上四分位数-下四分位数
#异常值：上四分位数+1.5*IQR以外的值
#最大值
#上四分位数
#中位数
#下四分位数
#最小值
#异常值：下四分位数-1.5*IQR以外的值
boxplot(distance/ air_time ~ carrier,data=flights,main="Box plot of flight speed by carrier")

#y中代表distance/air_time的值，飞行速度，x轴不同的航空公司
#data=flights boxplot到哪里找公式指定的变量


#数据分析拟合线性模式
f <- function(x) 3 + 2 * x
x <- rnorm(100)
y <- f(x) + 0.5 * rnorm(100)

#lm线性模型拟合x和y关系，注意的是y~x表达式告诉lm这个线性回归是关于因变量y和单个回归元
model1 <- lm(y ~x)
model1
#coef 是一个通用函数，它从建模函数返回的对象中提取模型系数。
coef(model1)

#summary了解关于这个线性模型的统计性质
summary(model1)

plot(x,y,main="A simple linear regression")
abline(coef(model1),col="blue")

#predict对所拟合模型进行预测
predict(model1,list(x=c(-1,0.5)),se.fit=TRUE)


data("flights",package="nycflights13")
plot(air_time ~distance,data=flights,pch=".",main="flight speed plot")


rows <- nrow(flights)
rows_id <-1:rows
sample_id <- sample(rows_id,rows * 0.75,replace=FALSE)
flights_train <- flights[sample_id,]
flights_test <- flights[setdiff(rows_id,sample_id),]

model2 <- lm(air_time ~distance ,data=flights_train)
predict2_train <- predict(model2,flights_train)
error2_train <- flights_train$air_time - predict2_train

evaluate_error <- function(x){
  c(abs_err = mean(abs(x),na.rm=TRUE),std_dev=sd(x,na.rm=TRUE))
}

evaluate_error(error2_train)

predict2_test <- predict(model2,flights_test)
error2_test <- flights_test$air_time - predict2_test
evaluate_error(error2_test)

model3 <- lm(air_time ~ carrier + distance + month + dep_time,data=flights_train)

predict3_train <- predict(model3,flights_train)
error3_train <- flights_train$air_time - predict3_train
evaluate_error(error3_train)

predict3_test <- predict(model3,flights_test)
error3_test <- flights_test$air_time - predict3_test
evaluate_error(error3_test)

plot(density(error2_test,na.rm=TRUE),main="Empirical distributions of out-of-sample errors")
lines(density(error3_test,na.rm=TRUE),lty=2)
legend("topright",legend=c("model2","model3"),lty=c(1,2),cex=0.8,x.intersp = 0.6,y.intersp = 0.6)

#拟合回归树
#https://en.wikipedia.org/wiki/Decision_tree_learning
#扩展实现决策树学习算法party  https://cran.r-project.org/web/packages/party
install.packages("party")
library("party")
#ctree 不接受带有缺失值的响应变量
model4 <- party::ctree(air_time ~ distance + month + dep_time, 
                       data = subset(flights_train, !is.na(air_time)))
predict4_train <- predict(model4, flights_train)
error4_train <- flights_train$air_time - predict4_train[, 1]
evaluate_error(error4_train)

predict4_test <- predict(model4, flights_test)
error4_test <- flights_test$air_time - predict4_test[, 1]
evaluate_error(error4_test)

plot(density(error3_test,na.rm=TRUE),ylim=range(0, 0.06),main="Empirical distributions of out-of-sample errors")
lines(density(error4_test,na.rm=TRUE),lty=2)
legend("topright",legend=c("model3","model4"),lty=c(1,2),cex=0.8,x.intersp = 0.6,y.intersp = 0.6)





















