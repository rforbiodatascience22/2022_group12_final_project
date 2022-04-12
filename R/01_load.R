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
source_raw <- read_tsv(file = "data/_raw/source.idx")



# Wrangle data ------------------------------------------------------------
# TODO:
# - 
# Loading column names into vector
entries_header <- read.table(file = 'data/_raw/entries.idx',header = F,nrows = 1, sep = ',')[1,]
colnames(entries_raw) <- entries_header
my_data <- my_data_raw # %>% ...


# Write data --------------------------------------------------------------
write_tsv(x = my_data,
          file = "data/01_my_data.tsv")
