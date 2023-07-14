#使用内置函数操作数据框
library(readr)
product_info <- read_csv("E:/ryuyanxuexi/product-info.csv")
product_info
sapply(product_info,class)
#使用内置函数操做数据框
product_info[product_info$type == 'toy',]

product_info[product_info$released =="no",]

product_info[,c("id","name","type")]

product_info[c("id","name","class")]

product_info[product_info$type == 'toy',c("name","class","released")]

subset(product_info,subset = type =="model" & released =="yes",select = name:class)
with(product_info,name[released =="no"])

with(product_info,table(type[released =="yes"]))


product_stats <- read_csv("E:/ryuyanxuexi/product-stats.csv")
product_stats

top_3_id <- unlist(product_stats[order(product_stats$size,decreasing = TRUE),"id"])[1:3]
product_info[product_info$id %in% top_3_id,]

product_table <- merge(product_info,product_stats,by = "id")
product_table

product_table[order(product_table$size),]

product_table[order(product_table$size,decreasing = TRUE),"name"][1:3]

product_table[order(product_table$weight,decreasing = TRUE),][product_table$type == "model",]

transform(product_table,released=ifelse(released=="yes",TRUE,FALSE),
          density = weight / size)

product_tests <- read_csv("E:/ryuyanxuexi/product-tests.csv")
product_tests
#na.omit删除所有包含缺失值的行
na.omit(product_tests)

#complete.cases返回有逻辑向量，某一行是否完整
complete.cases(product_tests)

product_tests[complete.cases(product_tests),"id"]

product_tests[!complete.cases(product_tests),"id"]

product_full <- merge(product_table,product_tests,by="id")
product_full

#tapply根据某一列对另一个列的数据进行统计
mean_quality1 <- tapply(product_full$quality,list(product_full$type),mean,na.rm=TRUE)
mean_quality1


str(mean_quality1)

is.array(mean_quality1)

mean_quality2 <- tapply(product_full$quality,list(product_full$type,product_full$class),mean,na.rm=TRUE)
mean_quality2

mean_quality2["model","vehicle"]


mean_quality3 <- with(product_full,tapply(quality,list(type,material,released),mean,na.rm=TRUE))
mean_quality3

str(mean_quality3)

mean_quality3["model","Wood","yes"]

#使用reshape2重塑数据框
toy_tests <- read_csv("E:/ryuyanxuexi/product-toy-tests.csv")
toy_tests

install.packages("reshape2")

#reshape::dcast转换数据
library(reshape2)
toy_quality <- dcast(toy_tests,date ~id,value.var="quality")
toy_quality
#填补缺失值方法末次观测值结转法(Last Observation Carried Forward LOCF)
#放缺失值后面紧跟着一个缺失值，就该非缺失值填补后面的缺失值，直到所有的缺失值都被填补完成zoo包提供了LOCF
install.packages("zoo")
zoo::na.locf(c(1,2,NA,NA,3,1,NA,2,NA))

toy_quality$T01 <- zoo::na.locf(toy_quality$T01)
toy_quality$T02 <- zoo::na.locf(toy_quality$T02)


toy_quality[-1] <- lapply(toy_quality[-1],zoo::na.locf)
toy_quality

toy_tests$ym <- substr(toy_tests$date,1,6)
toy_tests

toy_quality <- dcast(toy_tests,ym ~ id,value.var="quality")
toy_quality

toy_tests2 <- melt(toy_tests,id.vars=c("id","ym"),measure.vars = c("quality","durability"),variable.name="measure")
toy_tests2

library(ggplot2)
ggplot(toy_tests2,aes(x=ym,y=value)) + geom_point() + facet_grid(id ~ measure)

#通过sqldf包使用sql查询数据框
install.packages("sqldf")

library(sqldf)

