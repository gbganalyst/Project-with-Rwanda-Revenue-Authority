setwd('//192.168.0.17/planning/STATISTICS DIVISION/Performance Analysis/FY 2018-19/CIT ANALYSIS')
library(tidyverse)
library(openxlsx)

# Reading data from the server
cit_2018 <- readxl::read_xlsx("CIT-IQP-JULY-SEP-2018.xlsx")
cit_2017 <- readxl::read_xlsx("CIT-IQP-JULY-SEP-2017.xlsx")


cit_2018_1=cit_2018 %>% select(1,2,57)
cit_2017_1=cit_2017 %>% select(1,2,57)

cit_2018_1= cit_2018_1 %>% rename('Balance Due 2018'='Balance Due')
cit_2017_1= cit_2017_1 %>% rename('Balance Due 2017'='Balance Due')


data_combined=left_join(cit_2018_1, cit_2017_1, by=c('TIN', "Tax Payer Name"))
data_combined <- data_combined %>% replace_na(list("Balance Due 2017"=0, "Balance Due 2018"=0))
data_combined <- data_combined %>% mutate(`Balance Due Difference`=`Balance Due 2018`-`Balance Due 2017`)
View(data_combined)
write.xlsx(data_combined,"CIT comparison july-Sep 2018-19 Vs 17-18 vs2.xlsx")



