format_tab6 <- function(x) {
  result <- x %>% 
    flextable() %>% 
    fontsize(size = 8, part = "all") %>% 
    font(fontname = "Times New Roman", part = "all") %>% 
    align(align = "center", part = "header") %>% 
    align(align = "right", part = "body") %>% 
    align(j = 1, align = "left") %>% # diff from tab1
    bg(bg = "#4F4F4F", part = "header") %>% 
    color(color = "#FFFFFF", part = "header") %>% 
    hline(i = c(5), part = "body", border = fp_border(color = "#000000", width = 1)) %>% 
    bold(i = c(1, 3, 6, 7), part = "body") %>% 
    hline(i = 7, part = "body", border = fp_border(color = "#b80001", width = 1)) %>% 
    autofit() %>% 
    height_all(height = 0.1771654) %>% 
    width(j = 2:6, width = 1.185039)
  
  result
}