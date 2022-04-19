# Define project functions ------------------------------------------------
wrangle_source <- function(source_raw){
  #' correctly splits up source data
  rows <- source_raw$X1
  IDCODE <- c()
  SOURCE <- c()
  for (i in 1:length(rows)) {
    IDCODE[i] <- substring(rows[i], 
                           first = 1, 
                           last = 4)
    SOURCE[i] <- substring(rows[i], 
                           first = 5) %>%
      str_replace_all("\t", "")
  }
  df <- data.frame(IDCODE = IDCODE,
                   SOURCE = SOURCE)
  return(df)
}

#...