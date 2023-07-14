#查询网页内容
#使用css选择器从网页中提取数据
#https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors
#http://www.w3schools.com/tags/
install.packages("rvest")
library(rvest)
single_table_page <- read_html("E:/ryuyanxuexi/single-table.html")
single_table_page
#使用rvest从网页上爬取信息的典型过程是这样的。定位需要从中提取数据的html节点。使用css选择器或者XPATH表达式晒徐html节点
#从而选择需要的节点，剔除不需要的节点。对已解析的网页使用合适的选择器，html_nodes提取节点子集,html_attrs提取属性,html_text提取文本
#html_table提取网页使用的table元素
html_table(single_table_page)

#css选择器table 的时候，html_node选取第一个节点，选择出来的节点调用html_table得到一个数据框
html_table(html_node(single_table_page,"table"))

single_table_page %>%
  html_node("table") %>%
  html_table()
#读取products.html,html_nodes匹配<span class="name">节点
products_page <- read_html("E:/ryuyanxuexi/products.html")
products_page %>%
  html_nodes(".product-list li .name")

#html_text从选择的节点中提取内容，返回一个字符向量
products_page %>%
  html_nodes(".product-list li .name") %>%
  html_text()

products_page %>%
  html_nodes(".product-list li .price") %>%
  html_text()

product_items <- products_page %>%
  html_nodes(".product-list li")
products <- data.frame(
  name = product_items %>%
    html_nodes(".name") %>%
    html_text(),
  price = product_items %>%
    html_nodes(".price") %>%
    html_text() %>%
    gsub("$","", ., fixed = TRUE) %>%
    as.numeric(),
  stringsAsFactors = FALSE
)
products

#产品价格是数值，gsub从原生价格移除$，结果转换成一个数值向量。管道操作的gsub调用有点特殊
#使用XPath选择器
page <- read_html("E:/ryuyanxuexi/new-products.html")

page %>% html_nodes(xpath = "//p")

#class属性的li节点
page %>% html_nodes(xpath = "//li[@class]")

page %>% html_nodes(xpath="//div[@id = 'list']/ul/li")

page %>% html_nodes(xpath = "//div[@id = 'list']//li/span[@class = 'name']")

page %>%
  html_nodes(xpath = "//li[@class='selected']/span[@class='name']")
#所有包含p子节点的div节点
page %>% html_nodes(xpath = "//div[p]")
page %>%
  html_nodes(xpath = "//span[@class = 'info-value' and text() = 'Good']")


page %>%
  html_nodes(xpath = "//li[div/ul/li[1]/span[@class = 'info-value' and text() = 'Good']]/span[@class = 'name']")

page %>%
  html_nodes(xpath = "//li[div/ul/li[2]/span[@class = 'info-value' and text() > 3]] /span[@class = 'name']")

#http://www.w3schools.com/xsl/xpath_syntax.aspac


#分析html代码并提取数据
page <- read_html("https://cran.rstudio.com/web/packages/available_packages_by_name.html")
pkg_table <- page %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)
head(pkg_table,5)

pkg_table <- pkg_table[complete.cases(pkg_table),]
colnames(pkg_table) <- c("name","title")
head(pkg_table,3)

page <- read_html("https://finance.yahoo.com/quote/MSFT")
page %>%
  html_node("div#quote-header-info > section > span") %>%
  html_text() %>%
  as.numeric()

page %>%
  html_node("#key-statistics table") %>%
  html_table()


get_price <- function(symbol) {
  page <- read_html(sprintf("https://finance.yahoo.com/quote/%s", symbol))
  list(symbol = symbol,
       company = page %>% 
         html_node("div#quote-header-info > div:nth-child(1) > h6") %>%
         html_text(),
       price = page %>% 
         html_node("div#quote-header-info > section > span:nth-child(1)") %>%
         html_text() %>%
         as.numeric())
}
get_price("AAPL")


page <- read_html("https://stackoverflow.com/questions/tagged/r?sort = votes&pageSize=5")
questions <- page %>%
  html_node("#questions")


questions %>%
  html_nodes(".summary h3") %>%
  html_text()

questions %>%
  html_nodes(".question-hyperlink") %>%
  html_text()


questions %>%
  html_nodes(".question-hyperlink") %>%
  html_text()


questions %>%
  html_nodes(".question-summary .vote-count-post") %>%
  html_text() %>%
  as.integer()

questions %>%
  html_nodes(".question-summary .status strong") %>%
  html_text() %>%
  as.integer()


questions %>%
  html_nodes(".question-summary .tags") %>%
  lapply(function(node) {
    node %>%
      html_nodes(".post-tag") %>%
      html_text()
  }) %>%
  str



questions %>%
  html_nodes(".question-hyperlink") %>%
  html_attr("href") %>%
  lapply(function(link) {
    paste0("https://stackoverflow.com", link) %>%
      read_html() %>%
      html_node("#qinfo") %>%
      html_table() %>%
      setNames(c("item", "value"))
  })
























































































































