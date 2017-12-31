---
title: "README.md"
author: "Tiago Flores"
date: "2017 - 12 - 21"
output: html_document
---

# How this project works
This project is based mainly in run_analysis.R script, that works as follows

## Configurations
```r
srcdata <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dstdata <- "dataset.zip"
wrkgdir <- "~/Dev/R/DSGettingAndCleaningData/CourseProject"
datadir <- "./data"
```
## Environment setup
```r
setwd(wrkgdir)
library(dplyr)
```

## Aux. functions
```r
downloaddata <- function(urlsource, filesource)
{
  if (!file.exists(filesource)){
    download.file(urlsource, filesource)  
  } else {
    cat(sprintf("File %s already downloaded.\n", filesource))
  }
  return(filesource)
}
```
## 1. Merges the training and the test sets to create one data set.
## Main 'function' 
```r
dset <- downloaddata(srcdata, paste(datadir,"/",dstdata, sep = ""))
cat(sprintf("Extracting %s to ./data/.\n", dset))
unzip(dset, exdir = datadir)
# Downloaded data are in "data/UCI HAR Dataset" subdirectory
```

## Read aux data
```r
hd <- read.csv("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, sep = "", header = FALSE, fileEncoding = "us-ascii")[,2]
activity_labels <- read.csv("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, sep = "", header = FALSE, fileEncoding = "us-ascii")
names(activity_labels) <- c("activityid","activityname")
```

## Read training data, merging columns for all files
```r
trxdata <- read.csv("./data/UCI HAR Dataset/train/X_train.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
names(trxdata) <- hd
trxdata[, "subject"] <- read.csv("./data/UCI HAR Dataset/train/subject_train.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
trxdata[, "ydata"] <- read.csv("./data/UCI HAR Dataset/train/y_train.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
```

## Read test data, merging columns for all files
```r
tsxdata  <- read.csv("./data/UCI HAR Dataset/test/X_test.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
names(tsxdata) <- hd
tsxdata[, "subject"] <- read.csv("./data/UCI HAR Dataset/test/subject_test.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
tsxdata[, "ydata"] <- read.csv("./data/UCI HAR Dataset/test/y_test.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
```

### rbind test and training data, using as_tibble because tbl_df is deprecated
```r
alldata <- as_tibble(rbind(trxdata, tsxdata))
actlbls <- as_tibble(activity_labels)
```

## 3. Uses descriptive activity names to name the activities in the data set
```r
alldata <- left_join(alldata, actlbls, c("ydata" = "activityid"), copy = TRUE)
```

### free memory
```r
rm(list = c("hd", "trxdata", "tsxdata","activity_labels"))
```
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
### identify std and mean cols at "alldata"
```r
stdmeancols <- grep("std\\(\\)|mean\\(\\)", names(alldata))
alldata <- select(alldata, "activityname","subject",stdmeancols)
```

## 4. Appropriately labels the data set with descriptive variable names.
### remove "()", "-" and lowercase variable names
```r
names(alldata) <- tolower(gsub("\\(\\)","", gsub("-","",names(alldata))))
```

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```r
evavg_data <- alldata %>% group_by(activityname, subject) %>% summarise_all(mean)
```



