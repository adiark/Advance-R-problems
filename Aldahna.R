library(rvest)


url <- "https://www.hapag-lloyd.com/en/products/fleet/vessel.html"

webpage <- read_html(url)

links <- webpage %>% html_nodes(".linklist")%>%
  html_nodes(".hal-list") %>% 
  html_nodes('li a')%>%
  html_attr('href')

links <- paste("https://www.hapag-lloyd.com", links, sep = "")


for (i in links){
  df1 <- data.frame()
  wb <- read_html(i)
Box_content <- wb%>% html_nodes(".boxContent")%>% 
  html_nodes('label') %>% 
  html_text() %>% 
  as.data.frame()
Box_content2 <- wb%>% html_nodes(".boxContent")%>% 
  html_nodes('span') %>% 
  html_text() %>% 
  as.data.frame()
df1 <- cbind(Box_content,Box_content2)

vessel_name <- wb%>% html_nodes(".hal-stagetext-content")%>% 
  html_nodes('h1') %>% 
  html_text() 
vessel_name <- gsub(" ", "", vessel_name, fixed = TRUE)

write_path <-  paste("C:\\Users\\Aditya Jain\\Desktop\\Trainee\\Week 3\\Day 4_Akshay\\Assignment\\Problem\\Assignment_3\\Input\\", vessel_name ,".csv", sep="" )
write.csv(df1, write_path ,row.names = FALSE )

}


