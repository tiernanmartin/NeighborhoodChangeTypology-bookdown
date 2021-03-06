
# SETUP -------------------------------------------------------------------

source("00-bookdown/R/setup.R",echo = FALSE)

# LOAD DATA ---------------------------------------------------------------

coorev18 <- readr::read_rds("00-bookdown/data/model-all-20190305.rds") %>% 
  select(matches("GEOGRAPHY"), matches("COOREV18")) %>%  
  as_tibble() 


# TRANSFORM DATA: VULNERABILITY -------------------------------------------


dat_vuln_wide <- coorev18 %>% select(matches("GEOGRAPHY"),
                 COOREV18_VULN_POC_EST_PCT_2013_2017,
                 COOREV18_VULN_LOWED_EST_PCT_2013_2017, 
                         COOREV18_VULN_LOWINCAMI_EST_PCT_2011_2015,
                 COOREV18_VULN_RENTHH_EST_PCT_2013_2017) 

dat_vuln_long <- dat_vuln_wide %>% 
  gather(COL, VAL, -matches("GEOGRAPHY")) %>% 
  mutate(YEAR = str_extract(COL,"\\d{4}_\\d{4}$")) %>% 
  mutate(VAR = case_when(
    str_detect(COL,"LOWED") ~ "% LOW-EDUCATION",
    str_detect(COL,"LOWINCAMI") ~ "% LOW-INCOME",
    str_detect(COL,"POC") ~ "% PEOPLE OF COLOR",
    str_detect(COL,"RENTHH") ~ "% RENTERS"
  )) %>% 
  mutate(VAR = glue("{VAR} ({str_replace(YEAR,'_','-')})"))

dat_vuln_tr <- dat_vuln_long %>% 
  filter(GEOGRAPHY_TYPE %in% c("tract"))

dat_vuln_lines <- dat_vuln_long %>% 
  filter(GEOGRAPHY_TYPE %in% c("county", "community") | !is.na(GEOGRAPHY_COMMUNITY_NAME)) %>% 
  mutate(GEOG_TYPE_FCT = factor(GEOGRAPHY_TYPE,
                                levels = c("tract",
                                           "community",
                                           "county")))
dat_vuln_lines_by_comm <- dat_vuln_lines %>% 
  mutate(WC = VAL,
         RV = VAL,
         STC_TUK = VAL) %>% 
  select(-VAL) %>% 
  gather(GEOG_COMM, VAL, WC, RV, STC_TUK) %>% 
  nest(-GEOG_COMM) %>% 
  mutate(data = map2(data, GEOG_COMM, ~ filter(.x, GEOGRAPHY_COMMUNITY_ID %in% .y | GEOGRAPHY_TYPE %in% c("county", "community")))) %>% 
  unnest() %>% 
  mutate(GEOG_COMM = case_when(
    GEOG_COMM %in% "WC" ~ "White Center",
    GEOG_COMM %in% "RV" ~ "Rainier Valley",
    GEOG_COMM %in% "STC_TUK" ~ "Seatac/Tukwila"
  )) %>% 
  filter(GEOGRAPHY_TYPE %in% c("tract","county") | GEOG_COMM == GEOGRAPHY_NAME)


# PLOT: VULNERABILITY ------------------------------------------------------

showtext_auto()

