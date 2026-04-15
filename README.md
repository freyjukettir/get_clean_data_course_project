# Getting and Cleaning Data Course Project

## *Avanti!*

##The Brief

Create one R program which:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## The Data

The dataset to be used for this project: *Human Activity Recognition Using Smartphones*

*Full description available at the URL whence the data were obtained:*

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

*Raw Data can be downloaded via:*

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Files

*code_book.md* describes the variables, the data, and any transformations or work that was performed to clean up the data.

*run_analysis.R* contains the program required to generate the tidy data files . 

*composite_data.csv* contains the raw data manipulated per the requirements of item 4 of the brief.

*composite_data_summary_means.csv* contains the summarized data per the requirement of item 5 of the brief.

## *run_analysis.R* - Description of operation

###Preliminary matters:

This description closely follows the in-line commentary to be found in *run_analysis.R*.

1. We will operate under the assumption that the data have been downloaded and extracted to a directory named "UCI_HAR_Dataset", preserving the directory structure within the .zip archive.
2. Load the tidyverse and janitor packages. Install them if necessary; this program will make no changes to the user's R setup or libraries by design.
3. Set the working directory (for the writer's configuration; adapt as needed to your own).
4. Read in information common to both data sets: features (variable names) and activity labels (activity names).
5. Create a vector of column headers, adding labels for subject and activity to the head of the vector, that we 
   can use for both the "test" and "train" data sets.

###Import and initial manipulation:

1. Read in the "test" data set and its ancillary information (subject, activity). Add the subject and activity IDs to the dataframe via cbind().
2. Name the columns with the vector of column headers created earlier.
3. Identify the columns needed in the final data set - those which contain means and standard deviations of variables - names which contain mean() or std().
4 Cut the data set down to the columns of concern.
5. Repeat this process for the "train" data set.


###Assemble the "test" and "train" data sets into the composite data set.

1. Use rbind() to connect the data sets head to tail. 
2. Assign descriptive activity labels, drawn from "activity_labels.txt", using merge().
3. Merging adds the activity_name column to the right side of the dataframe. We therefore
   reorder the columns for clarity.
4. Group the data for further analysis, arrange by subject and activity, and clean up 
   the messy column names for improved human readability of the data set:
5. Do a little housekeeping to free up some RAM.

###Create the requested summary data set.

*This data set is to contain the means of the variables in the composite data set, grouped by subject and activity.*

1. As one cannot calculate a mean on a character variable, we must lose the activity_name column in the summary calculation, then add it back to the final summary data set.
2. Adjust the key column name to match that in our summary dataframe, then
merge them back together. An unfortunate side effect of this merge disturbs out neat 
arrangement by subject and activity, and puts the activity_name column on the far side of the dataframe (column 69). 
3. Therefore we will:
	1. Relocate the activity_name column. 
	2. Rearrange the dataframe by subject and activity.
	3. Clean up the column names using janitor::clean_names()
	for a nice, human-readable data set.

4. Finish the cleanup by removing the last intermediate from RAM.

###Generate output.

1. Write .csv files of both the composite and summary data sets for storage, sharing, and future analysis.
