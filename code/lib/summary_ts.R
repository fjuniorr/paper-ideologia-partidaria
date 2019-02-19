source(here::here("code/lib/", "mandato.R"))
source(here::here("code/lib/", "percent.R"))
source(here::here("code/lib", "gmean.R"))

summary_ts <- function(data, name = "Series", level = TRUE) {
    
  if(level) {
    summary_ts_level(data, name)
  } else {
    summary_ts_relative_change(data, name)
    }

}


summary_ts_relative_change <- function(data, name) {
  tab1 <- data %>% 
    purrr::set_names(c("ANO", "RELATIVE_CHANGE")) %>% 
    dplyr::mutate(HEADER = mandato(ANO)) %>% 
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE")
  
  tab2 <- data %>% 
    purrr::set_names(c("ANO", "RELATIVE_CHANGE")) %>% 
    dplyr::mutate(HEADER = "2003-2018") %>% 
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE") %>% 
    dplyr::select(-NAME)
  
  cbind(tab1, tab2)
  
}

summary_ts_level <- function(data, name) {
  tab1 <- data %>% 
    purrr::set_names(c("ANO", "LEVEL")) %>% 
    dplyr::mutate(HEADER = mandato(ANO)) %>% 
    dplyr::mutate(RELATIVE_CHANGE = LEVEL / lag(LEVEL)) %>% 
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    tidyr::drop_na() %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE")
  
  tab2 <- data %>% 
    purrr::set_names(c("ANO", "LEVEL")) %>% 
    dplyr::mutate(HEADER = "2003-2018") %>% 
    dplyr::mutate(RELATIVE_CHANGE = LEVEL / lag(LEVEL)) %>% 
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    tidyr::drop_na() %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE") %>% 
    dplyr::select(-NAME)
  
  cbind(tab1, tab2)
}