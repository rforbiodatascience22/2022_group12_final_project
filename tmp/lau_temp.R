pdb_entries_aug %>% 
  #select(IDCODE,RESOLUTION) %>% 
  #drop_na() %>% 
  filter(RESOLUTION<2) %>% 
  count()
  group_by(`EXPERIMENT TYPE`) %>% 
  count()

# SCOP wrangling
scop_df <- pdb_entries_aug %>% 
  filter(`MOLECULE TYPE` != "nuc") %>% 
  select(IDCODE, `MOLECULE TYPE`, SCOP_NAME) %>% 
  drop_na(SCOP_NAME) %>% 
  group_by(SCOP_NAME) %>% 
  count()
  
#SCOP plot
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
ggsave(filename = "results/scop-class_plot.png")


#------------

# SCOP wrangling version 2
scop_df <- pdb_entries_aug %>% 
  filter(`MOLECULE TYPE` != "nuc") %>% 
  select(IDCODE, `MOLECULE TYPE`, SCOP_NAME, RESOL_TYPE) %>% 
  drop_na(SCOP_NAME) %>% 
  group_by(SCOP_NAME, RESOL_TYPE) %>% 
  replace_na(list(RESOL_TYPE = "Not available")) %>% 
  count()

#SCOP plot version 2: with resolution type
scop_df %>% 
  ggplot(mapping = aes(x = fct_reorder(SCOP_NAME,
                                       desc(n),
                                       max),
                       y = n,
                       group = SCOP_NAME,
                       fill = RESOL_TYPE)) +
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
#ggsave(filename = "results/pdb_scop2.png")
<<<<<<< HEAD

# RESOLUTION PLOTS ---------------------------------

#Wrangle before resolution boxplot
exp_type <- pdb_entries_aug %>% 
  select(IDCODE, `EXPERIMENT TYPE`, RESOLUTION) %>% 
  group_by(`EXPERIMENT TYPE`) %>% 
  drop_na(`EXPERIMENT TYPE`, RESOLUTION) %>% 
  add_tally() %>% 
  arrange(n) %>% 
  slice(1:3)

#Boxplot
exp_type %>% 
  ggplot(mapping = aes(x = `EXPERIMENT TYPE`,
                       y = RESOLUTION)) +
  geom_boxplot()


# duplicates
pdb_entries_aug %>% 
  select(IDCODE) %>% 
  distinct() %>% 
  count()

# -- SCATTER PLOT ---

#Wrangle before resolution scatter plot
exp_type2 <- pdb_entries_aug %>% 
  select(IDCODE, `EXPERIMENT TYPE`, RESOLUTION, YEAR) %>% 
  drop_na(`EXPERIMENT TYPE`, RESOLUTION) 
=======
>>>>>>> 4ca1438a185669ad5ba216d3cde8c79f7ad3ac8b

