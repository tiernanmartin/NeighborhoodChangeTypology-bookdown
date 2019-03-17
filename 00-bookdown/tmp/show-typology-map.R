#' @title SHow Typology Map
#' @description This is a temporary function.
#' @param model_all desc
#' @param kc_boundary desc
#' @return a leaflet map

#' @rdname show-typology-map
#' @export
show_typology_map <- function(){

  # loadd the objects

  drake::loadd(model_all, kc_boundary)

  # assign one of the model objects to model_df

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "COOREV18_SF_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)

  model_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[5])) %>%
    dplyr::mutate(COOREV18_SF_TYPE_FCT = factor(COOREV18_SF_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))

  wc_tr <- c("53033026600",
             "53033026700",
             "53033026500",
             "53033026801",
             "53033026802",
             "53033027000")

my_pal <- c(
  RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
  RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
  RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
)

my_pal_hex <- c("#f5eb12",
                "#fcc811",
                "#f89621",
                "#9e2382",
                "#0d94ce",
                "#1c6091")


pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$COOREV18_SF_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(model_ready$COOREV18_SF_TYPE_FCT))

model_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("labels", zIndex = 440) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
  leaflet::addPolygons(data = kc_boundary,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels"))
  # leaflet::addLegend(title = '',position = 'topright',pal = pal, values = ~COO16_TYPE_FCT, opacity = 1)

}

#' @rdname show-typology-map
#' @export
show_pdx18_sf_map <- function(){

  # loadd the objects

  drake::loadd(model_all, kc_boundary)

   # assign one of the model objects to model_df

  model_colnames <- c("PDX18_TYPE",       # 1
                      "PDX18_TYPE",       # 2
                      "PDX18_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "PDX18_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)

  model_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[1])) %>%
    dplyr::mutate(PDX18_TYPE_FCT = factor(PDX18_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))

  wc_tr <- c("53033026600",
             "53033026700",
             "53033026500",
             "53033026801",
             "53033026802",
             "53033027000")

my_pal <- c(
  RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
  RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
  RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
)

my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f")


pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$PDX18_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(model_ready$PDX18_TYPE_FCT))

model_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("labels", zIndex = 440) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(fillColor = ~pal(PDX18_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
  leaflet::addPolygons(data = kc_boundary,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels")) %>%
  leaflet::addLegend(title = '',position = 'topright',pal = pal, values = ~PDX18_TYPE_FCT, opacity = 1)

}

#' @rdname show-typology-map
#' @export
show_coo16_sf_map <- function(){

  # loadd the objects

  model_all <- st_read("00-bookdown/data/model-coo16-20190305.gpkg")
  
  kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg")

   # assign one of the model objects to model_df

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO16_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "COO16_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)

  model_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[2])) %>%
    dplyr::mutate(COO16_TYPE_FCT = factor(COO16_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))

  wc_tr <- c("53033026600",
             "53033026700",
             "53033026500",
             "53033026801",
             "53033026802",
             "53033027000")

my_pal <- c(
  RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
  RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
  RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
)

my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f")


pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$COO16_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(model_ready$COO16_TYPE_FCT))

model_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("labels", zIndex = 440) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(fillColor = ~pal(COO16_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
  leaflet::addPolygons(data = kc_boundary,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels")) %>%
  leaflet::addLegend(title = '',position = 'topright',pal = pal, values = ~COO16_TYPE_FCT, opacity = 1)

}

#' @rdname show-typology-map
#' @export
show_coo18_sf_map <- function(){

  # loadd the objects

  model_all <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg")
  
  kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg")

   # assign one of the model objects to model_df

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "COO18_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)

  model_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[3])) %>%
    dplyr::mutate(COO18_TYPE_FCT = factor(COO18_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))

  wc_tr <- c("53033026600",
             "53033026700",
             "53033026500",
             "53033026801",
             "53033026802",
             "53033027000")

my_pal <- c(
  RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
  RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
  RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
)

my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f")


pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$COO18_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(model_ready$COO18_TYPE_FCT))

