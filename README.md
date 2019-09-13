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
