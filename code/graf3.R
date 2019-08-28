library(ggplot2); library(dplyr)
library(execucao); library(relatorios)

source("code/lib/is_rec_tributaria_principal.R")

dfReceitaTributaria <- exec_rec %>% 
  filter(is_rec_tributaria_principal(.)) %>% 
  group_by(ANO) %>% 
  summarize(ReceitaTributaria = sum(VL_EFET_AJUST)) %>% 
  mutate(ReceitaTributaria = ReceitaTributaria / lag(ReceitaTributaria) - 1) %>% 
  tidyr::drop_na()


dfPIBNominal <- readxl::read_excel("data/dfPIB.xlsx") %>% 
  select(ANO, PIBNominal) %>% 
  mutate(PIBNominal = PIBNominal - 1)

left_join(dfReceitaTributaria, dfPIBNominal, by = "ANO") %>% 
  writexl::write_xlsx("data/dfgraf3.xlsx")


left_join(dfReceitaTributaria, dfPIBNominal, by = "ANO") %>% 
  ggplot(aes(x = factor(ANO), y = ReceitaTributaria, group = 1, color = "Receita Tributária")) + 
  geom_line() +
  geom_line(aes(y = PIBNominal, group = 1, color = "PIB-MG Nominal")) +
  theme_bw() +
  xlab(element_blank()) + 
  ylab(element_blank()) + 
  theme(panel.border = element_blank()) + 
  theme(legend.position=c(0.85,0.95), legend.justification=c(0,1)) +
  scale_color_manual(values = c(
    'Receita Tributária' = 'blue',
    'PIB-MG Nominal' = 'red')) +
  theme(legend.title = element_blank()) + 
  theme(panel.grid.minor = element_line(size = .2), panel.grid.major = element_line(size = .2))
