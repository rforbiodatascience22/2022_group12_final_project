# Load libraries ----------------------------------------------------------
library(tidyverse)
library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(ggplot2)


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
# Load entries.idx, skip first 2 lines
entries_tsv <- read_tsv(file = "data/_raw/entries.idx", 
                        skip = 2, 
                        col_names = FALSE)

# Load pdb_entry_type.txt and set col_names manually
pdb_entry_type_tsv <- read_tsv(file = "data/_raw/pdb_entry_type.txt", 
                               col_names = c("IDCODE", "MOLECULE TYPE", "EXPERIMENT TYPE"))


# Wrangle data ------------------------------------------------------------
# Set col_names of entries_tsv
colnames(entries_tsv) <- read.table(file = 'data/_raw/entries.idx',
                                    header = FALSE,
                                    nrows = 1, 
                                    sep = ',')[1,] %>% 
  str_remove(pattern = " ")

# Change letter of IDCODE to upper in pdb_entry_type_tsv
pdb_entry_type_tsv <- pdb_entry_type_tsv %>% 
  mutate(IDCODE = str_to_upper(IDCODE))

# Join the 2 tables by IDCODE
pdb_entries <- entries_tsv %>% 
  full_join(pdb_entry_type_tsv,
            by = "IDCODE")

# Write data --------------------------------------------------------------
write_tsv(x = pdb_entries,
          file = "data/01_dat_load.tsv")
