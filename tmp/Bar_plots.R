#Let's try this again
#protein <- str_replace(pdb_entries_clean$'MOLECULE TYPE', "prot", "PROTEIN")
 #          pdb_entries_clean$'MOLECULE TYPE' <- protein
#nucleotide <- str_replace(pdb_entries_clean$'MOLECULE TYPE', "nuc", "NUCLEOTIDE")
 #             pdb_entries_clean$'MOLECULE TYPE' <- nucleotide

#Plot 1 - Entity type bar plot
molecule_bar <- pdb_entries_aug %>% 
                drop_na(`MOLECULE TYPE`) %>% 
  filter(`MOLECULE TYPE` != "other") %>% 
  ggplot(mapping = aes(x = `MOLECULE TYPE`)) +
  geom_bar() + 
  theme_linedraw() +
  labs(title = "Distribution of Structures by Entity Type",
       x = "Entity Type",
       y = "")

molecule_bar + scale_co

#Plot2 - Distribution of structures based on entry year
accession_year_bar <- pdb_entries_aug %>% 
                      drop_na(YEAR) %>%  
  ggplot(mapping = aes(x = YEAR)) +
  geom_bar() +
  theme_linedraw() + 
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  labs(title = "Distribution of Structures by Year of Entry into PDB",
       x = "",
       y = "Accession year")

accession_year_bar  

#Plot3 - Distribution of structures based on Experiment Type
experiment_bar <- pdb_entries_aug %>% 
  drop_na('EXPERIMENT TYPE (IF NOT X-RAY)') %>%  
  ggplot(mapping = aes(y = 'EXPERIMENT TYPE (IF NOT X-RAY)')) +
  geom_bar() +
  theme_linedraw() + 
  labs(title = "Distribution of Structures based on Experiment type",
       x = "",
       y = "Experiment type")

experiment_bar 


#Plot for source needs more cleaning 

source_bar <- pdb_entries_aug %>% 
              mutate(SOURCE = str_replace_all(SOURCE, "[:punct:]", ""), 
                     SOURCE = str_match(SOURCE, "[\\w]+")[,1]) %>% #str_replace('SOURCE', "; ", "") %>% 
              group_by(SOURCE) %>%
              drop_na() %>% 
              summarise(n = n()) %>% 
              top_n(10) %>% 
              mutate(REORDERED = reorder(SOURCE, desc(n))) %>%
ggplot(mapping = aes(x = REORDERED, y = n)) +
geom_bar(stat = "identity") +
theme_minimal() +
theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


source_bar

install.packages("wesanderson")
library(wesanderson)

pdb_entries_aug %>% 
isthisworking <- pdb_entries_aug %>% mutate(SOURCE = str_replace_all(SOURCE, "[:punct:]", ""), 
                                            SOURCE = str_match_all SOURCE, "[\w]", ""))
#pdb_entries_aug %>%  mutate(SOURCE = str_match(SOURCE,"[:;:]+")[, 1])
      # scop_reference = str_match(scop_reference, "[\\d]+")[, 1])

#try2 <- pdb_entries_aug %>% mutate(SOURCE = str_replace_all(SOURCE