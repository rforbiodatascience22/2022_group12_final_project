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
pdb_entries <- read_tsv(file = "data/01_dat_load.tsv")


# Wrangle data ------------------------------------------------------------
#1. merge experiment type columns in one that contain info of all entries (use mutate)
#2. homogenize NAs (?)
#3. subset data that contains source 
#4. create a column year/decade we can use to create nice plot of "new entries per year per species (top 5)" <- line or density plot


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean,
          file = "data/02_my_data_clean.tsv")