#操作关系型数据库
install.packages("RSQLite")

#创建一个sqlite数据库
if(!dir.exists("data")) dir.create("data")

library(RSQLite)
con <- dbConnect(SQLite(),"data/example.sqlite")

example1 <- data.frame(
  id = 1:5,
  type = c("A","A","B","B","C"),
  score = c(8,9,8,10,9),
  stringsAsFactors = FALSE)
example1


dbWriteTable(con,"example1",example1)
#断开数据库连接
dbDisconnect(con)

#向一个数据库写入多张表格
install.packages(c("ggplot2","nycflights13"))
#data载入数据框
data("diamonds",package = "ggplot2")
data("flights",package = "nycflights13")


con <- dbConnect(SQLite(), "data/datasets.sqlite")
dbWriteTable(con, "diamonds", diamonds, row.names = FALSE)
dbWriteTable(con, "flights", flights, row.names = FALSE)
dbDisconnect(con)
#检查这两个变量的类
class(diamonds)
class(flights)
#diamonds和flights不仅是一般的data.frame类型，更复杂的数据结构，写入数据库，as.data.frame转换普通的数据框对象
con <- dbConnect(SQLite(), "data/datasets.sqlite")
dbWriteTable(con, "diamonds", as.data.frame(diamonds), row.names = FALSE)
dbWriteTable(con, "flights", as.data.frame(flights), row.names = FALSE)
dbDisconnect(con)

#2.向表中追加数据
con <-  dbCanConnect(SQLite(),"data/example2.sqlite")
chunk_size <- 10
id <-0
for(i in 1:6){
  chunk <- data.frame(id=((i-1L) * chunk_size):(i * chunk_size-1L),
                      type=LETTERS[[i]],
                      score=rbinom(chunk_size,10,(10-i)/10),
                      stringsAsFactors = FALSE)
  dbWriteTable(con,"products",chunk,append=i > 1,row.names=FALSE)
}
dbDisconnect(con)

#访问表和表中字段
con <- dbConnect(SQLite(),"data/datasets.sqlite")
#检查数据库是否存在某种表
dbExistsTable(con,"diamonds")
dbExistsTable(con,"mtcars")
#列出数据库所有表
dbListTables(con)

dbListFields(con,"diamonds")
































































