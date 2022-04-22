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
entries_raw <- read_tsv(file = "data/_raw/entries.idx", skip = 2, col_names = FALSE)
pdb_entry_type_raw <- read_tsv(file = "data/_raw/pdb_entry_type.txt")


# Wrangle data ------------------------------------------------------------
colnames(entries_raw) <- read.table(file = 'data/_raw/entries.idx',header = F,nrows = 1, sep = ',')[1,]



# Write data --------------------------------------------------------------
write_tsv(x = entries_raw,
          file = "data/01_entries.tsv")
write_tsv(x = pdb_entry_type_raw,
          file = "data/01_pdb_entry_type.tsv")
