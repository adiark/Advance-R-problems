library(rvest)
library(openxlsx)

url <- "https://www.beagledatabase.co.za/supplier_search/results?utf8=%E2%9C%93&supplier_search%5Bkeyword%5D=&supplier_search%5Blevel%5D=&supplier_search%5Bblack_ownership%5D=&supplier_search%5Bblack_female_ownership%5D=&supplier_search%5Bcompany_size%5D=&supplier_search%5Bregions%5D=&supplier_search%5Bcommodity%5D=&commit=Search"
count <- 0
k <- 1
webpage <- read_html(url)

comodity <- webpage %>% 
  html_nodes(".grouped_select") %>% 
  html_nodes('optgroup option')%>%
  html_attr('value')

comodity <- gsub(" ", "+", comodity, fixed = TRUE)
comodity <- gsub("&", "%26", comodity, fixed = TRUE)
comodity <- gsub(",", "%2C", comodity, fixed = TRUE)

links <- paste("https://www.beagledatabase.co.za/supplier_search/results?utf8=%E2%9C%93&supplier_search%5Bkeyword%5D=&supplier_search%5Blevel%5D=&supplier_search%5Bblack_ownership%5D=&supplier_search%5Bblack_female_ownership%5D=&supplier_search%5Bcompany_size%5D=&supplier_search%5Bregions%5D=&supplier_search%5Bcommodity%5D=",comodity,"&commit=Search", sep = "")
links
ws <- createWorkbook()
for (i in links){
  

wb <- read_html(i)

number <- wb %>% 
  html_nodes(".results_header") %>% 
  html_nodes('h4') %>% 
  html_text() 

number <- as.integer(gsub("Results", "", number, fixed = TRUE))
number <- ((number-1)%/%500)+1

if (k==30)
{
  number <- 1
  
}




  
    
    if (number>1){
      df1 <- data.frame()
      i <- paste0("https://www.beagledatabase.co.za/supplier_search/results?commit=Search&page=1&supplier_search%5Bblack_female_ownership%5D=&supplier_search%5Bblack_ownership%5D=&supplier_search%5Bcommodity%5D=", comodity[k],"&supplier_search%5Bcompany_size%5D=&supplier_search%5Bkeyword%5D=&supplier_search%5Blevel%5D=&supplier_search%5Bregions%5D=&utf8=%E2%9C%93")
      sub_link <- unlist(strsplit(i ,"page=1"))
      for (j in 1 : (number)) {
      
    s_link <- paste(sub_link[1],"page=",j, sub_link[2], sep = "")
    wb <- read_html(s_link)
    data <- wb %>% 
      html_nodes(".company_table_wrapper") %>% 
      html_nodes("table") %>% 
      html_table(fill = TRUE ) %>% 
      as.data.frame()
    data <- data[,-6]
    
    df1 <- rbind(df1,data)
    
      }
      count <- as.integer(count +1)
      addWorksheet(ws, count)
      writeData(ws,sheet = count, df1, colNames = T)
    }
    else{   
      df1 <- data.frame()
    wb <- read_html(i)
    data <- wb %>% 
      html_nodes(".company_table_wrapper") %>% 
      html_nodes("table") %>% 
      html_table(fill = TRUE ) %>% 
      as.data.frame()
    data <- data[,-6]
    
    df1 <- rbind(df1,data)
    count <- as.integer(count +1)
    addWorksheet(ws, count)
    writeData(ws,sheet = count, df1, colNames = T)
    
        }
                 
View(df1)    

  
print(comodity[k])
print(k)
k <- k+1


saveWorkbook(ws, "C:\\Users\\Aditya Jain\\Desktop\\Trainee\\Week 3\\Day 4_Akshay\\Assignment\\Problem\\Assignment_4\\Problem\\done.xlsx", overwrite = TRUE )

print(count)
  
}
