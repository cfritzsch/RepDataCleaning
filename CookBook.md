# Description of variables

The original description of variables and variable names can be found in the dataset that is downloaded when the analysis is run in the files "features.txt", "features_info.txt" and "README.txt".

I modified the variable names of features such that they contain mean in front of them, as I calculated the mean over the features for each combination of subjects and activities.

I added three columns:
- "activity": denotes the activity of the person, as given in the "y_train.txt" and "y_test.txt" files, with the numbers being replaced by text from "activity_labels.txt"
- "set": denotes whether row is from "test" or "train" set
- "subject": number, indicating which subject performed the tasks



# Code:


## Load data

- download data and unzip

```r

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI-HAR-Dataset.zip")
unzip("UCI-HAR-Dataset.zip")
setwd("./UCI HAR Dataset")

```

- load all important files

```r
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

```

## Merge data

- add activity labels and subjects to features
- create additional column specifying whether this is test or training data
- merge test and train data

```r

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
```

## Provide descriptive variable and activity names

- give variable descriptive names
```r
colnames(allData) <- c(colLabs$V2, "set", "subject", "activity")

```

- give activities descriptive names
```r
allData$activity <- as.factor(actLabs$V2[allData$activity])
```

## Extract variables with mean and standard deviation
```r

# get column indices with mean and std values
meanStdIdx <- c(grep("mean",colnames(allData)),
                grep("std",colnames(allData)))

# also retain columns with info on set, subject and activity
meanStdIdx <- c(meanStdIdx, ncol(allData) - c(0,1,2))

allData <- allData[,meanStdIdx]

```

## Create a second, independent tidy data set with the average of each variable for each activity and each subject.

```r

avgData <- allData %>%
            unite(ssa, subject, set, activity, sep = ".") %>%
            group_by(ssa) %>%
            summarise_each(funs(mean)) %>%
            separate(ssa, c("subject","set","activity"), sep = "[.]")

colnames(avgData)[4:ncol(avgData)] <- paste("mean", colnames(avgData)[4:ncol(avgData)], sep = "-")

```

## save data
```r
write.table(avgData, "../tidy_avg.txt", row.names = FALSE, quote = FALSE)
```

