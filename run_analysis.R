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

# Next, we'll create a vector of column headers, pre-pending labels for subject 
# and activity, that we can use for both "test" and "train" data sets.
header_v <- c("subject", "activity", headers[, 2])

columns_of_concern <- grep("-mean\\(\\)|-std\\(\\)", header_v)

# Now pull in the "test" data set and its ancillary information.
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

# The process is repeated for the "training" data set:

# Pull in the training data set
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

# The activity_name column is added to the right side of the dataframe, so we
# reorder the columns for clarity (put activity code and type together,
# and pair the the mean and standard deviation for each axis):
#composite_data <- select(composite_data, 2, 1, 9, 3, 6, 4, 7, 5, 8)

# Assign descriptive (and less clumsy) variable names:
# names(composite_data) <- c("subject_id", "activity_id", "activity_name",
#                            "body_acc_mean_X", "body_acc_sd_X", "body_acc_mean_Y",
#                            "body_acc_sd_Y", "body_acc_mean_Z", "body_acc_sd_Z")

# Group the data for further analysis, arrange by subject and activity, and
# clean up the messy column names for improved human readability 
# of the data set:
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
# First, we need to making the key column name line up with our summary
# dataframe:
names(activity_labels) <- c("activity", "activity_name")

# And merge them back together. 
composite_data_summary_means <- merge(composite_data_summary_means, activity_labels)

# The merging we just performed has the unfortunate side effect of
# discombobulating our neat arrangement by subject and activity. So we'll put 
# activity_name column where we want, rearrange by subject and activity, and
# and clean up the column names for a nice, human-readable data set:
composite_data_summary_means <- select(composite_data_summary_means, 
                                       2, 1, 69, c(3:68)) |> 
    arrange(subject, activity)

# And to finish our cleanup, remove the last intermediate from RAM:
remove(activity_labels)

# Write .csv files of both data sets for storage, sharing, and future analysis
write.csv(composite_data, 
          file = "composite_data.csv", 
          row.names = FALSE)
write.csv(composite_data_summary_means, 
          file = "composite_data_summary_means.csv", 
          row.names = FALSE)




