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
                               col_names = c("IDCODE", 
                                             "MOLECULE TYPE", 
                                             "EXPERIMENT TYPE"))

# Load pdb.accession2taxid
taxid_pdb <- read_tsv(file = "data/_raw/pdb.accession2taxid")

# Load taxonomy.tsv
taxonomy_taxid <- read_delim(file = "data/_raw/rankedlineage.tsv.gz",
                           delim = "|")

# Load scop classification data
scop_pdb <- read_delim(file = "data/_raw/scop-cla.txt", 
                       col_names = FALSE,
                       delim = ' ',
                       skip = 6) %>%
  select(X2, X11)

# Load scop classes
scop_ref <- read_delim(file = "data/_raw/scop-description.txt",
                       delim = ' ',
                       skip = 1,
                       col_names = c("scop_reference", "scop_name"))

# Wrangle data ------------------------------------------------------------
# Set col_names of entries_tsv
colnames(entries_tsv) <- read.table(file = 'data/_raw/entries.idx', 
                                    header = FALSE,
                                    nrows = 1, 
                                    sep = ',')[1,] %>% 
  str_remove(pattern = " ")

# Set col_names of scop_pdb
colnames(scop_pdb) <- c("IDCODE", "scop_reference")

# Change letter of IDCODE to upper in pdb_entry_type_tsv
pdb_entry_type_tsv <- pdb_entry_type_tsv %>% 
  mutate(IDCODE = str_to_upper(IDCODE))

# Join entries_tsv and pdb_entry_type_tsv by IDCODE
pdb_entries <- entries_tsv %>% 
  full_join(pdb_entry_type_tsv,
            by = "IDCODE")

# Change pdb IDs (accession) in taxid_pdb to match pdb_entries
taxid_pdb <- taxid_pdb %>% 
  mutate(accession = str_replace(accession, "_.", "")) %>% 
  distinct(accession, taxid)

# Join taxid_pdb with previous data
pdb_entries <- pdb_entries %>% 
  inner_join(taxid_pdb,
             by = c("IDCODE" = "accession"))

# Change col_names of taxonomy_taxid
colnames(taxonomy_taxid) <- c("taxid", 
                              "tax_name", 
                              "species", 
                              "genus", 
                              "family", 
                              "order", 
                              "class", 
                              "phylum", 
                              "kingdom", 
                              "superkingdom",
                              "NA")

# Select the taxid and superkingdom columns from taxonomy_taxid
taxonomy_taxid <- taxonomy_taxid %>% 
  distinct(taxid, superkingdom) %>% 
  mutate(taxid = as.double(taxid))

# Join taxonomy_taxid with previous data
pdb_entries <- pdb_entries %>% 
  inner_join(taxonomy_taxid,
             by = "taxid")

# Join scop_pdb with previous data
pdb_entries <- pdb_entries %>% 
  full_join(scop_pdb,
            by = "IDCODE")

# Clean SCOP column of data frame in order to be able to join it with scop_ref
pdb_entries <- pdb_entries %>% 
  mutate(scop_reference = str_match(scop_reference,"CL=[\\d]+")[, 1],
         scop_reference = str_match(scop_reference, "[\\d]+")[, 1])

# Join pdb_entries with scop_ref
pdb_entries <- pdb_entries %>% 
  inner_join(scop_ref,
             by = "scop_reference")

# Write data --------------------------------------------------------------
write_tsv(x = pdb_entries,
          file = "data/01_dat_load.tsv")
