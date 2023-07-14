install.packages("RSQLite")


if (file.exists("data/example.sqlite")) 
  file.remove("data/example.sqlite")


if (!dir.exists("data")) dir.create("data")


library(RSQLite)
con <- dbConnect(SQLite(), "data/example.sqlite")


example1 <- data.frame(
  id = 1:5, 
  type = c("A", "A", "B", "B", "C"),
  score = c(8, 9, 8, 10, 9), 
  stringsAsFactors = FALSE)
example1


dbWriteTable(con, "example1", example1)


dbDisconnect(con)


if (file.exists("data/datasets.sqlite")) 
  file.remove("data/datasets.sqlite")


install.packages(c("ggplot2", "nycflights13"))


data("diamonds", package = "ggplot2")
data("flights", package = "nycflights13")


con <- dbConnect(SQLite(), "data/datasets.sqlite")
dbWriteTable(con, "diamonds", diamonds, row.names = FALSE)
dbWriteTable(con, "flights", flights, row.names = FALSE)
dbDisconnect(con)


class(diamonds)
class(flights)


con <- dbConnect(SQLite(), "data/datasets.sqlite")
dbWriteTable(con, "diamonds", as.data.frame(diamonds), row.names = FALSE)
dbWriteTable(con, "flights", as.data.frame(flights), row.names = FALSE)
dbDisconnect(con)


if (file.exists("data/example2.sqlite")) 
  file.remove("data/example2.sqlite")


con <- dbConnect(SQLite(), "data/example2.sqlite")
chunk_size <- 10
id <- 0
for (i in 1:6) {
  chunk <- data.frame(id = ((i - 1L) * chunk_size):(i * chunk_size - 1L), 
    type = LETTERS[[i]],
    score = rbinom(chunk_size, 10, (10 - i) / 10),
    stringsAsFactors = FALSE)
  dbWriteTable(con, "products", chunk, 
    append = i > 1, row.names = FALSE)
}
dbDisconnect(con)


con <- dbConnect(SQLite(), "data/datasets.sqlite")


dbExistsTable(con, "diamonds")
dbExistsTable(con, "mtcars")


dbListTables(con)

#列出这张表的列名
dbListFields(con, "diamonds")
#dbReadTable读入一个数据框
db_diamonds <- dbReadTable(con,"diamonds")
dbDisconnect(con)

head(db_diamonds,3)
head(diamonds,3)

#identical比较
identical(diamonds,db_diamonds)


str(db_diamonds)

str(diamonds)

#sql对关系型数据库进行查询
con <- dbConnect(SQLite(),"data/datasets.sqlite")
dbListTables(con)
#select选取diamonds数据，dbGetQuery数据库连接con和查询语句作为参数输入
db_diamonds <- dbGetQuery(con,"select * from diamonds")
head(db_diamonds,3)

#*代表所有的字段，
db_diamonds <- dbGetQuery(con,"select carat,cut,color,clarity,depth,price from diamonds")
head(db_diamonds,3)

#选取所有不重复的值，select distinct
dbGetQuery(con,"select distinct cut from diamonds")

#DBGetQuery返回一个数据框，一列，单列数据框
dbGetQuery(con,"select distinct clarity from diamonds")[[1]]

db_diamonds <- dbGetQuery(con,"select carat,price,clarity as clarity_level from diamonds")
head(db_diamonds,3)

db_diamonds <- dbGetQuery(con,"select carat,price,x*y*z as size from diamonds")
head(db_diamonds,3)

db_diamonds<- dbGetQuery(con,"select carat,price,x * y *z as size,price / size as value_density from diamonds")

db_diamonds <- dbGetQuery(con,"select *,price / size as value_density from (select  carat,price, x*y*z as size from diamonds)")
head(db_diamonds,3)

#where指明查询结构满足的条件
good_diamonds <- dbGetQuery(con,"select carat,cut,price from diamonds where cut =='Good'")
head(good_diamonds,3)

nrow(good_diamonds) / nrow(diamonds)

good_e_diamonds <- dbGetQuery(con,"select carat,cut,color,price from diamonds where cut='Good' and color = 'E'")
head(good_e_diamonds,3)