product_info <- read.csv("E:/ryuyanxuexi/product-info.csv")
product_stats <- read.csv("E:/ryuyanxuexi/product-stats.csv")
product_tests <- read.csv("E:/ryuyanxuexi/product-tests.csv")
toy_tests <- read.csv("E:/ryuyanxuexi/product-toy-tests.csv")


sqldf("select * from product_info")

sqldf("select id,name,class from product_info")

sqldf("select id,name from product_info where released = 'yes'")

sqldf("select id,material,size/weight as density from product_stats")

sqldf("select * from product_stats order by size desc")

sqldf("select * from product_info join product_stats using (id)")

sqldf("select * from product_info where id in (select id from product_stats where material = 'Wood')")

sqldf("select waterproof,avg(quality),avg(durability) from product_tests group by waterproof")

sqldf("select id,avg(quality),avg(durability) from toy_tests group by id")

sqldf("select * from product_info join (select id,avg(quality),avg(durability) from toy_tests group by id) using (id)")

#使用sqldf和sql对数据框进行查询看上去轻松，局限性很明显
#第一，sqldf基于sqlite，sqlite数据库的局限性，自然也是这个包的局限性，内置的分组汇总函数是有限的。
#https://sqlite.org/lang_aggfunc.html函数如果需要更多函数
#第二，查询数据时，提供一串选择语句，当语句的某部分是由R变量决定时，动态生成sql语句就不那么方便
#第三，sql的局限性也是sqldf限制性。很难使用更加复杂的方法计算新列。
#r语言中，调用order就可以实现现有列计算出一个排序列，
#使用plyr包，
install.packages("plyr")

plyr::ddply(product_stats,"material",function(x){
  head(x[order(x$size,decreasing = TRUE),],1L)
})


plyr::ddply(toy_tests,"id",function(x){
  head(x[order(x$sample,decreasing = TRUE),],2)
})
#http://had.co.nz/plyr/
#https://github.com/hadley/plyr


#使用data.table包操作数据
#data.table提供一个加强版的data.frame，运行效率极高，能够处理合适内存的大数据集，[]实现了一个自然的数据操作语法
install.packages("data.table")

library(data.table)

dt <- data.table(x = 1:3,y = rnorm(3),z = letters[1:3])
dt

str(dt)

#data。table具体继承了什么，增强了什么
#载入产品数据。data.table中的fread函数来读取数据。fread函数非常快，内存效率很高
product_info <- fread("E:/ryuyanxuexi/product-info.csv")
product_stats <- fread("E:/ryuyanxuexi/product-stats.csv")
product_tests <- fread("E:/ryuyanxuexi/product-tests.csv")
toy_tests <- fread("E:/ryuyanxuexi/product-toy-tests.csv")

product_info

str(product_info)

product_info[1]

product_info[1:3]

#[]提供负值，排除对应记录行
product_info[-1]
#.N提取最后一行
product_info[.N]

product_info[c(1,.N)]

product_info[released == "yes"]

product_info[released == "yes",id]

product_info[released == "yes","id",with=FALSE]

product_info[released == "yes",c("id","name"),with=FALSE]

product_info[released == "yes",table(type,class)]

product_info[released == "yes",list(id,name)]

product_info[, list(id, name, released = released == "yes")]

product_stats[, list(id, material, size, weight, 
                     density = size / weight)]

#data.table为list提供了缩写.()
product_info[, .(id,name,type,class)]

product_info[released == "yes", .(id,name)]

product_stats[order(size,decreasing = TRUE)]

product_stats


#:=对列进行原地赋值的符号
product_stats[, density := size / weight]

product_stats

#:=代替已有的列
product_info[, released := released == "yes"]
product_info

#使用键获取行
#data.table索引支持，创建键，获取记录极其高效
setkey(product_info,id)

product_info

key(product_info)

#键获取记录
product_info["M01"]

product_stats["M01"]

#setkeyv设置键，只接受字符向量
setkeyv(product_stats,"id")

product_stats["M02"]

product_info[product_stats]

setkey(toy_tests,id,date)

toy_tests[.("T01",20160201)]

