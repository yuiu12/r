x <- c(1,2,3,4,5)
y <- numeric()
sum_x <- 0
for(xi in x){
  sum_x <- sum_x + xi
  y <- c(y,sum_x)
}
y

my_cumsum1 <- function(x){
  y <- numeric()
  sum_x <- 0
  for(xi in x){
    sum_x <- sum_x + xi
    y <- c(y,sum_x)
  }
  y
}

my_cumsum2 <- function(x){
  y <- numeric(length(x))
  if(length(y)){
    y[[1]] <- x[[1]]
    for(i in 2:length(x)){
      y[[i]] <- y[[i - 1]] + x[[i]]
    }
  }
}

x <- rnorm(100)
all.equal(cumsum(x),my_cumsum1(x))
all.equal(cumsum(x),my_cumsum2(x))

#测试代码性能
x <- rnorm(100)
system.time(my_cumsum1(x))

system.time(my_cumsum2(x))


#内置函数cumsum
system.time(cumsum(x))

x <- rnorm(1000)
system.time(my_cumsum1(x))
system.time(my_cumsum2(x))
system.time(cumsum(x))

x <- rnorm(10000)
system.time(my_cumsum1(x))
system.time(my_cumsum2(x))
system.time(cumsum(x))

x <- rnorm(100000)
system.time(my_cumsum1(x))
system.time(my_cumsum2(x))
system.time(cumsum(x))


install.packages("microbenchmark")

library(microbenchmark)
x <- rnorm(100)
microbenchmark(my_cumsum1(x),my_cumsum2(x),cumsum(x))

x <- rnorm(1000)
microbenchmark(my_cumsum1(x),my_cumsum2(x),cumsum(x))


x <- rnorm(5000)
microbenchmark(my_cumsum1(x),my_cumsum2(x),cumsum(x))

x <- rnorm(10000)
microbenchmark(my_cumsum1(x),my_cumsum2(x),cumsum(x),times=10)

library(data.table)
benchmark <- function(ns,times=30){
  results <- lapply(ns,function(n){
    x <- rnorm(n)
    result <- microbenchmark(my_cumsum1(x),my_cumsum2(x),cumsum(x),times=times,unit = "ms")
    data <- setDT(summary(result))
    data[, n :=n]
    data
  })
  rbindlist(results)
}
benchmarks <- benchmark(seq(100,3000,100))
library(ggplot2)
ggplot(benchmarks,aes(x = n,color = expr)) +
  ggtitle("Microbenchmark on cumsum functions") +
  geom_point(aes(y = median)) +
  geom_errorbar(aes(ymin = lq,ymax=uq))

benchmarks2 <- benchmark(seq(2,600,10),times=50)

ggplot(benchmarks2,aes(x=n,color=expr)) +
  ggtitle("Microbenchmark on cumsum functions over small input") +
  geom_point(aes(y = median)) +
  geom_errorbar(aes(ymin = lq,ymax = uq))


benchmarks3 <- benchmark(seq(10,800,10),times=50)
ggplot(benchmarks3,aes(x = n,color=expr)) + 
  ggtitle("Microbenchmark on cumsum functions with break even") +
  geom_point(aes(y = median)) +
  geom_errorbar(aes(ymin = lq,ymax=uq))

#代码的性能分析
#rprof进行性能分析
x <- rnorm(1000)
tmp <- tempfile(fileext=".out")
Rprof(tmp)
for(i in 1:1000){
  my_cumsum1(x)
}
Rprof(NULL)
summaryRprof(tmp)

#tempfile创建一个临时文件来存储分析数据
tmp <- tempfile(fileext = ".out")
Rprof(tmp)
for(i in 1:1000){
  my_cumsum2(x)
}
Rprof(NULL)
summaryRprof(tmp)

tmp <- tempfile(fileext = ".out")
Rprof(tmp,line.profiling = TRUE)
source("E:/ryuyanxuexi/my_cumsum1.R",keep.source = TRUE)
Rprof(NULL)
summaryRprof(tmp,lines = "show")

#用profvis进行性能分析
#rprof提供了有用的信息帮助我们找到代码瓶颈，提升代码性能
#profvis增强版的分析工具profvis，分析R代码的交互式可视化功能 https://rstudio.github.io/profvis/
install.packages("profvis")

