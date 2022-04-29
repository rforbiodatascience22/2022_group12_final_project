# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
pdb_entries_aug <- read_tsv(file = "data/03_dat_augment.tsv")


# Wrangle data ------------------------------------------------------------
#######################
## TAXONOMY ANALYSIS ##
#######################

# Select superkingdom and molecule type columns, then tidy
taxonomy_df <- pdb_entries_aug %>% 
  select(IDCODE, superkingdom, `MOLECULE TYPE`) %>% 
  replace_na(list(superkingdom = "Others"))

# Count number of entries per superkingdom
pdb_taxonomy <- taxonomy_df %>% 
  group_by(superkingdom) %>% 
  add_tally(name = "n",
            sort = TRUE) %>% 
  distinct(superkingdom, n)
pdb_taxonomy

# Count number of entries per superkingdom stratified by molecule type
pdb_taxa_mol <- taxonomy_df %>% 
  group_by(superkingdom, `MOLECULE TYPE`) %>% 
  add_tally(name = "n") %>% 
  distinct(superkingdom, `MOLECULE TYPE`, n) %>% 
  arrange(superkingdom)
pdb_taxa_mol


# Model data
# my_data_clean_aug %>% ...


# Visualise data ----------------------------------------------------------
# PDB Data Distribution By Superkingdom
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
  labs(title = "PDB Data Distribution By Superkingdom",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom")

pdb_taxa_mol %>% 
  ggplot(mapping = aes(x = factor(superkingdom,
                                  level = c("Eukaryota", "Bacteria", "Viruses", "Archaea", "Others")),
                       y = n,
                       fill = superkingdom,
                       alpha = `MOLECULE TYPE`)) +
  geom_col() +
  scale_y_continuous(breaks = seq(0,120000,10000)) +
  scale_fill_discrete(breaks = c("Eukaryota", "Bacteria", "Viruses", "Archaea", "Others")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "PDB Data Distribution By Superkingdom",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom",
       alpha = "Superkingdom")


# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)