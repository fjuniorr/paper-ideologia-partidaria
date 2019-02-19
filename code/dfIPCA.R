BETS::BETSget(13522, from = "2003-12-01", to = "2018-12-01", data.frame = TRUE) %>% 
  mutate(ANO = data.table::year(date)) %>% 
  filter(data.table::month(date) == 12) %>% 
  mutate(IPCA = (value / 100) + 1) %>% 
  select(ANO, IPCA) %>% 
  writexl::write_xlsx("data/dfIPCA.xlsx")
