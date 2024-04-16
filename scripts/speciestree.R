# Set working directory
setwd('/your/directory/path')

# Check if packages are installed, and install them if not
if (!requireNamespace("ape", quietly = TRUE)) {
  install.packages("ape")
}
if (!requireNamespace("V.PhyloMaker", quietly = TRUE)) {
  install.packages("V.PhyloMaker")
}

# Load required libraries
library(ape)
library(V.PhyloMaker)

# Load data species list data into R
splist <- read.csv(file = "splist.csv", header = TRUE, sep = ",")

# Source of codes online
# https://rfunctions.blogspot.com/2012/07/standardized-effect-size-nearest.html

# Generate a tree
tree <- phylo.maker(splist)

# Write tree to file
write.tree(tree$scenario.3, "tree.tre")

# Load tree.tre in https://itol.embl.de/ and export pdf or svg
# To get a tree like the one in the paper, display the tree.tre in MEGAX software
# and export the traditional > straight version of the tree in either pdf or svg

# Load the tree pdf or svg in Inkscape and align with the bar graphs of the traits