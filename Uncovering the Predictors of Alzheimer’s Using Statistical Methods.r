# Load required libraries
library(ggplot2)
library(dplyr)
library(corrplot)

# Load the data
data <- read.csv("alzheimers_disease_data.csv")


# View structure and first few rows
str(data)
head(data)


# Summary statistics
summary(data)

# Check for missing values
sum(is.na(data))

data_subset <- data[, c("Diagnosis", "MMSE", "MemoryComplaints", "Confusion", 
                        "Forgetfulness", "DifficultyCompletingTasks")]


# Summary statistics
summary(data_subset)

#Converting binary variables to factors

data_subset$MemoryComplaints <- as.factor(data_subset$MemoryComplaints)
data_subset$Confusion <- as.factor(data_subset$Confusion)
data_subset$Forgetfulness <- as.factor(data_subset$Forgetfulness)
data_subset$DifficultyCompletingTasks <- as.factor(data_subset$DifficultyCompletingTasks)
data_subset$Diagnosis <- as.factor(data_subset$Diagnosis)

# Visualizations

# Diagnosis
barplot(table(data$Diagnosis), 
        col = "skyblue", 
        main = "Diagnosis Distribution", 
        xlab = "Diagnosis", 
        ylab = "Count")

# Memory Complaints
barplot(table(data$MemoryComplaints), 
        col = "red", 
        main = "Memory Complaints", 
        xlab = "Memory Complaints", 
        ylab = "Count")

# DifficultyCompletingTasks
barplot(table(data$DifficultyCompletingTasks), 
        col = "green", 
        main = "DifficultyCompletingTasks", 
        xlab = "DifficultyCompletingTasks", 
        ylab = "Count")

# Confusion
barplot(table(data$Confusion), 
        col = "purple", 
        main = "Confusion", 
        xlab = "Confusion", 
        ylab = "Count")


# Histogram for MMSE
hist(data_subset$MMSE, 
     main = "Histogram of MMSE", 
     xlab = "MMSE Score", 
     col = "skyblue", 
     border = "black")



# Select relevant numeric columns for correlation
cor_data <- data[, c("Diagnosis", "MemoryComplaints", "MMSE", "Disorientation", "Confusion")]

# Compute correlation matrix
cor_matrix <- cor(cor_data, use = "complete.obs")

# Plot the correlation heatmap
corrplot(cor_matrix, method = "color", type = "upper", 
         addCoef.col = "black", tl.col = "black", tl.srt = 45,
         col = colorRampPalette(c("blue", "white", "red"))(200))

# Shapiro-Wilk Test
shapiro.test(data_subset$MMSE)


# Q-Q Plot for MMSE
qqnorm(data_subset$MMSE, main = "Q-Q Plot of MMSE")
qqline(data_subset$MMSE, col = "red", lwd = 2)

# Convert Diagnosis to numeric if it's a factor
data_subset$Diagnosis_num <- as.numeric(as.character(data_subset$Diagnosis))

# Calculate Spearman correlation
spearman_rho <- cor(data_subset$MMSE, data_subset$Diagnosis_num, method = "spearman")

# Plot
plot(data_subset$MMSE, data_subset$Diagnosis_num,
     main = paste("Spearman Correlation (ρ ≈", round(spearman_rho, 2), ")"),
     xlab = "MMSE Score",
     ylab = "Diagnosis (0 = No, 1 = Yes)",
     pch = 19,
     col = rgb(0.2, 0.4, 0.8, 0.5))  # Semi-transparent blue

# Add smooth trend line to indicate direction
lines(lowess(data_subset$MMSE, data_subset$Diagnosis_num), col = "red", lwd = 2)


wilcox.test(MMSE ~ Diagnosis, data = data_subset)


# Independent t-test: MMSE by Diagnosis group
t_test_result <- t.test(MMSE ~ Diagnosis, data = data_subset)

# Print result
print(t_test_result)

# Chi - square test for the variables                                
chisq.test(table(data_subset$MemoryComplaints, data_subset$Diagnosis))
chisq.test(table(data_subset$Confusion, data_subset$Diagnosis))
chisq.test(table(data_subset$Forgetfulness, data_subset$Diagnosis))
chisq.test(table(data_subset$DifficultyCompletingTasks, data_subset$Diagnosis))



# Fit model
model <- glm(Diagnosis ~ MMSE + MemoryComplaints + Confusion + 
               Forgetfulness + DifficultyCompletingTasks, 
             data = data_subset, family = binomial())

# Model summary
summary(model)

# Odds ratios
exp(coef(model))

#Model Significance: Deviance and Chi-Square Test

# Extract deviance values
null_deviance <- model$null.deviance  # Null deviance
residual_deviance <- model$deviance  # Residual deviance
df_difference <- model$df.null - model$df.residual  # Degrees of freedom difference

# P-value from deviance difference
p_value <- 1 - pchisq(null_deviance - residual_deviance, df = df_difference)

# Display the results
cat("Null Deviance:", null_deviance, "\n")
cat("Residual Deviance:", residual_deviance, "\n")
cat("Degrees of Freedom Difference:", df_difference, "\n")
cat("P-value:", p_value, "\n")

# Predict probabilities from the model
data_subset$predicted_prob <- predict(model, type = "response")

# View first few rows with predictions
head(data_subset[, c("Diagnosis", "MMSE", "predicted_prob")])

# Plot for predicted probability
ggplot(data_subset, aes(x = MMSE, y = predicted_prob, color = Diagnosis)) +
  geom_point() +
  labs(title = "Predicted Probability of Alzheimer's Diagnosis by MMSE",
       x = "MMSE Score",
       y = "Predicted Probability") +
  theme_minimal()



# Proportion of patients with MemoryComplaints = Yes
memory_yes <- sum(data_subset$MemoryComplaints == "1")
total_patients <- nrow(data_subset)

# 95% Confidence Interval for proportion
prop.test(memory_yes, total_patients, conf.level = 0.95)


# Hypothesis Test: Is proportion of memory complaints different from 0.5?
prop.test(memory_yes, total_patients, p = 0.5, alternative = "two.sided")



