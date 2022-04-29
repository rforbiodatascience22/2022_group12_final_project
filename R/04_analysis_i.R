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
  count(sort = TRUE) %>% 
  replace_na(list(superkingdom = "Others"))
pdb_taxonomy


# Model data
# my_data_clean_aug %>% ...


# Visualise data ----------------------------------------------------------
pdb_taxonomy %>% 
  ggplot(mapping = aes(x = factor(superkingdom, 
                                  level = c("Eukaryota", "Bacteria", "Viruses", "Archaea", "Others")),
                       y = n,
                       fill = superkingdom)) +
  geom_col() +
  scale_y_continuous(breaks = seq(0,120000,10000)) +
  scale_fill_discrete(breaks = c("Eukaryota", "Bacteria", "Viruses", "Archaea", "Others")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "PDB Data Distribution By Taxonomy",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom")


# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)