nrow(good_e_diamonds) / nrow(diamonds)

color_ef_diamonds <- dbGetQuery(con,"select carat,cut,color,price from diamonds where color in ('E','F')")
nrow(color_ef_diamonds)

table(diamonds$color)

some_price_diamonds <- dbGetQuery(con,"select carat,cut,color,price from diamonds where price between 5000 and 5500")
nrow(some_price_diamonds) / nrow(diamonds)

good_cut_diamonds <- dbGetQuery(con,"select carat,cut,color,price from diamonds where cut like '%Good%'")
nrow(good_cut_diamonds)/nrow(diamonds)

cheapest_diamonds <- dbGetQuery(con,"select carat,price from diamonds order by price")

head(cheapest_diamonds)

most_expensive_diamonds <- dbGetQuery(con,"select carat,price from diamonds order by price desc")
head(most_expensive_diamonds)

cheapest_diamonds <- dbGetQuery(con,"select carat,price from diamonds order by price,carat desc")
head(cheapest_diamonds)

dense_diamonds <- dbGetQuery(con,"select carat,price, x * y *z as size from diamonds order by carat / size desc")
head(dense_diamonds)

head(dbGetQuery(con,"select carat,price from diamonds where cut='Ideal' and clarity = 'IF'and color='J' order by price"))

dbGetQuery(con,"select carat,price from diamonds order by carat desc limit 3")

dbGetQuery(con,"select color,count(*) as number from diamonds group by color")

#table检查查询结果
table(diamonds$color)

dbGetQuery(con,"select clarity, avg(price) as avg_price from diamonds group by clarity order by avg_price desc")


dbGetQuery(con,"select price,max(carat) as max_carat from diamonds group by price order by price limit 5")

dbGetQuery(con,"select clarity,min(price) as min_price,max(price) as max_price,avg(price) as avg_price from diamonds group by clarity order by avg_price desc")


dbGetQuery(con,"select clarity,sum(price * carat) / sum(carat) as wprice from diamonds group by clarity order by wprice desc")

dbGetQuery(con,"select clarity,color,avg(price) as avg_price from diamonds group by clarity,color order by avg_price desc limit 5")

diamond_selector <- data.frame(
  cut = c("Ideal","Good","Fair"),
  color = c("E","I","D"),
  clarity = c("VS1","T1","IF"),
  stringsAsFactors = FALSE)
diamond_selector

dbWriteTable(con,"diamond_selector",diamond_selector,row.names=FALSE,overwrite=TRUE)

subset_diamonds <- dbGetQuery(con,"select cut,color,clarity,carat,price from diamonds join diamond_selector using (cut,color,clarity)")
head(subset_diamonds)

nrow(subset_diamonds) / nrow(diamonds)

dbDisconnect(con)

#分块提取查询结果
#dbSendQuery查询
con<- dbConnect(SQLite(),"data/datasets.sqlite")
res <- dbSendQuery(con,"select carat,cut,color,price from diamonds where cut='Ideal'and color='E'")
while(!dbHasCompleted(res)){
  chunk <- dbFetch(res,800)
  cat(nrow(chunk),"records fetched\n")
}

dbClearResult(res)
dbDisconnect(con)


#出于一致性考虑的事务操作
set.seed(123)
con <- dbConnect(SQLite(),"data/products.sqlite")
chunk_size <- 10
for (i in 1:6){
  cat("Processing chunk",i,"\n")
  if(runif(1) <= 0.2) stop("Data error")
  chunk <- data.frame(id=((i - 1L) * chunk_size): (i * chunk_size - 1L),
                      type = LETTERS[[i]],
                      score = rbinom(chunk_size,10,(10-i) /10),
                      stringsAsFactors = FALSE)
  dbWriteTable(con,"products",chunk,append = i > 1,row.names=FALSE)
}
dbGetQuery(con,"select COUNT(*) from products")
dbDisconnect(con)

