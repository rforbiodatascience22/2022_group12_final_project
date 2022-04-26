resolution_histogram <- pdb_entries %>%
  filter(RESOLUTION < 5) %>%
  ggplot(
    mapping = aes(x = RESOLUTION)
  ) +
  geom_histogram(fill = `MOLECULE TYPE`) +
  theme_minimal()

resolution_histogram

resolution_by_taxa <- pdb_entries %>%
  filter(!grepl(';|,', 
               SOURCE)
         ) %>%
  ggplot(mapping = aes(x = (SOURCE),
                       y = RESOLUTION)
  ) +
  geom_boxplot(fill = as.factor(SOURCE)) +
  theme_minimal()

resolution_by_taxa

taxa_histogram <- pdb_entries %>%
  ggplot(
    mapping = aes(x = as.factor(SOURCE))
  ) +
  geom_histogram() +
  theme_minimal()

taxa_histogram