
# setwd('C:/Users/abrow/Documents/Quercus_IUCN_samp_sims')
require(dplyr)
require(ggplot2)
require(sp)
require(rgdal)
require(ggspatial)

# PREPARE MAPS ---------------------------------------------------------------
# specify projection
proj_from <- "+proj=longlat +ellps=WGS84 +datum=WGS84"
proj_to <- "+proj=aea +lat_0=40 +lon_0=-96 +lat_1=20 +lat_2=60 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"

# read in North America shapefiles
na_shp <- readOGR("shapefiles/NA_States_Provinces_Albers.shp", "NA_States_Provinces_Albers")
na_shp <- sp::spTransform(na_shp, proj_to)
cont_shp <- subset(na_shp,
                   (NAME_0 %in% c("United States of America", "Mexico", "Canada")))
lake_shp <- readOGR("shapefiles/Great_Lakes.shp", "Great_Lakes")
lake_shp <- sp::spTransform(lake_shp, proj_to)


#### NORTH AMERICA -----------------------------------------------------------
ggplot() + 
  geom_path(data = cont_shp, aes(x = long, y = lat, group = group), 
            size = 0.5) +
  geom_polygon(data = lake_shp, aes(x = long, y = lat, group = group),
               size = 0.5, color = 'black', fill = 'white') +
  annotation_scale(location = "bl", text_cex = 2) +
  annotation_north_arrow(location = "bl",
                         pad_x = unit(0.8, "in"), pad_y = unit(0.4, "in")) +
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        line = element_blank(),
        legend.position = 'none')
ggsave('figs/NA_inset_map.png')


# OGLETHORPENSIS --------------------------------------------------------------
# read data
og <- read.csv('data/QUOG_occ.csv', stringsAsFactors = FALSE)

# project coordinates
colnames(og) <- c('species', 'x', 'y')
xy <- og[,c('x','y')]
spdf <- SpatialPoints(coords = xy, proj4string = CRS(proj_from))
spdf <- spTransform(spdf, CRSobj = CRS(proj_to))
dat <- as.data.frame(spdf)

# plot
xlim <- c(min(dat$x) - 200000, max(dat$x) + 200000)
ylim <- c(min(dat$y) - 250000, max(dat$y) + 100000)

ggplot() + 
  geom_path(data = cont_shp, aes(x = long, y = lat, group = group), 
            size = 0.5) +
  geom_polygon(data = lake_shp, aes(x = long, y = lat, group = group),
               size = 0.5, color = 'black', fill = 'white') +
  geom_point(data = dat, aes(x = x, y = y),
             size = 7, pch = 21, fill = 'blue', color = 'black', alpha = 0.5) +
  annotation_scale(location = 'br', text_cex = 3, 
                   height = unit(1, 'cm'), line_width = unit(1, 'cm')) +
  # annotation_north_arrow(location = "br",
  #                        pad_x = unit(0.8, "in"), pad_y = unit(0.4, "in")) +
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        line = element_blank()) +
  coord_fixed(xlim = xlim,
              ylim = ylim)

ggsave('Figures/quog_map.png')


# TOMENTELLA --------------------------------------------------------------
# read data
to <- read.csv('data/QUTO_occ.csv', stringsAsFactors = FALSE)

# project coordinates
colnames(to) <- c('species', 'x', 'y')
xy <- to[,c('x','y')]
spdf <- SpatialPoints(coords = xy, proj4string = CRS(proj_from))
spdf <- spTransform(spdf, CRSobj = CRS(proj_to))
dat <- as.data.frame(spdf)

# plot
xlim <- c(min(dat$x) - 200000, max(dat$x) + 650000)
ylim <- c(min(dat$y) - 150000, max(dat$y) + 150000)

ggplot() + 
  geom_path(data = cont_shp, aes(x = long, y = lat, group = group), 
            size = 0.5) +
  geom_polygon(data = lake_shp, aes(x = long, y = lat, group = group),
               size = 0.5, color = 'black', fill = 'white') +
  geom_point(data = dat, aes(x = x, y = y),
             size = 7, pch = 21, fill = 'blue', color = 'black', alpha = 0.5) +
  annotation_scale(location = 'bl', text_cex = 3, 
                   height = unit(1, 'cm'), line_width = unit(1, 'cm')) +
  # annotation_north_arrow(location = 'bl',
  #                        pad_x = unit(0.8, "in"), pad_y = unit(0.4, "in")) +
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        line = element_blank()) +
  coord_fixed(xlim = xlim,
              ylim = ylim)

ggsave('Figures/quto_map.png')


# ACERIFOLIA --------------------------------------------------------------
# read data
ac <- read.csv('data/QUAC_occ.csv', stringsAsFactors = FALSE)

# project coordinates
colnames(ac) <- c('species', 'x', 'y')
xy <- ac[,c('x','y')]
spdf <- SpatialPoints(coords = xy, proj4string = CRS(proj_from))
spdf <- spTransform(spdf, CRSobj = CRS(proj_to))
dat <- as.data.frame(spdf)

# plot
xlim <- c(min(dat$x) - 200000, max(dat$x) + 200000)
ylim <- c(min(dat$y) - 200000, max(dat$y) + 200000)

ggplot() + 
  geom_path(data = cont_shp, aes(x = long, y = lat, group = group), 
            size = 0.5) +
  geom_polygon(data = lake_shp, aes(x = long, y = lat, group = group),
               size = 0.5, color = 'black', fill = 'white') +
  geom_point(data = dat, aes(x = x, y = y),
             size = 7, pch = 21, fill = 'blue', color = 'black', alpha = 0.5) +
  annotation_scale(location = 'bl', text_cex = 3, 
                   height = unit(1, 'cm'), line_width = unit(1, 'cm')) +
  # annotation_north_arrow(location = "br",
  #                        pad_x = unit(0.8, "in"), pad_y = unit(0.4, "in")) +
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        line = element_blank()) +
  coord_fixed(xlim = xlim,
              ylim = ylim)
ggsave('Figures/quac_map.png')
