is_rec_tributaria_principal <- function(x) {
  
  relatorios::is_icms_principal(x) | 
  relatorios::is_ipva_principal(x) | 
  relatorios::is_itcd_principal(x) | 
  relatorios::is_irrf_principal(x) |
  relatorios::is_taxas_principal(x)  
  
}
