## Diagnostic Analysis and Stepwise Regression

In 1888, Switzerland was suffering from an unusual decline in fertility, a period known as demographic transition, and so the Swiss collected data across its provinces in the hope of discovering why. Using stepwise regression, lets attempt to find the best model realting fertility to potential predictors.

The data includes the following features:
* Agriculture
* Examination
* Education
* Catholic
* Infant Mortality

---

Lets start with the correlation table of the Swiss data.

| | Fertility | Agriculture | Examination | Education | Catholic | Infant.Mortality |
| Fertility | 1.0000000 | 0.35307918 | -0.6458827 | -0.66378886 | 0.4636847 | 0.41655603 |
| Agriculture | 0.3530792 | 1.00000000 | -0.6865422 | -0.63952272 | 0.4010951 | -0.06085861 |
| Examination | -0.6458827 | -0.68654221 | 1.0000000 | 0.69841530 | -0.5727418 | -0.11402160 |
| Education | -0.6637889 | -0..63952252 | 0.6984153 | 1.00000000 | -0.1538589 | -0.09932185 |
| Catholic | 0.4636847 | 0.40109505 | -0.5727418 | -0.15385892 | 1.0000000 | 0.17549591 |
| Infant.Mortality | 0.4165560 | -0.06085861 | -0.1140216 | -0.09932185 | 0.1754959 | 1.00000000 |
