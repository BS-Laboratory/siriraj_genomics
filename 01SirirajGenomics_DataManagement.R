#!!!Please change file name in line 40 before source command 
# require packages  
require(readr)
require(stringr)
require(dplyr)
require(lubridate)

# Import data  
## Set working directory of file that collect on your computer 
setwd("~/Nutchavadee/REDCap/SirirajGenomics/SirirajGenomics_DataManagement")
data<- read.csv("ExampleScan01.csv")

# Change 3 digits in study id follow to condition below 
## study_id if 001 transform to GTS 
## study_id if 002 transform to SOT 
## study_id if 003 transform to PED 
### Split project id from study_id columns 
project<-(str_split_fixed(data$study_id, "-", 2))
project <- as.data.frame(project)
### Change column name in project data 
project <-project %>% rename("project"=V1 ,"study_id"=V2)
### change project 3 digits to text follow above 
project<-project %>% mutate(project=recode(project, "001"="GTS", "002"="SOT", "003"="PED"))
project$project_study_id = paste(project$project,project$study_id, sep = "-")
project<-project %>% select("project_study_id")
### Merge project_study_id to data 
data2 <- cbind(project, data)

# Convert B.E. to A.D. 
alldate <- c("birth_date","collection_date","anthropo_date")
## convert string to date
for (i in alldate) {
data2[,i] <- as.Date(data2[,i], format = "%d/%m/%Y")  
}
##convert B.E. to A.D. (-543)
for (i in alldate) {
data2[,i] <- ymd(data2[,i] - years(543))  
}

write.csv(data2, "SiGenomics_ChangeDate24022021.csv",na="", row.names =  F)


