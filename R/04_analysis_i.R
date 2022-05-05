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
  select(IDCODE, SUPERKINGDOM, `MOLECULE TYPE`, SCOP_NAME) %>% 
  replace_na(list(SUPERKINGDOM = "Unclassified"))

# Count number of entries per superkingdom
pdb_taxonomy <- taxonomy_df %>% 
  group_by(SUPERKINGDOM) %>% 
  add_tally(name = "n",
            sort = TRUE) %>% 
  distinct(SUPERKINGDOM, n)

# Count number of entries per superkingdom stratified by molecule type
pdb_taxa_mol <- taxonomy_df %>% 
  group_by(SUPERKINGDOM, `MOLECULE TYPE`) %>% 
  add_tally(name = "n") %>% 
  distinct(SUPERKINGDOM, `MOLECULE TYPE`, n) %>% 
  filter(`MOLECULE TYPE` != "other") %>% 
  drop_na(`MOLECULE TYPE`) %>% 
  arrange(SUPERKINGDOM)

# Count number of entries per superkingdom stratified by SCOP class
pdb_taxa_scop <- taxonomy_df %>% 
  group_by(SUPERKINGDOM, SCOP_NAME) %>% 
  add_tally(name = "n") %>% 
  distinct(SUPERKINGDOM, SCOP_NAME, n) %>% 
  drop_na(SCOP_NAME) %>% 
  arrange(SUPERKINGDOM)


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

# Store scop class levels to use in plots
scop_levels <- c("All alpha proteins",
                 "All beta proteins",
                 "Alpha and beta proteins (a/b)", 
                 "Alpha and beta proteins (a+b)",
                 "Small proteins")

# Plot PDB Data Distribution By Superkingdom
pdb_taxonomy %>% 
  ggplot(mapping = aes(x = factor(SUPERKINGDOM, 
                                  level = taxa_levels),
                       y = n,
                       fill = SUPERKINGDOM)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  scale_y_continuous(breaks = seq(0,140000,10000)) +
  scale_fill_brewer(palette = "Set1",
                    breaks = taxa_levels) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "PDB Data Distribution By Superkingdom",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom")

ggsave(filename = "results/pdb_taxonomy.png",
       height = 3,
       width = 5)

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
  scale_fill_brewer(palette = "Set1",
                    name = "Molecule type",
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
       y = "Number of entries")

ggsave(filename = "results/pdb_taxa_mol.png",
       height = 5,
       width = 7)

# Plot SCOP Classification Distribution By Superkingdom
pdb_taxa_scop %>% 
  ggplot(mapping = aes(x = factor(SCOP_NAME,
                                  level = scop_levels),
                       y = n,
                       fill = SCOP_NAME)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  facet_wrap(~factor(SUPERKINGDOM,
                     levels = taxa_levels)) +
  ylim(0, 6000) +
  scale_x_discrete(labels = c("All alpha proteins" = "all-α",
                              "All beta proteins" = "all-β",
                              "Alpha and beta proteins (a/b)" = "α/β", 
                              "Alpha and beta proteins (a+b)" = "α+β",
                              "Small proteins" = "small")) +
  scale_fill_brewer(palette = "Set1",
                    name = "SCOP Classification",
                    breaks = scop_levels,
                    labels = c("all-α",
                               "all-β",
                               "α/β",
                               "α+β",
                               "small")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  labs(title = "SCOP Classification Distribution By Superkingdom",
       x = "",
       y = "Number of entries")

ggsave(filename = "results/pdb_taxa_scop.png",
       height = 5,
       width = 9)

# over the entire time
pdb_entries_aug %>%
  group_by(YEAR) %>%
  drop_na() %>%
  arrange(YEAR) %>%
  count() %>%
  ggplot(mapping = aes(x = YEAR, y = log(n))) +
  geom_point() +
  geom_smooth(mapping = aes(x = YEAR, 
                            y = log(n),
                            fill = 'Set1'), method=lm) +
  theme_minimal()

ggsave(filename = "results/entries_over_time.png")

# exponential phase
pdb_entries_aug %>%
  group_by(YEAR) %>%
  drop_na() %>%
  filter(YEAR > 1985) %>%
  filter(YEAR < 2005) %>%
  arrange(YEAR) %>%
  count() %>%
  ggplot(mapping = aes(x = YEAR, 
                       y = log(n),
                       fill = 'Set1')) +
  geom_point() +
  geom_smooth(mapping = aes(x = YEAR, y = log(n)), method=lm) +
  theme_minimal()

ggsave(filename = "results/entries_over_time_exp.png")

# arranging the bars does not work
pdb_entries_aug %>% 
  group_by(HEADER) %>% 
  drop_na() %>%
  filter(HEADER != 'STRUCTURAL GENOMICS, UNKNOWN FUNCTION') %>%
  summarise(n = n()) %>% 
  top_n(10) %>% 
  mutate(enzyme_class = reorder(HEADER, desc(n))) %>%
  ggplot(aes(x = enzyme_class, 
             y = n,
             fill = 'Set1'))  +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

ggsave(filename = "results/enzyme_classes.png")