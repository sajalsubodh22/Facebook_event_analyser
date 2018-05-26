
setwd('~/fb_event_minor/model')
data<-read.csv('trainingdata.csv')

target<-data.frame(data$interested_count)

data<-within(data, rm('interested_count'))
data<-within(data, rm('X'))
data<-within(data, rm('id'))

unique(data$category)

for(unique_value in unique(data$category)){
 data[paste("category", unique_value, sep = ".")] <- ifelse(data$category == unique_value, 1, 0)
}

data

for(unique_value in unique(data$can_guests_invite)){
 data[paste("can_guest_invite", unique_value, sep = ".")] <- ifelse(data$can_guests_invite == unique_value, 1, 0)
}

for(unique_value in unique(data$guest_list_enabled)){
 data[paste("guest_list_enabled", unique_value, sep = ".")] <- ifelse(data$guest_list_enabled == unique_value, 1, 0)
}


data

data<-within(data, rm('can_guests_invite'))

data<-within(data, rm('guest_list_enabled'))

data<-within(data, rm('category'))

data

require(caTools)
set.seed(101) 
sample = sample.split(data, SplitRatio = .75)
x_train = subset(data, sample == TRUE)
x_test  = subset(data, sample == FALSE)

 
target1 = sample.split(target, SplitRatio = .75)
y_train = subset(target, sample == TRUE)
y_test  = subset(target, sample == FALSE)

dim(y_train)

dim(y_test)

#install.packages('randomForest')

library(randomForest)

regressor1=randomForest(x_train,y_train[,1],ntree=100)

a=predict(regressor1,x_test)

length(y_test[,1])

y_test[300,]

rmse <- function(error)
{
    sqrt(mean(error^2))
}

error <- y_test[,1] - a

rmse1 = rmse(error)

R2 <- 1 - (sum((y_test[,1]-a )^2)/(sum(y_test[,1]-mean(y_test[,1]))^2))

R2

varImpPlot(regressor1,main="Variable Importance")

library(ggplot2)


pred_comp = cbind(y_test,data.frame(a))
colnames(pred_comp) = c("Actual", "Predicted")



              