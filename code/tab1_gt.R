library(gt)

import::here(tab1, .from = "code/tab1.R")

tab1 %>% 
    gt() %>% 
    tab_source_note("Fonte: Elaboração própria a partir de dados do Siafi-MG") %>% 
    as_rtf() %>% 
    writeLines("results/tab1.rtf")

