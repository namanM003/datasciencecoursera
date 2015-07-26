library(plyr)

#############Read X_test and X_Train data############
x_data_test<- read.table("./test/X_test.txt",header = F)
x_data_train <- read.table("./train/X_train.txt",header = F)
###########Read the feature data to apply column names###############
feature <- read.table("./features.txt", header = F)
#####################Set Column Names (Headers) for the test and train data##############
colnames(x_data_test) <- feature[,2]
colnames(x_data_train) <- feature[,2]
################Merge test and train data#####################
data_x <- rbind(x_data_test,x_data_train)

###################Read Y_Test and Y_Train Data##################
y_data_test<- read.table("./test/y_test.txt",header = F)
y_data_train <- read.table("./train/y_train.txt",header = F)

################Aplly headers to y_test and y_train data############
colnames(y_data_test) <- "activityLabel"
colnames(y_data_train) <- "activityLabel"
##############Merge test train data#######################
data_y <- rbind(y_data_test,y_data_train)

#####################Read Subject test and train data##############
subject_data_test<- read.table("./test/subject_test.txt",header = F)
subject_data_train <- read.table("./train/subject_train.txt",header = F)
##################Add column name to test and train data and thne combine them##########
colnames(subject_data_test) <- "subjectId"
colnames(subject_data_train) <- "subjectId"
data_sub <- rbind(subject_data_test,subject_data_train)

#################Make one complete data set#############
combineddata <- cbind(data_y,data_sub,data_x)

#####################Extract only the colums needed from merged data and create a tidy data##########
patrn = "mean|std|subjectId|activityLabel"
tidyDataSet = combineddata[,grep(patrn , names(combineddata), value=TRUE)]


############Read the activity labels and substitute them in the tidy data set##########
activityLabel <- read.table("./activity_labels.txt",header = F)
tidyDataSet$activityLabel <- factor(tidyDataSet$activityLabel,labels = tolower(levels(activityLabel$V2)))


##############Create a final dataset by finding mean for each activity and subject#######
final_output <- ddply(tidyDataSet, .(activityLabel, subjectId), numcolwise(mean))
write.table(final_output, file="getting_and_cleaning_data_project.txt", sep = "\t", append=F, row.name = FALSE)
