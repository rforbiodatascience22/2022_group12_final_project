pdb_taxonomy %>% 
  ggplot(mapping = aes(x = fct_reorder(SUPERKINGDOM,
                                       desc(n),
                                       max),
                       y = n,
                       fill = SUPERKINGDOM)) +
  geom_col() +
  geom_label(aes(label = n),
             show.legend = FALSE) +
  scale_y_continuous(breaks = seq(0,120000,10000)) +
  scale_fill_discrete(breaks = c("Eukaryota", 
                                 "Bacteria", 
                                 "Viruses", 
                                 "Archaea", 
                                 "Unclassified")) +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "PDB Data Distribution By Superkingdom",
       x = "Superkingdom",
       y = "Number of entries",
       fill = "Superkingdom")