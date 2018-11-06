# Setting directory to the server

setwd('//192.168.0.17/planning/STATISTICS DIVISION/Performance Analysis/FY 2018-19/WOP 3%')

# Package needed for the analysis

pg= c('tidyverse', 'openxlsx');for (i in pg){ library(i, character.only = T)}


# Reading (Withholding 3% tax) data from the server

# This display roughly, you need to open them in excel and delete some unneccery 2 rows at the top and 4 last columns at the right

WOP_JULY_sEP_2018 <- readxl::read_xlsx( "wop 3% jULY-sEP 2018 PAYMENTS.xlsx") 
WOP_JULY_sEP_2018 <- WOP_JULY_sEP_2018 [1:(nrow(WOP_JULY_sEP_2018)-1),] # This remove the grand total row

WOP_JULY_sEP_2017 <- readxl::read_xlsx( "wop 3% jULY-sEP 2017 PAYMENTS.xlsx")
WOP_JULY_sEP_2017 <- WOP_JULY_sEP_2017 [1:(nrow(WOP_JULY_sEP_2017)-1),] # This remove the grand total row
# Choosing columns that are needed for the analysis

WOP_JULY_sEP_2018_1= WOP_JULY_sEP_2018%>% select(1,2,11) 
WOP_JULY_sEP_2017_1= WOP_JULY_sEP_2017%>% select(1,2,11)

# Aggregating the payment by tin for 2018

WOP_JULY_sEP_2018_2=WOP_JULY_sEP_2018_1 %>% 
  group_by(TIN,`Tax Payer Name`) %>% 
  summarise(Payments=sum(Payments,na.rm =TRUE) )

# Aggregating the payment by tin for 2017

WOP_JULY_sEP_2017_2=WOP_JULY_sEP_2017_1 %>% 
  group_by(TIN,`Tax Payer Name`) %>% 
  summarise(Payments=sum(Payments,na.rm =TRUE) )


# Renaming the payments columns

WOP_JULY_sEP_2018_3= WOP_JULY_sEP_2018_2 %>% rename("Payments 2018"="Payments")
WOP_JULY_sEP_2017_3= WOP_JULY_sEP_2017_2 %>% rename("Payments 2017"="Payments")

# Merge the two dataset for 2018 and 2017

data_combined=left_join(WOP_JULY_sEP_2018_3, WOP_JULY_sEP_2017_3, by=c('TIN', "Tax Payer Name")) 

# Payment difference

data_combined <- data_combined %>% mutate(`Payment Difference`=`Payments 2018`-`Payments 2017`)

# Writing out the file
write.xlsx(data_combined,"WOP 3% comparison july-Sep 2018-19 Vs 17-18.xlsx")
