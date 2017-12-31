---
title: "CodeBook.md"
author: "Tiago Flores"
date: "2017 - 12 - 21"
output: html_document
---

# Original Data

## Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

# Transformations

Data are originally divided in training and test data, with variables names in a file called features.txt and also another
file called activity_labels.txt which contains activity labels and activity id.

* Variables names (features.txt)
* Activity labels (activity_labels.txt)
* Train Data
    * train/X_train.txt
    * train/subject_train.txt
    * train/y_train.txt
* Test Data
    * test/X_test.txt
    * test/subject_test.txt
    * test/y_test.txt

1. **1st transformation step** is to load activity_labels.txt into the memory naming its two variables "activityid" and 
"activityname". The final dataset name of this step is named *activity_labels*.

1. **2nd transformation step** is to join data from the three files of test data in a single file, naming their variables
according to activity_labels.txt to data obtained from subject_test.txt, naming "ydata" the variable from y_test.txt, and
naming "subject" the variable from subject_test.txt. The same process is done with train data, resulting in two datasets:
"tsxdata" and "trxdata".

1. **3rd transformation step** is to "rbind" the test (*tsxdata*) and train (*trxdata*) datasets in a single dataframe. 
Named "alldata".

1. **4th tranformation step** is to create a dataframe from the previou loaded activity lables data. Named "actlbls".

1. **5th transformation step** is to join dataframes "alldata" and "actlbls" by the respective variables, "ydata" and 
"activityid", overwriting the "alldata" dataframe with the resulting of join operation.

1. **6th transformation step** is to select only variables which contain "std" and "mean" in their names. "activityname" 
and "subject" variables are also selected and the result overwrites "alldata" dataframe.

1. **7th transformation step** is to rename variables, removing "(", ")" and "-" characters.

1. **8th transformation step** is to create a independent tidy data set with the average of each variable (evavg_data)
for each activity and each subject.

# Final Data

The final data has 68 variables:
```r
 [1] "activityname"             "subject"                  "tbodyaccmeanx"            "tbodyaccmeany"           
 [5] "tbodyaccmeanz"            "tbodyaccstdx"             "tbodyaccstdy"             "tbodyaccstdz"            
 [9] "tgravityaccmeanx"         "tgravityaccmeany"         "tgravityaccmeanz"         "tgravityaccstdx"         
[13] "tgravityaccstdy"          "tgravityaccstdz"          "tbodyaccjerkmeanx"        "tbodyaccjerkmeany"       
[17] "tbodyaccjerkmeanz"        "tbodyaccjerkstdx"         "tbodyaccjerkstdy"         "tbodyaccjerkstdz"        
[21] "tbodygyromeanx"           "tbodygyromeany"           "tbodygyromeanz"           "tbodygyrostdx"           
[25] "tbodygyrostdy"            "tbodygyrostdz"            "tbodygyrojerkmeanx"       "tbodygyrojerkmeany"      
[29] "tbodygyrojerkmeanz"       "tbodygyrojerkstdx"        "tbodygyrojerkstdy"        "tbodygyrojerkstdz"       
[33] "tbodyaccmagmean"          "tbodyaccmagstd"           "tgravityaccmagmean"       "tgravityaccmagstd"       
[37] "tbodyaccjerkmagmean"      "tbodyaccjerkmagstd"       "tbodygyromagmean"         "tbodygyromagstd"         
[41] "tbodygyrojerkmagmean"     "tbodygyrojerkmagstd"      "fbodyaccmeanx"            "fbodyaccmeany"           
[45] "fbodyaccmeanz"            "fbodyaccstdx"             "fbodyaccstdy"             "fbodyaccstdz"            
[49] "fbodyaccjerkmeanx"        "fbodyaccjerkmeany"        "fbodyaccjerkmeanz"        "fbodyaccjerkstdx"        
[53] "fbodyaccjerkstdy"         "fbodyaccjerkstdz"         "fbodygyromeanx"           "fbodygyromeany"          
[57] "fbodygyromeanz"           "fbodygyrostdx"            "fbodygyrostdy"            "fbodygyrostdz"           
[61] "fbodyaccmagmean"          "fbodyaccmagstd"           "fbodybodyaccjerkmagmean"  "fbodybodyaccjerkmagstd"  
[65] "fbodybodygyromagmean"     "fbodybodygyromagstd"      "fbodybodygyrojerkmagmean" "fbodybodygyrojerkmagstd" 
```