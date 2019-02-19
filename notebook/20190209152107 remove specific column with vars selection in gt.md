---
id: '20190209152107'
tags: NULL
draft: FALSE
---

I want to use something like `-ANO`

```r
tbl %>% 
    gt() %>% 
    fmt_currency(-starts_with("ANO"))
```

# References

+ [Selecting columns in R data frame based on those *not* in a vector](https://stackoverflow.com/questions/12208090/selecting-columns-in-r-data-frame-based-on-those-not-in-a-vector)