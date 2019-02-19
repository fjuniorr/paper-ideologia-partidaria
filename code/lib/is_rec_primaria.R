library(data.table)

is_rec_primaria <- function(base) {
  
  base$COL <- FALSE
  
  base[ANO <= 2017 & is_primario_rec(base), COL := TRUE]
  
  base[ANO >= 2018 & 
         (is_primario_rec(base) | nat(RECEITA_COD, 22)) & 
         (nat(RECEITA_COD, 1, 2, 7, 9, -164001)), 
       COL := TRUE]
  
  return(base$COL)
}