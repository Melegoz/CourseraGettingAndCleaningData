# IMPORTANT NOTE: this scripts operates on data from:
# Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
# Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
# International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

# The script is free to use, all rights on data belongs to the above mentioned owners.


run_analysis <- function(){
  
  # check if the needed package data.table is installed
  if (!("data.table" %in% rownames(installed.packages()))) {
    print("Please install required package \"data.table\" before proceeding")
  } else {
  
  # load test data into a dataframe
  testData_Subject = read.table("UCI HAR Dataset/test/subject_test.txt")
  testDataSet = read.table("UCI HAR Dataset/test/X_test.txt")
  testDataActivityID = read.table("UCI HAR Dataset/test/Y_test.txt")
  
  # load training data into a dataframe
  trainData_Subject = read.table("UCI HAR Dataset/train/subject_train.txt")
  trainDataSet = read.table("UCI HAR Dataset/train/X_train.txt")
  trainDataActivityID = read.table("UCI HAR Dataset/train/Y_train.txt")
  
  # Here we load the Features table and the Activities table
  # We take advantage of the col.name function to give a name to both columns in both tables while uploading them
  features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
  
  # with grep function i am going to select only the features specified by the assignment (mean & std)
  # this will return a vector with row index positions of where i find mean or std
  selectedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
  
  # the table activities will be used for lookup information in order to replace the activity ID 1,2,3..with it's proper name
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
  
  # with gsub i'm going to "clean" the activities lables where there is "_" by substituting with a space,
  # all the activities lable that doesn't match it will be unchanged
  activities$activityLabel <- gsub("_", "\\1 \\2", as.character(activities$activityLabel))
  
  # Next step is to merge test and training data, with rbind i put one after the other one
  # Start with merging subject, after that i give a name to the subject vector
  subject <- rbind(testData_Subject, trainData_Subject)
  names(subject) <- "subjectId"
  
  # same goes for combining test and train datasets
  combinedData <- rbind(testDataSet, trainDataSet)
  
  # here i subset the combinedData by selecting only those columns which their index matches the one
  # from selectedFeature vector
  combinedData <- combinedData[, selectedFeatures]
  
  # assign the the features name to the column of combinedData. As i have subsetted combined data using "selectedFeatures"
  # i do the same subset also for the lables, this way each lable will match the proper column
  names(combinedData) <- features$featureLabel[selectedFeatures]
  
  # get the list of variables in combinedData
  variableNames <- names(combinedData)
  
  # create a vector with all the abbreviations
  abbreviated <- c("^f", "^t", "Acc", "-mean\\(\\)", "-meanFreq\\(\\)", "-std\\(\\)", "Gyro", "Mag", "BodyBody")
  # create a vector with significant name for each abbreviation
  corrected <- c("freq", "time", "Acceleration", "Mean", "MeanFrequency", "Std", "Gyroscope", "Magnitude", "Body")
  
  # replace each abbreviated element with its significant one
  for(i in seq_along(abbreviated)){
    variableNames <- sub(abbreviated[i], corrected[i], variableNames)
  }
  
  # assign the corrected variable names to the header of combinedData
  names(combinedData)<- variableNames
  
  # i then put together the 2 data table containing the IDs of the activities performed, both in Test and Train
  combinedActivityID <- rbind(testDataActivityID, trainDataActivityID)
  names(combinedActivityID) = "activityId"
  
  # Then i associate a lable to each activity ID by merging the 2 tables, by"activityID" as key field
  activity <- merge(combinedActivityID, activities, by="activityId")$activityLabel
  
  # now i put everything together to form a unique data table made of subject of the activity, the activity
  # and the performance (combinedData)
  data <- cbind(subject, activity, combinedData)
  
  melted<- melt(data, id = c("subjectId", "activity"))
  
  # write the data table on a new file
  write.table(data, "combined_tidy_data.txt")
  
  # now i will calculate the mean per each activity and variable, based on previous dataset
  # load the necessary libraries
  library(dplyr)
  library(data.table)
  # i convert the melted data set into a data.table
  meltedDT<- data.table(melted)
  setkey(meltedDT, subjectId, activity, variable)
  # here i calculate the mean
  calculatedMean <- meltedDT[, list(average = mean(value)), by=key(meltedDT)]
  # write the result on a txt file
  write.table(calculatedMean, "calculated_tidy_data.txt", row.name=FALSE)
  
  }
}