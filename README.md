How the run_analytics.R script work
===========

## Read labels
1. Read Activity type from "activity_labels.txt" files by using f_activityLabels() function

## Read test and training data
1. Read test and training data frile by using f_read_Data() function

1. Merge two loaded data in one by rbind().

1. Set column names

## Make tidy result file
1. Make final tidy data by using melt() & cast() function

1. mainly used function is belowed

* melt() - reshape data layout to vertical
* cast() - reshape to grouped
* gsub() - replace all matcheds of string
* merge() - merges two data frames by common columns
* rbind - combines vector, matrix or data frame by rows