library(mlbench)
library(caret)
library(e1071)
library(naivebayes)
library(DataExplorer) # IF NOT INSTALLED, RSTUDIO WILL DETECT AND ASK IF IT SHOULD INSTALL

data("PimaIndiansDiabetes")

data <- PimaIndiansDiabetes
remove(PimaIndiansDiabetes)

summary(data)
str(data)

colSums(is.na(data))

plot_missing(data)

tb <- table(data$diabetes)
tb

prop.table(tb)*100

# random down sampling
index_neg <- sample(1:400, 268)

neg <- data[which(data$diabetes == "neg"),]

pos <- data[which(data$diabetes == "pos"),]

neg_data <- neg[index_neg,]

undersample_data <- rbind(pos, neg_data)

table(undersample_data$diabetes)
# random up sampling
index_pos1 <- sample(1:232, 232)

pos_data <- pos[index_pos1,]

pos_data <- rbind(neg, pos_data)

upsample_data <- rbind(pos_data, neg_data)

#
index <- createDataPartition(upsample_data$diabetes, list = F, p= 0.8)

train <- upsample_data[index,]

test <- upsample_data[-index,]

# the model
model <- naiveBayes(diabetes ~., data = train)
model

pred1 <- predict(model, newdata = test)

tb1 <- table(pred1, test$diabetes)
tb1

confusionMatrix(tb1)

# the percentage changes every time you run the model

# method 2
trcontrol <- trainControl(
  method = "cv",
  number = 10
)

model1 <- train(
  diabetes ~., 
  data = train,
  method = "naive_bayes",
  preProcess = c("scale","center")
)

pred1 <- predict(model1, test, "raw")

tb <- table(pred1, test$diabetes)
tb

confusionMatrix(tb)
