# arranging the bars does not work
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
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Most common enzyme classes in the RCSB",
       x = "Enzyme class",
       y = "Number of entries")

ggsave(filename = "results/enzyme_classes.png") 
  