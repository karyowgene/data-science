# Set working directory
setwd('your/folder')

# Check if packages are installed, and install them if not
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}
if (!requireNamespace("corrplot", quietly = TRUE)) {
  install.packages("corrplot")
}
if (!requireNamespace("psych", quietly = TRUE)) {
  install.packages("psych")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# Load required libraries
library(readxl)
library(corrplot)
library(psych)
library(ggplot2)

# Read metadata from Excel file
metadata_with_samples_of_interest <- read_excel("metadata_with_samples_of_interest.xlsx")

# Convert metadata to matrix
m <- as.matrix(metadata_with_samples_of_interest[, -1])

# Define vertical and horizontal axis indices
vertical_axis <- 1:6
horizontal_axis <- 7:33

# Compute correlations
cts <- corr.test(m[, vertical_axis], m[, horizontal_axis])

# Save correlation plot to a PDF file
pdf("correlations.pdf")
corrplot(cts$r,
         method = "color",
         p.mat = cts$p,
         insig = "label_sig",
         sig.level = c(0.001, 0.01, 0.05),
         pch.cex = 1,
         pch.col = "black",
         tl.col = "black")
dev.off()

# Save heart rate vs. SOCS2 plot to a PDF file
pdf("heartrate-socs2.pdf")
p <- ggplot(metadata_with_samples_of_interest, aes(x = Heart_rate, y = SOCS2)) + 
  geom_point(shape = 19, size = 3) + 
  geom_smooth(method = "lm", se = TRUE) +
  theme(text = element_text(size = 20))  # Change the font size of all text elements in the plot
print(p)
dev.off()
