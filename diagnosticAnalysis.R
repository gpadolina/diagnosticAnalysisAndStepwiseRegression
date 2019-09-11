library(dplyr)
library(ggplot2)
library(GGally)
library(tidyr)
library(VIF)

remove(list = ls())

# Data exploration
View(swiss)

# Summary provides statistics of the dataset
summary(swiss)

# Dataset correlation
cor(swiss)
ggpairs(swiss)

# Identifying the presence of multicollinearity
swiss <- swiss

model <- lm(Fertility ~ Agriculture + Examination + Education + Catholic +
            Infant.Mortality, data = swiss)

# First model
summary(model)

# Normality plot
qqnorm(residuals(model), ylab = "Residuals", main = " ")
qqline(residuals(model))

# Normality test
shapiro.test(residuals(model))

# Plot to test constant variance of errors
plot(fitted(model), residuals(model), xlab = "Fitted", ylab = "Residuals")
abline(h = 0)

# Constant variance of errors
plot(swiss$Agriculture, residuals(model), xlab = "Examination", ylab = "Residuals")
plot(swiss$Examination, residuals(model), xlab = "Examination", ylab = "Residuals")
plot(swiss$Education, residuals(model), xlab = "Examination", ylab = "Residuals")
plot(swiss$Catholic, residuals(model), xlab = "Examination", ylab = "Residuals")
plot(swiss$Infant.Mortality, residuals(model), xlab = "Examination", ylab = "Residuals")

# F-test of equal variance of errors among two groups of Catholic
var.test(residuals(model)[swiss$Catholic > 60], residuals(model)[swiss$Catholic < 60])

n <- length(residuals(model))

plot(tail(residuals(model), n-1) ~ head(residuals(model), n-1),
     xlab = expression(hat(epsilon)[i]), ylab = expression(hat(epsilon)[i + 1]))

# Plot to test independent errors
abline(h = 0, v = 0, col = grey(0.75))

observation <- row.names(swiss)

hatV <- hatvalues(model)

# Plot to identify leverage points
halfnorm(hatV, labs = observation, ylab = "Leverages")

cook <- cooks.distance(model)
