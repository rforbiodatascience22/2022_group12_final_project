# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries_clean <- read_tsv(file = "data/02_dat_clean.tsv")

#Change accession date to year
pdb_entries_clean <- pdb_entries_clean %>%
  mutate(`ACCESSION DATE` = format(as.Date(`ACCESSION DATE`, '%m/%d/%y'), "%Y"))


# Wrangle data ------------------------------------------------------------
pdb_entries_aug <- pdb_entries_clean # %>% ...


# Write data --------------------------------------------------------------
write_tsv(x = pdb_entries_aug,
          file = "data/03_dat_augment.tsv")