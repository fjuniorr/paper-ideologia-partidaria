library("flextable"); library("dplyr"); library("officer"); library("execucao")

source("code/lib/format_tab3.R")
source("code/lib/summary_ts.R")
source("code/lib/add_labels.R")

tabReceitaTotal <- exec_rec %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts("Receitas", level = TRUE)

tabDespesaTotal <- exec_desp %>% 
  group_by(ANO) %>% 
  summarize(Despesas = sum(VL_EMP)) %>% 
  summary_ts("Despesas", level = TRUE)
 
tabIPCA <- readxl::read_excel("data/dfIPCA.xlsx") %>% 
  summary_ts("Inflação (IPCA)", level = FALSE)

tab_flex <- list(tabDespesaTotal, tabReceitaTotal, tabIPCA) %>% 
  purrr::reduce(rbind) %>% 
  add_labels(type = "2003-2018") %>% 
  format_tab3()

read_docx() %>% 
  body_add_flextable(value = tab_flex) %>% 
  print(target = "results/tab3.docx")