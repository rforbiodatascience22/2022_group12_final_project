# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries_aug <- read_tsv(file = "data/03_dat_augment.tsv")


# Wrangle data ------------------------------------------------------------
my_data_clean_aug %>% ...


# Model data
my_data_clean_aug %>% ...


# Visualise data ----------------------------------------------------------
my_data_clean_aug %>% ...


# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)