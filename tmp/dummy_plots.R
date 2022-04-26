
x <- c(2000, 2000, 1999, 1999, 1998, 2002, 2001)
y <- c(2.1, 2.0, 2.5, 2.4, 2.9, 2.0, 1.9)

dummy_data <- data.frame('ACCESSION DATE' = x, 
                         'RESOLUTION' = y)

plot1 <- dummy_data %>%
  ggplot(
    aes(x = RESOLUTION,
        y = factor(ACCESSION.DATE))
  ) +
  geom_boxplot()