set.seed(123)
file.remove("data/products.sqlite")
#dbBegin写入任意数据调用，变更完成后，dbCommit，出现错误调用dbRollback
con<- dbConnect(SQLite(),"data/products.sqlite")
chunk_size <- 10
dbBegin(con)
fes<- tryCatch({
  for (i in 1:6){
    cat("Processing chunk",i,"\n")
    if(runif(1) <= 0.2) stop("Data error")
    chunk <- data.frame(id = ((i - 1L) * chunk_size): (i * chunk_size - 1L),type=LETTERS[[i]],score = rbinom(chunk_size,10,(10-i)/10),
                        stringsAsFactors = FALSE)
    dbWriteTable(con,"products",chunk,append=i >1,row.names=FALSE)
  }
  dbCommit(con)
},error=function(e){
  warning("An error occurs: ",e,"\n Rolling back",immediate. = TRUE)
  dbRollback(con)
})

dbGetQuery(con,"select COUNT(*) from products")

dbDisconnect(con)

create_bank <- function(dbfile){
  if(file.exists(dbfile)) file.remove(dbfile)
  con <- dbConnect(SQLite(),dbfile)
  dbSendQuery(con,
              "create table accounts(name text primarykey key,balance real)")
  dbSendQuery(con,  "create table transactions(time text,account_from text,account_to text,value real)")
  con
}

create_account <- function(con,name,balance){
  dbSendQuery(con,
              sprintf("insert into accounts (name,balance) values ('%s','%.2f')",name,balance))
  TRUE
}

transfer <- function(con,from,to,value){
  get_account <- function(name){
    account <- dbGetQuery(con,
                          sprintf("select * from accounts where name = '%s'",name))
    if (nrow(account) == 0)
      stop(sprintf("Account '%s' does nor exist",name))
    account
  }
  account_from <- get_account(from)
  account_to <- get_account(to)
  if(account_from$balance < value){
    stop(sprintf("Insufficient money to transter from '%s'",from))}
  else{
    dbSendQuery(con,
                sprintf("update accounts set balance=%.2f where name = '%s'",account_from$balance - value,from))
    dbSendQuery(con,
                sprintf("update accounts set balance=%.2f where name = '%s'",account_to$balance + value ,to))
    dbSendQuery(con,sprintf("insert into transactions (time,account_from,account_to,value) values ('%s','%s','%s',%.2f)",format(Sys.time(),"%Y-%m-%d %H:%M:%S"),from,to,value))
    
  }
  TRUE
}

safe_transfer <- function(con,...){
  dbBegin(con)
  tryCatch({
    transfer(con,...)
    dbCommit(con)
  },error = function(e){
    message("An error occurs in the transaction. Rollback...")
    dbRollback(con)
    stop(e)
  })
}

get_balance <- function(con,name){
  res <- dbGetQuery(con ,sprintf("select balance from accounts where name = '%s'",name))
  res$balance
}
get_transactions <- function(con,from,to){
  dbGetQuery(con,
             sprintf("select * from transactions where account_from = '%s' and account_to = '%s'",from ,to))
}

#create_bank创建一个虚拟银行，返回一个指向数据库文件的sqlite连接
con <- create_bank("data/bank.sqlite")
create_account(con,"David",5000)
create_account(con,"Jenny",6500)
get_balance(con,"David")
get_balance(con,"Jenny")

safe_transfer(con,"David","Jenny",1500)
get_balance(con,"David")
get_balance(con,"Jenny")

safe_transfer(con,"David","Jenny",6500)
get_balance(con,"David")
get_balance(con,"Jenny")

get_transactions(con,"David","Jenny")

dbDisconnect(con)

#多个文件的数据存入一个数据库
chunk_rw <- function(input,output,table,chunk_size = 10000){
  first_row <- read.csv(input,nrows=1,header=TRUE)
  header <- colnames(first_row)
  n <- 0
  con <- dbConnect(SQLite(),output)
  on.exit(dbDisconnect(con))
  while (TRUE){
    df <- read.csv(input,skip=1 + n * chunk_size,nrows=chunk_size,header=FALSE,col.names=header,stringsAsFactors = FALSE)
    if(nrow(df)==0) break
    dbWriteTable(con,table,df,row.names=FALSE,append = n > 0)
    n <- n+1
    cat(sprintf("%d records written\n",nrow(df)))
  }
}

