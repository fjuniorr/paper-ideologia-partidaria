library(dplyr)
library(forecast)

dfPIBTrimestralRealizado <- readxl::read_excel("data-raw/PIB_trimestral_MG_2018-3.xlsx",
                             sheet = "Valores Correntes",
                             range = "A5:F39",
                             col_names = c("PERIODO", "AGROPECUARIA", "INDUSTRIA", "SERVICOS", "VA", "PIBNominal"))
# Vizualization
# library(ggplot2)
# dfPIBTrimestral %>% 
#   separate("PERIODO", c("ANO", "TRIMESTRE"), "\\.", convert = TRUE, remove = FALSE) %>% 
#   ggplot(aes(x = PERIODO, y = PIBNominal)) + geom_point()
# 
# dfPIBTrimestral %>% 
#   separate("PERIODO", c("ANO", "TRIMESTRE"), "\\.", convert = TRUE, remove = FALSE) %>% 
#   ggplot(aes(x = PERIODO, y = PIBNominal)) + geom_point() + facet_wrap(. ~ TRIMESTRE)

tsPIBTrimestralRealizado <- dfPIBTrimestralRealizado$PIBNominal %>% 
  ts(start = c(2010, 1), frequency = 4)

tsPIBTrimestralPrevisto <- forecast::tslm(tsPIBTrimestralRealizado ~ trend + season) %>% 
  forecast::forecast(h = 1) %>% 
  magrittr::extract2("mean")
  
dfPIBTrimestral <- c(tsPIBTrimestralRealizado, tsPIBTrimestralPrevisto) %>% 
  ts(start = c(2010, 1), frequency = 4) %>% 
  data.frame(ANO = time(.) %>% substr(1, 4) %>% as.numeric(),
             TRIMESTRE = cycle(.),
             PIBNominal = .) %>% 
  group_by(ANO) %>% 
  summarize(PIBNominal = sum(PIBNominal))
  
dfPIBAnual <- readxl::read_excel("data-raw/PIB_MG_anual_2002-2016.xlsx", 
           sheet = "Tabela 1", 
           range = "B12:P12",
           col_names = FALSE) %>% magrittr::set_colnames(2002:2016) %>% 
  tidyr::gather(key = "ANO", "PIBNominal") %>% 
  mutate(ANO = as.numeric(ANO))


dfPIBNominal <- full_join(dfPIBAnual, dfPIBTrimestral, by = "ANO") %>% 
  mutate(PIBNominal = ifelse(is.na(PIBNominal.x), PIBNominal.y, PIBNominal.x)) %>% 
  select(ANO, PIBNominal) %>% 
  mutate(PIBNominal = PIBNominal * 1000000) %>% 
  mutate(PIBNominal = PIBNominal / lag(PIBNominal)) %>% 
  tidyr::drop_na()


#=======================================================
# PIB Real e Deflator do PIB


# IGP-DI teve deflacao em 2017
# BETS::BETSget(190, from = "2003-01-01", to = "2018-12-01", data.frame = TRUE) %>% 
#   mutate(ANO = data.table::year(date)) %>% 
#   mutate(value = value / 100 + 1) %>% 
#   select(ANO, value) %>% 
#   group_by(ANO) %>% 
#   summarize(IGP_DI = prod(value))

dfIPCA <- readxl::read_excel("data/dfIPCA.xlsx")

dfPIBInfo <- readxl::read_excel("data-raw/PIB_MG_anual_2002-2016.xlsx", 
                                sheet = "Tabela 2", 
                                range = "C20:P21",
                                col_names = FALSE) %>% magrittr::set_colnames(2003:2016) %>% 
  mutate(SERIE = c("PIBReal", "PIBDeflator")) %>% 
  data.table::melt(id.vars = "SERIE", variable.name = "ANO") %>% 
  data.table::dcast(ANO ~ SERIE, value.var = "value", fun = sum) %>% 
  mutate_at(vars(starts_with("PIB")), funs((. / 100) + 1)) %>% 
  mutate(ANO = as.numeric(as.character(ANO)))


dfPIBDeflator <- full_join(dfPIBInfo, dfIPCA, by = "ANO") %>% 
  mutate(PIBDeflator = ifelse(is.na(PIBDeflator), IPCA, PIBDeflator)) %>% 
  select(ANO, PIBDeflator)


dfPIB <- left_join(dfPIBDeflator, dfPIBNominal, by = "ANO") %>% 
  mutate(PIBReal = PIBNominal / PIBDeflator)

dfPIB[dfPIB$ANO == 2017, "PIBReal"] <- 1.01382246330811
dfPIB[dfPIB$ANO == 2018, "PIBReal"] <- 1.01701553911974

dfPIB %>% 
  select(ANO, PIBNominal, PIBReal) %>% 
  writexl::write_xlsx("data/dfPIB.xlsx")  

