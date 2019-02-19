library("flextable"); library("dplyr"); library("officer"); library("execucao"); library("relatorios")

source("code/lib/format_tab4.R")
source("code/lib/summary_ts.R")
source("code/lib/add_labels.R")
source("code/lib/is_rec_tributaria_principal.R")

tabReceitaTributaria <- exec_rec %>% 
  filter(is_rec_tributaria_principal(.)) %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts("Receita Tributária", level = TRUE)


tabTransferenciasCorrentes <- exec_rec %>% 
  filter(nat(RECEITA_COD, 17)) %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts("Transferências Correntes", level = TRUE)


tabReceitaTotal <- exec_rec %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts("Receita Total", level = TRUE)


tabIPCA <- readxl::read_excel("data/dfIPCA.xlsx") %>% 
  summary_ts("Inflação (IPCA)", level = FALSE)


tabPIB <- readxl::read_excel("data/dfPIB.xlsx") %>% 
  select(ANO, PIBReal) %>% 
  summary_ts("PIB-MG real", level = FALSE)

tab_flex <- list(tabReceitaTributaria, tabTransferenciasCorrentes, tabReceitaTotal, tabIPCA, tabPIB) %>% 
  purrr::reduce(rbind) %>% 
  add_labels(type = "2003-2018") %>% 
  format_tab4()

read_docx() %>% 
  body_add_flextable(value = tab_flex) %>% 
  print(target = "results/tab4.docx")