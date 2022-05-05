#Plot 1 - Entity type bar plot
entity_type_plot <- pdb_entries_aug %>%
                filter(`MOLECULE TYPE` != "other") %>%
                group_by(`MOLECULE TYPE`)  %>% 
                drop_na(`MOLECULE TYPE`) %>%
                count() %>% 
  ggplot(mapping = aes(x = `MOLECULE TYPE`, y = n, fill = `MOLECULE TYPE`)) +
  geom_col() + 
  geom_label(aes(label = n), 
             show.legend = FALSE) +
  scale_x_discrete(limits = c("prot", "prot-nuc", "nuc"), 
                   labels = c("prot" = "Protein", 
                              "prot-nuc" = "Protein-Nucleotide",
                              "nuc" = "Nucleotide")) + 
  theme_linedraw() +
  scale_fill_brewer(labels = c("Nucleotide", 
                               "Protein", 
                               "Protein-Nucleotide"), 
                                palette = "Set1") +
  labs(title = "Distribution of Structures by Entity Type",
       x = "Entity Type",
       y = "Number of entries")

entity_type_plot




#Plot2 - Distribution of structures based on entry year
accession_year_plot <- pdb_entries_aug %>% 
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

accession_year_plot 



#Plot3 - Distribution of structures based on Experiment Type
experiment_type_plot <- pdb_entries_aug %>% 
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
  #theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer (palette = "Set1") +
  labs(title = "Distribution of Structures based on Experiment type",
       x = "Experiment type",
       y = "Number of entries")

experiment_type_plot


#Plot4 - Distribution of entries based on source organism 

source_bar <- pdb_entries_aug %>% 
              mutate(SOURCE = str_replace_all(SOURCE, "[:punct:]", ""),  
                     SOURCE = str_match(SOURCE, "^[\\w]+")[,1]) %>% 
              group_by(SOURCE) %>%
              drop_na() %>% 
              summarise(n = n()) %>% 
              top_n(5) %>% 
              mutate(REORDERED = reorder(SOURCE, desc(n))) %>%
    ggplot(mapping = aes(x = REORDERED, y = n, fill = REORDERED)) +
    geom_bar(stat = "identity") +
    geom_label(aes(label = n), 
             show.legend = FALSE) +
    theme_linedraw() +
    scale_x_discrete(labels = c("HOMO" = "HOMO SAPIENS",
                                "ESCHERICHIA" = "ESCHERICHIA COLI",
                                "MUS" = "MUS MUSCULUS",
                                "")) +
    scale_fill_brewer(palette = "Set1") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = "Distribution of Structures based on Source Organism",
       x = "Source Organism",
       y = "Number of entries", 
       color = "Source Organism") 
    

source_bar
