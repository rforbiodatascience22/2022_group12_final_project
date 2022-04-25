# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries <- read_tsv(file = "data/01_dat_load.tsv",
                        na = c("NOT", "NA"))


# Wrangle data ------------------------------------------------------------
#1. merge experiment type columns in one that contains info of all entries (use mutate)
#2. homogenize NAs
#3. subset data that contains source
#4. create a column year/decade we can use to create "new entries per year per species" (line or density plot)


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean,
          file = "data/02_my_data_clean.tsv")