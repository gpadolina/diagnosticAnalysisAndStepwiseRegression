## Diagnostic Analysis and Stepwise Regression

In 1888, Switzerland was suffering from an unusual decline in fertility, a period known as demographic transition, and so the Swiss collected data across its provinces in the hope of discovering why. Using stepwise regression, lets attempt to find the best model realting fertility to potential predictors.

The data is known as Swiss Fertility and Socioeconomic Indicators (1888) and includes the following features:
* Fertility 
* Agriculture - % of males involved in agricultures as occupation
* Examination - % draftees receiving highest mark on army examination
* Education - % education beyong primary school for draftees
* Catholic - % catholic (as opposed to 'protestant')
* Infant Mortality - live births who live less than 1 year

---

Lets start with the correlation table of the Swiss data.

| | Fertility | Agriculture | Examination | Education | Catholic | Infant.Mortality |
| --- | --- | --- | --- | --- | --- | --- |
| Fertility | 1.0000000 | 0.35307918 | -0.6458827 | -0.66378886 | 0.4636847 | 0.41655603 |
| Agriculture | 0.3530792 | 1.00000000 | -0.6865422 | -0.63952272 | 0.4010951 | -0.06085861 |
| Examination | -0.6458827 | -0.68654221 | 1.0000000 | 0.69841530 | -0.5727418 | -0.11402160 |
| Education | -0.6637889 | -0..63952252 | 0.6984153 | 1.00000000 | -0.1538589 | -0.09932185 |
| Catholic | 0.4636847 | 0.40109505 | -0.5727418 | -0.15385892 | 1.0000000 | 0.17549591 |
| Infant.Mortality | 0.4165560 | -0.06085861 | -0.1140216 | -0.09932185 | 0.1754959 | 1.00000000 |

After initial inspection, it can be seen that Fertility and Education are about averagely negatively correlated.

Lets visualize the correlation using ggpairs().

![Image of Correlation](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/correlation.png)

### Calling `lm`
```
model <- lm(Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality, data = swiss)

summary(model)
```
Residuals:

| Min | 1Q | Median | 3Q | Max |
| --- | --- | --- | --- | --- |
| -15.2743 | -5.2617 | 0.5032 | 4.1198 | 15.3213 |

Coefficients:

| | Estimate | Std. Error | t value | Pr(>abs(t)) |
| --- | --- | --- | --- | --- |
| (Intercept) | 66.91518 | 10.70604 | 6.250 | 1.91e-07 *** |
| Agriculture | -0.17211 | 0.07030 | -2.448 | 0.01873 * |
| Examination | -0.25801 | 0.25388 | -1.016 | 0.31546 |
| Education | -0.87094 | 0.18303 | -4.758 | 2.43e-05 *** |
| Catholic | 0.10412 | 0.03526 | 2.953 | 0.00519 ** |
| Infant.Mortality | 1.07705 | 0.38172 | 2.822 | 0.00734 ** |

Residual standard error: 7.165 on 41 degrees of freedom

Multiple R-squared: 0.7067, Adjusted R-squared: 0.671

F-statistic: 19.76 on 5 and 41 DF, p-value: 5.594e-10

### Normality Plot
![Image of Normality Plot](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/normalityPlot.png)

### Normality Test
Shapiro-Wilk normality test

data: residuals(model)
W = 0.98892, p-value = 0.9318

#### Test constant variance of errors
![Image of Constant Variance of Errors](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/constantVarianceofErrors.png)

### Constant variance of errors

![Image of Agriculture](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/agriculture.png)

![Image of Examination](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/examination.png)

![Image of Education](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/education.png)

![Image of Catholic](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/catholic.png)

![Image of Infant Mortality](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/infantMortality.png)

### F-stest of equal variance of errors among two groups of Catholic
```
var.test(residuals(model)[swiss$Catholic > 60], residuals(model)[swiss$Catholic < 60])
```
F test to compare two variances

F = 1.4591, num df = 15, denom df = 30, p-value = 0.3679

alternative hypothesis: true ratio of variances is not equal to 1

95 percent confidence interval:

   0.6324179 3.8574358

sample estimates:

ratio of variances

   1.459085

![Image of Catholic Residuals](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/catholicResiduals..png)

### Identify leverage points

![Image of leverage points](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/leveragePoints.png)

### Identify influential points

![Image of influential points](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/influentialPoints.png)

### Identify potential outliers

![Image of outliers](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/outliers1.png)

![Image of Q-Q plot](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/normalQQ.png)

![Image of Residuals vs Leverage](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/residualsLeverage.png)

![Image of Scale Location](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/scaleLocation.png)

### Removing one outlier
```
modelRemoveSierre <- lm(Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality,
                        data = swiss, subset = (observation != "sierre"))
                        
summary(modelRemoveSierre)
```

Residuals:

| Min | 1Q | Median | 3Q | Max |
| --- | --- | --- | --- | --- |
| -15.2743 | -5.2617 | 0.5032 | 4.1198 | 15.3213 |

Coefficients:

| | Estimate | Std. Error | t value | Pr(>abs(t)) |
| --- | --- | --- | --- | --- |
| (Intercept) | 66.91518 | 10.70604 | 6.250 | 1.91e-07 *** |
| Agriculture | -0.17211 | 0.07030 | -2.448 | 0.01873 * |
| Examination | -0.25801 | 0.25388 | -1.016 | 0.31546 |
| Education | -0.87094 | 0.18303 | -4.758 | 2.43e-05 *** |
| Catholic | 0.10412 | 0.03526 | 2.953 | 0.00519 ** |
| Infant.Mortality | 1.07705 | 0.38172 | 2.822 | 0.00734 ** |

