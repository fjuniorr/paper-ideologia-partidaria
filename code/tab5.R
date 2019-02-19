library("flextable"); library("dplyr"); library("officer"); library("execucao"); library("relatorios")

source("code/lib/format_tab5.R")
source("code/lib/add_labels.R")
source("code/lib/summary_ts_mandato.R")
source("code/lib/is_rec_tributaria_principal.R")

tabReceitaTributaria <- exec_rec %>% 
  filter(is_rec_tributaria_principal(.)) %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts_mandato("Receita Tributária", level = TRUE)


tabTransferenciasCorrentes <- exec_rec %>% 
  filter(nat(RECEITA_COD, 17)) %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts_mandato("Transferências Correntes", level = TRUE)


tabReceitaTotal <- exec_rec %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST)) %>% 
  summary_ts_mandato("Receita Total", level = TRUE)


tabIPCA <- readxl::read_excel("data/dfIPCA.xlsx") %>% 
  summary_ts_mandato("Inflação (IPCA)", level = FALSE)


tabPIB <- readxl::read_excel("data/dfPIB.xlsx") %>% 
  select(ANO, PIBReal) %>% 
  summary_ts_mandato("PIB-MG real", level = FALSE)

tab_flex <- list(tabReceitaTributaria, tabTransferenciasCorrentes, tabReceitaTotal, tabIPCA, tabPIB) %>% 
  purrr::reduce(rbind) %>% 
  add_labels(type = "2015-2018") %>% 
  format_tab5()

read_docx() %>% 
  body_add_flextable(value = tab_flex) %>% 
  print(target = "results/tab5.docx")
