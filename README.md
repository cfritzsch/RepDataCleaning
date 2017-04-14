This is my submission for the Getting and Cleaning Data Course Project.

If you run the run_analysis.R script it will download the "Human Activity Recognition Using Smartphones" dataset and process the files such that a tiny dataset is created and saved to tidy_avg.txt.

First, all feature values are loaded along with its activity type and test subject for both test and training set.
The activity type ("activity") and subject ("subject") are added as columns to the features. Furthermore, a column is added that indicates whether the row belongs to test or training set ("set"). Then the training and test sets are concatenated. The variable names are loaded from features.txt and used as column names. Descriptive names of activities are loaded from activity_labels.txt and used within the activity column.

Columns are extracted in which the columnname contains either "mean" or "std".

The mean of each feature was calculated for each combination of subject and activity and saved to tidy_avg.txt. The file can be loaded with 

The CookBook.md file contains the code that was used to process the data and explanations of the variables in tidy_avg.txt.