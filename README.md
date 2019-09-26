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

After initial inspection, the largest correlations were 0.6984 (Examination and Education) and -0.6865 (Agriculute and Education) and these values aren't very large to imply multicollinearity.

Lets visualize the correlation using ggpairs().

![Image of Correlation](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/correlation.png)

### Identifying the presence of multicollinearity
```
vif(swiss)
```

```
       Fertility      Agriculture      Examination        Education         Catholic 
        3.409885         2.618024         3.768004         4.307472         2.349162 
Infant.Mortality 
        1.322601 
```

Looking at vifs, the largest ones are 4.307 for Education and 3.768 for Examination, which again doesn't indicate that there is multicollinearity.

### Calling `lm`
```
model <- lm(Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality, data = swiss)

summary(model)
```

```
Call:
lm(formula = Fertility ~ Agriculture + Examination + Education + 
    Catholic + Infant.Mortality, data = swiss)

Residuals:
     Min       1Q   Median       3Q      Max 
-15.2743  -5.2617   0.5032   4.1198  15.3213 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      66.91518   10.70604   6.250 1.91e-07 ***
Agriculture      -0.17211    0.07030  -2.448  0.01873 *  
Examination      -0.25801    0.25388  -1.016  0.31546    
Education        -0.87094    0.18303  -4.758 2.43e-05 ***
Catholic          0.10412    0.03526   2.953  0.00519 ** 
Infant.Mortality  1.07705    0.38172   2.822  0.00734 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 7.165 on 41 degrees of freedom
Multiple R-squared:  0.7067,	Adjusted R-squared:  0.671 
F-statistic: 19.76 on 5 and 41 DF,  p-value: 5.594e-10
```
After running the initial model, it generated an adjusted R-squared of 0.671 and all of the variables except Examination are significant. This indicates that Examination should be dropped and see how it would affect the model and remaining variables. However, lets keep it until performing model selection.

### Normality Plot
![Image of Normality Plot](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/normalityPlot.png)

To test the assumption of normal errors, lets look at a Q-Q plot. The points appeared to fall of the line with little deviation. To supplement this, lets use a Shapiro-Wilk test. 

### Normality Test
```
	Shapiro-Wilk normality test

data:  residuals(model1)
W = 0.98892, p-value = 0.9318
```
With a p-value = 0.9318, the null hypothesis that the errors were from a normal population can be kept. Therefore, the normality assumption was not violated.

#### Test constant variance of errors
![Image of Constant Variance of Errors](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/constantVarianceofErrors.png)

### Constant variance of errors

![Image of Agriculture](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/agriculture.png)

![Image of Examination](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/examination.png)

![Image of Education](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/education.png)

![Image of Catholic](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/catholic.png)

![Image of Infant Mortality](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/infantMortality.png)

All of the plots against residuals looked good and did not show signs of non-linearity. The plot of Catholic against the residuals, however, did show two groups of data. Lets run an F-test to test if the variance between these two groups are equal.

### F-stest of equal variance of errors among two groups of Catholic
```
var.test(residuals(model)[swiss$Catholic > 60], residuals(model)[swiss$Catholic < 60])
```

```
	F test to compare two variances

data:  residuals(model1)[swiss$Catholic > 60] and residuals(model1)[swiss$Catholic < 60]
F = 1.4591, num df = 15, denom df = 30, p-value = 0.3679
alternative hypothesis: true ratio of variances is not equal to 1
95 percent confidence interval:
 0.6324179 3.8574358
sample estimates:
ratio of variances 
          1.459085 
```

The p-value = 0.3679, therefore the null hypothesis of having equal variances cannot be rejected. The equal variance assumption was then not violated.

To See if there is a pattern that indicates that the erors are not independent, lets plot residuals against successive residuals.

![Image of Catholic Residuals](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/catholicResiduals..png)

Clearly, there is no visible pattern from the plot. Therefore, the independent errors assumption was not violated.

### Identify leverage points

![Image of leverage points](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/leveragePoints.png)

By using the leverage and cook's distance plot, the influential outliers can be identified.

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

```
Call:
lm(formula = Fertility ~ Agriculture + Examination + Education + 
    Catholic + Infant.Mortality, data = swiss, subset = (observation != 
    "sierre"))

Residuals:
     Min       1Q   Median       3Q      Max 
-15.2743  -5.2617   0.5032   4.1198  15.3213 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      66.91518   10.70604   6.250 1.91e-07 ***
Agriculture      -0.17211    0.07030  -2.448  0.01873 *  
Examination      -0.25801    0.25388  -1.016  0.31546    
Education        -0.87094    0.18303  -4.758 2.43e-05 ***
Catholic          0.10412    0.03526   2.953  0.00519 ** 
Infant.Mortality  1.07705    0.38172   2.822  0.00734 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 7.165 on 41 degrees of freedom
Multiple R-squared:  0.7067,	Adjusted R-squared:  0.671 
F-statistic: 19.76 on 5 and 41 DF,  p-value: 5.594e-10
```

