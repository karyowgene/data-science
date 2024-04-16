import csv

input_csv = "pop0.csv"
output_phylip = "pop0.phy"

# Read CSV and extract taxon names and distance values
with open(input_csv, "r") as csv_file:
    reader = csv.reader(csv_file)
    taxa = next(reader)[1:]
    distances = []
    for row in reader:
        distances.append(row[1:])

# Write PHYLIP format
with open(output_phylip, "w") as phylip_file:
    phylip_file.write(f"{len(taxa)}\n")
    for i, taxon in enumerate(taxa):
        phylip_file.write(f"{taxon:<10}{' '.join(distances[i])}\n")