---
id: '20190209145856'
tags: NULL
draft: FALSE
---

```r
gtcars %>%
    dplyr::select(mfr, model, msrp) %>%
    dplyr::slice(1:5) %>%
    gt() %>%
    tab_header(
        title = "Data listing from gtcars"
    )
```