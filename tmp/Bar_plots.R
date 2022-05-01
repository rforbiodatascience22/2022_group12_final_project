#Running source org again
#ggplot(data = pdb_entries_aug, 
       #mapping = aes(x = 'ACCESSION DATE'))
       #geom_histogram()


accession_date_histogram <- pdb_entries %>%
  ggplot(
    mapping = aes(x = `ACCESSION DATE`)
  ) +
  geom_histogram() +
  theme_minimal()

accession_date_histogram



#Let's try this again
protein <- str_replace(pdb_entries_clean$'MOLECULE TYPE', "prot", "PROTEIN")
           pdb_entries_clean$'MOLECULE TYPE' <- protein
nucleotide <- str_replace(pdb_entries_clean$'MOLECULE TYPE', "nuc", "NUCLEOTIDE")
              pdb_entries_clean$'MOLECULE TYPE' <- nucleotide

molecule_bar <- pdb_entries_clean %>% drop_na('MOLECULE TYPE') %>% 
  ggplot(
  mapping = aes(x = `MOLECULE TYPE`)) +
  geom_bar() +
  theme_minimal()

molecule_bar  




#Plot for source needs more cleaning 

#pdb_entries_aug %>% str_remove_all("; ") 



#source_bar <- pdb_entries_aug %>% drop_na('SOURCE') %>% 
 # ggplot(
  
#mapping = aes(y = `SOURCE`)) +
 # geom_bar() +
  
#theme_minimal()

#source_bar