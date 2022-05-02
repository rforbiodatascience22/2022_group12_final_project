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
  select(IDCODE, SUPERKINGDOM, `MOLECULE TYPE`) %>% 
  replace_na(list(SUPERKINGDOM = "Unclassified"))

# Count number of entries per superkingdom
pdb_taxonomy <- taxonomy_df %>% 
  group_by(SUPERKINGDOM) %>% 
  add_tally(name = "n",
            sort = TRUE) %>% 
  distinct(SUPERKINGDOM, n)
pdb_taxonomy

# Count number of entries per superkingdom stratified by molecule type
pdb_taxa_mol <- taxonomy_df %>% 
  group_by(SUPERKINGDOM, `MOLECULE TYPE`) %>% 
  add_tally(name = "n") %>% 
  distinct(SUPERKINGDOM, `MOLECULE TYPE`, n) %>% 
  filter(`MOLECULE TYPE` != "other") %>% 
  drop_na(`MOLECULE TYPE`) %>% 
  arrange(SUPERKINGDOM)
pdb_taxa_mol

# Model data
# my_data_clean_aug %>% ...


# Visualise data ----------------------------------------------------------

######################
### TAXONOMY PLOTS ###
######################

# Store superkingdom levels to use in plots
taxa_levels = c("Eukaryota", 
                "Bacteria", 
                "Viruses", 
                "Archaea", 
                "Unclassified")

# Store molecule type levels to use in plots
mol_levels = c("prot", 
               "prot-nuc", 
               "nuc")

# Plot PDB Data Distribution By Superkingdom
pdb_taxonomy %>% 
  ggplot(mapping = aes(x = factor(SUPERKINGDOM, 
                                  level = taxa_levels),
                       y = n,
                       fill = SUPERKINGDOM)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  scale_y_continuous(breaks = seq(0,120000,10000)) +
  scale_fill_discrete(breaks = taxa_levels) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "PDB Data Distribution By Superkingdom",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom")

ggsave(filename = "results/pdb_taxonomy.png",
       width = 5.5)

# Plot Molecule Type Distribution By Superkingdom
pdb_taxa_mol %>% 
  ggplot(mapping = aes(x = factor(`MOLECULE TYPE`,
                                  level = mol_levels),
                       y = n,
                       fill = `MOLECULE TYPE`)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  facet_wrap(~factor(SUPERKINGDOM,
                     levels = taxa_levels)) +
  ylim(0, 120000) +
  scale_x_discrete(labels = c("prot" = "protein",
                              "prot-nuc" = "protein-nucleic \nacid complex",
                              "nuc" = "nucleic acid")) +
  scale_fill_discrete(name = "Molecule type",
                      breaks = mol_levels,
                      labels = c("protein", 
                                 "protein-nucleic \nacid complex", 
                                 "nucleic acid")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  labs(title = "Molecule Type Distribution By Superkingdom",
       x = "",
       y = "Number of entries",
       fill = "Molecule type")

ggsave(filename = "results/pdb_taxa_mol.png",
       height = 5,
       width = 7)

# Write data --------------------------------------------------------------
#write_tsv(...)
#ggsave(...)