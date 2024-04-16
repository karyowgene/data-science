# Check if packages are installed, and install them if not
if (!requireNamespace("adegenet", quietly = TRUE)) {
  install.packages("adegenet")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# Load required libraries
library(adegenet)
library(ggplot2)

# Set working directory
setwd("your/folder")

# Read SNP data from fasta file
snp <- fasta2genlight('input.fasta', snpOnly = TRUE)

# Read metadata
meta <- read.table('meta.txt', sep = ',', header = TRUE)

# Assign populations to individuals
snp$pop <- as.factor(meta[match(snp$ind.names, meta$Strain), ]$Samplingsites)

# Plot genetic distance
glPlot(snp)

# Perform PCA
pca <- glPca(snp, nf = 10)

# Plot eigenvalues
barplot(100 * pca$eig / sum(pca$eig), main = "Eigenvalues", col = heat.colors(length(pca$eig)))

# Plot PCA scatterplot
scatter(pca, psi = 'bottomright')

# Create dataset for PCA scores
pca.dataset <- as.data.frame(pca$scores)
pca.dataset$isolates <- rownames(pca.dataset)
pca.dataset$pop <- as.factor(meta[match(snp$ind.names, meta$Strain), ]$Samplingsites)
pca.dataset$spp <- as.factor(meta[match(snp$ind.names, meta$Strain), ]$Species)

# Plot PCA using ggplot2
ggplot(pca.dataset, aes(PC1, PC2, fill = spp)) + geom_point(shape = 21, size = 3, alpha = 0.7)
ggplot(pca.dataset, aes(PC1, PC3, fill = spp)) + geom_point(shape = 21, size = 3, alpha = 0.7)