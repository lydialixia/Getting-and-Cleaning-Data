library(dplyr)
library(tidyr)
library(data.table)
library(readr)

# download the zipped file and unzip it
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,"project.zip",method = "curl")
unzip("project.zip")

# parse features.txt
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
featurerow <- grep(".*mean.*|.*std.*",features[,2])
featurelabel <- features[featurerow,2]
featurelabel <- gsub("-mean","_Mean",featurelabel)
featurelabel <- gsub("-std","_Std",featurelabel)
featurelabel <- gsub("[()]","",featurelabel)
featurelabel <- gsub("-","_",featurelabel)


#read useful columns of x_test,x_train
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[featurerow]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test,y_test,x_test)

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[featurerow]
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train,y_train,x_train)

Totaldata <- rbind(train,test)
colnames(Totaldata) <- c("Subject","Activity",featurelabel)
write.table(Totaldata, "tidy.txt", row.names = FALSE, quote = FALSE)

#part 5
Groupdata <- Totaldata %>%
        group_by(Subject,Activity) %>%
        summarise_each(funs(mean))
        
