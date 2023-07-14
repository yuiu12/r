#字符串的使用
#字符串入门
#打印文本
"Hello"
str1 <- "Hello"
str1
for(i in 1:3){
  "Hello"
}
test1 <- function(x){
  "Hello"
  x
}
test1("World")

test2<-function(x){
  "Hello"
}
test2("World")

print(str1)

for(i in 1:3){
  print(str1)
}

test3<- function(x){
  print("Hello")
  x
}
test3("World")

cat("Hello")

name<-"Ken"
language <-"R"
cat("Hello,",name,"- a user of",language)

cat("Hello, ",name,", a user of",language,".")

cat("Hello, ",name,", a user of",language,".",sep = "")

#message相对严肃场合使用，陈述重要事件，其输出文本更引人注明。
#message和cat的区别，message不会自动使用空格分隔符来连接输入字符串
message("Hello, ",name,", a user of",language,".")
#message我们手动加上空格分隔符
#message会自动以换行符作为文本结尾，cat不会
for(i in 1:3){
  cat(letters[[i]])
}
for (i in 1:3){
  message(letters[[i]])
}
#cat输入的字符串不会被换行打印
#message每输入一共字符会出现在新的一行中
#cat每个字母输出在新行中，明确地在输入添加一个换行符
for(i in 1:3){
  cat(letters[[i]],"\n",sep="")
}

#连接字符串
#paste连接多个字符向量的函数，用空格作为默认分隔符
paste("Hello","World")

paste("Hello","World",sep="-")

#不需要分隔符，设定sep="",或者使用paste0()
paste0("Hello","World")

#cat只是在控制台打印字符串，paste返回字符串以便后续使用，cat打印了连续好的字符串，返回NULL
value1 <- cat("Hello","World")

value1

value2 <- paste("Hello","World")
value2
#cat打印了字符串，paste创建了一共新的字符向量
paste(c("A","B"),c("C","D"))
#paste自动匹配元素
#设定collapse=使两个元素再次连接
paste(c("A","B"),c("C","D"),collapse = ", ")


result <- paste(c("A","B"),c("C","D"),collapse = "\n") 
result
cat(result)
#转换文本
#1.转换大小写
#tolower将文本转换小写字母，toupper相反
tolower("Hello")
toupper("Hello")
calc <- function(type,x,y){
  type <- tolower(type)
  if(type == "add"){
    x+y
  }else if(type=="times"){
    x*y
  }else{
    stop("Not supported type of command")
  }
}
c(calc("add",2,3),calc("Add",2,3),calc("TIMES",2,3))

toupper(c("Hello","World"))
#2,字符计数
#nchar简单计算一共字符向量中每个元素的字符数量
nchar("Hello")
nchar(c("Hello","R","User"))
store_student <- function(name,age){
  stopifnot(length(name) == 1,nchar(name) >= 2,is.numeric(age),age>0)
  #将信息存储到数据库中
}
#相当于poyhton中assert函数， 用于嵌入函数中， 在检测某一确定的变量或条件是否为真， 如果判断为假，则为终止程序。
store_student("James",20)
store_student("P",23)

#nchar(x) == 0 和x=="" 是等价的，检查空字符串

#3.消除首末空白
store_student(" P",23)

#r3.2.0版本加入了trimws消除给定字符串开头和结尾的空白
store_student2 <- function(name,age){
  stopifnot(length(name) == 1,nchar(trimws(name))>=2,is.numeric(age),age>0)
  #将信息存储到数据库中
}

store_student2(" P",23)

trimws(c(" Hello","World "),which = "left")
#子字符串
#substr对字符向量中的文本构建子集
dates<- c("Jan 3","Feb 10","Nov 15")
substr(dates,1,3)
substr(dates,5,nchar(dates))

get_month_day <- function(x){
  months<- vapply(substr(tolower(x),1,3),function(md){
    switch(md,jan=1,feb=2,mar=3,apr=4,may=5,
           jun=6,jul=7,aug=8,sep=9,oct=10,nov=11,dec=12)
  },numeric(1),USE.NAMES = FALSE)
  days <- as.numeric(substr(x,5,nchar(x)))
  data.frame(month=months,day=days)
}
get_month_day(dates)

#substr替换一共给定的字符向量的字符串子集
substr(dates,1,3)<- c("Feb","Dec","Mar") 
dates


#切分文本
#strsplit指定分隔符将字符向量的文本且分开
strsplit("a,bb,ccc",split = ",")
students<-strsplit(c("Tony,26,Physics","James,25,Economics"),split = ", ")
students

#rbind数据放井矩阵中，并为矩阵赋予合适的列名
students_matrix <- do.call(rbind,students)
colnames(students_matrix) <- c("name","age","major")
students_matrix


students_df <- data.frame(students_matrix,stringsAsFactors = FALSE)
students_df$age <- as.numeric(students_df$age)
students_df

strsplit(c("hello","world"),split = "")

#格式化文本
cat(paste("#",1:nrow(students_df),",name:",students_df$name,",age:",students_df$age,",major: ",students_df$major,sep=""),sep="\n")

cat(sprintf("#%d,name:%s, age: %d,major: %s",1:nrow(students_df),students_df$name,students_df$age,students_df$major),sep="\n")


