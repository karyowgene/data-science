# Set working directory
setwd('/your/directory/path')

# Check if packages are installed, and install them if not
if (!requireNamespace("picante", quietly = TRUE)) {
  install.packages("picante")
}
if (!requireNamespace("ade4", quietly = TRUE)) {
  install.packages("ade4")
}
if (!requireNamespace("ape", quietly = TRUE)) {
  install.packages("ape")
}
if (!requireNamespace("V.PhyloMaker", quietly = TRUE)) {
  install.packages("V.PhyloMaker")
}
if (!requireNamespace("PhyloMeasures", quietly = TRUE)) {
  install.packages("PhyloMeasures")
}

# Load required libraries
library(picante)
library(ade4)
library(ape)
library(V.PhyloMaker)
library(PhyloMeasures)

# Load data species list data into R
splist100 <- read.csv(file = "splist100.csv", header = TRUE, sep = ",")
splistpdall <- read.csv(file = "splistpdall.csv", header = TRUE, sep = ",")
splistall <- read.csv(file = "splistall.csv", header = TRUE, sep = ",")
splistwoody <- read.csv(file = "splistwoody.csv", header = TRUE, sep = ",")
splistherbs <- read.csv(file = "splistherbs.csv", header = TRUE, sep = ",")

# Source of codes online
# https://rfunctions.blogspot.com/2012/07/standardized-effect-size-nearest.html

# Generate trees
tree100 <- phylo.maker(splist100)
treepdall <- phylo.maker(splistpdall)
treeall <- phylo.maker(splistall)
treewoody <- phylo.maker(splistwoody)
treeherbs <- phylo.maker(splistherbs)

# Write trees to file
write.tree(tree100$scenario.3, "tree100.tre")
write.tree(treepdall$scenario.3, "treepdall.tre")
write.tree(treeall$scenario.3, "treeall.tre")
write.tree(treewoody$scenario.3, "treewoody.tre")
write.tree(treeherbs$scenario.3, "treeherbs.tre")

# Load tree in figtree and export nexus
# Read the nexus file into R
tree100 <- read.nexus("itoltree100nex.txt")
treepdall <- read.nexus("itoltreepdallnex.txt")
treeall <- read.nexus("figtree.nex")
treeall <- read.nexus("treeallnex")
treewoody <- read.nexus("treewoodynex")
treeherbs <- read.nexus("treeherbsnex")

# Convert the nexus file into phylo
tree100.p <- as.phylo(tree100)
treepdall.p <- as.phylo(treepdall)
treeall.p <- as.phylo(treeall)
treewoody.p <- as.phylo(treewoody)
treeherbs.p <- as.phylo(treeherbs)

# Prep community file such as species are first row and comm are first column ##transpose
# Load communtiy matrix as a table into R
comp100 <- read.table("community100.txt", head = TRUE, sep = "\t")
comp101 <- read.table("comm100mzonesG.txt", head = TRUE, sep = "\t")
commall <- read.table("commall.txt", head = TRUE, sep = "\t")
commwoody <- read.table("commwoody.txt", head = TRUE, sep = "\t")
commherbs <- read.table("commherbs.txt", head = TRUE, sep = "\t")
commzoneall <- read.table("commzoneall.txt", head = TRUE, sep = "\t")
commzoneherbs <- read.table("commzoneherbs.txt", head = TRUE, sep = "\t")
commzonewoody <- read.table("commzonewoody.txt", head = TRUE, sep = "\t")

# Format the columns of the communtiy dataframe
rownames(comp100) <- comp100[,1]
rownames(comp101) <- comp101[,1]
rownames(commall) <- commall[,1]
rownames(commwoody) <- commwoody[,1]
rownames(commherbs) <- commherbs[,1]
rownames(commzoneall) <- commzoneall[,1]
rownames(commzoneherbs) <- commzoneherbs[,1]
rownames(commzonewoody) <- commzonewoody[,1]

# Calculate NRI
nri <- ses.mpd(comp101[,-1], cophenetic(treepdall.p), null.model = "taxa.labels", runs = 10)
nriall <- ses.mpd(commall[,-1], cophenetic(treeall.p), null.model = "taxa.labels", runs = 999)
nriwoody <- ses.mpd(commwoody[,-1], cophenetic(treewoody.p), null.model = "taxa.labels", runs = 10)
nriwoody2 <- ses.mpd(commwoody2[,-1], cophenetic(treewoody.p), null.model = "taxa.labels", runs = 999)
nriherbs2 <- ses.mpd(commherbs2[,-1], cophenetic(treeherbs.p), null.model = "taxa.labels", runs = 999)
nriherbs <- ses.mpd(commherbs[,-1], cophenetic(treeherbs.p), null.model = "taxa.labels", runs = 10)
nrizoneall <- ses.mpd(commzoneall[,-1], cophenetic(treeall.p), null.model = "taxa.labels", runs = 999)
nrizoneherbs <- ses.mpd(commzoneherbs[,-1], cophenetic(treeherbs.p), null.model = "taxa.labels", runs = 999)
nrizonewoody <- ses.mpd(commzonewoody[,-1], cophenetic(treewoody.p), null.model = "taxa.labels", runs = 999)

