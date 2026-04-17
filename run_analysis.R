# Getting and Cleaning Data Course Project
#
# run_analysis.R
#
# C. L. Basso, M.Sc.
# 2026-04-16

# We will operate under the assumption that the data have been downloaded and 
# extracted to a directory named "UCI_HAR_Dataset", preserving the directory
# structure within the .zip archive.

# Avanti!
# First, load the tidyverse and janitor packages.

library(tidyverse)
library(janitor)

# Set the working directory (for the writer's configuration; adapt as needed
# to your own).

setwd("C:/etc/Data_Science_Specialization/C03_Getting_and_Cleaning_Data/W04/UCI_HAR_Dataset")

# First, we'll pull in common information: features (variable names)

headers <- read.csv("./features.txt", sep = " ", header=FALSE)

# and activity labels (names).

activity_labels <- read.csv("./activity_labels.txt", sep = " ", header = FALSE, 
                            col.names = c("activity", "activity_name"))

# Next, we'll create a vector of column headers, adding labels for subject 
# and activity, that we can use for both "test" and "train" data sets.

header_v <- c("subject", "activity", headers[, 2])

# Identify the columns (variables) that we want to extract from the data set:
# mean and standard deviation (std) for each feature.

columns_of_concern <- grep("-mean\\(\\)|-std\\(\\)", header_v)

# Now import the "test" data set and its ancillary information.

data_test       <- read.fwf("./test/X_test.txt", widths = c(rep(16, 561)), 
                            header=FALSE)
subjects_test   <- read.fwf("./test/subject_test.txt", widths = 16)
activities_test <- read.fwf("./test/y_test.txt", widths = 16)

# And add subject and activity IDs.

data_test <- cbind(subjects_test, activities_test, data_test)

# Name the columns with the vector created above.

names(data_test) <- header_v

# Now we cut the data set down to the columns of concern, per direction
# (mean and standard deviation of each feature)

data_test <- data_test[, c(1, 2, columns_of_concern)]

# Import and initial manipulation for the "testing" data set is now complete.

# Repeat the process for the "training" data set:

# Import the training data set

data_train       <- read.fwf("./train/X_train.txt", widths = c(rep(16, 561)), 
                             header=FALSE)
subjects_train   <- read.fwf("./train/subject_train.txt", widths = 16)
activities_train <- read.fwf("./train/y_train.txt", widths = 16)

# And add the subject and activity IDs

data_train <- cbind(subjects_train, activities_train, data_train)

# Name the columns with the vector created above

names(data_train) <- header_v

# Cut the data set down to the columns of concern, per direction
# (mean and standard deviation of each feature).

data_train <- data_train[, c(1, 2, columns_of_concern)]

# Import and initial manipulation for the "training" data set is now complete.

# Now to assemble "testing" and "training" data into the composite data set...

# rbind() links the data sets in succession
composite_data <- rbind(data_test, data_train)

# Assign descriptive activity labels, drawn from "activity_labels.txt"

composite_data <- merge(composite_data, activity_labels)

# Group the data for further analysis, arrange by subject and activity, and
# clean up the column names using janitor::clean_names() for improved human 
# readability of the data set:

composite_data <- composite_data |> 
    arrange(subject, activity) |> 
    clean_names()

# Now for a little housekeeping to free up some RAM:

remove(activities_test, activities_train, data_test, 
       data_train, headers, header_v, subjects_test, subjects_train)

# Create the requested summary data set (item 5) containing the means of the 
# variables in the composite data set, grouped by subject and activity:

composite_data_summary_means <- composite_data |> 
    group_by(subject, activity) |> 
    summarise(across(-activity_name, \(x) mean(x, na.rm = TRUE)))

# As we had to lose the activity names in the summary calculation above (can't 
# calculate a mean on a character variable!), we'll just add them back in now. 
# First, we need to make the key column name line up with our summary
# dataframe:

names(activity_labels) <- c("activity", "activity_name")

# And merge them back together. 

composite_data_summary_means <- merge(composite_data_summary_means, activity_labels)

# The merging we just performed has the unfortunate side effect of
# discombobulating our neat arrangement by subject and activity. So we'll put the
# activity_name column where we want it then rearrange by subject and activity:

composite_data_summary_means <- select(composite_data_summary_means, 
                                       2, 1, 69, c(3:68)) |> 
    arrange(subject, activity)

# And indicate that these are means of the data by prefixing the variable names 
# with "xbar_":

names(composite_data_summary_means) <- c(
    names(composite_data_summary_means)[1:3], 
    paste("xbar_", names(composite_data_summary_means)[4:69], sep = ""))

# And to finish the cleanup, remove the last intermediate from RAM:
remove(activity_labels)

# Write .csv file of data set(s) for storage, sharing, and future analysis

# Un-comment this region to write out the full composite data set if desired.

# --------------------------------------------------------
#write.csv(composite_data, 
#          file = "composite_data.csv", 
#          row.names = FALSE)
#---------------------------------------------------------

write.csv(composite_data_summary_means, 
          file = "composite_data_summary_means.csv", 
          row.names = FALSE)


