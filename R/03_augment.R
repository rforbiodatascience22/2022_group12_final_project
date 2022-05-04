# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries_clean <- read_tsv(file = "data/02_dat_clean.tsv")


# Wrangle data ------------------------------------------------------------
#Change accession date to year
pdb_entries_aug <- pdb_entries_clean %>%
  mutate(YEAR = format(as.Date(`ACCESSION DATE`, '%m/%d/%y'), "%Y")) %>%
  select(-`ACCESSION DATE`)

#Create resolution type variable
pdb_entries_aug <- pdb_entries_aug %>% 
  mutate(RESOL_TYPE = case_when(RESOLUTION < 2 ~ "high",
                                RESOLUTION >= 2 ~ "low"))


# Write data --------------------------------------------------------------
write_tsv(x = pdb_entries_aug,
          file = "data/03_dat_augment.tsv")