#diamonds写入一个csv文件，chunk_rw将csv文件写入sqlite数据库
write.csv(diamonds,"data/diamonds.csv",quote=FALSE,row.names=FALSE)
chunk_rw("data/diamonds.csv","data/diamonds.sqlite","diamonds")

batch_rw <- function(dir,output,table,overwrite=TRUE){
  files <- list.files(dir,"\\.csv$",full.names = TRUE)
  con <- dbConnect(SQLite(),output)
  on.exit(dbDisconnect(con))
  exist <- dbExistsTable(con,table)
  if(exist){
    if(overwrite) dbRemoveTable(con,table)
    else stop(sprintf("Table '%s' already exists",table))
  }
  exist <- FALSE
  for(file in files){
    cat(file,"...")
      df <- read.csv(file,header = TRUE,stringsAsFactors = FALSE)
      dbWriteTable(con,table,df,row.names=FALSE,append = exist)
      exist <- TRUE
    cat("done\n")
  }
}
#batch_rw数据库导入数据库
batch_rw("data/groups","data/groups.sqlite","groups")
con <- dbConnect(SQLite(),"data/groups.sqlite")
dbReadTable(con,"groups")


dbDisconnect(con)


#操作非关系型数据库
#mongodb操作 
#1.用mongodb查询数据
# https://cran.r-project.org/src/contrib/Archive/ElemStatLearn/ElemStatLearn_2015.6.26.tar.gz

mongolite <- "E:/ryuyanxuexi/mongolite_2.7.2.tar.gz"
install.packages(mongolite, repos=NULL, type="source")
library(mongolite)
m <- mongo("products","test","mongodb://localhost")
m$count()
m$insert(
  '{"code":"A0000001","name":"Product-A","type":"Type-I","price":29.5,"amount":500,"comments":[
  {
  "user":"david",
  "score":8,
  "text":"This is a good product"
  },
  {
  "user":"jenny",
  "score":5,
  "text":"Just so so"
  }
  ]
  }')

m$count()

m$insert(list(
  code = "A0000002",
  name = "Product-B",
  type = "Type-II",
  price = 59.9,
  amount = 200L,
  comments = list(
    list(user = "tom",score = 6L,text = "Just fine"),
    list(user = "mike",score = 9L,text = "great product")
  )
),auto_unbox = TRUE)

#auto_unbox=TRUE单元素转换为json的标量，没有设置auto_unbox=TRUE，用jsonlite::unbox确保标量输出或用()确保数组输出
m$count()

#m$find取出集合的所有文档
products <- m$find()

str(products)

#m$iterate集合中进行迭代
iter <- m$iterate()
products <- iter$batch(2)
str(products)

#m$find声明条件查询及字段筛选集合
m$find('{"code":"A0000001"}','{"_id":0,"name":1,"price":1,"amount":1}')

m$find('{"price":{"$gte":40}}','{"_id":0,"name":1,"price":1,"amount":1}')

m$find('{"comments.score":9}','{"_id":0,"code":1,"name":1}')

m$find('{"comments.score":{"$lt":6}}','{"_id":0,"code":1,"name":1}')

#m$insert处理r数据框
m <- mongo("students","test","mongodb://localhost")
m$count()

students <- data.frame(
  name = c("David","Jenny","Sara","John"),
  age = c(25,23,26,23),
  major = c("Statistics","Physics","Computer Science","Statistics"),
  projects = c(2,1,3,1),
  stringsAsFactors = FALSE
)

students


m$insert(students)

m$count()

m$find()

m$find('{"name":"Jenny"}')

m$find('{"projects":{"$gte":2}}')


m$find('{"projects":{"$gte":2}}','{"_id":0,"name":1,"major":1}')

m$find('{"projects":{"$gte":2}}',fields ='{"_id":0,"name":1,"age":1}',sort='{"age":-1}')
#limit限制返回文档的数量
m$find('{"projects":{"$gte":2}}',fields ='{"_id":0,"name":1,"age":1}',sort='{"age":-1}',limit=1)
m$distinct("major")

