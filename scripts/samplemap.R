# Set working directory
setwd('/your/directory/path')

# Check if packages are installed, and install them if not
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("maps", quietly = TRUE)) {
  install.packages("maps")
}
if (!requireNamespace("ggsn", quietly = TRUE)) {
  install.packages("ggsn")
}

# Load required libraries
library(ggplot2)
library(maps)
library(ggsn)

# Load the world_map and sampling_data
world_map <- map_data("world")
sampling_data <- read.csv("sampling_data.csv")

# Find the minimum and maximum latitude and longitude in the sampling data
min_lat <- min(sampling_data$Latitude)
max_lat <- max(sampling_data$Latitude)
min_lon <- min(sampling_data$Longitude)
max_lon <- max(sampling_data$Longitude)

# Create the plot with adjusted axis limits
p <- ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgray", color = "gray") +
  geom_point(data = sampling_data, aes(x = Longitude, y = Latitude), color = "red", size = 3) +
  geom_text_repel(data = sampling_data, aes(x = Longitude, y = Latitude, label = popcode),
                  box.padding = 0.5, point.padding = 0.3, max.overlaps = Inf) +
  labs(x = "Longitude", y = "Latitude") +
  theme_minimal() +
  coord_cartesian(xlim = c(min_lon, max_lon), ylim = c(min_lat, max_lat))

# Add a scale bar using ggsn
p <- ggsn::scalebar(p, location = "bottomleft", dist = 0.1, st.dist = 0.1, dd2km = TRUE, model = "WGS84")

# Add a north arrow using ggsn
p <- ggsn::north(p, scale = 0.08, symbol = 15, y = max_lat - (max_lat - min_lat) * 0.05, 
                 x = max_lon - (max_lon - min_lon) * 0.05)

# Display the plot
print(p)