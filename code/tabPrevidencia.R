library("flextable"); library("dplyr"); library("officer")

dfPrevidencia <- readxl::read_excel("data-raw/previdencia.xlsx")

tab_flex <- dfPrevidencia %>% 
  mutate_at(vars(-Ano), function(x) {x / 1000000}) %>% 
  mutate_at(vars(-Ano), formattable::accounting, big.mark = ".", decimal.mark = ",") %>% 
  mutate(Ano = factor(Ano)) %>% # nice printing in flextable
  flextable() %>% 
  fontsize(size = 8, part = "all") %>% 
  font(fontname = "Times New Roman", part = "all") %>% 
  align(align = "center", part = "header") %>% 
  align(align = "right", part = "body") %>% 
  bg(bg = "#4F4F4F", part = "header") %>% 
  color(color = "#FFFFFF", part = "header") %>% 
  autofit() %>% 
  height_all(height = 0.1771654) %>% 
  hline(i = 12, part = "body", border = fp_border(color = "#b80001", width = 1))

tab_flex

read_docx() %>% 
  body_add_flextable(value = tab_flex) %>% 
  print(target = "results/tabPrevidencia.docx")
