# Getting-and-Cleaning-Data-Course-Project
Getting and Cleaning Data Course Project

```sh
## Data can be downloaded from here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## Files used: 
## - 'activity_labels.txt': Links the class labels with their activity name.
## - 'train/X_train.txt': Training set.
## - 'train/y_train.txt': Training labels.
## - 'test/X_test.txt': Test set.
## - 'test/y_test.txt': Test labels.
## - 'test/subject_test.txt'
## - 'train/subject_train.txt'
## - 'features.txt'
```

```sh
## Reading data files
test.labels <- read.table("./test/y_test.txt", col.names="label")
test.subjects <- read.table("./test/subject_test.txt", col.names="subject")
test.set <- read.table("./test/X_test.txt")
train.labels <- read.table("./train/y_train.txt", col.names="label")
train.subjects <- read.table("./train/subject_train.txt", col.names="subject")
train.set <- read.table("./train/X_train.txt")
features <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt")
```

```sh
## bind different datasets
dataLabels <- rbind(test.labels, train.labels)
dataSubject <- rbind(test.subjects, train.subjects)
dataSets <- rbind(test.set, train.set)
```

```sh
## Give them some names
names(dataSubject) <-c("subject")
names(dataLabels) <- c("activity")
names(activityLabels) <- c("activity","activityName")
names(dataSets) <- features$V2
```

```sh
## Combine datasets together
dataCombine <- cbind(dataSubject, dataLabels)
Data <- cbind(dataSets, dataCombine)
```

```sh
## Get only names that include mean or std
featuresMeanStd <- grep("mean\\(\\)|std\\(\\)",features$V2,value=TRUE)
```

```sh
## Lets add "subject" and "activity" to them, so will have complete set ready
dataFeaturesMeanStd <- union(c("subject","activity"), featuresMeanStd)
dataTable <- subset(Data, select=dataFeaturesMeanStd) 
```

```sh
## Now get activityLabels for the activities taht we have
dataTable <- merge(activityLabels, dataTable , by="activity", all.x=TRUE)
```

```sh
## ...database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ...
## ...These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz...
## ...Also the magnitude of these thre...
## ...(Note the 'f' to indicate frequency domain signals). ...
```

```sh
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
```

```sh
## Generate tidy data set with the average of each variable for each activity and each subject.
tidyData <- aggregate( . ~ activityName+subject, dataTable, mean)
write.table(tidyData, "tidyData.txt", sep="\t")
```
