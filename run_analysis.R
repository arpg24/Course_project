##Download and unzip the file
if(!file.exists("./data")){dir.create("./data")}
file<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file,destfile="./data/Data.zip",method="auto")

unzip(zipfile="./data/Data.zip",exdir="./data")

##New path
path <- file.path("./data" , "UCI HAR Dataset")

##Features
features <- read.table(file.path(path,"features.txt"), col.names = c('index', 'name'))
sub_features<-subset(features, grepl('-(mean|std)[(]', features$name))

##Activity Labels
act_Labels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
colnames(act_Labels)<-c("Labels","Label_names")

##Subject data
Subject_train <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
Subject_test <- read.table(file.path(path, "test", "subject_test.txt"),header = FALSE)

##Test data
Test<-cbind(read.table(file.path(path, "test" , "X_test.txt"),header = F),read.table(file.path(path, "test" , "y_test.txt"),header = F))
Subset_test<-Test[,c(sub_features[,1],ncol(Test))]
Subset_test<-cbind(Subset_test,Subject_test)
colnames(Subset_test)<-c(as.character(sub_features[,2]),"Labels","Subject")
Subset_test<-merge(Subset_test,act_Labels,all.x=T)
Subset_test<-Subset_test[,c(2:(ncol(Subset_test)-1),1,ncol(Subset_test))]
Subset_test<-Subset_test[order(Subset_test$Subject, Subset_test$Labels),]

##Train data
Train <-cbind(read.table(file.path(path, "train", "X_train.txt"),header = F),read.table(file.path(path, "train", "y_train.txt"),header = F))
Subset_train<-Train[,c(sub_features[,1],ncol(Train))]
Subset_train<-cbind(Subset_train,Subject_train)
colnames(Subset_train)<-c(as.character(sub_features[,2]),"Labels","Subject")
Subset_train<-merge(Subset_train,act_Labels,all.x=T)
Subset_train<-Subset_train[,c(2:(ncol(Subset_train)-1),1,ncol(Subset_train))]
Subset_train<-Subset_train[order(Subset_train$Subject, Subset_train$Labels),]

##Dataset with train and test data
global_data <- rbind(Subset_test, Subset_train)
global_data<- global_data[,-68]

##Tidy data set
tidy.data<-aggregate(. ~ Subject + Label_names, global_data, mean)
tidy.data<-tidy.data[order(tidy.data$Subject,tidy.data$Label_names),]
rownames(tidy.data)<-1:nrow(tidy.data)
write.table(tidy.data, file = "tidydata.txt",row.name=F)

