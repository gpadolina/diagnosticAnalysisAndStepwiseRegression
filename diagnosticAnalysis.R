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

# Identifying the presence of multicollinearity
swiss <- swiss

model <- lm(Fertility ~ Agriculture + Examination + Education + Catholic +
            Infant.Mortality, data = swiss)

# First model
summary(model)