model_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("labels", zIndex = 440) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(fillColor = ~pal(COO18_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
  leaflet::addPolygons(data = kc_boundary,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels")) %>%
  leaflet::addLegend(title = '',position = 'topright',pal = pal, values = ~COO18_TYPE_FCT, opacity = 1)

}

#' @rdname show-typology-map
#' @export
show_coorev18_sf_map <- function(){

  # loadd the objects

  model_all <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg")
  
  kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg")

  # assign one of the model objects to model_df

  coo_communities <- model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_SF_TYPE", # 4
                      "COOREV18_SF_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)

  model_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[4])) %>%
    dplyr::mutate(COOREV18_SF_TYPE_FCT = factor(COOREV18_SF_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))

  wc_tr <- c("53033026600",
             "53033026700",
             "53033026500",
             "53033026801",
             "53033026802",
             "53033027000")

my_pal <- c(
  RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
  RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
  RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
)

my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f")


pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$COOREV18_SF_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(model_ready$COOREV18_SF_TYPE_FCT))

model_ready %>% 
sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("communities", zIndex = 440) %>%
  leaflet::addMapPane("labels", zIndex = 450) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(data = kc_boundary,
                       fillOpacity = 0.1, smoothFactor = 0,
                       fill = "black", weight = 0, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addPolygons(fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels"))  

}

#' @rdname show-typology-map
#' @export
show_coorev18_mf_map <- function(){

  # loadd the objects

  model_all <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg")
  
  kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg")

  # assign one of the model objects to model_df

  coo_communities <- model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "COOREV18_MF_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)

  model_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[4])) %>%
    dplyr::mutate(COOREV18_MF_TYPE_FCT = factor(COOREV18_MF_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))

  wc_tr <- c("53033026600",
             "53033026700",
             "53033026500",
             "53033026801",
             "53033026802",
             "53033027000")

my_pal <- c(
  RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
  RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
  RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
)

my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f")


pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$COOREV18_MF_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(model_ready$COOREV18_MF_TYPE_FCT))

model_ready %>% 
sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("communities", zIndex = 440) %>%
  leaflet::addMapPane("labels", zIndex = 450) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(data = kc_boundary,
                       fillOpacity = 0.1, smoothFactor = 0,
                       fill = "black", weight = 0, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addPolygons(fillColor = ~pal(COOREV18_MF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels"))  

}

#' @rdname show-typology-map
#' @export
show_coorev18_sf_communities_map <- function(){

  # loadd the objects

  model_all <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg")
  
  kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg") 

  coo_communities <- model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)

    kc_no_comm <- kc_boundary %>% st_difference(st_union(coo_communities)) %>% st_union()
  
    kc_no_wc <- kc_boundary %>% st_difference(coo_comm_wc) %>% st_union()
    
     kc_no_rv <- kc_boundary %>% st_difference(coo_comm_rv) %>% st_union()
    
    kc_no_stk <- kc_boundary %>% st_difference(coo_comm_stk) %>% st_union()
    
    
  comm_tracts <- model_all %>% 
    filter(!is.na(GEOGRAPHY_COMMUNITY_ID)) %>% 
    filter(GEOGRAPHY_TYPE %in% "tract")
  
 
  comm_tract_centers <- model_all %>% 
    st_centroid() %>% 
    mutate(coord = map(geom, ~ as_tibble(st_coordinates(.x))),
           coord_x = map_dbl(coord, ~pull(.x,"X")),
           coord_y =  map_dbl(coord, ~pull(.x,"Y"))) %>% 
    select(matches("GEOG"),matches("coord")) %>% 
    mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME,", King County, Washington"),
           GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME,"Census "))
  

  
   # assign one of the model objects to model_df

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "COOREV18_SF_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)


my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f") 



dat_ready <- comm_tracts %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[5])) %>%
    dplyr::mutate(COOREV18_SF_TYPE_FCT = factor(COOREV18_SF_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))
