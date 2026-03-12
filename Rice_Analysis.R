# install.packages("foreign")
# install.packages("class")
# install.packages("ggplot2")
# install.packages("corrplot")
# install.packages("farff")
library(foreign)
library(class)
library(ggplot2)
library(corrplot)
library(farff)

# Set your path accordingly
# setwd("/set/your/path")

# Load the data
rice <- readARFF("rice.arff")

# Binary transformation
target_label <- unlist(rice$Class)
target_binary <- ifelse(target_label == "Cammeo", 1, 0)
dataset <- data.frame(rice[, 1:7], Class = target_binary)

# Splitting into Training (80%) and Test (20%) sets
set.seed(42)
n_rows <- nrow(dataset)
train_indices <- sample(1:n_rows, size = 0.8 * n_rows)

train_set <- dataset[train_indices, ]
test_set <- dataset[-train_indices, ]

# Correlation Matrix
corr_matrix <- cor(train_set[, 1:7])
corrplot(corr_matrix, method = "color", addCoef.col = "black", 
         tl.col = "black", title = "Feature Correlation Matrix", mar=c(0,0,1,0))

# Distribution of Area by Class
ggplot(train_set, aes(x = as.factor(Class), y = Area, fill = as.factor(Class))) +
  geom_boxplot() +
  scale_fill_manual(values = c("#3498db", "#e74c3c"), labels = c("Osmancik", "Cammeo")) +
  labs(title = "Area Distribution by Rice Variety", x = "Class (0: Osmancik, 1: Cammeo)", fill = "Variety") +
  theme_minimal()

set.seed(42)
val_indices <- sample(1:nrow(train_set), size = 0.25 * nrow(train_set))
train_sub <- train_set[-val_indices, ]
val_set <- train_set[val_indices, ]

mod_log <- glm(Class ~ ., data = train_sub, family = "binomial")
prob_log_val <- predict(mod_log, newdata = val_set, type = "response")
pred_log_val <- ifelse(prob_log_val > 0.5, 1, 0)

summary(mod_log)

acc_log <- mean(pred_log_val == val_set$Class)
cat("Logistic Regression Validation Accuracy:", round(acc_log, 4))

normalize <- function(x) { (x - min(x)) / (max(x) - min(x)) }

train_sub_norm <- as.data.frame(lapply(train_sub[, 1:7], normalize))
val_set_norm <- as.data.frame(lapply(val_set[, 1:7], normalize))

best_k <- 1
best_acc_knn <- 0
k_values <- c(3, 5, 7, 9, 11)
acc_results <- numeric(length(k_values))

for(i in seq_along(k_values)) {
  k <- k_values[i]
  pred_knn <- knn(train = train_sub_norm, test = val_set_norm, 
                  cl = train_sub$Class, k = k)
  acc_knn <- mean(pred_knn == val_set$Class)
  acc_results[i] <- acc_knn
  
  if(acc_knn > best_acc_knn) {
    best_acc_knn <- acc_knn
    best_k <- k
  }
}

cat("Best K found:", best_k, "with Accuracy:", round(best_acc_knn, 4))

# Visualize K-NN tuning
plot(k_values, acc_results, type = "b", pch = 19, col = "blue",
     xlab = "Number of Neighbors (K)", ylab = "Accuracy", main = "K-NN Hyperparameter Tuning")

# Final Model Training
modello_finale <- glm(Class ~ ., data = train_set, family = "binomial")

# Probability and Class Predictions
prob_test <- predict(modello_finale, newdata = test_set, type = "response")
pred_test <- ifelse(prob_test > 0.5, 1, 0)

# Custom Metrics Functions
calc_acc <- function(vera, pred) { mean(vera == pred) }
calc_f1 <- function(vera, pred) {
  tp <- sum(vera == 1 & pred == 1); fp <- sum(vera == 0 & pred == 1); fn <- sum(vera == 1 & pred == 0)
  p <- tp/(tp+fp); r <- tp/(tp+fn)
  return(2 * (p * r) / (p + r))
}
calc_logloss <- function(vera, prob) {
  prob <- pmax(pmin(prob, 1 - 1e-15), 1e-15)
  -mean(vera * log(prob) + (1 - vera) * log(1 - prob))
}

# Display Results
results <- data.frame(
  Accuracy = calc_acc(test_set$Class, pred_test),
  F1_Score = calc_f1(test_set$Class, pred_test),
  Log_Loss = calc_logloss(test_set$Class, prob_test)
)

print("Final Model Performance (Logistic Regression)")
print(results)

roc_custom <- function(vera, prob, soglie = seq(0, 1, by = 0.05)) {
  res <- t(sapply(soglie, function(s) {
    pred <- ifelse(prob >= s, 1, 0)
    tpr <- sum(vera == 1 & pred == 1) / sum(vera == 1)
    fpr <- sum(vera == 0 & pred == 1) / sum(vera == 0)
    c(Soglia = s, TPR = tpr, FPR = fpr)
  }))
  
  plot(res[,3], res[,2], type = "b", col = "#e67e22", lwd = 2,
       main = "ROC Curve - Final Logistic Model", xlab = "FPR (1-Specificity)", ylab = "TPR (Recall)")
  abline(a = 0, b = 1, lty = 2, col = "darkgrey")
  return(as.data.frame(res))
}

tabella_soglie <- roc_custom(test_set$Class, prob_test)