library(profvis)
profvis({
  my_cumsum1 <- function(x){
    y <- numeric()
    sum_x <- 0
    for(xi in x){
      sum_x <- sum_x + xi
      y <- c(y,sum_x)
    }
    y
  }
  x <- rnorm(1000)
  for(i in 1:1000){
    my_cumsum1(x)
  }
})
profvis({
  my_cumsum2 <- function(x){
    y <- numeric(length(x))
    y[[1]] <- x[[1]]
    for(i in 2:length(x)){
      y[[i]] <- y[[i-1]] + x[[i]]
    }
    y
  }
  x<- rnorm(1000)
  for(i in 1:1000){
    my_cumsum2(x)
  }
})


#理解代码为什么这么慢
n <- 10000
microbenchmark(grow_by_index = {
  x <- list()
  for(i in 1:n) x[[i]] <- i
},preallocated = {
  x <- vector("list",n)
  for(i in 1:n) x[[i]] <- i
},times = 20)

#提高代码性能
#使用内置函数
cumsum

diff_for <- function(x){
  n <- length(x) - 1
  res <- numeric(n)
  for(i in seq_len(n)){
    res[[i]] <- x[[i + 1]] - x[[i]]
  }
  res
}

diff_for(c(2,3,1,5))

x <- rnorm(1000)
all.equal(diff_for(x),diff(x))

microbenchmark(diff_for(x),diff(x))


mat <- matrix(1:12,nrow=3)
mat

my_transpose <- function(x){
  stopifnot(is.matrix(x))
  res <- matrix(vector(mode(x),length(x)),
    nrow = ncol(x),ncol=nrow(x),
    dimnames = dimnames(x)[c(2,1)])
  for(i in seq_len(ncol(x))){
    for(j in seq_len(nrow(x))){
      res[i,j] <- x[j,i]
    }
  }
  res
}

my_transpose(mat)
all.equal(my_transpose(mat),t(mat))

microbenchmark(my_transpose(mat),t(mat))

mat <- matrix(rnorm(25000),nrow=1000)
all.equal(my_transpose(mat),t(mat))

microbenchmark(my_transpose(mat),t(mat))

mat <- matrix(rnorm(25000),nrow = 1000)
all.equal(my_transpose(mat),t(mat))

microbenchmark(my_transpose(mat),t(mat))

microbenchmark(my_transpose(mat),t(mat),t.default(mat))

#使用向量化
add <- function(x,y){
  stopifnot(length(x) == length(y),
            is.numeric(x),is.numeric(y))
  z <- numeric(length(x))
  for(i in seq_along(x)){
    z[[i]] <- x[[i]] + y[[i]]
  }
  z
}

x <- rnorm(10000)
y <- rnorm(10000)
all.equal(add(x,y),x+y)

microbenchmark(add(x,y),x+y)

algo1_for <- function(n){
  res <- 0
  for(i in seq_len(n)){
    res <- res +1 / i ^ 2
  }
  res
}

algo1_vec <- function(n){
  sum(1 / seq_len(n) ^ 2)
}

algo1_for(10)
algo1_vec(10)

microbenchmark(algo1_for(200),algo1_vec(200))

microbenchmark(algo1_for(1000),algo1_vec(1000))

#使用字节码编译器
library(compiler)
diff_cmp <- cmpfun(diff_for)
diff_cmp

x <- rnorm(10000)
microbenchmark(diff_for(x),diff_cmp(x),diff(x))

algo1_cmp <- cmpfun(algo1_for)
algo1_cmp


n <- 1000
microbenchmark(algo1_for(n),algo1_cmp(n),algo1_vec(n))

algo1_vec_cmp <- cmpfun(algo1_vec)
microbenchmark(algo1_vec(n),algo1_vec_cmp(n),times=10000)


#使用Intel MKL支持R
#https://mran.microsoft.com/open/
#https://software.intel.com/en-us/intel-mkl
#https://mran.microsoft.com/documents/rro/multithread/
#使用并行计算
set.seed(1)
sim_data <- 100 * cumprod(1 + rnorm(500,0,0.006))
plot(sim_data,type = "s",ylim = c(85,115),
     main="A simulated random path")
