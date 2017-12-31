
# Getting and Cleaning Data Course Project

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers 
# on a series of yes/no questions related to the project. You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you performed
#    to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.

# One of the most exciting areas in all of data science right now is wearable computing - see for example 
# this article. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms 
# to attract new users. The data linked to from the course website represent data collected from the 
# accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the 
# data was obtained:
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.
###############################################################################

# Configurations
srcdata <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dstdata <- "dataset.zip"
wrkgdir <- "~/Dev/R/DSGettingAndCleaningData/CourseProject"
datadir <- "./data"

# Environment setup
setwd(wrkgdir)
library(dplyr)

# Aux. functions
downloaddata <- function(urlsource, filesource)
{
  if (!file.exists(filesource)){
    download.file(urlsource, filesource)  
  } else {
    cat(sprintf("File %s already downloaded.\n", filesource))
  }
  return(filesource)
}

## 1. Merges the training and the test sets to create one data set.

# Main 'function' 
dset <- downloaddata(srcdata, paste(datadir,"/",dstdata, sep = ""))
cat(sprintf("Extracting %s to ./data/.\n", dset))
unzip(dset, exdir = datadir)
# Downloaded data are in "data/UCI HAR Dataset" subdirectory

# Read aux data
hd <- read.csv("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, sep = "", header = FALSE, fileEncoding = "us-ascii")[,2]
activity_labels <- read.csv("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, sep = "", header = FALSE, fileEncoding = "us-ascii")
names(activity_labels) <- c("activityid","activityname")

# Read training data, merging columns for all files
trxdata <- read.csv("./data/UCI HAR Dataset/train/X_train.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
names(trxdata) <- hd
trxdata[, "subject"] <- read.csv("./data/UCI HAR Dataset/train/subject_train.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
trxdata[, "ydata"] <- read.csv("./data/UCI HAR Dataset/train/y_train.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")

# Read test data, merging columns for all files
tsxdata  <- read.csv("./data/UCI HAR Dataset/test/X_test.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
names(tsxdata) <- hd
tsxdata[, "subject"] <- read.csv("./data/UCI HAR Dataset/test/subject_test.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")
tsxdata[, "ydata"] <- read.csv("./data/UCI HAR Dataset/test/y_test.txt", sep = "", stringsAsFactors = FALSE, header = FALSE, fileEncoding = "us-ascii")

# rbind test and training data, using as_tibble because tbl_df is deprecated
alldata <- as_tibble(rbind(trxdata, tsxdata))
actlbls <- as_tibble(activity_labels)

## 3. Uses descriptive activity names to name the activities in the data set
alldata <- left_join(alldata, actlbls, c("ydata" = "activityid"), copy = TRUE)

# free memory
rm(list = c("hd", "trxdata", "tsxdata","activity_labels"))

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# identify std and mean cols at "alldata"
stdmeancols <- grep("std\\(\\)|mean\\(\\)", names(alldata))
alldata <- select(alldata, "activityname","subject",stdmeancols)

## 4. Appropriately labels the data set with descriptive variable names.
# remove "()", "-" and lowercase variable names
names(alldata) <- tolower(gsub("\\(\\)","", gsub("-","",names(alldata))))

## 5. From the data set in step 4, creates a second, independent tidy data set with
##  the average of each variable for each activity and each subject.
#alldata_active_subject <- group_by(alldata, activityname, subject)
evavg_data <- alldata %>% group_by(activityname, subject) %>% summarise_all(mean)

