# Code Book

### *Data Science Specialization Course - Getting and Cleaning Data course project*

## 1. Overview of the data set
**Source project:**

Human Activity Recognition Using Smartphones Dataset Version 1.0  
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto  
Smartlab - Non-Linear Complex Systems Laboratory, Università degli Studi di Genova, Italy  

For a complete description of the original data, kindly refer to the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

---

## 2. Description of the original data files

Much like Gaul, the original data set is divided into three parts:

* *Metadata:*
    * `README.txt`: General dataset information.
    * `features_info.txt`: Detailed description of original variables.
    * `features.txt`: List of all 561 feature labels.
    * `activity_labels.txt`: Mapping of Activity IDs (1–6) to names.
* *Training Data:*
    * `train/X_train.txt`: Training set measurements.
    * `train/y_train.txt`: Training labels (Activity IDs).
    * `train/subject_train.txt`: IDs of subjects in the training set.
* *Test Data:*
    * `test/X_test.txt`: Test set measurements.
    * `test/y_test.txt`: Test labels (Activity IDs).
    * `test/subject_test.txt`: IDs of subjects in the test set.

 *N.B.: Files within the `Inertial Signals` subdirectories were not used in the course of this project.*

---

## 3. Background and feature selection
The data was collected from 30 subjects performing six activities while wearing a Samsung Galaxy S II on the waist.

### Activities recorded:
1. WALKING
2. WALKING_UPSTAIRS
3. WALKING_DOWNSTAIRS
4. SITTING
5. STANDING
6. LAYING *(sic)*

### Signal processing:
* **Sensors:** 3-axis linear acceleration (Accelerometer) and 3-axis angular velocity (Gyroscope).
* **Sampling:** Captured at 50 Hz.
* **Sample processing:** Samples signals were filtered using a median filter and a 3rd order low pass Butterworth filter (corner frequency 20 Hz) to remove noise. The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter(corner frequency 0.3 Hz).
* **Domain:** Time domain signals (prefix **t**) and calculated Frequency domain signals (prefix **f**).
* **Units:** All features are normalized and bounded within **[-1, 1]**.

### Variable selection:
Per the assignment rubric, variables representing the **mean** and **standard deviation** of measured and calculated quantities were extracted.
* **Subject:** Integer ID of the volunteer (1–30).
* **Activity:** Descriptive name of the activity performed.
* **Features:** 66 variables containing `mean()` or `std()`.

---

## 4. Data transformations
The following processes were performed via the `run_analysis.R` program:

1. **Extraction of measurements:** Only columns containing mean and standard deviation were retained.
	* Mean: variable names containing "mean()".
	* Standard deviation: variable names containing "std()".
2. **Addition of subject and activity data:** Subject and activity data combined with the dataframe containing the columns of concern via the cbind() function.
3. **Assignation of variable names:** Names were assigned to the chosen variables based upon the supplied `features.txt` file.
4. **Merging of data:** Training and Test sets were combined to create one large data frame via the rbind() function.
5. **Addition of descriptive activity names:** Numeric activity IDs were supplemented with their corresponding names from `activity_labels.txt`.
6. **Label cleaning:** Variable names were modified for readability via the `janitor` R package:
    * Parentheses removed
    * Hyphens replaced by underscores
    * Name broken as appropriate with underscores to create a human-readable, yet still compact, variable name; refer to variable name key (vide infra).
7. **Data set creation:** The data was grouped by subject and activity, and the mean of each variable was calculated.
	* To enhance human readability, the data were then arranged (as distinct from *grouping* by subject and activity.
	* Both the full composite data set and the calculated summary data set were generated as comma-delimited (.csv) files.

---
## 5. Variable name key

Descriptive variable names are constructed as follows:

#### *Domain_Component_Source_[descriptors for calculated signal]_Estimator_Axis*

* Domain
	*Time (**t**) or Frequency (**f**)
* Component
	*Body (**body**) or Gravitation (**gravity**)
* Source of the measurement signal
	* Accelerometer (**acc**) or Gyroscopic 3-axis (**gyro**) signal
* Descriptors for calculated/derived measurements
	* Jerk signals (**jerk**) were derived from the accelerometer and gyroscopic signals with respect to time.
	* Magnitude (**mag**) of the accelerometer, gyroscopic, and jerk signals was calculated to the Euclidean norm.
	* A Fast Fourier Transform was applied to certain of the measured and calculated signals to produce frequency domain signals (identified by the domain code "**f**").
* The statistical estimator calculated from the sample data.
	* Mean (**mean**)
	* Standard deviation (**std**)
* The axis of measurement
	* X-axis (**x**), Y-axis (**y**), or Z-axis (**z**)

### Examples:

 **t_body_acc_mean_x** denotes the mean of the time-domain body component of linear acceleration along the X axis.
 **f_body_acc_jerk_std_z** denotes the standard deviation of the frequency-domain body component of the Z axis jerk signal.

## 5. Summary data set structure

**Output Files:** 
* `composite_data.csv`: Full composite data set
	*10299 observations
	*69 variables
* `composite_data_summary_means.csv`: Calculated means by subject and activity of the composite data set.
	* 180 observations (30 subjects, 6 activities each)
	* 69 variables.

| Variable | Type | Description |
| :--- | :--- | :--- |
| subject | Integer | ID number of the subject (1–30) |
| activity | Integer | ID number of the activity (1-6) |
| activity_name | Factor | Name of the activity |
| t_body_acc_mean_x | Numeric | Average of mean time-domain body component of linear acceleration (X-axis) |
| t_body_acc_mean_y | Numeric | Average of mean time-domain body component of linear acceleration (Y-axis) |
| t_body_acc_mean_z | Numeric | Average of mean time-domain body component of linear acceleration (Z-axis) |
| t_body_acc_std_x | Numeric | Average standard deviation of time-domain body component of linear acceleration (X-axis) |
| t_body_acc_std_y | Numeric | Average standard deviation of time-domain body component of linear acceleration (Y-axis) |
| t_body_acc_std_z | Numeric | Average standard deviation of time-domain body component of linear acceleration (Z-axis) |
| ... | ... | ... |

#### *etc.*
---

## 6. Reproducing this data set
1. Download the [Project data set archive](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. Extract the archive into your working directory, maintaining the archive's directory structure.
3. Ensure `run_analysis.R` is in the same directory and execute the program.
4. The program output will be written to your working directory:
	1. `composite_data.csv` (approximately 8104 kB)
	2. `composite_data_summary_means.csv` (approximately 220 kB)
