#Clean scop column
temp <- pdb_entries_aug %>% 
  mutate(SCOP = str_match(SCOP,"CL=[\\d]+"),
         SCOP = str_match(SCOP, "[\\d]+")) 

# Count number of entries per scop-reference
pdb_taxonomy <- taxonomy_df %>% 
  group_by(superkingdom) %>% 
  add_tally(name = "n",
            sort = TRUE) %>% 
  distinct(superkingdom, n)
pdb_taxonomy

# Count number of entries per superkingdom
temp <- pdb_entries_aug %>% 
  select(`MOLECULE TYPE` = "prot") %>% 
  group_by(SCOP_NAME)

