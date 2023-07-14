# ctrl +enter  运行选中的命令行
# ctrl + shift +S  执行当前文档，一次执行当前文档中的所有表达式
#tab 或ctrl+Space组合展示匹配当前输入变量和函数的自动补齐列表
#入门实例
#
#创建一个向量x，100个服从正态分布的随机数构成
#创建一个向量y，每一个数都是x中对应数的3倍加2
#加上一些随机噪声，<-赋值操作符，str函数输出向量的结构
x <- rnorm(100)
y <- 2 + 3 * x + rnorm(100) * 0.5
str(x)
#num [1:100] 0.4097 -1.038 -2.0157 -0.9386 0.0979 ...
str(y)
#num [1:100] 3.309 -1.421 -5.04 -0.603 2.422 ...
model1
#Call:
# lm(formula = y ~ x)

#Coefficients:
#  (Intercept)            x  
#2.058        3.072  
summary(model1)

plot(x,y,main="Simple linear regression")
#函数的作用是在一张图表上添加直线, 可以是一条斜线，通过x或y轴的交点和斜率来确定位置；也可以是一条水平或者垂直的线，
#只需要指定与x轴或y轴交点的位置就可以了
abline(model1$coefficients,col="blue")


































































