pal <- leaflet::colorFactor(my_pal_hex,levels = levels(dat_ready$COOREV18_SF_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(dat_ready$COOREV18_SF_TYPE_FCT))


dat_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("communities", zIndex = 440) %>%
  leaflet::addMapPane("labels", zIndex = 450) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(data = kc_no_comm,
                       fillOpacity = 0.1, smoothFactor = 0,
                       fill = "black", weight = 0, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addPolygons(fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addPolygons(data = comm_tracts,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .25, weight = 5,
                       options = leaflet::pathOptions(pane = "lines")) %>% 
  leaflet::addPolygons(data = coo_communities,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "communities")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels")) 
  
dat_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("communities", zIndex = 440) %>%
  leaflet::addMapPane("labels", zIndex = 450) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(data = kc_no_wc,
                       fillOpacity = 0.1, smoothFactor = 0,
                       fill = "black", weight = 0, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addPolygons(fillOpacity = 0, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>%  
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addPolygons(data = wc_tracts,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .25, weight = 5,
                       options = leaflet::pathOptions(pane = "lines")) %>% 
  leaflet::addPolygons(data = coo_comm_wc,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "communities")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels")) %>% 
  leaflet::addLabelOnlyMarkers(data = wc_tract_centers, options = markerOptions(draggable = TRUE),
                    lng = ~coord_x, lat = ~coord_y, label = ~GEOGRAPHY_NAME,
                    labelOptions = labelOptions(noHide = TRUE, direction = 'top', textOnly = FALSE, textsize = "10px")) 
}

#' @rdname show-typology-map
#' @export
show_coorev18_sf_communities_individual_map <- function(){

  # loadd the objects

  model_all <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg")
  
  kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg") 

  coo_communities <- model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)
  
  coo_comm_wc <-  model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    filter(GEOGRAPHY_COMMUNITY_ID %in% "WC") %>% 
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)
  
  coo_comm_rv <-  model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    filter(GEOGRAPHY_COMMUNITY_ID %in% "RV") %>% 
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)
    
    coo_comm_stk <-  model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    filter(GEOGRAPHY_COMMUNITY_ID %in% "STC_TUK") %>% 
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)

    
    kc_no_wc <- kc_boundary %>% st_difference(coo_comm_wc) %>% st_union()
    
     kc_no_rv <- kc_boundary %>% st_difference(coo_comm_rv) %>% st_union()
    
    kc_no_stk <- kc_boundary %>% st_difference(coo_comm_stk) %>% st_union()
    
    
  comm_tracts <- model_all %>% 
    filter(!is.na(GEOGRAPHY_COMMUNITY_ID)) %>% 
    filter(GEOGRAPHY_TYPE %in% "tract")
  
 
  comm_tract_centers <- model_all %>% 
    st_centroid() %>% 
    mutate(coord = map(geom, ~ as_tibble(st_coordinates(.x))),
           coord_x = map_dbl(coord, ~pull(.x,"X")),
           coord_y =  map_dbl(coord, ~pull(.x,"Y"))) %>% 
    select(matches("GEOG"),matches("coord")) %>% 
    mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME,", King County, Washington"),
           GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME,"Census "))
  
  
  wc_tracts <- model_all %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "WC")
  
  rv_tracts <- model_all %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "RV")
  
  stk_tracts <- model_all %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "STC_TUK")
  
  
  wc_tract_centers <- comm_tract_centers %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "WC")
  
  rv_tract_centers <- comm_tract_centers %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "RV")
  
  stk_tract_centers <- comm_tract_centers %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "STC_TUK")
  
   # assign one of the model objects to model_df

  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_MF_TYPE", # 4
                      "COOREV18_SF_TYPE") # 5

  kc_boundary <- sf::st_transform(kc_boundary, 4326)

  model_all <- sf::st_transform(model_all, 4326)


my_pal_hex <- c("#ffff00",
                "#ffc800",
                "#ff9600",
                "#a30382",
                "#0794d0",
                "#1b5f8f") 

pal <- leaflet::colorFactor(my_pal_hex,levels = levels(dat_ready$COOREV18_SF_TYPE_FCT), ordered = TRUE,na.color = 'transparent')

