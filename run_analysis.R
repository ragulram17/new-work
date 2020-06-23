dir.create("./data")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile ="./data/data.zip" )
unzip(zipfile = "./data/data.zip", exdir = "./data")
#path for the files
pathfile<-"./data/UCI HAR Dataset"
Files<-list.files(pathfile, recursive = TRUE)

#Objective 1. Merging Data
#Assign Data
#Test Data
test_x<-read.table(paste(pathfile,Files[15],sep = "/"), header = FALSE)
test_y<-read.table(paste(pathfile,Files[16],sep = "/"), header = FALSE)
subject_test<-read.table(paste(pathfile,Files[14],sep = "/"), header = FALSE)

#Train Data
train_x<-read.table(paste(pathfile,Files[27],sep = "/"), header = FALSE)
train_y<-read.table(paste(pathfile,Files[28],sep = "/"), header = FALSE)
subject_train<-read.table(paste(pathfile,Files[26],sep = "/"), header = FALSE)

#Read features 
feature<-read.table(paste(pathfile,Files[2],sep = "/"), header = FALSE)
#Activity label
alabels<-read.table(paste(pathfile,Files[1],sep = "/"), header = FALSE)
colnames(alabels)<-c("Activity_ID", "Activity")

#Assingning labels to the data
colnames(test_x)<-feature[,2]
colnames(train_x)<-feature[,2]
colnames(test_y)<-"Activity_ID"
colnames(train_y)<-"Activity_ID"
colnames(subject_test)<-"Subject_ID"
colnames(subject_train)<-"Subject_ID"

#Merge test and train data
merge_train<-cbind(train_y,subject_train,train_x)
merge_test<-cbind(test_y,subject_test,test_x)
merged_data<-rbind(merge_train,merge_test)

#Objective 2.- extracting mean and std for each measurement
cnames<-colnames(merged_data)
c_extracted<-grepl("Activity_ID|Subject_ID|mean|std",cnames)
data_extracted<-merged_data[,c_extracted]

#Objective 3.- Descriptive activity names to name the activity data set
descriptivedata<-merge(alabels,data_extracted, by="Activity_ID", all.x = TRUE)

#Creates a second independent tidy data with the average of each variable, each activity and each subject
tidydata<-aggregate(.~Subject_ID+Activity,descriptivedata,mean)
write.table(tidydata,"tidydata.txt",row.names = FALSE)
