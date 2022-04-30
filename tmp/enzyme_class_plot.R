# arranging the bars does not work
pdb_entries_aug %>% 
  group_by(HEADER) %>% 
  drop_na() %>%
  filter(HEADER != 'STRUCTURAL GENOMICS, UNKNOWN FUNCTION') %>%
  summarise(n = n()) %>% 
  top_n(10) %>% 
  mutate(enzyme_class = reorder(HEADER, desc(n))) %>%
  ggplot(aes(x = enzyme_class, y = n))  +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))