vals <- levels(ordered(dat_ready$COOREV18_SF_TYPE_FCT))


dat_ready <- wc_tracts %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[5])) %>%
    dplyr::mutate(COOREV18_SF_TYPE_FCT = factor(COOREV18_SF_TYPE,
                                        levels = c("Susceptible",
                                                   "Early Type 1",
                                                   "Early Type 2",
                                                   "Dynamic",
                                                   "Late",
                                                   "Continued Loss"
                                        )))


dat_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("communities", zIndex = 440) %>%
  leaflet::addMapPane("labels", zIndex = 450) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(data = kc_no_wc,
                       fillOpacity = 0.1, smoothFactor = 0,
                       fill = "black", weight = 0, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addPolygons(fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addPolygons(data = wc_tracts,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .25, weight = 5,
                       options = leaflet::pathOptions(pane = "lines")) %>% 
  leaflet::addPolygons(data = coo_comm_wc,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "communities")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels"))  
  
dat_ready %>%
  sf::st_transform(4326) %>%
  dplyr::mutate(POPUP= paste0(GEOGRAPHY_NAME,": ",GEOGRAPHY_ID)) %>%
  leaflet::leaflet() %>%
  leaflet::addMapPane("background_map", zIndex = 410) %>%
  leaflet::addMapPane("polygons", zIndex = 420) %>%
  leaflet::addMapPane("lines", zIndex = 430) %>%
  leaflet::addMapPane("communities", zIndex = 440) %>%
  leaflet::addMapPane("labels", zIndex = 450) %>%
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                            options = leaflet::pathOptions(pane = "background_map")) %>%
  leaflet::addPolygons(data = kc_no_wc,
                       fillOpacity = 0.1, smoothFactor = 0,
                       fill = "black", weight = 0, 
                       options = leaflet::pathOptions(pane = "polygons")) %>% 
  leaflet::addPolygons(fillOpacity = 0, smoothFactor = 0,
                       color = 'white', opacity = .85, weight = .5,
                       popup = ~POPUP,
                       options = leaflet::pathOptions(pane = "polygons")) %>%  
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                            options = leaflet::pathOptions(pane = "lines")) %>%
  leaflet::addPolygons(data = wc_tracts,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .25, weight = 5,
                       options = leaflet::pathOptions(pane = "lines")) %>% 
  leaflet::addPolygons(data = coo_comm_wc,
                       fillOpacity = 0, smoothFactor = 0,
                       color = 'black', opacity = .85, weight = 5,
                       options = leaflet::pathOptions(pane = "communities")) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                            options = leaflet::pathOptions(pane = "labels")) %>% 
  leaflet::addLabelOnlyMarkers(data = wc_tract_centers, options = markerOptions(draggable = TRUE),
                    lng = ~coord_x, lat = ~coord_y, label = ~GEOGRAPHY_NAME,
                    labelOptions = labelOptions(noHide = TRUE, direction = 'top', textOnly = FALSE, textsize = "10px")) 
}


