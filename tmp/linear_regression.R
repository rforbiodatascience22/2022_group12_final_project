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

# boom phase
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