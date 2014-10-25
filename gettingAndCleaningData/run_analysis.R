#--- setup the initial directory...
#      UCI HAR Dataset directory is located in a different directory from the script
#      this directory contains the
#       |-featues.txt,
#       |-activiy_labels.txt,
#       |-test (directory),
#       |-train (direcory)
#       etc..

  #-- store the script directory into a variable
  #-- later to use for output the tidy_data.txt file...
  outputFileName <- paste(getwd(),"/","tidy_data.txt",sep="")

  #-- set the working directory as below
  setwd("../../dataFiles/c03/UCI HAR Dataset")

  #-- load the data.table library...

  library(data.table)


#----------------------- 00 SETUP
# Merges the training and the test sets to create one data set.
# create global datasets for FEATURES and ACTIVITY LABLES to be used
# This data sets will be used in TEST and TRAIN data sets.
#-----------------------

  #----  read the Features.txt file and load into dfFeatures

  dfFeatures <- read.table("./features.txt")

  #---- read the activity lables txt file into dfActivityLabels

  dfActivityLabels <- read.table("./activity_labels.txt")

  subjectFilesToRead <- c("./test/subject_test.txt", "./train/subject_train.txt")
  xValueFilesToRead <- c("./test/x_test.txt", "./train/x_train.txt")
  yValueFilesToRead <- c("./test/y_test.txt", "./train/y_train.txt")

#----------------------- 01
# Read a merged dataset combining Test and Train data
#-----------------------

  # load the TEST and TRAIN datasets
  # by calling the files to be loaded and rbinding the read files into single
  # dataset

  dfSubjectALL <- do.call ("rbind", lapply(subjectFilesToRead, read.table))
  yValuesALL <- do.call ( "rbind",  lapply(yValueFilesToRead, read.table))
  xValuesALL <- do.call ( "rbind", lapply(xValueFilesToRead, read.table))


#----------------------- 02
# Extract the measurements on the mean and standard deviation.
# a vector for columns having -std() OR -mean() (inclusive of meanFreq() )
#-----------------------

  colToConsider <- grepl("-std()|-mean()", dfFeatures[,2])

#----------------------- 03
# Use descriptive activity names to name the activities in the dataset
#-----------------------

  #-- add a new column for descriptive activity names by looking up
  #-- the activiy_labels loaded in dfActivityLables dataset

  yValuesALL$V2 <- dfActivityLabels[yValuesALL$V1, 2]

#----------------------- 04
# Label the data set with descriptive variable names
#-----------------------

  # -------------------------------------------
  # tidy up the test data with proper col names
  # -------------------------------------------

  names(dfSubjectALL) = "Subject"
  names(yValuesALL) = c("Activity_Id", "Activity")
  names(xValuesALL) = dfFeatures[,2]

#----------------------- 05
# Extracts only the measurements on the mean and standard deviation for each measurement.
# include only cols we want usinf the logical vector setup earlier
#-----------------------

  xValuesALL <- xValuesALL[,colToConsider]

  # combine them into one dataset
  # -----------------------

  dfCombined <- cbind(dfSubjectALL, yValuesALL, xValuesALL)

  #-- average of each variable for each activity and each subject.

  #-- when using aggregate, apply mean function to the features columns only
  #-- (starting from 4th col till the end) according to Subject and Activity

  dfTidyData <- aggregate(dfCombined[,4:ncol(dfCombined)], by=list(Subject = dfCombined$Subject, Activity = dfCombined$Activity), FUN=mean, na.rm = TRUE)

  # write the tidy data into a tab delimited text file, without the row names column
  write.table( dfTidyData, outputFileName, sep = "\t", row.names = FALSE)