show_coorev18_both <- function(){
  
  source("00-bookdown/R/setup.R",echo = FALSE)

# LOAD DATA ---------------------------------------------------------------

model_all <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg", quiet = TRUE) 

kc_boundary <- st_read("00-bookdown/data/kc-boundary.gpkg", quiet = TRUE)

# LEAFLET MAP ---------------------------------------------------------------
  
  # assign one of the model objects to model_df
  
  coo_communities <- model_all %>%
    dplyr::select(GEOGRAPHY_ID,
                  dplyr::matches("GEOGRAPHY_COMMUNITY")) %>%
    dplyr::filter(! is.na(GEOGRAPHY_COMMUNITY_ID)) %>%
    dplyr::group_by(GEOGRAPHY_COMMUNITY_NAME, GEOGRAPHY_COMMUNITY_ID) %>%
    dplyr::summarise() %>%
    sf::st_transform(4326)
  
  model_colnames <- c("PDX18_TYPE",       # 1
                      "COO16_TYPE",       # 2
                      "COO18_TYPE",       # 3
                      "COOREV18_SF_TYPE", # 4
                      "COOREV18_MF_TYPE") # 5
  
  kc_boundary <- sf::st_transform(kc_boundary, 4326)
  
  model_all <- sf::st_transform(model_all, 4326)
  
  model_mf_ready <- model_all %>%
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[5])) %>%  
    dplyr::mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME, "Census ")) %>% 
    dplyr::mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME, ", King County, Washington")) %>% 
    dplyr::mutate(POPUP = as.character(glue("{GEOGRAPHY_NAME} ({GEOGRAPHY_ID})<br>
                                            Type: {COOREV18_MF_TYPE}<br>
                                            Housing Market Type: Multifamily"))
      
    ) %>% 
    dplyr::mutate(COOREV18_SF_TYPE_FCT = factor(COOREV18_MF_TYPE,
                                                levels = c("Susceptible",
                                                           "Early Type 1",
                                                           "Early Type 2",
                                                           "Dynamic",
                                                           "Late",
                                                           "Continued Loss"
                                                ))) %>% 
    sf::st_transform(4326) %>% 
    filter(!is.na(COOREV18_SF_TYPE_FCT))
  
  
  model_sf_ready <- model_all %>%
    filter(! GEOGRAPHY_ID %in% model_mf_ready$GEOGRAPHY_ID) %>% 
    dplyr::select(dplyr::starts_with("GEOGRAPHY"),
                  tidyselect::vars_select(names(.),model_colnames[4])) %>%  
    dplyr::mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME, "Census ")) %>% 
    dplyr::mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME, ", King County, Washington")) %>% 
    dplyr::mutate(POPUP = case_when(
      
      !is.na(GEOGRAPHY_COMMUNITY_NAME) & !is.na(COOREV18_SF_TYPE) ~ as.character(glue("<strong>{GEOGRAPHY_COMMUNITY_NAME}</strong>\n<hr>\n 
                                            {GEOGRAPHY_NAME} ({GEOGRAPHY_ID})<br>
                                            Type: {COOREV18_SF_TYPE}")),
      !is.na(GEOGRAPHY_COMMUNITY_NAME) ~ as.character(glue("<strong>{GEOGRAPHY_COMMUNITY_NAME}</strong>\n<hr>\n 
                                            {GEOGRAPHY_NAME} ({GEOGRAPHY_ID})<br>
                                            Type: Not At-Risk or Gentrifying")),
      !is.na(COOREV18_SF_TYPE) ~ as.character(glue("{GEOGRAPHY_NAME} ({GEOGRAPHY_ID})<br>
                                            Type: {COOREV18_SF_TYPE}")),
      TRUE ~ as.character(glue("{GEOGRAPHY_NAME} ({GEOGRAPHY_ID})<br>
                                            Type: Not At-Risk or Gentrifying")) 
      
    )) %>% 
    dplyr::mutate(COOREV18_SF_TYPE_FCT = factor(COOREV18_SF_TYPE,
                                                levels = c("Susceptible",
                                                           "Early Type 1",
                                                           "Early Type 2",
                                                           "Dynamic",
                                                           "Late",
                                                           "Continued Loss"
                                                ))) %>%   
    sf::st_transform(4326) 
  
  model_ready <- list(model_mf_ready,
       model_sf_ready) %>% 
    map_dfr(c) %>% 
    st_sf() %>% 
    st_set_crs(st_crs(model_mf_ready))
  
  
  model_wc <- model_ready %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "WC")
  
  model_rv <- model_ready %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "RV")
  
  model_stk <- model_ready %>% filter(GEOGRAPHY_COMMUNITY_ID %in% "STC_TUK")
  
  model_other <- model_ready %>% filter(is.na(GEOGRAPHY_COMMUNITY_ID))
  
  
  
  
  my_pal <- c(
    RColorBrewer::brewer.pal(n = 9,'YlOrRd')[c(3,5,6)],
    RColorBrewer::brewer.pal(n = 9,'RdPu')[c(6)],
    RColorBrewer::brewer.pal(n = 9,'YlGnBu')[c(6,7)]
  )
  
  my_pal_hex <- c("#ffff00",
                  "#ffc800",
                  "#ff9600",
                  "#a30382",
                  "#0794d0",
                  "#1b5f8f")
  
  
  pal <- leaflet::colorFactor(my_pal_hex,levels = levels(model_ready$COOREV18_SF_TYPE_FCT), ordered = TRUE,na.color = 'transparent')
  
  vals <- levels(ordered(model_ready$COOREV18_SF_TYPE_FCT))
  
  html_legend <- "<img src='images/typology-scale.png' style= 'height: 25px;'>"
  
  
  leaflet::leaflet(data = model_ready) %>%
    leaflet::addMapPane("background_map", zIndex = 410) %>%
    leaflet::addMapPane("polygons", zIndex = 420) %>%
    leaflet::addMapPane("lines", zIndex = 430) %>%
    leaflet::addMapPane("communities", zIndex = 440) %>%
    leaflet::addMapPane("labels", zIndex = 450) %>% 
    leaflet::addMapPane("popup", zIndex = 499) %>%
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLite,
                              options = leaflet::pathOptions(pane = "background_map")) %>%
    leaflet::addPolygons(data = kc_boundary,
                         fillOpacity = 0.1, smoothFactor = 0,
                         fill = "black", weight = 0,
                         options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addPolygons(group = "White Center",
                         data = model_wc,
                         fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                         color = 'white', opacity = .85, weight = .5,
                         options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addPolygons(group = "Rainier Valley",
                         data = model_rv,
                         fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                         color = 'white', opacity = .85, weight = .5,
                         options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addPolygons(group = "Seatac/Tukwila",
                         data = model_stk,
                         fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                         color = 'white', opacity = .85, weight = .5,
                         options = leaflet::pathOptions(pane = "polygons")) %>%
    leaflet::addPolygons(group = "Outside COO (SF/Mixed)",
                         data = model_other,
                         fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                         color = 'white', opacity = .85, weight = .5,
                         options = leaflet::pathOptions(pane = "polygons")) %>% 
    leaflet::addPolygons(group = "Outside COO (MF)",
                         data = model_mf_ready,
                         fillColor = ~pal(COOREV18_SF_TYPE_FCT), fillOpacity = 1, smoothFactor = 0,
                         color = 'white', opacity = .85, weight = .5,
                         options = leaflet::pathOptions(pane = "polygons")) %>% 
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLines,
                              options = leaflet::pathOptions(pane = "lines")) %>%
    leaflet::addPolygons(data = coo_communities,
                         fillOpacity = 0, smoothFactor = 0,
                         color = 'black', opacity = .85, weight = 2,
                         options = leaflet::pathOptions(pane = "communities")) %>%
    leaflet::addPolygons(data = coo_communities,
                         fillOpacity = 0, smoothFactor = 0,
                         color = 'black', opacity = .25, weight = 10,
                         options = leaflet::pathOptions(pane = "communities")) %>%
    leaflet::addProviderTiles(provider = leaflet::providers$Stamen.TonerLabels,
                              options = leaflet::pathOptions(pane = "labels")) %>%
    leaflet::addPolygons(popup = ~POPUP,
                         fillOpacity = 0,
                         opacity = 0,
                         smoothFactor = 0,
                         options = leaflet::pathOptions(pane = "popup")) %>%
    leaflet.extras::addFullscreenControl() %>%
    leaflet::addLegend(position = "topright",pal = pal, values = ~COOREV18_SF_TYPE_FCT, opacity = 1,title = "") %>% 
    addLayersControl( 
      overlayGroups = c("White Center", 
                        "Rainier Valley",
                        "Seatac/Tukwila",
                        "Outside COO (SF/Mixed)",
                        "Outside COO (MF)"),
      position = "topleft",
      options = layersControlOptions(collapsed = TRUE)
    )
  
}