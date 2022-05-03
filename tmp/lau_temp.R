# SCOP wrangling before plot
scop_plot <- pdb_entries_aug %>% 
  filter(`MOLECULE TYPE` != "nuc") %>% 
  select(IDCODE, `MOLECULE TYPE`, SCOP_NAME) %>% 
  drop_na(SCOP_NAME) %>% 
  group_by(SCOP_NAME) %>% 
  count() %>% 
  ggplot(mapping = aes(x = fct_reorder(SCOP_NAME,
                                       desc(n),
                                       max),
                       y = n,
                       fill = SCOP_NAME)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  scale_x_discrete(labels = c("All alpha proteins" = "all-α",
                              "All beta proteins" = "all-β",
                              "Alpha and beta proteins (a/b)" = "α/β", 
                              "Alpha and beta proteins (a+b)" = "α+β",
                              "Small proteins" = "small")) +
  scale_fill_brewer(palette = "Set1") +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "Distribution of SCOP classes in PDB entries",
       x = "SCOP class",
       y = "Number of entries",
       fill = "SCOP class")
#ggsave(filename = "results/pdb_scop.png")

scop_plot
