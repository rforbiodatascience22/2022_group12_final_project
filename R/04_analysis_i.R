# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries_aug <- read_tsv(file = "data/03_dat_augment.tsv")


# Wrangle data ------------------------------------------------------------
## TAXONOMY ANALYSIS ##
pdb_taxonomy <- pdb_entries_aug %>% 
  select(IDCODE, superkingdom, `MOLECULE TYPE`) %>% 
  group_by(superkingdom) %>% 
  count()
pdb_taxonomy


# Model data
# my_data_clean_aug %>% ...


# Visualise data ----------------------------------------------------------
pdb_taxonomy %>% 
  ggplot(mapping = aes(x = fct_reorder(superkingdom, 
                                       desc(n)),
                       y = n,
                       fill = superkingdom)) +
  geom_col()


# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)