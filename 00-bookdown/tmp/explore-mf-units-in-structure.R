

# LOAD DATA ---------------------------------------------------------------

coorev18_sf <- st_read("00-bookdown/data/model-coorev18-20190305.gpkg", quiet = TRUE)

wa_counties_ready <- st_read("00-bookdown/data/counties-nearby-kc-no-waterbodies.gpkg", quiet = TRUE)

# PREP DATA ---------------------------------------------------------------

uis_sf <- coorev18_sf %>% 
  filter(GEOGRAPHY_TYPE %in% "tract") %>% 
  select(GEOGRAPHY_ID,
         MFUNITS_PCT = COOREV18_HOUSMRKT_MFUNITS_EST_PCT_2013_2017)

percent_flat <- percent_format(accuracy = 1)

breaks <- seq(0,1,by = 0.1)

labels <- map_chr(breaks[1:10], ~ as.character(glue::glue("{as.integer(.x * 1e2)}-{percent_flat(if_else(.x == 0.9, .x + 0.1, .x+0.09))}")))

uis_hist_sf <- uis_sf %>%
  mutate(HIST_GRP = cut(MFUNITS_PCT,
                        breaks,
                        labels = labels,
                        format_fun = scales::percent,
                        simplify = F,
                        include.lowest = TRUE,
                        right = FALSE)
  )

plot_histogram_pct <- function(){
  
  ggplot(data = uis_hist_sf,
         aes(x = HIST_GRP, fill = HIST_GRP)) +
    geom_bar() +
    scale_fill_viridis_d()+
    theme_minimal() +
    ylab("# of tracts") +
    theme_nct +
    theme(plot.title = element_text(size = 20),
          plot.subtitle = element_text(size = 12),
          axis.title.x = element_blank(),
          panel.grid = element_blank(),
          legend.position = "none")
  
  
  
}

p1 <- plot_histogram_pct()

plot_ggplot_pct_no_legend <- function(){
  
  
  ggplot() +
    geom_sf(data = wa_counties_ready, fill = colors_nct$grey, color = "white") +
    geom_sf(data = uis_hist_sf, aes(fill = HIST_GRP), color = "transparent") +
    geom_sf(data = uis_hist_sf, fill = "transparent",color = "black") +
    scale_fill_viridis_d() +
    theme_void() +
    coord_sf(datum = NA, expand = FALSE) +
    theme_nct +
    theme(legend.position="none",
          plot.margin = margin(t = 0,r = -0.1,b = 0,l = 0,unit = "npc"),
          plot.caption = element_text(size = 10)
    )  
  
  
} 


# PLOTS -------------------------------------------------------------------



plot1 <- plot_histogram_pct()

plot1 <- plot1 + plot_ggplot_pct_no_legend()

plot1 <- plot1 + plot_layout(ncol = 1,
                             heights = c(0.33, 1))

plot1 <- plot1 + plot_annotation(title = "Multifamily Residences as a % of All Housing Units (2013-2017)",
                  subtitle = "",
                  caption = wrapper("Source: author's analysis of ACS Table B25032; 2013 - 2017 5-year span; Census Tracts in King County, WA"),
                  theme = theme_nct)

showtext_auto()

plot1