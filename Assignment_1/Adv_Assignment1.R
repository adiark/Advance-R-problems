library(openxlsx)
library(xlsx)
library(readxl)
library(dplyr)
setwd("C:\\Users\\Aditya Jain\\Desktop\\Trainee\\Week 3\\Day 4_Akshay\\Assignment\\Problem\\Assignment_1\\Problems")
file_names <- list.files()
df1 <- data.frame()
file_names
for (i in file_names){
  
  df2 <- read_excel(i)

  df1 <- rbind(df1,df2)
}
df1$SrNo <- NA
for (i in 1:nrow(df1)){
  df1[i,]$SrNo <- i
}

User_input <- readline(prompt="Enter Subset number: ")
# convert character into integer
User_input <- as.integer(User_input)
number <- nrow(df1)%/%User_input
df1 <- df1[order(df1$CAGR, decreasing = TRUE), ]

df1$bin <- cut( x= seq(1:nrow(df1)),breaks = User_input, labels = seq(1:User_input))

new_df <- aggregate(df1[c(-1,-2,-37)], by=list(df1$bin), mean)


wb <- createWorkbook()
addWorksheet(wb, "data")
addWorksheet(wb, "mean")

format_1 <- createStyle(fontName = "calibri", fontColour = "white" , fontSize = 10, textDecoration = "bold", fgFill = "#000099" )
styling <- createStyle(halign = "center", valign = "center", numFmt = "percentage")

addStyle(wb, sheet = "mean", styling, rows = 1:nrow(df1),cols = 1:ncol(df1), gridExpand = TRUE)


writeData(wb,sheet = "data", df1, colNames = T, headerStyle = format_1)
writeData(wb, sheet = "mean", new_df, colNames = T, headerStyle = format_1)

saveWorkbook(wb, "C:\\Users\\Aditya Jain\\Desktop\\Trainee\\Week 3\\Day 4_Akshay\\Assignment\\Problem\\Assignment_1\\Problems\\final.xlsx", overwrite = TRUE )

names(df1)
View(df1)
