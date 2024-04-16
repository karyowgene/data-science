# Set working directory
setwd('/your/directory/path')

# Check if packages are installed, and install them if not
if (!requireNamespace("rgbif", quietly = TRUE)) {
  install.packages("rgbif")
}
if (!requireNamespace("usethis", quietly = TRUE)) {
  install.packages("usethis")
}

# Load required libraries
library(rgbif)
library(usethis)

# Edit .Renviron file
usethis::edit_r_environ()

# Now you should edit your .Renviron to include your GBIF credentials:
# GBIF_USER="username"
# GBIF_PWD="password"
# GBIF_EMAIL="email"

# Download one species
gbif_download <- occ_download(
  pred_in("taxonKey", 1427020), 
  format = "SIMPLE_CSV",
  hasGeospatialIssue = FALSE,
  hasCoordinate = TRUE
)

# Download multiple species using API
# Create request.json file
gbif_taxon_keys <- readr::read_csv("from590list.csv") %>% 
  pull("Taxon name") %>%
  taxize::get_gbifid_(method = "backbone") %>%
  imap(~ .x %>% mutate(original_sciname = .y)) %>%
  bind_rows() %>%
  filter(matchtype == "EXACT" & status == "ACCEPTED") %>%
  filter(kingdom == "Plantae") %>%
  pull(usagekey)

# Prepare JSON request string
json_request <- paste(
  '{
    "creator": "', "username", '",
    "notification_address": [
      "', "email", '"
    ],
    "sendNotification": true,
    "format": "SIMPLE_CSV",
    "predicate": {
      "type": "and",
      "predicates": [
        {
          "type": "in",
          "key": "COUNTRY",
          "values": ["CTRY1", "CTRY2"]
        },
        {
          "type": "in",
          "key": "gbif_taxon_keys",
          "values": [', paste(gbif_taxon_keys, collapse = ","), ']
        }
      ]
    }
  }',
  collapse = ""
)

writeLines(json_request, file("request.json"))

# Filter conditions and download for short list
occ_download(
  pred_in("taxonKey", gbif_taxon_keys),
  pred_in("basisOfRecord", c('PRESERVED_SPECIMEN', 'HUMAN_OBSERVATION', 'OBSERVATION', 'MACHINE_OBSERVATION')),
  pred("country", "Country1"),
  pred("country", "Country2"),
  pred("hasGeospatialIssue", FALSE),
  format = "SIMPLE_CSV"
)

# Use API for downloading
url <- "http://api.gbif.org/v1/occurrence/download/request"
library(httr)

POST(url = url, 
     config = authenticate("username", "password"), 
     add_headers("Content-Type: application/json"),
     body = upload_file("request.json"), 
     encode = 'json') %>% 
  content(as = "text")