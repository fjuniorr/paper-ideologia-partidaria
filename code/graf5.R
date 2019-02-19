library(ggplot2); library(dplyr)
library(execucao); library(relatorios)

source("code/lib/is_rec_tributaria_principal.R")

dfReceitaTotal <- exec_rec %>% 
  group_by(ANO) %>% 
  summarize(ReceitaTotal = sum(VL_EFET_AJUST)) %>% 
  mutate(ReceitaTotal = (ReceitaTotal / first(ReceitaTotal))*100) %>% 
  tidyr::drop_na()


dfInvestimentos <- exec_desp %>% 
  filter(GRUPO_COD == 4) %>% 
  group_by(ANO) %>% 
  summarize(Investimentos = sum(VL_EMP)) %>% 
  mutate(Investimentos = (Investimentos / first(Investimentos))*100) %>% 
  tidyr::drop_na()

  
left_join(dfReceitaTotal, dfInvestimentos, by = "ANO") %>% 
  ggplot(aes(x = factor(ANO), y = ReceitaTotal, group = 1, color = "Receita Total")) + 
  geom_line() +
  geom_line(aes(y = Investimentos, group = 1, color = "Investimentos")) +
  theme_bw() +
  xlab(element_blank()) + 
  ylab(element_blank()) + 
  theme(panel.border = element_blank()) + 
  theme(legend.position=c(0.05,0.95), legend.justification=c(0,1)) +
  scale_color_manual(values = c(
    'Receita Total' = 'blue',
    'Investimentos' = 'red')) +
  theme(legend.title = element_blank()) +
  theme(panel.grid.minor = element_line(size = .2), panel.grid.major = element_line(size = .2))
