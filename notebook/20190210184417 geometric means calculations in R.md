---
id: '20190210184417'
tags: NULL
draft: FALSE
---

Possible implementation (which I don't understand) is
```
gmean <- function(x, na.rm=TRUE){
  exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
}
```



# References

+ https://stackoverflow.com/questions/2602583/geometric-mean-is-there-a-built-in

+ https://rdrr.io/cran/psych/man/geometric.mean.html

+ https://github.com/fjuniorr/misc/blob/master/R/taxas_crescimento.R

+ http://www.moneychimp.com/features/cagr.htm

+ http://www.in2013dollars.com/inflation-rate-in-2017

Geometric mean is also used for price inflation data.

+ https://ww2.ibge.gov.br/home/estatistica/populacao/tendencia_demografica/tabela01.shtm

Utilização do termo média geometrica pelo IBGE.

+ https://blog.exploratory.io/5-most-practically-useful-window-table-calculations-in-r-7e2c7ca431d9

Several types of window calculations in R
