library("flextable"); library("dplyr"); library("officer"); library("execucao"); library("relatorios")

source("code/lib/format_tab6.R")
source("code/lib/add_labels.R")
source("code/lib/summary_ts.R")

tabDespesasCapital <- exec_desp %>% 
  filter(CATEGORIA_COD == 4) %>% 
  group_by(ANO) %>% 
  summarize(DespesasCapital = sum(VL_EMP)) %>% 
  summary_ts("Despesas de Capital", level = TRUE)

tabInvestimentos <- exec_desp %>% 
  filter(GRUPO_COD == 4) %>% 
  group_by(ANO) %>% 
  summarize(Investimentos = sum(VL_EMP)) %>% 
  summary_ts("Investimentos", level = TRUE)

tabDespesasCorrentes <- exec_desp %>% 
  filter(CATEGORIA_COD == 3) %>% 
  group_by(ANO) %>% 
  summarize(DespesasCorrentes = sum(VL_EMP)) %>% 
  summary_ts("Despesas Correntes", level = TRUE)

tabCusteio <- exec_desp %>% 
  filter(GRUPO_COD == 3) %>% 
  group_by(ANO) %>% 
  summarize(Custeio = sum(VL_EMP)) %>% 
  summary_ts("Outras Despesas Correntes", level = TRUE)

tabPessoal <- exec_desp %>% 
  filter(GRUPO_COD == 1) %>% 
  group_by(ANO) %>% 
  summarize(Pessoal = sum(VL_EMP)) %>% 
  summary_ts("Pessoal e Encargos Sociais", level = TRUE)

tabDespesaTotal <- exec_desp %>% 
  group_by(ANO) %>% 
  summarize(Despesas = sum(VL_EMP)) %>% 
  summary_ts("Total Geral", level = TRUE)

tabIPCA <- readxl::read_excel("data/dfIPCA.xlsx") %>% 
  summary_ts("Inflação (IPCA)", level = FALSE)

tab_flex <- list(tabDespesasCapital, tabInvestimentos, tabDespesasCorrentes, tabCusteio, tabPessoal, tabDespesaTotal, tabIPCA) %>% 
  purrr::reduce(rbind) %>%
  add_labels(type = "2003-2018") %>% 
  format_tab6()

read_docx() %>% 
  body_add_flextable(value = tab_flex) %>% 
  print(target = "results/tab6.docx")