# If error about samples and outofbound occurs, check and ensure names in the tree file
# and the community files are identical. If not,
# replace symbols in tree species names to match them with community species name list
# Better avoid complicated names, use names with nothing beyond the genus_species
tree100.p$tip.label <- gsub("-", ".", tree100.p$tip.label)

# Write NRI to file
write.csv(nri, "nri.csv")
write.csv(nriall, "nriall.csv")
write.csv(nriwoody, "nriwoody.csv")
write.csv(nriherbs, "nriherbs.csv")
write.csv(nrizoneall, "nrizoneall.csv")
write.csv(nrizoneherbs, "nrizonehers.csv")
write.csv(nrizonewoody, "nrizonewoody.csv")

# Calculate NTI
nti <- ses.mntd(comp101[,-1], cophenetic(treepdall.p), null.model = "taxa.labels", runs = 10)
ntiall <- ses.mntd(commall[,-1], cophenetic(treeall.p), null.model = "taxa.labels", runs = 999)
ntiwoody <- ses.mntd(commwoody[,-1], cophenetic(treewoody.p), null.model = "taxa.labels", runs = 999)
ntiwoody <- ses.mntd(commwoody[,-1], cophenetic(treewoody.p), null.model = "taxa.labels", runs = 10)
ntiherbs <- ses.mntd(commherbs[,-1], cophenetic(treeherbs.p), null.model = "taxa.labels", runs = 10)
ntizoneall <- ses.mntd(commzoneall[,-1], cophenetic(treeall.p), null.model = "taxa.labels", runs = 999)
ntizoneherbs <- ses.mntd(commzoneherbs[,-1], cophenetic(treeherbs.p), null.model = "taxa.labels", runs = 999)

# Write NTI
write.csv(nti, "nti.csv")
write.csv(ntiall, "ntiall.csv")
write.csv(ntiwoody, "ntiwoody.csv")
write.csv(ntiherbs, "ntiherbs.csv")
write.csv(ntizoneall, "ntizoneall.csv")
write.csv(ntizoneherbs, "ntizoneherbs.csv")
write.csv(ntizonewoody, "ntizonewoody.csv")

# Calculate the SES of PD (or FD)
ses.fdpd <- ses.pd(commall[,-1], treeall.p, null.model = "taxa.labels", runs = 10)
ses.fdpdall <- ses.pd(commall[,-1], treeall.p, null.model = "taxa.labels", runs = 999)
ses.fdpdwoody <- ses.pd(commwoody[,-1], treewoody.p, null.model = "taxa.labels", runs = 999)
ses.fdpdwoody <- ses.pd(commwoody[,-1], treewoody.p, null.model = "taxa.labels", runs = 10)
ses.fdpdherbs <- ses.pd(commherbs[,-1], treeherbs.p, null.model = "taxa.labels", runs = 10)
ses.fdpdzoneall <- ses.pd(commzoneall[,-1], treeall.p, null.model = "taxa.labels", runs = 999)
ses.fdpdzonehers <- ses.pd(commzoneherbs[,-1], treeherbs.p, null.model = "taxa.labels", runs = 999)
ses.fdpdzonewoody <- ses.pd(commzonewoody[,-1], treewoody.p, null.model = "taxa.labels", runs = 999)

# Write SES of PD
write.csv(ses.fdpd, "ses.fdpd.csv")
write.csv(ses.fdpdall, "ses.fdpdall.csv")
write.csv(ses.fdpdwoody, "ses.fdpdwoody.csv")
write.csv(ses.fdpdherbs, "ses.fdpdherbs.csv")
write.csv(ses.fdpdzoneall, "ses.fdpdzoneall.csv")
write.csv(ses.fdpdzonehers, "ses.fdpdzoneherbs.csv")

# Calculate PD

# Online source
# https://rdrr.io/rforge/picante/man/pd.html

# Calculate PD
pdwoody <- pd(commwoody[,-1], treewoody.p, include.root = TRUE)
pdherbs <- pd(commherbs[,-1], treeherbs.p, include.root = TRUE)
pdall <- pd(commall[,-1], treeall.p, include.root = TRUE)
pdzoneall <- pd(commzoneall[,-1], treeall.p, include.root = TRUE)
pdzonewoody <- pd(commzonewoody[,-1], treewoody.p, include.root = TRUE)
pdzoneherbs <- pd(commzoneherbs[,-1], treeherbs.p, include.root = TRUE)

# Write PD
write.csv(pdwoody, "pdwoody.csv")
write.csv(pdherbs, "pdherbs.csv")
write.csv(pdall, "pdall.csv")
write.csv(pdzoneall, "pdzoneall.csv")
write.csv(pdzonewoody, "pdzonewoody.csv")