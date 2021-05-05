# load the libraries
library(caret) # splitting the data, modelling
library(class) # normal knn

# load the data
data(iris)
View(iris)

str(iris)

dplyr::glimpse(iris)

# visualization

# normalize

# scaling

#  data splitting
set.seed(234) # reproducibility
index <- createDataPartition(iris$Species, list = F, p = 0.7)

# train data split
train <- iris[index,]

# test data split
test <- iris[-index,]

#balanced response 
table(train$Species)

table(test$Species)

# model
model <- knn(train = train[,-5], test = test[,-5], cl = train$Species, k = 3)
model

# confusion matrix
cm <- table(test$Species, model)
cm

confusionMatrix(cm)

# misclassification error
shipunov::Misclass(test$Species, model)

# methods, names(getModelInfo())
# using caret
model2 <- train(Species ~., data=train, method="knn")
model2

# predictions
pred <- predict(model2,newdata = test)

# classification table
ct <- table(test$Species, pred)
ct

confusionMatrix(ct)

shipunov::Misclass(test$Species, pred)
