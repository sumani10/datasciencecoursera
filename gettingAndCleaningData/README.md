# Getting and Cleaning Data

The purpose of this project is to prepare tidy data that can be used for later analysis.

The data for the project is available at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Change to script to enable proper execution

    1. Edit the run_analysis.R to change the directory where the data is un-zipped:
      `setwd("../../dataFiles/c03/UCI HAR Dataset")``
    3. Run the `run_analysis.R`, to create the output file after loading, merging and transforming the data.

## Outputs produced

    1. Tidy dataset `tidy_data.txt`, which is a tab-delimited text file.
