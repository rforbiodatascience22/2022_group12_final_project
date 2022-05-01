# over the entire time
pdb_entries_aug %>%
  group_by(`ACCESSION DATE`) %>%
  drop_na() %>%
  arrange(`ACCESSION DATE`) %>%
  count() %>%
  ggplot(mapping = aes(x = `ACCESSION DATE`, y = log(n))) +
  geom_point() +
  geom_smooth(mapping = aes(x = `ACCESSION DATE`, y = log(n)), method=lm) +
  theme_minimal()

# boom phase
pdb_entries_aug %>%
  group_by(`ACCESSION DATE`) %>%
  drop_na() %>%
  filter(`ACCESSION DATE` > 1985) %>%
  filter(`ACCESSION DATE` < 2005) %>%
  arrange(`ACCESSION DATE`) %>%
  count() %>%
  ggplot(mapping = aes(x = `ACCESSION DATE`, y = log(n))) +
  geom_point() +
  geom_smooth(mapping = aes(x = `ACCESSION DATE`, y = log(n)), method=lm) +
  theme_minimal()