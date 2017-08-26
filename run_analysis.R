#Download the dataset 
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")

#unzip and extract the dataset
unzip("./data/dataset.zip",exdir = "./data")

#Read Training data
x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Read testing data
x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Read features
features<-read.table("./data/UCI HAR Dataset/features.txt")

#Read Activity lables
activity_labels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")

colnames(x_train)<-features[,2]
colnames(y_train)<-"activityId"
colnames(x_test)<-features[,2]
colnames(y_test)<-"activityId"
colnames(subject_train)<-"subjectId"
colnames(subject_test)<-"subjectId"
colnames(activity_labels)<-c("activityId","activity")



# 1st Task:Merge training and test sets
train<-cbind(y_train,subject_train,x_train)
test<-cbind(y_test,subject_test,x_test)
oneDataset<-rbind(train,test)


#2nd Task : Extract Measurments based on mean and std

cnames<-colnames(oneDataset)
measurements<-(grepl("activityId",cnames) | grepl("subjectId",cnames)| grepl("mean",cnames)| grepl("std",cnames))
result<-oneDataset[,measurements]

#3rd Task : use descriptive activity name to name activities in the data set:
activities<-merge(result,activity_labels,by="activityId",all.x=TRUE)

#5th Task
Data.mean<-aggregate(. ~subjectId+activityId,activities,mean)
 write.table(Data.mean,"Data.mean.txt",row.names=F)

