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
  geom_label(aes(label = n),
             show.legend = FALSE) +
  scale_y_continuous(breaks = seq(0,120000,10000)) +
  scale_fill_discrete(breaks = c("Eukaryota", "Bacteria", "Viruses", "Archaea", "Others")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "PDB Data Distribution By Superkingdom",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom")
ggsave(filename = "results/pdb_taxonomy.png")

pdb_taxa_mol %>% 
  ggplot(mapping = aes(x = factor(`MOLECULE TYPE`,
                                  level = c("prot", "prot-nuc", "nuc")),
                       y = n,
                       fill = `MOLECULE TYPE`)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  facet_wrap(~superkingdom) +
  ylim(0, 120000) +
  scale_x_discrete(labels = c("prot" = "protein",
                              "prot-nuc" = "protein-nucleic \nacid complex",
                              "nuc" = "nucleic acid")) +
  scale_fill_discrete(name = "Molecule type",
                      breaks = c("prot", "prot-nuc", "nuc"),
                      labels = c("protein", "protein-nucleic \nacid complex", "nucleic acid")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  labs(title = "Molecule Type Distribution By Superkingdom",
       x = "",
       y = "Number of entries",
       fill = "Molecule type")
ggsave(filename = "results/pdb_taxa_mol.png",
       height = 5)

# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)