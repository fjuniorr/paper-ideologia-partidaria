source(here::here("code/lib/", "mandato.R"))
source(here::here("code/lib/", "percent.R"))
source(here::here("code/lib", "gmean.R"))

summary_ts_mandato <- function(data, name = "Series", level = TRUE) {
    
  if(level) {
    summary_ts_level_mandato(data, name)
  } else {
    summary_ts_relative_change_mandato(data, name)
    }

}


summary_ts_relative_change_mandato <- function(data, name) {
  tab1 <- data %>% 
    purrr::set_names(c("ANO", "RELATIVE_CHANGE")) %>% 
    dplyr::mutate(RELATIVE_CHANGE = RELATIVE_CHANGE - 1) %>% 
    dplyr::select(ANO, RELATIVE_CHANGE) %>% 
    dplyr::filter(ANO %in% 2015:2018) %>% 
    dplyr::mutate(ANO = factor(ANO)) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ ANO, value.var = "RELATIVE_CHANGE")
  
  tab2 <- data %>% 
    purrr::set_names(c("ANO", "RELATIVE_CHANGE")) %>% 
    dplyr::filter(ANO %in% 2015:2018) %>% 
    dplyr::mutate(HEADER = "2015-2018") %>% 
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE") %>% 
    dplyr::select(-NAME)
  
  tab3 <- data %>% 
    purrr::set_names(c("ANO", "RELATIVE_CHANGE")) %>% 
    dplyr::mutate(HEADER = "2003-2018") %>% 
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE") %>% 
    dplyr::select(-NAME)
  
  cbind(tab1, tab2, tab3)
  
}

summary_ts_level_mandato <- function(data, name) {

  tab1 <- data %>% 
    purrr::set_names(c("ANO", "LEVEL")) %>% 
    dplyr::mutate(RELATIVE_CHANGE = LEVEL / lag(LEVEL) -1) %>% 
    dplyr::select(ANO, RELATIVE_CHANGE) %>% 
    dplyr::filter(ANO %in% 2015:2018) %>% 
    dplyr::mutate(ANO = factor(ANO)) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>%
    data.table::dcast(NAME ~ ANO, value.var = "RELATIVE_CHANGE")
      
  tab2 <- data %>% 
    purrr::set_names(c("ANO", "LEVEL")) %>%
    dplyr::mutate(RELATIVE_CHANGE = LEVEL / lag(LEVEL)) %>% 
    dplyr::filter(ANO %in% 2015:2018) %>% 
    dplyr::mutate(HEADER = "2015-2018") %>%   
    dplyr::select(HEADER, RELATIVE_CHANGE) %>% 
    dplyr::group_by(HEADER) %>% 
    dplyr::summarize(GROWTH_RATE = gmean(RELATIVE_CHANGE)-1) %>% 
    dplyr::mutate_if(is.numeric, percent) %>% 
    dplyr::mutate(NAME = name) %>% 
    data.table::dcast(NAME ~ HEADER, value.var = "GROWTH_RATE") %>% 
    dplyr::select(-NAME)
  
    tab3 <- data %>% 
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
    
  cbind(tab1, tab2, tab3)
}