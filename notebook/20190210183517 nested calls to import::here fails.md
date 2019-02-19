---
id: '20190210183517'
tags: NULL
draft: FALSE
---

If we have three files `script1.R`, `script2.R`, and `script3.R` with the following content

```r
# script1.R

VALUES <- rnorm(100)
```

```r
# script2.R

import::here(VALUES, .from = "code/script1.R")
VALUES <- VALUES + 50
```

```r
# script3.R

import::here(VALUES, .from = "code/script2.R")
```

When I run `script3.R`, I get the following error:

```r
import::here(VALUES, .from = "code/script2.R")
# Error in loadNamespace(from, lib.loc = .library) : 
#  there is no package called ‘code/script3.R’
```