toy_tests["T01"]

toy_tests[.(20160201)]

toy_tests[.(20160201,"T01")]
#数据分组汇总
product_info[, .N,by=released]


product_info[, .N,by= .(type,class)]

product_tests[, mean(quality,na.rm=TRUE),by=.(waterproof)]

product_tests[, .(mean_quality = mean(quality,na.rm=TRUE)),by=.(waterproof)]


type_class_tests0 <- product_info[product_tests][released==TRUE,.(mean_quality = mean(quality,na.rm=TRUE),mean_durability = mean(durability,na.rm=TRUE)),by = .(type,class)]

type_class_tests0

key(type_class_tests0)

type_class_tests <- product_info[product_tests][released == TRUE,.(mean_quality = mean(quality,na.rm = TRUE),mean_durability = mean(durability,na.rm=TRUE)),keyby=.(type,class)]
type_class_tests

type_class_tests[.("model","vehicle"),mean_quality]

n <- 10000000
test1 <- data.frame(id=1:n,x=rnorm(n),y=rnorm(n))

system.time(row <- test1[test1$id == 876543,])

setDT(test1,key="id")
class(test1)

system.time(row <- test1[.(87654321)])

row

#重塑data.table
toy_tests[, ym :=substr(date,1,6)]
toy_quality <- dcast(toy_tests,ym ~ id,value.var="quality")
toy_quality


toy_tests2 <- dcast(toy_tests,ym ~ id,value.var = c("quality","durability"))
toy_tests2


key(toy_tests2)

toy_tests2[.(201602)]

sapply(toy_tests2,class)

toy_tests2["201602"]

class(20160101)
class(substr(20160101,1,6))

#使用原地设置函数
product_stats
setDF(product_stats)
class(product_stats)

#setDT任意的data.frame转换成data.table
setDT(product_stats,key="id")
class(product_stats)

setnames(product_stats,"size","volume")

product_stats

product_stats[, i := .I]
product_stats

setcolorder(product_stats,c("i","id","material","weight","volume","density"))
product_stats

#data.table中的动态作用域
market_data <- data.table(date = as.Date("2015-05-01")+0:299)
head(market_data)

set.seed(123)
market_data[, `:=`(
  price = round(30 * cumprod(1 + rnorm(300,0.001,0.05)),2),
  volume = rbinom(300,5000,0.8)
)]

head(market_data)

plot(price ~ date,data = market_data,type = "l",main="Market data")

market_data[, range(date)]

monthly <- market_data[,
                       .(open = price[[1]], high=max(price),
                         low = min(price),close=price[[.N]]),
                       keyby = .(year = year(date),month = month(date))]
head(monthly)

oldpar <- par(mfrow  = c(1,2))
market_data[, {
  plot(price ~ date,type = "l",
       main = sprintf("Market data (%d)",year))
  
},by = .(year = year(date))]
par(oldpar)

data("diamonds",package = "ggplot2")
setDT(diamonds)
head(diamonds)

diamonds[, {
  m <- lm(log(price) ~ carat + depth)
  as.list(coef(m))
},keyby = .(cut)]

average <- function(column){
  market_data[, .(average = mean(.SD[[column]])),
              by = .(year = year(date))]
}

average("price")

average("volume")




price_cols <- paste0("price",1:3)
market_data[, (price_cols) := lapply(1:3,function(i) round(price + rnorm(.N,0,5),2))]
head(market_data)

cols <- colnames(market_data)
price_cols <- cols[grep("^price",cols)]
price_cols

market_data[, (price_cols) := lapply(.SD,zoo::na.locf),.SDcols = price_cols]
#https://github.com/Rdatatable/data.table/wiki 查看data.table的完整功能列表
#https://www.datacamp.com/community/tutorials/data-table-cheat-sheet
#使用dplyr管道操作处理数据框
install.packages("dplyr")
library(readr)
product_info <- read_csv("E:/ryuyanxuexi/product-info.csv")
product_stats <- read_csv("E:/ryuyanxuexi/product-stats.csv")
product_tests <- read_csv("E:/ryuyanxuexi/product-tests.csv")
toy_tests <- read_csv("E:/ryuyanxuexi/product-toy-tests.csv")
library(dplyr)

