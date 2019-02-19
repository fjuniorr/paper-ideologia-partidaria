# https://jessicabaker.co.uk/2018/09/10/comment-free-coding/amp/?__twitter_impression=true
# Longer variable names section

# refactoring

mandato <- function(x) {
  LEGISLATURA <- c(`2003` = "2003-2006", 
                 `2004` = "2003-2006",
                 `2005` = "2003-2006",
                 `2006` = "2003-2006",
                 `2007` = "2007-2010",
                 `2008` = "2007-2010",
                 `2009` = "2007-2010",
                 `2010` = "2007-2010",
                 `2011` = "2011-2014",
                 `2012` = "2011-2014",
                 `2013` = "2011-2014",
                 `2014` = "2011-2014",
                 `2015` = "2015-2018",
                 `2016` = "2015-2018",
                 `2017` = "2015-2018",
                 `2018` = "2015-2018")
  
  LEGISLATURA[as.character(x)]
}