show_comm_hist <- function(x, y_axis_title, legend_position){  

  comm_name <- unique(x$GEOG_COMM)
  
  dat_vuln_tr %>% 
    ggplot2::ggplot(ggplot2::aes(x = VAL)) + 
    ggplot2::geom_histogram(fill = colors_nct$grey) +
    ggplot2::geom_vline(data = x, 
                        aes(xintercept = VAL, 
                            color = GEOG_TYPE_FCT, 
                            size = GEOG_TYPE_FCT, 
                            alpha = GEOG_TYPE_FCT,
                            linetype = GEOG_TYPE_FCT)) +
    scale_color_manual(values = c(colors_nct_list$Dynamic,
                                  colors_nct_list$Dynamic,
                                  colors_nct_list$Late)) +
    scale_x_continuous(limits = c(0,1), labels = scales::percent) +
    scale_size_manual(values = c(0.5,1,1)) +
    scale_alpha_manual(values = c(0.75,1,1)) +
    scale_linetype_manual(values = c(1,6,1)) + 
    ggplot2::facet_wrap(~ VAR, ncol = 1, scales = "free_x") +
    theme_nct_8 +
    labs(y = y_axis_title,
         x = "",
         title = comm_name) +
    theme(legend.position = legend_position,
          legend.direction="horizontal",
          legend.text = element_text(hjust = 0.5),
          legend.spacing.x = unit(2, "pt"),
          legend.key.width = unit(30, "pt"),
          legend.key.height = unit(12, "pt"),
          legend.title = element_blank(),
          strip.background = element_blank(), 
          strip.placement = "outside")
}
dat_vuln_list_by_comm <- group_split(dat_vuln_lines_by_comm, GEOG_COMM)