### Remove a different outlier
```
modelRemovePorrentruy <- lm(Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality,
                            data = swiss, subset = (observation != "Porrentruy"))
                           
summary(modelRemovePorrentruy)
```

```
Call:
lm(formula = Fertility ~ Agriculture + Examination + Education + 
    Catholic + Infant.Mortality, data = swiss, subset = (observation != 
    "Porrentruy"))

Residuals:
     Min       1Q   Median       3Q      Max 
-15.7365  -5.0540   0.1953   4.1084  15.5399 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      65.45554   10.16998   6.436 1.15e-07 ***
Agriculture      -0.21034    0.06859  -3.067  0.00387 ** 
Examination      -0.32278    0.24227  -1.332  0.19031    
Education        -0.89506    0.17384  -5.149 7.36e-06 ***
Catholic          0.11269    0.03363   3.351  0.00177 ** 
Infant.Mortality  1.31567    0.37571   3.502  0.00115 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 6.794 on 40 degrees of freedom
Multiple R-squared:  0.7415,	Adjusted R-squared:  0.7091 
F-statistic: 22.94 on 5 and 40 DF,  p-value: 8.583e-11
```

### Remove both of the previous outliers
```
modelRemoveBoth <- lm(Fertility ~ Agriculture + Examination + Catholic + Infant.Mortality,
                     data = swissRemoveBoth)
                     
summary(modelRemoveBoth)
```

```
Call:
lm(formula = Fertility ~ Agriculture + Examination + Catholic + 
    Infant.Mortality, data = swissRemoveBoth)

Residuals:
     Min       1Q   Median       3Q      Max 
-23.3173  -2.9673   0.5707   5.9365  13.0533 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      53.55482   12.71678   4.211 0.000140 ***
Agriculture      -0.08179    0.07876  -1.039 0.305260    
Examination      -0.98770    0.24689  -4.001 0.000265 ***
Catholic          0.02405    0.03703   0.649 0.519854    
Infant.Mortality  1.80574    0.47162   3.829 0.000444 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 8.412 on 40 degrees of freedom
Multiple R-squared:  0.5736,	Adjusted R-squared:  0.531 
F-statistic: 13.45 on 4 and 40 DF,  p-value: 4.918e-07
```
As you can see, removing both outliers did not do good as the adjusted R-squared dropped significantly. However, some predictor variables became more significant.

### Stepwise regression excluding the two outliers
This uses the AIC criterios and returns the model with Examination removed. Recall that the Examination was the only nonsignificant variable from the beginning when it was considered to be drop. So, it makes sense that this was the variable that stepwise regression chose to eliminate.

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
The new model generated an adjusted R-squared of 0.7326 as can be seen. Furthermore, all the remaining variables were more significant than in the previous full model.

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
        
### Testing model with education removed
```
modelDropEdu <- lm(Fertility ~ Agriculture + Catholic + Infant.Mortality, data = swissRemoveBoth)

summary(modelDropEdu)
```

```
Call:
lm(formula = Fertility ~ +Agriculture + Catholic + Infant.Mortality, 
    data = swissRemoveBoth)

Residuals:
    Min      1Q  Median      3Q     Max 
-25.424  -5.273   1.224   6.183  19.190 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      21.00683   11.42308   1.839 0.073168 .  
Agriculture       0.11501    0.07188   1.600 0.117284    
Catholic          0.07970    0.04011   1.987 0.053628 .  
Infant.Mortality  1.99470    0.54844   3.637 0.000763 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 9.832 on 41 degrees of freedom
Multiple R-squared:  0.403,	Adjusted R-squared:  0.3593 
F-statistic: 9.226 on 3 and 41 DF,  p-value: 8.715e-05
```

### Testing for equal variance of errors with model from stepwise regression

![Image of stepwise regression model](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/stepwiseRegressionModel.png)

![Image of qqnorm stepwise](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/qqnormStepwiseRegression.png)

### Testing the normality assumption with new model
```
shapiro.test(residuals(model2))
```

```
	Shapiro-Wilk normality test

data:  residuals(model2)
W = 0.97892, p-value = 0.5764
```

### Testing the normality assumption with new model

![Image of outliers2](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/outliers2.png)

![Image of normalqq2](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/normalQQ2.png)

