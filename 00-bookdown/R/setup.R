

# LOAD PACKAGES -----------------------------------------------------------

library(bookdown)
library(tidyverse)
library(sp)
library(sf)
library(gt)
library(leaflet)
library(leaflet.extras)
library(showtext) 
library(cowplot)
library(magick)
library(patchwork)
library(glue) 
library(scales) 

# FUNCTIONS ---------------------------------------------------------------


g <- dplyr::glimpse

wrapper <- function(x, width = 125, ...){
  paste(strwrap(x, width, ...), collapse = "\n")
  
}

myLfltOpts <- function(map, tileLabels = TRUE, fullScreenBtn = TRUE, bumpTileLabels = TRUE, hideControls = TRUE, pseudoFullscreen = TRUE){

        # Arguments to pass to the chain

        fs <- if(fullScreenBtn){
                function(x)addFullscreenControl(x, pseudoFullscreen = pseudoFullscreen)
        }else{function(x)x}

        tileLbl <- if(tileLabels){
                function(x)addProviderTiles(x,
                                            providers$CartoDB.PositronOnlyLabels,
                                            layerId = 'labels_layer' )
        }else{function(x)x}

        # JS strings

        lbl <- if(bumpTileLabels == TRUE){"var shadowPane = myMap.getPanes().shadowPane;shadowPane.style.pointerEvents = 'none';shadowPane.appendChild(myMap.layerManager._byLayerId['tile\\nlabels_layer'].getContainer());"}else{""}

        cntrl <- if(hideControls == TRUE){"myMap.removeControl(myMap.attributionControl);myMap.removeControl(myMap.zoomControl);"}else{""}

        jqry <- paste0("function(el, t){var myMap = this;",lbl,cntrl,"}")


        # Final function

        map %>%
                tileLbl()%>%
                fs() %>%
                htmlwidgets::onRender(jqry)

}


# GGPLOT2 OBJECTS ---------------------------------------------------------

coo_community_levels <- c("Seatac/Tukwila",
                          "Rainier Valley",
                          "White Center")

typology_levels <- c("Susceptible",
                     "Early Type 1",
                     "Early Type 2",
                     "Dynamic",
                     "Late",
                     "Continued Loss")
 
# font_add_google("Open Sans", "Open Sans")

theme_nct <- theme_minimal(base_size = 10,
                           base_family = "Open Sans",
                           base_line_size = 1) +
  theme(plot.title = element_text(hjust = 0),
        plot.subtitle = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))

theme_nct_8 <- theme_minimal(base_size = 8,
                           base_family = "Open Sans",
                           base_line_size = 0.5) +
  theme(plot.title = element_text(hjust = 0),
        plot.subtitle = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))

theme_void_nct <- theme_void(base_size = 10,
                           base_family = "Open Sans",
                           base_line_size = 1) +
  theme(plot.margin = margin(t = 5,r = 5,b = 5,l = 0,unit = "pt"),
        plot.title = element_text(hjust = 0),
        plot.subtitle = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))

colors_nct <- list(darkgrey = "#434343",
                   grey = "#cccccc")

colors_nct_typology <- c(
  "Susceptible" = "#ffff00",
  "Early Type 1" = "#ffc800",
  "Early Type 2" = "#ff9600",
  "Dynamic" = "#a30382",
  "Late" = "#0794d0",
  "Continued Loss" = "#1b5f8f"
)

colors_nct_list <- list( "Susceptible" = "#ffff00",
  "Early Type 1" = "#ffc800",
  "Early Type 2" = "#ff9600",
  "Dynamic" = "#a30382",
  "Late" = "#0794d0",
  "Continued Loss" = "#1b5f8f")

scale_discrete_nct <- function(aesthetic, ...) {
  ggplot2:::manual_scale(
    aesthetic,
    ...,
    values = colors_nct_typology,
    drop = FALSE
  )
}


