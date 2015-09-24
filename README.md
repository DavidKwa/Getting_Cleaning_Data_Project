# Coursera Data Science Scepailisation   
# Course 3 - Getting and Cleaning Data   
## Week 3 Course project   

## Introduction

This Repository contains 3 files:  
1. run_analysis.R - This is the R script that does the following:   
    *  Merges the training and the test sets to create one data set.  
    *  Extracts only the measurements on the mean and standard deviation for each measurement.  
    *  Uses descriptive activity names to name the activities in the data set.  
    *  Appropriately labels the data set with descriptive variable names.  
    *  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
2. README.md - Describes how the script works.     
3. Codebook.md - Describes the variables in the output file.   


## Data   

The scripts assumes the data has been downloaded and unzipped into a folder called "UCI HAR Dataset"


## Script

The flow of the script is as follows:  
1. set the library path for the session (this is where you change it to you own path)   
2. set the working directory (this is where you change it to you own directory)   
3. load the required libraries   
4. read in all the txt files   
5. combine both training and test data into one dataset.   
6. rename the feature names to something easier to serach for   
7. subset out only the Mean & Standard Deviation together with Subject & Activity   
8. assign column names 1st so the dataset looks clearer and makes it easier to work with   
9. use merge function to "join" the dataset with the Activity labels   
10. use melt function to change the dataset to a "flat" format with 4 columns   
11. use dcast function to rearrange data in "crosstab" format and calculate the mean of each variable.   
12. output the data as tidy.txt   