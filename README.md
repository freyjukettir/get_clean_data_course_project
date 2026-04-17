# Getting and Cleaning Data Course Project

## *Avanti!*

## The Brief

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

### Preliminary matters:

This description closely follows the in-line commentary to be found in *run_analysis.R*.

1. We will operate under the assumption that the data have been downloaded and extracted to a directory named "UCI_HAR_Dataset", preserving the directory structure within the .zip archive.
2. Load the tidyverse and janitor packages. (The user should install them if necessary; this program will make no changes to the user's R setup or libraries by design.)
3. Set the working directory (for the writer's configuration; adapt as needed to your own).
4. Read in information common to both "test" and "train" data sets: features (variable names) and activity labels (activity names).
5. Create a vector of column headers, adding labels for subject and activity to the head of the vector, that we 
   can use for both the "test" and "train" data sets.

### Import and initial manipulation:

*Due to the limited free RAM in the writer's office desktop, each data set was manipulated separately and the two were combined prior to the summary mean calculations. The brief does not specify the order in which the manipulations and merging must occur, only that both must be done.*

1. Read in the "test" data set and its ancillary information (subject, activity). Add the subject and activity IDs to the dataframe via cbind().
2. Name the columns with the vector of column headers created earlier.
3. Identify the columns needed in the final data set - those which contain means and standard deviations of variables - names which contain mean() or std().
4. Cut the data set down to the columns of concern. *(This reduces the size of each dataframe by 87%.)*
5. Repeat this process for the "train" data set.

**This satisfies point 2 of the brief.**

### Assemble the "test" and "train" data sets into the composite data set.

1. Use rbind() to connect the data sets head-to-tail. 
2. Assign descriptive activity labels, drawn from "activity_labels.txt", using merge().
3. Merging adds the activity_name column to the right side of the dataframe. We therefore
   reorder the columns for clarity.
4. Group the data for further analysis and arrange by subject and activity.
5. Do a little housekeeping to free up some RAM.

**This satisfies point 1 of the brief.**

### Create the requested summary data set.

*The data set is to contain the means of the variables in the composite data set, grouped by subject and activity.*

1. Compute the mean of each variable in the data set, for each combination of subject and activity.

**This satisfies point 3 of the brief.**

2. As one cannot calculate a mean on a character variable, we drop the activity_name column in the summary calculation, then add it back to the final summary data set.
3. Adjust the key column name to match that in our summary dataframe, then
merge them back together. An unfortunate side effect of this merge disturbs out neat 
arrangement by subject and activity, and puts the activity_name column on the far side of the dataframe (column 69). 
4. Therefore we will:
	1. Relocate the activity_name column. 
	2. Rearrange the dataframe by subject and activity.
	3. Clean up the column names using `janitor::clean_names()` to remove camel case and parentheses, replace hyphens with underscores, and break up names for better readability. The use of this function eliminates the need for multiple `gsub()` expressions.
	4. Prefix the columns containing summary means with "xbar_" to indicate that these are means of the column variables.
    5. Variable names remain abbreviated, but are now obviously descriptive and easier to read. The naming convention is explained in the accompanying code book.
       
	**This satisfies point 4 of the brief.**

6. Finish the cleanup by removing the last intermediate from RAM. The `composite_data` and `composite_data_summary_means` dataframes remain in memory for the generation of output file(s) and further analysis if desired.

### Generate output.

1. Write .csv files of both the composite (optional) and summary data sets for storage, sharing, and future analysis.
	1. *composite_data.csv* - To generate this file, uncomment the command indicated in the program.
 	2. *composite_data_summary_means.csv* - Default output file.

**This satisfies point 5 of the brief.**
