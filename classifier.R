# Artificial Neural Net

# Install package if needed (code below):
# install.packages("ISLR")
# install.packages("caTools")
# install.packages("neuralnet")

# Import package (may be in a different place on your machine)
library("ISLR", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")
library("caTools", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")
library("neuralnet", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")

# Scale all values to a range 0 to 1. Exclude daysLate.
maxs <- apply(cust[,2:13], 2, max)
mins <- apply(cust[,2:13], 2, min)
scaled.data <- as.data.frame(scale(cust[,2:13],center = mins, scale = maxs - mins))

# Label the data
IsLate <- as.numeric(cust$daysLate > 20)
data <- cbind(IsLate, scaled.data)

# Define function for ANN to use
features <- names(scaled.data)
func <- paste(features, collapse=' + ')
func <- paste('IsLate ~',func)
func <- as.formula(func)

# Set up k-fold cross-validation
# k <- 10
# folds <- cut(seq(1,nrow(data)), breaks=k, labels=FALSE)
# 
# h <- 20                    #Max size of hidden layer
# results <- matrix(0,k,2)
# accuracy <- matrix(0,h,2)
# 
# for(j in 1:h){
#   for(i in 1:k){
#     testIndices <- which(folds==i, arr.ind=TRUE)
#     test <- data[testIndices,]
#     train <- data[-testIndices,]
#   
#     # Train the Artificial Neural Net
#     ann <- neuralnet(func, train, hidden=c(j), stepmax=1000000000, rep=1, threshold=0.2, linear.output=FALSE)
#   
#     # Test model on testing data
#     predicted <- compute(ann,na.omit(test[,2:13]))
#     predicted$net.result <- sapply(predicted$net.result,round,digits=0)
#   
#     confusion <- table(test$IsLate,predicted$net.result)
#     
#     # Handle edge case with all 0 predicted
#     blank <- c(0,0)
#     confusion <- cbind(confusion, blank)
#   
#     # Calculate accuracy, precision, and recall
#     results[i,1] <- i
#     results[i,2] <- (confusion[1,1] + confusion[2,2]) / sum(confusion)
#   }
# 
#   accuracy[j,1] <- j
#   accuracy[j,2] <- mean(results[,2])
#   plot(accuracy,type="l")
# }
# Split into training and testing data
split <- sample.split(data$IsLate, SplitRatio = 0.90)
train <- subset(data, split == TRUE)
test <- subset(data, split == FALSE)

ann <- neuralnet(func, train, hidden=c(5), stepmax=1000000000, rep=1, threshold=0.2, linear.output=FALSE)

# Test model on testing data
predicted <- compute(ann,na.omit(test[,2:13]))
predicted$net.result <- sapply(predicted$net.result,round,digits=0)

# Create confusion matrix
confusion <- table(test$IsLate,predicted$net.result)

# Calculate accuracy, precision, and recall
accuracy <- (confusion[1,1] + confusion[2,2]) / sum(confusion)
precision <- matrix(0,2,1)
recall <- matrix(0,2,1)
precision[1,1] <- confusion[1,1] / (confusion[1,1] + confusion[2,1])
precision[2,1] <- confusion[2,2] / (confusion[1,2] + confusion[2,2])
recall[1,1] <- confusion[1,1] / (confusion[1,1] + confusion[1,2])
recall[2,1] <- confusion[2,2] / (confusion[2,1] + confusion[2,2])

# Print confusion matrix, accuracy, precision, and recall. (0 = Not Late, 1 = Late)
confusion
print(paste("Accuracy: ", accuracy))
print(paste("Precision (Not Late): ", precision[1,1]))
print(paste("Precision (Late): ", precision[2,1]))
print(paste("Recall (Not Late): ", recall[1,1]))
print(paste("Recall (Late): ", recall[2,1]))
