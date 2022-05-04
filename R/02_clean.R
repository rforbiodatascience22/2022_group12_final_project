# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries <- read_tsv(file = "data/01_dat_load.tsv",
                        na = c("NOT", 
                               "NA"))


# Wrangle data --------------------------------------------------------------
# Remove unnecessary columns
pdb_entries_clean <- pdb_entries %>% 
  select(-c(`AUTHOR LIST`,
            `EXPERIMENT TYPE`,
            taxid,
            scop_reference)) %>% 
  rename(`EXPERIMENT TYPE` = 7)



# Write data --------------------------------------------------------------
write_tsv(x = pdb_entries_clean,
          file = "data/02_dat_clean.tsv")
            
