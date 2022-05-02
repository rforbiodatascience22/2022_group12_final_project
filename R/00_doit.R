# Install packages --------------------------------------------------------
if (!"tidyverse" %in% installed.packages()) install.packages("tidyverse")
if (!"readr" %in% installed.packages()) install.packages("readr")
if (!"dplyr" %in% installed.packages()) install.packages("dplyr")
if (!"stringr" %in% installed.packages()) install.packages("stringr")
if (!"purrr" %in% installed.packages()) install.packages("purrr")
if (!"tidyr" %in% installed.packages()) install.packages("tidyr")
if (!"ggplot2" %in% installed.packages()) install.packages("ggplot2")
if (!"wesanderson" %in% installed.packages()) install.packages("wesanderson")

# Run all scripts ---------------------------------------------------------
source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")
source(file = "R/04_analysis_i.R")
