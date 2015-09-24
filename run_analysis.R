#===============================================================================================
# Project objective:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#===============================================================================================

#set library path for that session
.libPaths("D:\\RScripts\\library")

#set working dir
setwd("D:\\RScripts\\Coursera\\UCI HAR Dataset")


#======================================START OF CODE================================================================
#load the libraries required
library(dplyr)
library(reshape2)

#read in the trainin data
train_data <- read.table("train/X_train.txt")
train_activityID <- read.table("train/y_train.txt")
train_subjID <- read.table("train/subject_train.txt")

#read in the test data
test_data <- read.table("test/X_test.txt")
test_activityID <- read.table("test/y_test.txt")
test_subjID <- read.table("test/subject_test.txt")

#read in the activity labels which gives the Activity name of each ID
activityID_name <- read.table("activity_labels.txt")

#read in the features which gives the feature names of each column number of the data
feature_name <- read.table("features.txt")

#append training Subject ID & Activity ID to the data at the front of the training data
train_all <- cbind(train_subjID, train_activityID, train_data)
#append test Subject ID & Activity ID to the data at the front of the test data
test_all <- cbind(test_subjID, test_activityID, test_data)

#append the complete test data to the bottom of the complete training data
#Solution to (1): Complete data set
ALL_DATA <- rbind(train_all, test_all)
#============================================End of Part 1================================================

#column 1 of feature_name being the ID & column 2 being the name, replace the name (column 2) to something easier to search for
feature_name[,2] = gsub('-mean', 'Mean', feature_name[,2])
feature_name[,2] = gsub('-std', 'Std', feature_name[,2])
feature_name[,2] = gsub('[-()]', '', feature_name[,2])

#find the column numbers which contain either "Mean" or "Std"
features_selected <- grep(".*Mean.*|.*Std.*", feature_name[,2])
#take a subset of the original feature_name that contains only the required columns
sel_feature <- feature_name[features_selected,]

#take a subset of the original train data that contains only the required columns
sel_traindata <- train_data[,features_selected]
#take a subset of the original test data that contains only the required columns
sel_testdata <- test_data[, features_selected]
#append the Subject ID & Activity ID to the back of the respective train & test Data
sel_trainall <- cbind(sel_traindata, train_subjID, train_activityID)
sel_testall <- cbind(sel_testdata, test_subjID, test_activityID)

#append test data below training data
#Solution to (2): Complate data set with only the Means & Standard Deviation of each measurement
selALLDATA <- rbind(sel_trainall, sel_testall)
#============================================End of Part 2===============================================

#assign column names to the data
#Part 4 was done before 3 as it is always easier to work with properly labelled columns
#Solution to Part (4): Give appropriate labels to variables
colnames(selALLDATA) <- c(sel_feature$V2, "SubjectID", "ActivityID")
#============================================End of Part 4===============================================

#assign column names to Activity label so that we can use the column name later when calling the Merge function
colnames(activityID_name) <- c("ActivityID", "ActivityName")
#merge the data between these 2 tables like how it is done in DB operations
#Solution to Part (3): Give descriptive activity names to the activities in the data
selALLDATA_wActivityName<-merge(selALLDATA, activityID_name, by.x="ActivityID",by.y="ActivityID" )[-1]
#============================================End of Part 3===============================================

#turn data into a Flat format of 4 columns (SubjectID, ActivityName, Variable, data), where all measurements become Variables, using the "melt" function
FinalData <- melt(selALLDATA_wActivityName, id = c("SubjectID", "ActivityName"))
#rearrange data in "crosstab" format and calculate the mean of each variable using dcast
#Solution to Part (5): create tidy dataset with mean of each variable for each subject & activity
FinalData_wMean <- dcast(FinalData, SubjectID + ActivityName ~ variable, mean)
#============================================End of Part 5===============================================

#output the data
write.table(FinalData_wMean, "tidy.txt", row.names = FALSE, quote = FALSE)

#===========================================END OF CODE==================================================
