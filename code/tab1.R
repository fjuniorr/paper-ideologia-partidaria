library(execucao); library(relatorios)
library(purrr); library(dplyr); library(formattable)

source("code/lib/is_rec_primaria.R")

dfReceitaTotal <- exec_rec %>% 
  group_by(ANO) %>% 
  summarize(Receitas = sum(VL_EFET_AJUST))

dfDespesaTotal <- exec_desp %>% 
  group_by(ANO) %>% 
  summarize(Despesas = sum(VL_EMP))

dfReceitaPrimaria <- exec_rec %>% 
  filter(is_rec_primaria(.)) %>% 
  group_by(ANO) %>% 
  summarize(ReceitaPrimaria = sum(VL_EFET_AJUST))

dfDespesaPrimaria <- exec_desp %>% 
  filter(is_primario_desp(exec_desp)) %>% 
  group_by(ANO) %>% 
  summarize(DespesaPrimaria = sum(VL_EMP))


tab1 <- list(dfReceitaTotal, dfDespesaTotal, dfReceitaPrimaria, dfDespesaPrimaria) %>% 
  reduce(full_join, by = "ANO") %>% 
  mutate(Resultado = Receitas - Despesas,
         ResultadoPrimario = ReceitaPrimaria - DespesaPrimaria) %>% 
  select(-contains("Primaria")) %>% 
  mutate_at(vars(-ANO), accounting, big.mark = ".", decimal.mark = ",") %>% 
  mutate(ANO = factor(ANO)) %>% # nice printing in flextable
  rename(Ano = ANO, `Superávit/Déficit` = Resultado, `Superávit/Déficit Primário` = ResultadoPrimario) %>% 
  mutate_at(vars(-Ano), function(x) {x / 1000000})


tab_flex <- tab1 %>% 
  flextable() %>% 
  fontsize(size = 8, part = "all") %>% 
  font(fontname = "Times New Roman", part = "all") %>% 
  align(align = "center", part = "header") %>% 
  align(align = "right", part = "body") %>% 
  bg(bg = "#4F4F4F", part = "header") %>% 
  color(color = "#FFFFFF", part = "header") %>% 
  autofit() %>% 
  height_all(height = 0.1771654) %>% 
  hline(i = 17, part = "body", border = fp_border(color = "#b80001", width = 1))

tab_flex

read_docx() %>% 
  body_add_flextable(value = tab_flex) %>% 
  print(target = "results/tab1.docx")