m$distinct("major",'{"projects":{"$gte":2}}')

#upodate找到所有文档，设置特定字段的取值
m$update('{"name":"Jenny"}','{"$set":{"age":24}}')

m$find

#创建或移除索引
m$index('{"name":1}')

m$find('{"name":"Sara"}')

m$find('{"name":"Jane"}')

#drop删除集合
m$drop()

set.seed(123)
m <- mongo("simulation","test")
sim_data <- expand.grid(
  type = c("A","B","C","D","E"),
  category = c("P-1","P-2","P-3"),
  group = 1:20000,
  stringsAsFactors = FALSE)
head(sim_data)

sim_data$score1 <- rnorm(nrow(sim_data),10,3)
sim_data$score2 <- rbinom(nrow(sim_data),100,0.8)

head(sim_data)

m$insert(sim_data)
system.time(rec <- m$find('{"type":"C","category":"P-3","group":87}'))

rec
system.time({
  recs <- m$find('{"type":{"$in":["B","D"]},"category":{"$in":["P-1","P-2"]},"group":{"$gte":25,"$lte":75}}')
})

head(recs)
system.time(recs2 <- m$find('{"score1":{"$gte":20}}'))

head(recs2)

m$index('{"type":1,"category":1,"group":1}')

system.time({
  rec <- m$find('{"type":"C","category":"P-3","group":87}')
})

system.time({
  recs <- m$find('{"type":{"$in":["B","D"]},"category":{"$in":["P-1","P-2"]},"group":{"$gte":25,"$lte":75}}')
})

system.time({
  recs2 <- m$find('{"score1":{"$gte":20}}')
})

m$aggregate('[
            {"$group":{
            "_id":"$type",
            "count":{"$sum":1},
            "avg_score":{"$avg":"$score1"},
            "min_test":{"$min":"$test1"},
            "max_test":{"$max":"$test1"}
            }
            }
          ]')

m$aggregate('[
            {"$group":{
            "_id":{"type":"$type","category":"$category"},
            "count":{"$sum":1},
            "avg_score":{"$avg":"$score1"},
            "min_test":{"$min":"$test1"},
            "max_test":{"$max":"$test1"}
            }
            }
            ]')

#聚合管到支持以流线形式运行聚合操作
m$aggregate('[
            {"$group":{
            "_id":{"type":"$type","category":"$category"},
            "count":{"$sum":1},
            "avg_score":{"$avg":"$score1"},
            "min_test":{"$min":"$test1"},
            "max_test":{"$max":"$test1"}
            }}]')


m$aggregate('[
            {"$group":{
            "_id":{"type":"$type","category":"$category"},
            "count":{"$sum":1},
            "avg_score":{"$avg":"$score1"},
            "min_test":{"$min":"$test1"},
            "max_test":{"$max":"$test1"}
            }
            },
            {
            "$sort":{"avg_score":-1}
            },
            {
            "$limit":3
            },
            {
            "$project":{
               "_id.type":1,
               "_id.category":1,
               "avg_score":1,
               "test_range":{"$subtract":["$max_test","$min_test"]}
            }
            }
            ]')

#https://docs.mongodb.com/manual/reference/operator/aggregation-pipeline/
#https://en.wikipedia.org/wiki/MapReduce  MapReduce
bins <- m$mapreduce(
  map = 'function(){
  emit(Math.floor(this.score1 / 2.5) * 2.5,1);}',
  reduce = 'function(id,counts){
  return Array.sum(counts);}'
)
#map所有数值都映射到一个键-值对上
#reduce 聚合键-值对
bins

with(bins,barplot(value / sum(value),name.arg = `_id`,main="Histogram of scores",xlab="score1",ylab="Percentage"))

m$drop()
#https://docs.mongodb.com/manual/tutorial
#使用redis
#用r访问redis
rredis <- "E:/ryuyanxuexi/rredis_1.7.0.tar.gz"
install.packages(rredis, repos=NULL, type="source")
library(rredis)
redisConnect(host="127.0.0.1",port=6379)
redisSet("num1",100)
redisGet("num1")





