abline(h = 100,lty=2,col="blue")
abline(h = 100 * (1 + 0.1 * c(1,-1)),lty=3,col="red")

simulate <- function(i, p=100,n = 10000,
                     r = 0,sigma = 0.0005,margin = 0.1){
  ps <- p * cumprod(1 + rnorm(n,r,sigma))
  list(id = i,
       first = ps[[1]],
       high = max(ps),
       low = min(ps),
       last = ps[[n]],
       signal = any(ps > p * (1 + margin) | ps < p * (1 - margin)))
}

simulate(1)

system.time(res <- lapply(1:10000,simulate))

library(data.table)
res_table <- rbindlist(res)
head(res_table)

res_table[, sum(signal) /.N]

library(parallel)
c1 <- makeCluster(detectCores())
#返回你的计算机配备的核数目
#parLapply函数，并行版本lapply函数
system.time(res <- parLapply(c1,1:10000,simulate))

stopCluster(c1)
length(res)
res_table <- rbindlist(res)
res_table[, sum(signal) /.N]

c1 <- makeCluster(detectCores())
n <- 1
parLapply(c1,1:3,function(x) x + n)

n <- 100
data <- data.frame(id = 1:n,x = rnorm(n),y = rnorm(n))
take_sample <- function(n){
  data[sample(seq_len(nrow(data)),size = n,replace = FALSE),]
}

c1 <- makeCluster(detectCores())
clusterEvalQ(c1,Sys.getpid())

clusterEvalQ(c1,ls())

clusterExport(c1,c("data","take_sample"))
clusterEvalQ(c1,ls())

clusterEvalQ(c1,take_sample(2))

invisible(clusterCall(c1,function(){
  local_var <- 10
  global_var <<- 100
}))
clusterEvalQ(c1,ls())

clusterExport(c1,"simulate")
invisible(clusterEvalQ(c1,{
  library(data.table)
}))
res <- parLapply(c1,1:3,function(i){
  res_table <- rbindlist(lapply(1:1000,simulate))
  res_table[, id :=NULL]
  summary(res_table)
})
res

#使用rcpp
install.packages("Rcpp")
Rcpp::sourceCpp("E:/ryuyanxuexi/rcpp-demo.cpp")
timesTwo
timesTwo(10)
timesTwo(c(1,2,3))
Rcpp::sourceCpp("E:/ryuyanxuexi/rcpp-algo1.cpp")
algo1_cpp(10)

algo1_cpp(c(10,15))
library(microbenchmark)
n <- 1000
microbenchmark(
  algo1_for(n),
  algo1_cmp(n),
  algo1_vec(n),
  algo1_cpp(n))

Rcpp::sourceCpp("E:/ryuyanxuexi/rcpp-diff.cpp")
diff_cpp(c(1,2,3,5))

x <- rnorm(1000)
microbenchmark(
  diff_for(x),
  diff_cmp(x),
  diff(x),
  diff.default(x),
  diff_cpp(x))

#http://www.rcpp.org/book/
#openMP
#http://gallery.rcpp.org/tags/openmp
Rcpp::sourceCpp("E:/ryuyanxuexi/rcpp-diff-openmp.cpp")
diff_cpp_omp(c(1,2,4,8))

x <- rnorm(1000)
microbenchmark(
  diff_for(x),
  diff_cmp(x),
  diff(x),
  diff.default(x),
  diff_cpp(x),
  diff_cpp_omp(x)
)

x <- rnorm(100000)
microbenchmark(
  diff_for(x),
  diff_cmp(x),
  diff(x),
  diff.default(x),
  diff_cpp(x),
  diff_cpp_omp(x)
)


#http://bisqwit.iki.fi/story/howto/openmp

#http://rcppcore.github.io/RcppParallel/
#https://www.threadingbuildingblocks.org/
#http://tinythreadapp.bitsnbites.eu/
mat <- matrix(1:12,nrow=3)
mat

par_transform(mat)

all.equal(par_transform(mat),1 / (1 + mat ^ 2))

mat <- matrix(rnorm(1000 * 2000),nrow=1000)
microbenchmark(1 / (1 + mat ^ 2),par_transform(mat))

#http://rcppcore.github.io/RcppParallel































