library(data.table)
library(xgboost)
train<-read.csv('trainingdata.csv')

y<-data.frame(train$interested_count)
labels <- train$interested_count
train<-within(train, rm('interested_count'))
train<-within(train, rm('X'))
train<-within(train, rm('maybe_count'))
train<-within(train, rm('id'))
require(caTools)
set.seed(101) 
sample = sample.split(train, SplitRatio = .75)
x_train = subset(train, sample == TRUE)
x_test  = subset(train, sample == FALSE)


target1 = sample.split(labels, SplitRatio = .75)
y_train = subset(labels, sample == TRUE)
y_test  = subset(labels, sample == FALSE)

new_tr <- model.matrix(~.+0,data = x_train) 
new_ts <- model.matrix(~.+0,data = x_test)
dtrain <- xgb.DMatrix(data = new_tr,label = y_train) 
dtest <- xgb.DMatrix(data = new_ts,label=y_test)
params <- list(booster = "gbtree", objective = "reg:linear", eta=0.3, gamma=0, max_depth=6, min_child_weight=1, subsample=1, colsample_bytree=1)
xgbcv <- xgb.cv( params = params, data = dtrain, nrounds = 100, nfold = 5, showsd = T, stratified = T, early_stop_round = 20, maximize = F)

xgb1 <- xgb.train (params = params, data = dtrain, nrounds = 79, watchlist = list(val=dtest,train=dtrain), print_every_n = 10, early_stop_round = 10, maximize = F , eval_metric = "error")
xgbpred1 <- predict (xgb1,dtest)
variable <- function(xgbpred1,id){
  d = read.csv("trainingdata.csv")
  index = na.omit(d[d$id==id,]$X)[1]
  if (is.na(index))
    return (NA)
  return (cbind(y_test[index],xgbpred1[index]))
}
library(ggplot2)
sqrt(sum(((xgbpred-y_test)^2)/length(xgbpred)))
cbind(Predictions=xgbpred1,Actual=y_test) -> Pred
pred_comp2 <- as.data.frame(Pred)
ggplot(aes(x=Actual,y=Predictions),data=pred_comp2)+geom_point(col="blue")+xlim(0,50000)+ylim(0,50000)

mat <- xgb.importance (feature_names = colnames(new_tr),model = xgb1)
xgb.plot.importance (importance_matrix = mat[1:20]) 


