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

# Plot SCOP Classification Distribution By Superkingdom - Bar
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
                            y = log(n)), method=lm) +
  theme_linedraw()  +
  labs(title = "Number of entries to the RCSB over time",
       x = "Year",
       y = "Number of entries")

ggsave(filename = "results/entries_over_time.png",
       width = 8,
       height = 5) 

# exponential phase
pdb_entries_aug %>%
  group_by(YEAR) %>%
  drop_na() %>%
  filter(YEAR > 1985) %>%
  filter(YEAR < 2005) %>%
  arrange(YEAR) %>%
  count() %>%
  ggplot(mapping = aes(x = YEAR, 
                       y = log(n))) +
  geom_point() +
  geom_smooth(mapping = aes(x = YEAR, y = log(n)), method=lm) +
  theme_linedraw() +
  labs(title = "Exponential growth phase of entries added to RCSB",
       x = "Year",
       y = "Number of entries")

ggsave(filename = "results/entries_over_time_exp.png",
       width = 8,
       height = 5) 

# Bar plot of most common enzyme classes in the RCSB
pdb_entries_aug %>% 
  group_by(HEADER) %>% 
  drop_na() %>%
  filter(HEADER != 'STRUCTURAL GENOMICS, UNKNOWN FUNCTION') %>%
  summarise(n = n()) %>% 
  top_n(9) %>% 
  mutate(enzyme_class = reorder(HEADER, desc(n))) %>%
  ggplot(aes(x = enzyme_class, 
             y = n,
             fill = enzyme_class))  +
  geom_bar(stat = "identity") +
  theme_linedraw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Most common enzyme classes in the RCSB",
       x = "Enzyme class",
       y = "Number of entries",
       fill = "Enzyme class")

ggsave(filename = "results/enzyme_classes.png",
       width = 6,
       height = 6) 

#Plot 1 - Entity type bar plot
pdb_entries_aug %>%
  filter(`MOLECULE TYPE` != "other") %>%
  group_by(`MOLECULE TYPE`)  %>% 
  drop_na(`MOLECULE TYPE`) %>%
  count() %>% 
  ggplot(mapping = aes(x = `MOLECULE TYPE`, y = n, fill = `MOLECULE TYPE`)) +
  geom_col() + 
  geom_label(aes(label = n), 
             show.legend = FALSE) +
  scale_x_discrete(limits = c("prot", "prot-nuc", "nuc"), 
                   labels = c("prot", "prot-nuc", "nuc")) + 
  theme_linedraw() +
  scale_fill_brewer(name = "Molecule Type",
                    breaks = mol_levels,
                    labels = c("Protein", 
                               "Protein-Nucleic Acid", 
                               "Nucleic Acid"), 
                    palette = "Set1") +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  labs(title = "Distribution of Structures by Molecule Type",
       x = "Molecule Type",
       y = "Number of entries")

ggsave(filename = "results/entity_type_plot.png",
       width = 6,
       height = 4)


#Plot2 - Distribution of structures based on entry year
pdb_entries_aug %>% 
  group_by(YEAR) %>% 
  drop_na(YEAR) %>% 
  count() %>% 
  ggplot(mapping = aes(x = YEAR, y = n, fill = YEAR)) +
  geom_col() +
  theme_linedraw() + 
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  labs(title = "Distribution of Structures by Year of Entry into PDB",
       x = "Year of entry",
       y = "Number of entries")

ggsave(filename = "results/entries_per_year.png",
       width = 7,
       height = 4)


#Plot3 - Distribution of structures based on Experiment Type
pdb_entries_aug %>% 
  group_by(`EXPERIMENT TYPE`) %>% 
  drop_na(`EXPERIMENT TYPE`) %>%  
  summarise(n = n()) %>% 
  top_n(3) %>% 
  mutate(REORDERED = reorder(`EXPERIMENT TYPE`, desc(n))) %>%
  ggplot(mapping = aes(x = REORDERED, y = n, fill = `EXPERIMENT TYPE`)) +
  geom_bar(stat = "identity") +
  geom_label(aes(label = n), 
             show.legend = FALSE) +
  theme_linedraw() + 
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Distribution of Structures based on Experiment type",
       x = "Experiment type",
       y = "Number of entries")

ggsave(filename = "results/experiment_type.png",
       width = 6,
       height = 4)

#Plot4 - Distribution of entries based on source organism
pdb_entries_aug %>% 
  mutate(SOURCE = str_replace_all(SOURCE, "\\;[\\w\\s]+", ""),  
         SOURCE = str_match(SOURCE, "^[\\w\\s]+")[,1]) %>%  
  group_by(SOURCE) %>%
  drop_na() %>% 
  summarise(n = n()) %>% 
  top_n(9) %>% 
  mutate(REORDERED = reorder(SOURCE, desc(n))) %>%
  ggplot(mapping = aes(x = REORDERED, y = n, fill = REORDERED)) +
  geom_bar(stat = "identity") +
  geom_label(aes(label = n), 
             show.legend = FALSE) +
  theme_linedraw() +
  scale_fill_brewer(name = "Source Organism",
                    palette = "Set1") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Distribution of Structures based on Source Organism",
       x = "Source Organism",
       y = "Number of entries") 

ggsave(filename = "results/source.png",
       width = 8,
       height = 5)

######################
###### SCOP PLOT #####
######################

scop_df <- pdb_entries_aug %>% 
  filter(`MOLECULE TYPE` != "nuc") %>% 
  select(IDCODE, `MOLECULE TYPE`, SCOP_NAME) %>% 
  drop_na(SCOP_NAME) %>% 
  group_by(SCOP_NAME) %>% 
  count()

scop_df %>% 
  ggplot(mapping = aes(x = fct_reorder(SCOP_NAME,
                                       desc(n),
                                       max),
                       y = n,
                       fill = SCOP_NAME)) +
  geom_col() +
  #geom_label(aes(label = n),
  #           show.legend = FALSE) +
  scale_x_discrete(labels = c("Alpha and beta proteins (a+b)" = "α+β",
                              "Alpha and beta proteins (a/b)" = "α/β",
                              "All beta proteins" = "all-β", 
                              "All alpha proteins" = "all-α",
                              "Small proteins" = "small")) +
  scale_fill_brewer(palette = "Set1",
                    breaks = c("Alpha and beta proteins (a+b)",
                               "Alpha and beta proteins (a/b)",
                               "All beta proteins", 
                               "All alpha proteins",
                               "Small proteins")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "Distribution of SCOP classes in PDB entries",
       x = "SCOP class",
       y = "Number of entries",
       fill = "SCOP class")

ggsave(filename = "results/scop-class_plot.png",
       height = 3,
       width = 6)

# Boxplot resolution by experiment type
pdb_entries_aug %>% 
  select(IDCODE, RESOLUTION, `EXPERIMENT TYPE`) %>% 
  filter(RESOLUTION < 5) %>% 
  drop_na(`EXPERIMENT TYPE`) %>% 
  ggplot(mapping = aes(x = `EXPERIMENT TYPE`,
                       y = RESOLUTION,
                       fill = `EXPERIMENT TYPE`)) +
  geom_boxplot(alpha = 0.6) +
  scale_fill_brewer(palette = "Set1") +
  theme_linedraw() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        plot.title = element_text(hjust = 0.5)) +
  labs(x = "Experiment type",
       y = "Resolution (Å)",
       title = "Resolution stratified by Experiment Type*",
       caption = "*Nine most common",
       fill = "Experiment Type")

ggsave(file = "results/resolution_boxplot.png",
       width = 10,
       height = 5)
