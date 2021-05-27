# load the libraries
library(mlbench)
library(caret)
library(e1071)
library(naivebayes)
library(DataExplorer)

# load the data
data("PimaIndiansDiabetes")

data <- PimaIndiansDiabetes
remove(PimaIndiansDiabetes)

summary(data)
str(data)

colSums(is.na(data))

# visualize na values
plot_missing(data)
# exploring the data
tb <- table(data$diabetes)
tb

prop.table(tb)*100

# imbalanced data set
# random down sampling
index_neg <- sample(1:400, 268)

# creating the seperate classes
neg <- data[which(data$diabetes == "neg"),]
pos <- data[which(data$diabetes == "pos"),]

neg_data <- neg[index_neg,]

undersample_data <- rbind(pos,neg_data)

table(undersample_data$diabetes)

# random up sampling
index_pos1 <- sample(1:232,232)

pos_data <- pos[index_pos1,]

pos_data <- rbind(pos_data, pos)

upsample_data <- rbind(pos_data, neg)

table(upsample_data$diabetes)

# split the data
index <- createDataPartition(upsample_data$diabetes, list = F,p = 0.8)

train <- upsample_data[index,]
test <- upsample_data[-index,]

# the model
model <- naiveBayes(diabetes~., data = train)
model

# predictions
pred <- predict(model, newdata = test)

tb <- table(pred, test$diabetes)
tb

confusionMatrix(tb)

# method
trcontrol <- trainControl(
  method = "cv",
  number = 10
) 

model1 <- train(
  diabetes~.,
  data = train,
  method ="naive_bayes",
  preProcess = c("scale", "center")
)

# predictions
pred1 <- predict(model1, newdata = test, type = "raw")

tb1 <- table(pred1, test$diabetes)
tb1

confusionMatrix(tb1)
