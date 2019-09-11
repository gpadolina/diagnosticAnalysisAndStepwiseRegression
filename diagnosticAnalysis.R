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

plot(tail(residuals(model), n - 1) ~ head(residuals(model), n - 1),
     xlab = expression(hat(epsilon)[i]), ylab = expression(hat(epsilon)[i + 1]))

# Plot to test independent errors
abline(h = 0, v = 0, col = grey(0.75))

observation <- row.names(swiss)

hatV <- hatvalues(model)

# Plot to identify leverage points
halfnorm(hatV, labs = observation, ylab = "Leverages")

cook <- cooks.distance(model)

# Plot to identify influential points
halfnorm(cook, 3, labs = observation, ylab = "Cook's Distance")

# Provides several plots to identify potential outliers
plot(model)

summary(model)

modelRemoveS <- lm(Fertility ~ Agriculture + Examination + Education +
                   Catholic + Infant.Mortality, data = swiss,
                   subset = (observation != "sierre"))

# Model with new dataset which removes one outlier
summary(modelRemoveS)

modelRemoveP <- lm(Fertility ~ Agriculute + Examination + Education +
                   Catholic + Infant.Mortality, data = swiss,
                   subset = (observation != "Porrentruy"))

# Model with new dataset which removes a different outlier
summary(modelRemoveP)

swissRemoveBoth <-[-c(6, 37), ]
View(swissRemoveBoth)

# Model with new dataset which removes both of the previous outliers
modelRemoveBoth <- lm(Fertility ~ Agriculture + Examination + Catholic +
                      Infant.Mortality, data = swissRemoveBoth)

summary(modelRemoveBoth)

# Model with intercept parameter only
null <- lm(Fertility ~ 1, data = swissRemoveBoth)

# Performs stepwise regression on the null model with dataset excluding the two outliers
step(null, scope = list(upper = modelRemoveBoth), data = swissRemoveBoth,
     direction = "both")

# New model from stepwise regression
model2 <- lm(Fertility ~ Agriculture + Education + Catholic +
             Infant.Mortality, data = swissRemoveBoth)

summary(model2)

# Testing multicollinearity of data with outliers removed
vif(swissRemoveBoth)

# Testing model education removed
modelDropEduc <- lm(Fertility ~ Agriculture + Catholic + Infant.Mortality,
                    data = swissRemoveBoth)

summary(modelDropEduc)

# Testing the equal variance of errors with model from stepwise regression
plot(fitted(model2), residuals(model2), xlab = "Fitted",
     ylab = "Residuals")

qqnorm(residuals(model2), ylab = "Residuals", main = " ")
qqline(residuals(model2))

# Testing the normality assumption with new model
shapiro.test(residuals(model2))
plot(model2)

n <- length(residuals(model2))

plot(tail(residuals(model2), n - 1) ~ head(residuals(model2), n - 1),
     xlab = expression(hat(epsilon)[i]), ylab = expression(hat(epsilon)[i + 1]))

# Plot to test independent errors again
abline(h = 0, v = 0, col = grey(0.75))

observation2 <- row.names(swissRemoveBoth)

cook2 <- cooks.distance(model2)

# Identifying new outliers with new model
halfnorm(cook2, 3, labs = observation2, ylab = "Cook's Distance")

model2RemoveR <- lm(Fertility ~ Agriculture + Education + Catholic +
                    Infant.Mortality, data = swissRemoveBoth,
                    subset = (observation2 != "Rive Gauche"))

# Testing another model with new outlier removed
summary(model2RemoveR)

# Final data set with all 3 outliers removed
swissFinal <- swissRemoveBoth[-c(45), ]
View(swissFinal)

# Model with only intercept (using final dataset)
null2 <- lm(Fertility ~ 1, data = swissFinal)
