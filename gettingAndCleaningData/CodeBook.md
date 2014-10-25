# CodeBook for the tidy dataset

## About this file
This file describes the data, variables and approach that has been taken to clean up the data.

## Dataset Description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensore signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Each record includes:

    1. Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
    2. Triaxial Angular velocity from the gyroscope.
    3. A 561-feature vector with time and frequency domain variables.
    4. Its activity label.
    5. An identifier of the subject who carried out the experiment.


Descriptions of files included in the dataset:


    1. 'features_info.txt': Shows information about the variables used on the feature vector.
    2. 'features.txt': List of all features.
    3. 'activity_labels.txt': Links the activity ids with their activity name.
    4. 'train/X_train.txt': Training set.
    5. 'train/y_train.txt': Training labels.
    6. 'test/x_test.txt': Test set.
    7. 'test/y_test.txt': Test labels.
    8. 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
    9. 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
    10. 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.
    11. 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.


## Variables

The features selected for this database come from the accelerometer and gyroscope
3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals
(prefix 't' to denote time) were captured.

Subsequently, the body linear acceleration and angular velocity
were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ).
Also the magnitude of these three-dimensional signals were calculated
using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag,
tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

## Analysis

### Load the datasets of training and test, activity labels and features

Download and unzip the data based on the url as provided in the assignment instructions.

Since the directory where the data for this exercise is un-zipped is different from the
script for this project, storing the output location in a variable `outputFileName`.

```
outputFileName <- paste(getwd(),"/","tidy_data.txt",sep="")

```

Use `read.table` to load the data.

```
dfFeatures <- read.table("./features.txt") # load the features
dfActivityLabels <- read.table("./activity_labels.txt") # load the activity lables

# setup the files to read for both the test and train data
dfSubjectALL <- do.call ("rbind", lapply(subjectFilesToRead, read.table))
yValuesALL <- do.call ( "rbind",  lapply(yValueFilesToRead, read.table))
xValuesALL <- do.call ( "rbind", lapply(xValueFilesToRead, read.table))
````

### Now read the COMBINED test & train data ...

````
dfSubjectALL <- do.call ("rbind", subjectFilesToRead)
yValuesALL <- do.call ( "rbind", yValueFilesToRead)
xValuesALL <- do.call ( "rbind", xValueFilesToRead)

```

### Extracts only the measurements on the mean and standard deviation for each measurement.

As we are only interested in the variables on mean and standard deviation, we will setup a logical vector
using the regular expression function `grepl` for columns containing words "-std" OR "-mean". This will
include meanFreq() columns also.

`colToConsider <- grepl("-std()|-mean()", dfFeatures[,2])`

### Uses descriptive activity names to name the activities in the data set

The descriptive activity names are loaded into `dfActivityLables` dataset,
and it is used to add a new column the combined data.

```
yValuesALL$V2 <- dfActivityLabels[yValuesALL$V1, 2]
```

### Label the data set with descriptive variable names.

Tidying up of the combined data with descriptive variable names
```
names(dfSubjectALL) = "Subject"
names(yValuesALL) = c("Activity_Id", "Activity")
names(xValuesALL) = dfFeatures[,2]
```

### Extracts only the measurements on the mean and standard deviation for each measurement.

Select only the variables we want to consider the logical vector `colToConsider` declared earlier
```
xValuesALL <- xValuesALL[,colToConsider]
```

Now, we merge the datasets using `cbind` function

```
dfCombined <- cbind(dfSubjectALL, yValuesALL, xValuesALL)
```

### Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The `aggregate` function and apply `mean` function to all the features columns only (starting from 4th column till the end) and according to each Subject and each Activity. The tidy data is then stored in `dfTidyData`  data table

```
dfTidyData <- aggregate(dfCombined[,4:ncol(dfCombined)], by=list(Subject = dfCombined$Subject, Activity = dfCombined$Activity), FUN=mean, na.rm = TRUE)
```

Finally write the `dfTidyData` into a tab delimited text file, excluding the row names column by
setting `row.names=FALSE`. The `outputFileName` is defined at the start of the script.

```
write.table( dfTidyData, outputFileName, sep = "\t", row.names = FALSE)
```
