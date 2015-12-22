########################################################
## Getting and Cleaning Data
## Peer Assessment
## date : 2015.12.22
########################################################

f_read_Data = function (fname, folder) {
  path = file.path(folder, paste0("y_", fname, ".txt"))
  y_data = read.table(path, header=FALSE, col.names = c("ActiviytID"))
  
  path = file.path(folder, paste0("subject_", fname, ".txt"))
  subject_data = read.table(path, header=FALSE, col.names=c("SubjectID"))
  
  data_columns = read.table("features.txt", header=FALSE, as.is=TRUE, col.names=c("MeasureID", "MeasureName"))
  
  path = file.path(folder, paste0("X_", fname, ".txt"))
  dataset = read.table(path, header=FALSE, col.names=data_columns$MeasureName)
  
  subset_data_columns = grep(".*mean\\(\\)|.*std\\(\\)", data_columns$MeasureName)
  
  dataset = dataset[, subset_data_columns]
  
  dataset$ActivityID = y_data$ActivityID
  dataset$SubjectID = subject_data$SubjectID
  
  dataset
}

# reading the test dataset
f_read_test_data = function() {
  f_read_Data("test", "test")
}

# reading the train dataset
f_read_train_data = function () {
  f_read_Data("train", "train")
}

# merging the two datasets and giving proper column names
f_merge_Dataset = function () {
  dataset = rbind(f_read_test_data(), f_read_train_data())
  cnames = colnames(dataset)
  cnames = gsub("\\.+mean\\.+", cnames, replacement = "Mean")
  cnames = gsub("\\.+std\\.+", cnames, replacement = "Std")
  colnames(dataset) = cnames
  dataset
}

# Part 3 & Part 4
# Reading the activity labels and creating a column for activity labels 
f_activityLabels = function (dataset) {
  activity_labels = read.table("activity_labels.txt", header = FALSE, as.is=TRUE, col.names = c("ActivityID", "ActivityName"))
  activity_labels$ActivityName = as.factor(activity_labels$ActivityName)
  data_labels = merge(dataset, activity_labels)
  data_labels
}

# merging the activity labels to the merged dataset
merge_label_data = function () {
  f_activityLabels(f_merge_Dataset())
}

# Part 5
# Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 
f_tidyData = function(merge_label_data) {
  library(reshape2)
  
  vars = c("ActivityID", "ActivityName", "SubjectID")
  measure_vars = setdiff(colnames(merge_label_data), vars)
  melted_data <- melt(merge_label_data, id=vars, measure.vars=measure_vars)
  
  # recast 
  dcast(melted_data, ActivityName + SubjectID ~ variable, mean)
}

#Getting the clean tidy dataset
tidy_data_file =function(fname){
  tidy_data = f_tidyData(merge_label_data())
  write.table(tidy_data, fname)
}

tidy_data_file("tidy.txt")