![Image of scalelocation2](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/scaleLocation2.png)

![Image of residualsleverage2](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/residualsLeverage2.png)

#### Test independent errors

![Image of stepwise residuals](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/stepwiseResiduals.png)

### Identifying new outliers with new models

![Image of new outliers model](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/influentialPoints2.png)

```
model2RemoveR <- lm(Fertility ~ Agriculture + Education + Catholic + Infant.Mortality, data = swissRemoveBoth,
		    subset = (observation2 != "Rive Gauche"))
		    
summary(model2RemoveR)
```

```
Call:
lm(formula = Fertility ~ Agriculture + Education + Catholic + 
    Infant.Mortality, data = swissRemoveBoth, subset = (observation2 != 
    "Rive Gauche"))

Residuals:
     Min       1Q   Median       3Q      Max 
-10.9764  -4.7365   0.7061   3.7102  12.5382 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      55.67762    8.09634   6.877 3.16e-08 ***
Agriculture      -0.20119    0.05787  -3.477  0.00126 ** 
Education        -0.94425    0.12679  -7.447 5.25e-09 ***
Catholic          0.13174    0.02494   5.283 5.11e-06 ***
Infant.Mortality  1.50098    0.33565   4.472 6.52e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.925 on 39 degrees of freedom
Multiple R-squared:  0.7683,	Adjusted R-squared:  0.7445 
F-statistic: 32.32 on 4 and 39 DF,  p-value: 6.619e-12
```

### Stepwise regression on null model with final data to confirm having the final model
```
stepwise(null, scope = list(upper = model2RemoveR), data = swissFinal, direction = "both")
```

```
Start:  AIC=226.73
Fertility ~ 1

                   Df Sum of Sq    RSS    AIC
+ Education         1   2871.37 3767.1 203.23
+ Infant.Mortality  1   1629.31 5009.2 216.06
+ Catholic          1   1211.93 5426.6 219.66
+ Agriculture       1    694.83 5943.7 223.75
<none>                          6638.5 226.73

Step:  AIC=203.23
Fertility ~ Education

                   Df Sum of Sq    RSS    AIC
+ Infant.Mortality  1   1202.14 2565.0 187.94
+ Catholic          1    810.64 2956.5 194.33
<none>                          3767.1 203.23
+ Agriculture       1    112.54 3654.6 203.87
- Education         1   2871.37 6638.5 226.73

Step:  AIC=187.94
Fertility ~ Education + Infant.Mortality

                   Df Sum of Sq    RSS    AIC
+ Catholic          1    537.06 2027.9 179.37
<none>                          2565.0 187.94
+ Agriculture       1     64.96 2500.0 188.78
- Infant.Mortality  1   1202.14 3767.1 203.23
- Education         1   2444.21 5009.2 216.06

Step:  AIC=179.36
Fertility ~ Education + Infant.Mortality + Catholic

                   Df Sum of Sq    RSS    AIC
+ Agriculture       1    414.21 1613.7 171.08
<none>                          2027.9 179.37
- Catholic          1    537.06 2565.0 187.94
- Infant.Mortality  1    928.57 2956.5 194.33
- Education         1   2182.57 4210.5 210.24

Step:  AIC=171.08
Fertility ~ Education + Infant.Mortality + Catholic + Agriculture

                   Df Sum of Sq    RSS    AIC
<none>                          1613.7 171.08
- Agriculture       1    414.21 2027.9 179.37
- Infant.Mortality  1    720.88 2334.6 185.70
- Catholic          1    886.31 2500.0 188.78
- Education         1   2349.34 3963.0 209.51

Call:
lm(formula = Fertility ~ Education + Infant.Mortality + Catholic + 
    Agriculture, data = swissRemoveBoth)

Coefficients:
     (Intercept)         Education  Infant.Mortality          Catholic  
         55.8620           -1.0143            1.5206            0.1245  
     Agriculture  
         -0.1987  
```

### Final check of multicollinearity with all outliers removed
```
vif(swissFinal)
```

```
       Fertility      Agriculture      Examination        Education         Catholic 
        4.554269         3.068551         3.643064         4.625727         2.493741 
Infant.Mortality 
        1.642003 
```

![Image of final residual](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/finalResidual.png)

![Image of final constant variace](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/finalConstantVariance.png)

### Final test of normality with final model
```
shapiro.test(residuals(model2RemoveR))
```

```
	Shapiro-Wilk normality test

data:  residuals(model2RemoveR)
W = 0.97813, p-value = 0.5605
```

![Image of final independent errors](https://github.com/gpadolina/diagnosticAnalysisAndStepwiseRegression/blob/master/plots/finalIndependentErrorsModel.png)
