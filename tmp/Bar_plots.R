#Let's try this again
protein <- str_replace(pdb_entries_clean$'MOLECULE TYPE', "prot", "PROTEIN")
           pdb_entries_clean$'MOLECULE TYPE' <- protein
nucleotide <- str_replace(pdb_entries_clean$'MOLECULE TYPE', "nuc", "NUCLEOTIDE")
              pdb_entries_clean$'MOLECULE TYPE' <- nucleotide

#Plot 1 - Entity type bar plot
molecule_bar <- pdb_entries_clean %>% 
                drop_na('MOLECULE TYPE') %>% 
  ggplot(mapping = aes(x = `MOLECULE TYPE`)) +
  geom_bar() +
  theme_linedraw() +
  labs(title = "Distribution of Structures by Entity Type",
       x = "Entity Type",
       y = "")

molecule_bar  

#Plot2 - Distribution of structures based on entry year
accession_year_bar <- pdb_entries_clean %>% 
                      drop_na('ACCESSION DATE') %>%  
  ggplot(mapping = aes(y = `ACCESSION DATE`)) +
  geom_bar() +
  theme_linedraw() +
  labs(title = "Distribution of Structures by Date of Entry into PDB",
       x = "",
       y = "Accession year")

accession_year_bar  




#Plot for source needs more cleaning 

#pdb_entries_aug %>% str_remove_all("; ") 



#source_bar <- pdb_entries_aug %>% drop_na('SOURCE') %>% 
 # ggplot(
  
#mapping = aes(y = `SOURCE`)) +
 # geom_bar() +
  
#theme_minimal()

#source_bar