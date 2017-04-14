
## Load data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI-HAR-Dataset.zip")
unzip("UCI-HAR-Dataset.zip")
setwd("./UCI HAR Dataset")

# test data
Xtest <- read.table("test/X_test.txt")
Ytest <- read.table("test/Y_test.txt", col.names = "activity")
subtest <- read.table("test/subject_test.txt", col.names = "subject")

# train data
Xtrain <- read.table("train/X_train.txt")
Ytrain <- read.table("train/Y_train.txt", col.names = "activity")
subtrain <- read.table("train/subject_train.txt", col.names = "subject")

# column labels
colLabs <- read.table("features.txt", sep = " ", stringsAsFactors = FALSE)

# activity labels
actLabs <- read.table("activity_labels.txt", sep = " ", stringsAsFactors = FALSE)



## Merge data

# add activity labels and subjects to features
# create additional column specifying whether this is test or training data
# merge test and train data

library(tidyr)
library(dplyr)

# add activity labels and subjects to features
testData <- Xtest %>%
                  mutate(set = "test") %>% # add label for test set
                  bind_cols(subtest) %>%
                  bind_cols(Ytest)
                  
trainData <- Xtrain %>%
                  mutate(set = "train") %>% # add label for train set
                  bind_cols(subtrain) %>%
                  bind_cols(Ytrain)

# merge test and train data
allData <- bind_rows(testData, trainData)


## Provide descriptive variable and activity names

# give variable descriptive names
colnames(allData) <- c(colLabs$V2, "set", "subject", "activity")

# give activities descriptive names
allData$activity <- as.factor(actLabs$V2[allData$activity])


## Extract variables with mean and standard deviation

# get column indices with mean and std values
meanStdIdx <- c(grep("mean",colnames(allData)),
                grep("std",colnames(allData)))

# also retain columns with info on set, subject and activity
meanStdIdx <- c(meanStdIdx, ncol(allData) - c(0,1,2))

allData <- allData[,meanStdIdx]


## Create a second, independent tidy data set with the average of each variable for each activity and each subject.
avgData <- allData %>%
            unite(ssa, subject, set, activity, sep = ".") %>%
            group_by(ssa) %>%
            summarise_each(funs(mean)) %>%
            separate(ssa, c("subject","set","activity"), sep = "[.]")

colnames(avgData)[4:ncol(avgData)] <- paste("mean", colnames(avgData)[4:ncol(avgData)], sep = "-")

## save data
write.table(avgData, "../tidy_avg.txt", row.name = FALSE, quote = FALSE)


