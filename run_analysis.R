## Coursera Getting and Cleaning Data Final

library(dplyr)

## Step 1


# Download the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl ="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Course3.zip",method="curl")

# Unzip the folder
if (!file.exists("UCI HAR Dataset")) { 
  unzip("Course3.zip") 
}

# Read in files from folder 

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Merge train and test data and subject datasets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
mergedData <- cbind(subject, Y, X)

## Step 2: extract mean and standard deviation

newdata <- mergedData %>% select(subject,
              code, contains("mean"), contains("std"))

# Step 3: Assign activities to activity codes
newdata$code <- activities[newdata$code, 2]

# Step 4: Appropriately label dataset

names(newdata)[2] = "Activity"
names(newdata)<-gsub("Acc", "Accelerometer", names(newdata))
names(newdata)<-gsub("Gyro", "Gyroscope", names(newdata))
names(newdata)<-gsub("BodyBody", "Body", names(newdata))
names(newdata)<-gsub("Mag", "Magnitude", names(newdata))
names(newdata)<-gsub("^t", "Time", names(newdata))
names(newdata)<-gsub("^f", "Frequency", names(newdata))
names(newdata)<-gsub("tBody", "TimeBody", names(newdata))
names(newdata)<-gsub("-mean()", "Mean", names(newdata), ignore.case = TRUE)
names(newdata)<-gsub("-std()", "STD", names(newdata), ignore.case = TRUE)
names(newdata)<-gsub("-freq()", "Frequency", names(newdata), ignore.case = TRUE)
names(newdata)<-gsub("angle", "Angle", names(newdata))
names(newdata)<-gsub("gravity", "Gravity", names(newdata))

# Step 5: create table

finalData <-aggregate(. ~subject + Activity, newdata, mean)
finalData <-finalData[order(finalData$subject,finalData$activity),]
write.table(finalData, file = "finalData.txt", row.name = FALSE)
str(finalData) # to check the data
 


