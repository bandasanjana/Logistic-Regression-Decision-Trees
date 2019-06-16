#Author: Sanjana Banda
#Title: Assignment-2
#Purpose: DecisionTrees & Logistic Regression

setwd("/Users/sanjana/Documents/Spring2019/TA/R/R-TA")
library(rpart)
library(rpart.plot)
library(dplyr)
library(readxl)
library(schoolmath)
library(caret)
library(tidyverse)
library(ROCR)
library(pROC)

#******************************************************************************************************************************#
#(a) Import the data to R. Copy the R code used below.
organics.df <-read_excel("organics.xlsx")
summary(organics.df)
# Drop variable ID- (Unique Key)
organics.df<- select(organics.df,-c(1))
#*******************************************************************************************************************************#




#(b) Examine the distribution of the target variable: (1) plot a bar chart to show the number of observations in each category,
#and (2) plot a bar chart to show the frequency of observations in each category.
#To describe a categorical variable. table() count the number of observations in each category
f <- factor(organics.df$TargetBuy)
counts <- table(f)
barplot(counts, main="No. of Observations in each category",xlab="Organics purchased ?",col="darkblue")

h <- table(f) / length(f)
barplot(h,  main="frequency in each category",xlab="Organics purchased ?",col="darkred")

#*********************************************************************************************************************


# (c) The variable DemClusterGroup contains collapsed levels of the variable DemCluster. Presume
# that, based on previous experience, you believe that DemClusterGroup is sufficient for this type of
# modeling effort. Exclude the variable DemCluster for the analysis. Copy the R code used below.


# Drop variable DemCluster
organics.df<- select(organics.df,-c(3))
#*********************************************************************************************************************
# (d) As noted above, only TargetBuy will be used for this analysis and should have a role of target.
# Can TargetAmt be used as an input for a model used to predict TargetBuy? Why or why not?

# Drop variable TargetAmt
organics.df<- select(organics.df,-c(11))


#*********************************************************************************************************************
# (i) Next, consider using a logistic regression model. First, are there any missing values?
data.frame(miss.val=sapply(organics.df, function(x)
  (sum(length(which(is.na(x))))))) 



#*********************************************************************************************************************
# (j) Impute: impute “U” for unknown class variable values and the overall mean for unknown interval
# variable values. Copy the code used below.

x <- data.frame(datatype = sapply(organics.df, is.numeric))
for(i in 1:length(x$datatype)){
  if ( x$datatype[i] == TRUE)
  {
    organics.df[is.na(organics.df[,i]), i] <- mean(as.vector(unlist(array(as.data.frame(organics.df[,i])))), na.rm = TRUE)

  }
 else{
   organics.df[is.na(organics.df[,i]), i] <- 'U'
 }
}

#*********************************************************************************************************************
# (e) Partition the data: set records 1, 3, 5, … (the rows with odd numbers) as the training data, and set
# records 2, 4, 6, … (the rows with even numbers) as the validation data, which results in 50%/50%
#   partition for training/validation. Copy the code used below.

num <- c(1:nrow(organics.df))

numodd <- c()
for(i in 1:length(num)){
  if(num[i]%%2 != 0)
    numodd[i] <- num[i]}

sample<- numodd[!is.na(numodd)]
train <- organics.df[sample, ]
validate <- organics.df[-sample, ]



#*********************************************************************************************************************
# (f) Implement a decision tree on the Training data to predict “TargetBuy” status. Plot the tree. Copy
# the code used and the result below. How many leaves are in the tree? Which variable was used for the
# first split? Create a confusion matrix which shows the accuracy rate of your classification. Copy the
# code used and the result below.

Ttree <- rpart(TargetBuy ~ ., data = train, method = "class",control = rpart.control(cp=0.01))
summary(Ttree)
rpart.plot(Ttree)
train$PredictClass <- predict(Ttree, newdata = train, type="class")
traintab <- table(train$PredictClass, train$TargetBuy)
confusionMatrix(traintab)

#*********************************************************************************************************************
# (g) Apply your decision tree from the training data to the validation data, and compare the accuracy
# of classification of your validation and training data sets. Show the confusion matrix. Copy the code
# used and the results below. How is the accuracy using validation data different from that using
# training data? Is this what you expected? Why?

validate$PredictClass <- predict(Ttree, newdata = validate, type="class")
validatetab <- table(validate$PredictClass, validate$TargetBuy)
confusionMatrix(validatetab)


#*********************************************************************************************************************
# (h) Imposing maxdepth = 2, create another decision tree on the training data to predict TargetBuy
# status. Plot the tree. Create a confusion matrix which shows the accuracy rate of your classification.
# Copy the code used and the result below. How many leaves are in the tree? Compared with the tree in
# (f), which one appears to be better? Is this what you expected? Why?
train <- select(train,-c(11))
Dtree <- rpart(train$TargetBuy ~ ., data = train, method = "class", maxdepth = 2)
rpart.plot(Dtree)
train$PredictClass <- predict(Dtree, newdata = train, type="class")
Dtraintab <- table(train$PredictClass, train$TargetBuy)

confusionMatrix(Dtraintab)



#*********************************************************************************************************************
# (k) Use a logistic regression model to classify the data set using the same dependent variable,
# TargetBuy. Copy the code used and the result below.
train <- select(train,-c(11))
validate <- select(validate,-c(11))
model1 <- glm(TargetBuy~.,family=binomial(link='logit'),data=train)
summary(model1)


model2 <- glm(TargetBuy~.,family=binomial(link='logit'),data=validate)
summary(model2)


#*********************************************************************************************************************
# (l) Compare the performance of the logit model on the training and validation data sets by creating
# confusion matrixes which show the accuracy rates. Copy the code used and the result below. Which
# one appears to be better?


train$pdata1 <- ifelse(predict(model1, train)> 0.5,1,0)
traintab <- table(train$pdata1, train$TargetBuy)
confusionMatrix(traintab)

validate$pdata1 <- ifelse(predict(model2, validate)> 0.5,1,0)
validtab <- table(validate$pdata1, validate$TargetBuy)

confusionMatrix(validtab)



# train$pdata1 <- predict(model1, newdata = train, type = "response")
# # pred = predict(mod_fit, newdata=testing)
# accuracy <- table(train$pdata1, train[,"Class"])
# sum(diag(accuracy))/sum(accuracy)
# 
# pdata2 <- predict(model2, data = validate, type = "response")
# confusionMatrix(data = as.numeric(pdata2>0.5), reference = validate$TargetBuy)




#*********************************************************************************************************************
# (m) Plot ROC curves for the decision tree in (f) and the logit model using validation data. Summarize
# each curve by its ROC index (“area under the curve (AUC)”). Copy the code used and the result
# below. In terms of ROC index, which model is better?

#Logistic Regression
# Compute AUC for predicting Class with the model
validate <- select(validate,-c(11))
prob <- predict(model1, newdata=validate, type="response")
pred <- prediction(prob, validate$TargetBuy)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
plot(perf)
auc <- performance(pred, measure = "auc")
auc <- auc@y.values[[1]]
auc
## [1] 0.8148634




#Decision Trees
validate <- select(validate,-c(11))
prob1<- predict(Dtree, newdata = validate, type="prob")
auc <- auc(validate$TargetBuy, prob1[,2])
plot(roc(validate$TargetBuy, prob1[,2]))
# Area under the curve: 0.7346

