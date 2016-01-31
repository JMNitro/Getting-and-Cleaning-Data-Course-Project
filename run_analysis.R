## You should create one R script called run_analysis.R that does the following.

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## - 'activity_labels.txt': Links the class labels with their activity name.
## - 'train/X_train.txt': Training set.
## - 'train/y_train.txt': Training labels.
## - 'test/X_test.txt': Test set.
## - 'test/y_test.txt': Test labels.

## Reading data files
test.labels <- read.table("./test/y_test.txt", col.names="label")
test.subjects <- read.table("./test/subject_test.txt", col.names="subject")
test.set <- read.table("./test/X_test.txt")
train.labels <- read.table("./train/y_train.txt", col.names="label")
train.subjects <- read.table("./train/subject_train.txt", col.names="subject")
train.set <- read.table("./train/X_train.txt")
features <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt")

## bind different datasets
dataLabels <- rbind(test.labels, train.labels)
dataSubject <- rbind(test.subjects, train.subjects)
dataSets <- rbind(test.set, train.set)

## Give them some names
names(dataSubject) <-c("subject")
names(dataLabels) <- c("activity")
names(activityLabels) <- c("activity","activityName")
names(dataSets) <- features$V2

## Combine datasets together
dataCombine <- cbind(dataSubject, dataLabels)
Data <- cbind(dataSets, dataCombine)



## Get only names that include mean or std
featuresMeanStd <- grep("mean\\(\\)|std\\(\\)",features$V2,value=TRUE)

## Lets add "subject" and "activity" to them, so will have complete set ready
dataFeaturesMeanStd <- union(c("subject","activity"), featuresMeanStd)
dataTable <- subset(Data, select=dataFeaturesMeanStd) 

## Now get activityLabels for the activities taht we have
dataTable <- merge(activityLabels, dataTable , by="activity", all.x=TRUE)

## ...database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ...
## ...These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz...
## ...Also the magnitude of these thre...
## ...(Note the 'f' to indicate frequency domain signals). ...

names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))

## Generate tidy data set with the average of each variable for each activity and each subject.
tidyData <- aggregate( . ~ activityName+subject, dataTable, mean)
write.table(tidyData, "tidyData.txt", sep="\t")
