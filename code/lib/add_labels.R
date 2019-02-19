add_labels <- function(table, type = c("2003-2018", "2015-2018")) {
  type <- match.arg(type)
  
  if(type == "2003-2018") {
    names(table) <- c("Especificação",
                    "2003-2006\n(PSDB)",
                    "2007-2010\n(PSDB)",
                    "2011-2014\n(PSDB)",
                    "2015-2018\n(PT)",
                    "Média do Período\n(2003-2018)")  
  } else if(type == "2015-2018") {
    names(table) <- c("Especificação",
                      "2015",
                      "2016",
                      "2017",
                      "2018",
                      "Média do quadriênio\n(2015-2018)",
                      "Média do Período\n(2003-2018)")  
  }
  
  table
}