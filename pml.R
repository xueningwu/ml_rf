setwd("c:\\temp\\ml")
library(caret)
pml_data <- read.csv("pml-training.csv")


# remove low variance columns
col_rm <- nearZeroVar(pml_data)
pml_data1 <- pml_data[, -col_rm]
# remove features with too much NA
pml_data2 <- pml_data1[ ,colSums(is.na(pml_data1))<nrow(pml_data1)/2]

pml_data3 <- pml_data2[ ,c(-1,-3,-4,-5)]

randomSelection <- createDataPartition(pml_data3$classe, p = 0.7, list = FALSE)

modelTraining <- pml_data3[randomSelection, ]
modelTesting <- pml_data3[-randomSelection, ]

rfModel <- train(classe ~ ., data=modelTraining, method="rf", verbose=FALSE)

if (!file.exists("rfModel.save")) {
        rfModel <- rfModel
        save(rfModel, file="rfModel.save")
} else {
        load("rfModel.save")
}

rfPredictions <- predict(rfModel, modelTesting)
confusionMatrix(rfPredictions, modelTesting$classe)