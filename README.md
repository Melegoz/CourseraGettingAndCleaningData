
Getting and Cleaning Data
================================================

In this repository you find all the requested files for the final assignment of the course Getting and Cleaning data, there are **4** files:


- `ReadMe.md` - this file providing the overview of the project and files included in this repository

- `Codebook.md` - description of where i have taken the data, step by step data transformation to obtain the cleaned and calculated output

- `run_analysis.R` - R script (function) that will process the given data according to what described in CodeBook.md

- `calculated_tidy_data.txt` - final tidy dataset with the average values of each variable for each activity and each subject

## Introduction

For this project, the dataset I worked with is the ***Human Activity Recognition Using Smartphones Data Set  from the given*** from the UCI Machine Learning Repository. The data is collected from the recordings of **30** subjects performing **6** different types daily living activities while carrying a waist-mounted smartphone with embedded inertial sensors: 

- walking

- walking upstairs

- walking downstairs

- sitting

- standing

- laying

The full description can be found  [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and the dataset can be manually downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).


## Starting Data

The original data repository includes **4** text files and **2** folders:

- `activity_labels.txt` - the mapping of numeric values 1 to 6 to the 6 activities previously described

- `features.txt` - list of all variable names for 561 variables

- `features_info.txt` - explaination of what variables there are, how they have been created and what they mean

- `README.txt` - overview of the dataset

- **`test`** - folder containing the *test* subset of data (2947 observations), which contain 3 text files and 1 folder

    - `Inertial Signal` - raw signal data from the sensors, irrelevant for this project
    
    - `subject_test.txt` - mapping of each observation to the subject (number 1 to 30) performing the activity
    
    - `X_test.txt` - actual observations for 561 variables from the subset of subjects
    
    - `y_test.txt` - mapping of each observation to the activity performed (number 1 to 6)

- **`train`** - folder containing the *train* subset of data (7252 observations), which contain 3 text files and 1 folder

    - `Inertial Signal` - raw signal data from the sensors, irrelevant for this project
    
    - `subject_train.txt` - mapping of each observation to the subject (number 1 to 30) performing the activity
    
    - `X_train.txt` - actual observations for 561 variables from the subset of subjects
    
    - `y_train.txt` - mapping of each observation to the activity performed (number 1 to 6)
    

These are the steps i have performed to get the requested dataset named `calculated_tidy_data.txt`

1. I have downloaded the data from the given link above
2. Unzipped the data set into a folder named "UCI HAR Dataset"
3. Placed that folder into my working directory

## What does the script `run_analysis.R`does:

The script will merge the test and train data obtained from the 30 users performing the assigned activities, it will clean the activity names giving them a more understandable lable, it will calculate the mean aggregating subjects and activities and finally create a .txt file as output with this cleaned data set.

Here are the actions performed by the script `run_analysis.R` to obtain the tidy and clean dataset with the average of each feature for each activity performed by eahc subject:

1. Check if the needed packages (data.table) are installed, if not i print a warning message
2. Loaded test and training data sets into data frames
3. Loaded features from "features.txt" into a table and gave significant name to its columns
4. I have selected only those features containing either mean or std, as requested by the assignment
5. Loaded the file "activity_labels.txt" into a table, giving significan names to its columns
6. Cleaned the activity lables by removing "_" and replacing it with a space
7. Using rbind i have put together subjects from train and test data
8. Using rbind i have put together the measures from test and train data
9. I have then created a subset of the measurments keeping only the columns related to the requested features
10. I have given a readble name to each column of the measurments
11. Using rbing i have put together the activity ID from test and train data
12. Then i've associated a readable lable to each activity ID
13. Using cbind i have created the desired tidy table for output, putting together Subject, Activity, Measurments
14. Written the new data table on a new file "combined_tidy_data.txt" (this was not required however it is good for anyone who simply wants to check how the tidy data looks like - without the average)
15. Loaded library data.table
16. Coverted the previously obtained output into a data.table
17. Using the function lapply i have calculated the mean by grouping first by subjectId then by activity
18. I have written the output on a new file named "calculated_tidy_data.txt"

## How to use the script:
In order to run the script `run_analysis.R` you have to save the above mentioned data in your working directory and unzip them into "UCI HAR Dataset" folder.
Within your working directory, source and run the `run_analysis.R`

## The output of the script:
The output is a .txt file named `calculated_tidy_data.txt` which contains the tidy and clean dataset with the average of each feature for each activity performed by each subject

Acknowledgements:
=================
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

IMPORTANT NOTE:
=================
The `run_analysis.R` script is free to use, the original data and the output produced by the script are copyrighted and belongs to their respected owners mentioned in the Acknowledgements above.