sprintf("The length of the line is approximately %.1fmm",12.295)

sprintf("The ratio is %d%%",10)


#在R中使用python字符串函数
sprintf("%s,%d years old ,majors in %s and loves %s","James",25,,"Physics","Physics")

install.packages("pystr")
library(pystr)
pystr <- "E:/ryuyanxuexi/pystr_2.0.0.tar.gz"
install.packages(pystr,repos=NULL,type="source")

library(pystr)
pystr_format("{1},{2} years old,majors in {3} and loves {3}.","James",25,"Physics","Physics")

pystr_format("{name},{age} years old,majors in {major} and loves {major}.",name="James",age=25,major="Physics")

#格式化日/时间
#Sys.Date返回当前日期，Sys.time返回当前时间
Sys.Date()
Sys.time()
current_date <- Sys.Date()
as.numeric(current_date)

current_time <- Sys.time()
as.numeric(current_time)

#将文本解析为日期/时间
as.Date(1000,"1970-01-01")
my_date <- as.Date("2016-02-10")
my_date
my_date + 3

my_date + 80

my_date - 65

date1 <- as.Date("2014-09-28")
date2 <- as.Date("2015-10-20")
date2-date1

as.numeric(date2-date1)

#使用as.POSTIXct或as.POSTIXlt文本创建日期时间。POSTIX标准下对日期/时间对象的不同实现，as.POSTIXlt创建一共日期/时间对象
my_time<-as.POSIXct("2016-02-10 10:25:31")
my_time

my_time +10
my_time +12345
my_time -1234567

as.Date("2015.07.25")
#as.Date字符串解析为日期
as.Date("2015.07.25",format="%Y.%m.%d")

as.POSIXct("7/25/2015 09:30:25",format="%m/%d/%Y %H:%M:%S")

#字符串转换成时间的函
strptime("7/25/2015 09:30:25","%m/%d/%Y %H:%M:%S")

as.Date(c("2015-05-01","2016-02-12"))

as.Date("2015-01-01") + 0:2

strptime("7/25/2015 09:30:25","%m/%d/%Y %H:%M:%S") + 1:3

as.Date("20150610",format="%Y%m%d")

strptime("20150610093215","%Y%m%d%H%M%S")

datetimes<-data.frame(date=c(20150601,20150603),time=c(92325,150621))
dt_text <- paste0(datetimes$date,datetimes$time)
dt_text
strptime(dt_text,"%Y%m%d%H%M%S")

#格式化日期/时间为字符串
my_date


#as.character 日期转换成标准形式的字符串
date_text <- as.character(my_date)
date_text
date_text + 1

as.character(my_date,format="%Y.%m.%d")

format(my_date,"%Y.%m.%d")

my_time

format(my_time,"date: %Y-%m-%d,time: %H:%M:%S")

#?strptime阅读相关文档
#lubridate(https://cran.r-project.org/web/packages/lubridate)

#使用正则表达式
#read.csv正确表头和数据类型将csv文件导入为数据框
read.csv("E:/ryuyanxuexi/messages.txt",header=FALSE)
#正则表达式(https://en.wikipedia.org/wiki/Regular_expression)
#寻找字符串模式
#^  这个符号一行的开始
#\w符号一个字母
#\s  空格字符
#\d  一共数字字符
#$ 一行的结束
fruits <- readLines("E:/ryuyanxuexi/fruits.txt")
fruits

matches <- grep("^\\w+:\\s\\d+$",fruits)
matches

fruits[matches]

grep("\\d",c("abc","a12","123","1"))

grep("^\\d$",c("abc","a12","123","1"))

#使用分组提取数据
library(stringr)
matches<- str_match(fruits,"^(\\w+):\\s(\\d+)$")
matches

#转换为数据框
fruits_df <- data.frame(na.omit(matches[, -1]),stringsAsFactors = FALSE)
#添加表头
colnames(fruits_df) <- c("fruit","quantity")
#将quantity的类型从字符转换整数
fruits_df$quantity <- as.integer(fruits_df$quantity)
fruits_df

#[0-9]从0到9的单个整数
#[a-z]从a到z的单个小写字母
#[A-Z] 从A到Z的单个大写字母
#.:任意单个符号
#*:一个模式出现零次、一次或者更多次
#+  一共模式出现一次或者更多次
#{n}  一共模式重复出现n次
#{m,n}一共模式出现m次，至多n次

telephone <- readLines("E:/ryuyanxuexi/telephone.txt")
telephone

telephone[grep("^\\d{3}-\\d{5}$",telephone)]

telephone[grep("^\\d{4}-\\d{4}$",telephone)]


#找出异常情况，grep1函数更好用，返回一共逻辑向量，指出每个元素是否匹配模式。
telephone[!grepl("^\\d{3}-\\d{5}$",telephone) & !grepl("^\\d{4}-\\d{4}$",telephone)]

#以自定义的方式读取数据
messages<- readLines("E:/ryuyanxuexi/messages.txt")
pattern <- "^(\\d+-\\d+-\\d+),(\\d+:\\d+:\\d+),(\\w+),(\\w+),\\s*(.+)$"
matches <- str_match(messages,pattern)
messages_df <- data.frame(matches[, -1])
colnames(messages_df) <- c("Date","Time","Sender","Receiver","Message")
messages_df


