pmap(list(x = dat_vuln_list_by_comm,
            y_axis_title = c("# of Census Tracts","",""),
            legend_position = c("none","bottom","none")), 
     show_comm_hist) %>% 
  wrap_plots(nrow = 1) +
  plot_annotation(title = "Vulnerability Indicators by COO Community (2013-2017)",
                subtitle = "",
                caption = wrapper("Source: author's analysis of data from American Community Survey and HUD CHAS
                                  \nNote: The income indicator uses CHAS data, which lags behind the ACS data by two years. The gray bars show the amount of census tracts at each part of the x-axis."),
                theme = theme_nct)

# TRANSFORM DATA: DEMO. CHANGE -------------------------------------------


dat_demochng_wide <- coorev18 %>% select(matches("GEOGRAPHY"),
                                         COOREV18_DEMOCHNG_HIGHED_DIFF_PCT_2007_2011_TO_2013_2017,
                                         COOREV18_DEMOCHNG_INCOME_DIFF_MED_2007_2011_TO_2013_2017,
                                         COOREV18_DEMOCHNG_WHITE_DIFF_PCT_2007_2011_TO_2013_2017,
                                         COOREV18_DEMOCHNG_OWNHH_DIFF_PCT_2007_2011_TO_2013_2017) 

dat_demochng_long <- dat_demochng_wide %>% 
  gather(COL, VAL, -matches("GEOGRAPHY")) %>% 
  mutate(YEAR = str_extract(COL,"\\d{4}_\\d{4}_TO_\\d{4}_\\d{4}$")) %>%  
  mutate(YEAR = str_replace(YEAR,"_TO_", " TO ")) %>% 
  mutate(YEAR = str_replace_all(YEAR,'_','-')) %>% 
  mutate(YEAR = str_replace_all(YEAR,'20',"'")) %>% 
  mutate(VAR = case_when(
    str_detect(COL,"HIGHED") ~ "CHANGE % HIGH-ED.",
    str_detect(COL,"INCOME") ~ "CHANGE MEDIAN INC.",
    str_detect(COL,"WHITE") ~ "CHANGE % WHITE",
    str_detect(COL,"OWNHH") ~ "CHANGE % HOMEOWNER"
  )) %>% 
  mutate(VAR = as.character(glue("{VAR} ({YEAR})"))) 

lvls <- unique(dat_demochng_long$VAR)

dat_demochng_long <-dat_demochng_long %>% 
  mutate(VAR = factor(VAR,
                      levels = c(lvls)))


dat_demochng_tr <- dat_demochng_long %>% 
  filter(GEOGRAPHY_TYPE %in% c("tract"))

dat_demochng_lines <- dat_demochng_long %>% 
  filter(GEOGRAPHY_TYPE %in% c("county", "community") | !is.na(GEOGRAPHY_COMMUNITY_NAME)) %>% 
  mutate(GEOG_TYPE_FCT = factor(GEOGRAPHY_TYPE,
                                levels = c("tract",
                                           "community",
                                           "county")))
dat_demochng_lines_by_comm <- dat_demochng_lines %>% 
  mutate(WC = VAL,
         RV = VAL,
         STC_TUK = VAL) %>% 
  select(-VAL) %>% 
  gather(GEOG_COMM, VAL, WC, RV, STC_TUK) %>% 
  nest(-GEOG_COMM) %>% 
  mutate(data = map2(data, GEOG_COMM, ~ filter(.x, GEOGRAPHY_COMMUNITY_ID %in% .y | GEOGRAPHY_TYPE %in% c("county", "community")))) %>% 
  unnest() %>% 
  mutate(GEOG_COMM = case_when(
    GEOG_COMM %in% "WC" ~ "White Center",
    GEOG_COMM %in% "RV" ~ "Rainier Valley",
    GEOG_COMM %in% "STC_TUK" ~ "Seatac/Tukwila"
  )) %>% 
  filter(GEOGRAPHY_TYPE %in% c("tract","county") | GEOG_COMM == GEOGRAPHY_NAME)


# PLOT: DEMOGRAPHIC CHANGE ------------------------------------------------

showtext_auto()

show_comm_hist <- function(x, y_axis_title, legend_position){  
  
  comm_name <- unique(x$GEOG_COMM)
  
  varied_labels <- function(x) {   
    
    if (max(x, na.rm = TRUE) > 1){
      percent_format(accuracy = 1,prefix = "+")(x) %>% str_replace_all("\\+\\-","\\-")
    }else{
      percent_format(accuracy = 1, prefix = "+", suffix = "%pts.")(x) %>% str_replace_all("\\+\\-","\\-")
    } 
  }
  
  dat_demochng_tr %>% 
    filter(!is.na(VAL)) %>% 
    ggplot2::ggplot(ggplot2::aes(x = VAL)) + 
    ggplot2::geom_histogram(fill = colors_nct$grey) +
    ggplot2::geom_vline(data = x, 
                        aes(xintercept = VAL, 
                            color = GEOG_TYPE_FCT, 
                            size = GEOG_TYPE_FCT, 
                            alpha = GEOG_TYPE_FCT,
                            linetype = GEOG_TYPE_FCT)) +
    scale_color_manual(values = c(colors_nct_list$`Early Type 2`,
                                  colors_nct_list$`Early Type 2`,
                                  colors_nct_list$Late)) + 
    scale_size_manual(values = c(0.5,1,1)) +
    scale_alpha_manual(values = c(.75,1,1)) +
    scale_linetype_manual(values = c(1,6,1)) +  
     facet_wrap(~ VAR, ncol = 1, scales = "free_x") +
    scale_x_continuous(labels = varied_labels) +
    theme_nct_8 +
    labs(y = y_axis_title,
         x = "",
         title = comm_name) +
    theme(legend.position = legend_position,
          legend.direction="horizontal",
          legend.text = element_text(hjust = 0.5),
          legend.spacing.x = unit(2, "pt"),
          legend.key.width = unit(30, "pt"),
          legend.key.height = unit(12, "pt"),
          legend.title = element_blank(),
          strip.background = element_blank(), 
          strip.placement = "outside")
}
dat_demochng_list_by_comm <- group_split(dat_demochng_lines_by_comm, GEOG_COMM)

pmap(list(x = dat_demochng_list_by_comm,
          y_axis_title = c("# of Census Tracts","",""),
          legend_position = c("none","bottom","none")), 
     show_comm_hist) %>% 
  wrap_plots(nrow = 1) +
  plot_annotation(title = "Demographic Change Indicators by COO Community (2007-2001 to 2013-2017)",
                  subtitle = "",
                  caption = wrapper("Source: author's analysis of data from American Community Survey 
                                  \nNote: Median income at the community level is not calculated. The gray bars show the amount of census tracts at each part of the x-axis."),
                  theme = theme_nct)




# TRANSFORM DATA: HOUSING MARKET -------------------------------------------


dat_housmrkt_wide <- coorev18 %>% select(matches("GEOGRAPHY"),
                                         COOREV18_HOUSMRKT_RENTPRICE_EST_MED_2013_2017,
                                         COOREV18_HOUSMRKT_SFHOMEVALKC_EST_MED_2018_2018,
                                         COOREV18_HOUSMRKT_SFSALEPRICESQFT_EST_MED_2018_2018,
                                         COOREV18_HOUSMRKT_SFHOMEVALKC_DIFF_MED_2010_2010_TO_2018_2018,
                                         COOREV18_HOUSMRKT_SFSALEPRICESQFT_DIFF_MED_2010_2010_TO_2018_2018,
                                         COOREV18_HOUSMRKT_SFSALERATE_EST_PCT_2016_2018) 

dat_housmrkt_long <- dat_housmrkt_wide %>% 
  gather(COL, VAL, -matches("GEOGRAPHY")) %>% 
  mutate(YEAR = str_extract(COL,"20.*$")) %>% 
  mutate(YEAR = str_replace_all(YEAR, "2010_2010","2010")) %>% 
  mutate(YEAR = str_replace_all(YEAR, "2018_2018","2018")) %>% 
  mutate(YEAR = str_replace_all(YEAR, "_TO_"," TO ")) %>%  
  mutate(YEAR = str_replace_all(YEAR,'_','-')) %>%  
  mutate(YEAR = str_replace_all(YEAR,'20',"'")) %>% 
  mutate(YEAR = str_replace(YEAR,"^'18$","2018")) %>%  
  mutate(VAR = case_when(
    str_detect(COL,"RENTPRICE") ~ "MEDIAN RENT PRICE",
    str_detect(COL,"SFHOMEVALKC_EST") ~ "MEDIAN HOME VALUE",
    str_detect(COL,"SFSALEPRICESQFT_EST") ~ "MEDIAN HOME PRICE SQFT",
    str_detect(COL,"SFHOMEVALKC_DIFF") ~ "CHANGE MEDIAN HOME VALUE",
    str_detect(COL,"SFSALEPRICESQFT_DIFF") ~ "CHANGE MEDIAN HOME PRICE SQFT",
    str_detect(COL,"SFSALERATE") ~ "% HOMES SOLD"
  )) %>% 
  mutate(VAR = as.character(glue("{VAR} ({YEAR})")))

lvls <- unique(dat_housmrkt_long$VAR)

dat_housmrkt_long <-dat_housmrkt_long %>% 
  mutate(VAR = factor(VAR,
                      levels = c(lvls)))


dat_housmrkt_tr <- dat_housmrkt_long %>% 
  filter(GEOGRAPHY_TYPE %in% c("tract"))

dat_housmrkt_tr_no_outliers <- dat_housmrkt_tr %>% 
  mutate(VAL = case_when(
    VAR %in% "MEDIAN RENT PRICE ('13-'17)" & VAL >= 2500 ~ 2500,
    VAR %in% "MEDIAN HOME VALUE (2018)" & VAL >= 1e6 ~ 1e6,
    VAR %in% "MEDIAN HOME PRICE SQFT (2018)" & VAL >= 800 ~ 800,
    VAR %in% "CHANGE MEDIAN HOME VALUE ('10 TO '18)" & VAL >= 2 ~ 2,
    VAR %in% "% HOMES SOLD ('16-'18)" & VAL >= 0.2 ~ 0.2, 
    TRUE ~ VAL
  ))

dat_housmrkt_lines <- dat_housmrkt_long %>% 
  filter(GEOGRAPHY_TYPE %in% c("county", "community") | !is.na(GEOGRAPHY_COMMUNITY_NAME)) %>% 
  mutate(GEOG_TYPE_FCT = factor(GEOGRAPHY_TYPE,
                                levels = c("tract",
                                           "community",
                                           "county")))
dat_housmrkt_lines_by_comm <- dat_housmrkt_lines %>% 
  mutate(WC = VAL,
         RV = VAL,
         STC_TUK = VAL) %>% 
  select(-VAL) %>% 
  gather(GEOG_COMM, VAL, WC, RV, STC_TUK) %>% 
  nest(-GEOG_COMM) %>% 
  mutate(data = map2(data, GEOG_COMM, ~ filter(.x, GEOGRAPHY_COMMUNITY_ID %in% .y | GEOGRAPHY_TYPE %in% c("county", "community")))) %>% 
  unnest() %>% 
  mutate(GEOG_COMM = case_when(
    GEOG_COMM %in% "WC" ~ "White Center",
    GEOG_COMM %in% "RV" ~ "Rainier Valley",
    GEOG_COMM %in% "STC_TUK" ~ "Seatac/Tukwila"
  )) %>% 
  filter(GEOGRAPHY_TYPE %in% c("tract","county") | GEOG_COMM == GEOGRAPHY_NAME)

# PLOT: HOUSING MARKET ------------------------------------------------

showtext_auto()

show_comm_hist <- function(x, y_axis_title, legend_position){   
  
  comm_name <- unique(x$GEOG_COMM)
  
  dollar_short <- function(x){
    if(is.na(x)){NA_character_} else 
      if(x>=1e6) {dollar_format(accuracy = 1,suffix = "M")(x/1e6)} else
        if(between(x,1e3,1e6-1)) {dollar_format(accuracy = 1,suffix = "k")(x/1e3)} else
          if(between(x,0,1e3-1)){ dollar_format(accuracy = 1,suffix = "")(x)} else 
            stop("Oops")
  }
  
  
  varied_labels <- function(x) {   
    
    if(max(x, na.rm = TRUE) > 1000){
      map_chr(x, dollar_short)
    }else 
      if (max(x, na.rm = TRUE) > 5){
      dollar_format(accuracy = 1, suffix = "/sqft")(x)
    }else
     if(max(x, na.rm = TRUE) > 1){
       percent_format(accuracy = 1,prefix = "+")(x) %>% str_replace_all("\\+\\-","\\-")
     }else{
      percent_format(accuracy = 1, prefix = "", suffix = "%")(x)
    } 
  }
  
  dat_housmrkt_tr_no_outliers %>% 
    filter(!is.na(VAL)) %>% 
    ggplot2::ggplot(ggplot2::aes(x = VAL)) + 
    ggplot2::geom_histogram(fill = colors_nct$grey) +
    ggplot2::geom_vline(data = x, 
                        aes(xintercept = VAL, 
                            color = GEOG_TYPE_FCT, 
                            size = GEOG_TYPE_FCT, 
                            alpha = GEOG_TYPE_FCT,
                            linetype = GEOG_TYPE_FCT)) +
    scale_color_manual(values = c(colors_nct_list$`Early Type 2`,
                                  colors_nct_list$`Early Type 2`,
                                  colors_nct_list$Late)) + 
    scale_size_manual(values = c(0.5,1,1)) +
    scale_alpha_manual(values = c(.75,1,1)) +
    scale_linetype_manual(values = c(1,6,1)) +  
    facet_wrap(~ VAR, ncol = 1, scales = "free_x") +
    scale_x_continuous(labels = varied_labels) +
    theme_nct_8 +
    labs(y = y_axis_title,
         x = "",
         title = comm_name) +
    theme(legend.position = legend_position,
          legend.direction="horizontal",
          legend.text = element_text(hjust = 0.5),
          legend.spacing.x = unit(2, "pt"),
          legend.key.width = unit(30, "pt"),
          legend.key.height = unit(12, "pt"),
          legend.title = element_blank(),
          strip.background = element_blank(), 
          strip.placement = "outside")
}


dat_housmrkt_list_by_comm <- group_split(dat_housmrkt_lines_by_comm, GEOG_COMM)

pmap(list(x = dat_housmrkt_list_by_comm,
          y_axis_title = c("# of Census Tracts","",""),
          legend_position = c("none","bottom","none")), 
     show_comm_hist) %>% 
  wrap_plots(nrow = 1) +
  plot_annotation(title = "Housing Market Indicators by COO Community (2018)",
                  subtitle = "",
                  caption = wrapper("Source: author's analysis of data from American Community Survey 
                                  \nNote: Some outliers have been transformed to enhance the clarity of the grahic. Median rent price at the community level is not calculated. The gray bars show the amount of census tracts at each part of the x-axis."),
                  theme = theme_nct)