Residual standard error: 7.165 on 41 degrees of freedom

Multiple R-squared: 0.7067, Adjusted R-squared: 0.671

F-statistic: 19.76 on 5 and 41 DF, p-value: 5.594e-10

### Remove a different outlier
```
modelRemovePorrentruy <- lm(Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality,
                            data = swiss, subset = (observation != "Porrentruy"))
                           
summary(modelRemovePorrentruy)
```

Residuals:

| Min | 1Q | Median | 3Q | Max |
| --- | --- | --- | --- | --- |
| -15.7365 | -5.0540 | 0.1953 | 4.1084 | 15.5399 |

Coefficients:

| | Estimate | Std. Error | t value | Pr(>abs(t)) |
| --- | --- | --- | --- | --- |
| (Intercept) | 65.45554 | 10.16998 | 6.436 | 1.15e-07 *** |
| Agriculture | -0.21034 | 0.06859 | -3.067 | 0.00387 ** |
| Examination | -0.32278 | 0.24227 | -1.332 | 0.19031 |
| Education | -0.89506 | 0.17384 | -5.149 | 7.36e-06 *** |
| Catholic | 0.11269 | 0.03363 | 3.351 | 0.00177 ** |
| Infant.Mortality | 1.31567 | 0.37571 | 3.502 | 0.00115 ** |

Residual standard error: 6.794 on 40 degrees of freedom

Multiple R-squared: 0.7415, Adjusted R-squared: 0.7091

F-statistic: 22.94 on 5 and 40 DF, p-value: 8.583e-11

### Remove both of the previous outliers
```
modelRemoveBoth <- lm(Fertility ~ Agriculture + Examination + Catholic + Infant.Mortality,
                     data = swissRemoveBoth)
                     
summary(modelRemoveBoth)
```

Residuals:

| Min | 1Q | Median | 3Q | Max |
| --- | --- | --- | --- | --- |
| -23.3173 | -2.9673 | 0.5707 | 5.9365 | 13.0533 |

Coefficients:

| | Estimate | Std. Error | t value | Pr(>abs(t)) |
| --- | --- | --- | --- | --- |
| (Intercept) | 53.55482 | 12.71678 | 4.211 | 0.000140 *** |
| Agriculture | -0.08179 | 0.07876 | -1.039 | 0.305260 |
| Examination | -0.98770 | 0.24689 | -4.001 | 0.000265 *** |
| Catholic | 0.02405 | 0.03703 | 0.649 | 0.519854 |
| Infant.Mortality | 1.80574 | 0.47162 | 3.829 | 0.000444 *** |

Residual standard error: 8.412 on 40 degrees of freedom

Multiple R-squared: 0.5736, Adjusted R-squared: 0.531

F-statistic: 13.45 on 4 and 40 DF, p-value: 4.918e-07

### Stepwise regression excluding the two outliers
```
step(null, scope = list(upper = modelRemoveBoth), data = swissRemoveBoth,
      direction = "both")
```

```
Start:  AIC=226.73
Fertility ~ 1

                   Df Sum of Sq    RSS    AIC
+ Examination       1   2533.47 4105.0 207.10
+ Infant.Mortality  1   1629.31 5009.2 216.06
+ Catholic          1   1211.93 5426.6 219.66
+ Agriculture       1    694.83 5943.7 223.75
<none>                          6638.5 226.73

Step:  AIC=207.1
Fertility ~ Examination

                   Df Sum of Sq    RSS    AIC
+ Infant.Mortality  1   1173.47 2931.6 193.95
<none>                          4105.0 207.10
+ Agriculture       1    142.23 3962.8 207.51
+ Catholic          1     85.05 4020.0 208.16
- Examination       1   2533.47 6638.5 226.73

Step:  AIC=193.95
Fertility ~ Examination + Infant.Mortality

                   Df Sum of Sq    RSS    AIC
<none>                          2931.6 193.95
+ Agriculture       1     71.23 2860.3 194.84
+ Catholic          1     24.74 2906.8 195.57
- Infant.Mortality  1   1173.47 4105.0 207.10
- Examination       1   2077.63 5009.2 216.06

Call:
lm(formula = Fertility ~ Examination + Infant.Mortality, data = swissRemoveBoth)

Coefficients:
     (Intercept)       Examination  Infant.Mortality  
         46.9259           -0.8877            1.8940
```

### New model from stepwise regression
```
model2 <- lm(Fertility ~ Agriculture + Education + Catholic + Infant.Mortality, data = swissRemoveBoth)

summary(model2)
```

```
Call:
lm(formula = Fertility ~ Agriculture + Education + Catholic + 
    Infant.Mortality, data = swissRemoveBoth)

Residuals:
    Min      1Q  Median      3Q     Max 
-14.756  -5.413   1.006   3.643  12.930 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      55.86203    8.67888   6.437 1.15e-07 ***
Agriculture      -0.19874    0.06202  -3.204 0.002659 ** 
Education        -1.01426    0.13291  -7.631 2.52e-09 ***
Catholic          0.12455    0.02657   4.687 3.19e-05 ***
Infant.Mortality  1.52059    0.35972   4.227 0.000133 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 6.352 on 40 degrees of freedom
Multiple R-squared:  0.7569,	Adjusted R-squared:  0.7326 
F-statistic: 31.14 on 4 and 40 DF,  p-value: 8.375e-12
```

### Testing multicollinearity with outliers removed
```
vif(swissRemoveBoth)
```

```
       Fertility      Agriculture      Examination        Education         Catholic 
        4.242630         2.950615         3.564488         4.945927         2.351665 
Infant.Mortality 
        1.557780 
```
        
