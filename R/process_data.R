library(tidyverse)
# Read the CSV files
dat <- read_csv("C:/Users/fcong/Desktop/Biostat R/Biostats 632/github_repo/hw2/hw2plot/data/contraceptive_use.csv")
est <- read_csv("C:/Users/fcong/Desktop/Biostat R/Biostats 632/github_repo/hw2/hw2plot/data/est.csv")

# Save them as .rda files in the data folder
save(dat, file = "data/dat.rda")
save(est, file = "data/est.rda")

