# method 1: Using caret
# loading the libraries
library(caret)
library(tidyverse)
library(adabag)

# loading the data
# we will titanic data from the datasets lib
data("Titanic")

View(Titanic)

# convert into data frame
# removing the last column.
# lets encode it
dat = as.data.frame(Titanic)[-5]

data_new = dat

data_new$Class = as.factor(ifelse(dat$Class == "1st",1,
                 ifelse(dat$Class == "2nd",2,
                        ifelse(dat$Class == "3rd",3,
                               ifelse(dat$Class == "Crew",4,""))))) 

# data summary
summary(data_new)

# data structure
str(data_new)

# you can now visualize here

# data splitting
index = createDataPartition(data_new$Survived, p=0.75, list = FALSE)

# train
train <- data_new[index,]

# test
test <- data_new[-index,]


# model 1
# it will take time depending on how fast your machine is.
# it is an iteration process.
model <- train(Survived~., method="adaboost", data=train, metric="Accuracy")

# predictions
pred <- predict(model, newdata = test)

confusionMatrix(pred, test$Survived)

# method 2
model2 = boosting(Survived~.,data = train)

pred2 = predict(model2, newdata = test)

pred2$confusion

pred2