select(product_info,id,name,type,class)

filter(product_info,released == "yes")

filter(product_info,released == "yes",type == "model")

#mutate函数创建一个新的数据框，新列，或者替换原数据的列
mutate(product_stats,density=size /weight)

#arrange创建一个新的数据框，按一个或多个列排序后的
arrange(product_stats,material,desc(size),desc(weight))
product_info_tests <- left_join(product_info,product_tests,by="id")
product_info_tests

#?dplyr::join这些连接操作的更多差异
#group_by创建一个分组后的表格，summarize汇总数据
summarize(group_by(product_info_tests,type,class),mean_quality = mean(quality,na.rm=TRUE),
          mean_durability = mean(durability,na.rm=TRUE))

product_info %>%
  filter(released == "yes") %>%
  inner_join(product_tests,by="id") %>%
  group_by(type,class) %>%
  summarize(
    mean_quality = mean(quality,na.rm = TRUE),
    mean_durability = mean(durability,na.rm = TRUE)) %>%
  arrange(desc(mean_quality))

d1 <- f1(d0,arg1)
d2 <- f2(d1,arg2)
d3 <- f3(d2,arg3)
f3(f2(f1(d0, arg1), arg2), arg3)


d0 %>%
  f1(arg1) %>%
  f2(arg2) %>%
  f3(arg3)

data(diamonds, package = "ggplot2")
plot(density(diamonds$price, from = 0),
     main = "Density plot of diamond prices")

diamonds$price %>%
  density(from = 0) %>%
  plot(main = "Density plot of diamonds prices")


models <- diamonds %>%
  group_by(cut) %>%
  do(lmod = lm(log(price) ~ carat, data = .))
models

models$lmod[[1]]


toy_tests %>%
  group_by(id) %>%
  arrange(desc(sample)) %>%
  do(head(.,3)) %>%
  summarize(
    quality = sum(quality * sample) / sum(sample),
    durability = sum(durability * sample) / sum(sample))

toy_tests %>%
  group_by(desc(sample))

toy_tests %>%
  group_by(id) %>%
  arrange(desc(sample)) %>%
  do(head(., 3))


#dplyr 指南 https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
#https://www.datacamp.com/courses/dplyr-data-manipulation-r-tutorial

#使用rlist包处理嵌套数据结构
#针对列表对象的映射、筛选、选择、排序、分组和聚合功能
install.packages("rlist")
library(rlist)

products <- list.load("E:/ryuyanxuexi/products.json")
str(products)

str(list.map(products,id))

list.mapv(products,name)

released_products <- list.filter(products,released)
list.mapv(released_products,name)

products %>%
  list.filter(released) %>%
  list.mapv(name)

products %>%
  list.filter(released,test$waterproof) %>%
  list.select(id,name,scores) %>%
  str()


products %>%
  list.filter(mean(scores) >= 8) %>%
  list.select(name,scores,mean_score=mean(scores)) %>%
  str()


products %>%
  list.select(name,mean_score = mean(scores)) %>%
  list.sort(-mean_score) %>%
  list.stack()


products %>%
  list.select(name,type,released) %>%
  list.group(type) %>%
  str()

products %>%
  list.table(type,class)

products %>%
  list.filter(released) %>%
  list.table(type, waterproof = tests$waterproof)

products %>%
  list.filter(length(scores) >= 5) %>%
  list.sort(-mean(scores)) %>%
  list.take(2) %>%
  list.select(name, 
              mean_score = mean(scores),
              n_score = length(scores)) %>%
  list.stack()

#rlist  https://renkun.me/rlist-tutorial
#purrr https://github.com/hadley/purrr


