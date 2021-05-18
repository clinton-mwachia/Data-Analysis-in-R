# create a model to predict mortality caused by heart failure
# loading the libraries
library(caret) # splitting the data
library(randomForest)
library(tidyverse)

# loading the data
data <- readr::read_csv("Random Forest/heart_failure_clinical_records_dataset.csv")

str(data)

summary(data)

# check for na
colSums(is.na(data))

# convert columns to factors
cols <- c("anaemia","diabetes","high_blood_pressure","sex","smoking","DEATH_EVENT")

data <- data %>%
  mutate_at(cols, list(~factor(.)))

# normalize the numeric variables
cols2 <- c("age","creatinine_phosphokinase","ejection_fraction","platelets",
           "serum_creatinine","serum_sodium","time")

data <- data %>%
  mutate_at(cols2, list(~BBmisc::normalize(.)))

# visualization
# you can do visualization

# modeling
# data splitting
index <- createDataPartition(data$DEATH_EVENT, list = FALSE, p = 0.75)

# train data
train <- data[index,]
test <- data[-index,]

# method 1
model <- randomForest(DEATH_EVENT~., data = train, importance = TRUE)
model

# variable importance
varImpPlot(model)

importance(model)

# making predictions
pred <- predict(model, newdata = test, type = "response")

# confusion table
ct <- table(pred, test$DEATH_EVENT)
ct

# confusion matrix
cm <- confusionMatrix(ct)
cm


# method 2
# cross validation
model2 <- train(DEATH_EVENT~., data=train, method="rf")
model2

# predictions
pred2 <- predict(model2, newdata = test, type = "raw")

# confusion table
ct1 <- table(pred2, test$DEATH_EVENT)

# matrix
confusionMatrix(ct1)
