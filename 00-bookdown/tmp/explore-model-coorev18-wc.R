
# SETUP -------------------------------------------------------------------

source("00-bookdown/R/setup.R",echo = FALSE)

# LOAD DATA ---------------------------------------------------------------

coorev18_wc <- readr::read_rds("00-bookdown/data/model-all-20190305.rds") %>% 
  select(matches("GEOGRAPHY"), COOREV18_SF_TYPE) %>%  
  filter(GEOGRAPHY_COMMUNITY_NAME %in% "White Center") %>% 
  filter(GEOGRAPHY_TYPE %in% "tract") %>% 
  as_tibble() 

type_cnt <- coorev18_wc %>% 
  count(COOREV18_SF_TYPE) %>% 
  mutate(COOREV18_SF_TYPE_FCT = fct_rev(factor(COOREV18_SF_TYPE, levels = typology_levels))) %>% 
  filter(!is.na(COOREV18_SF_TYPE_FCT))
  

coorev18_cnt <- coorev18 %>%  
  count(COOREV18_SF_TYPE) %>% 
  mutate(COOREV18_SF_TYPE_FCT = fct_rev(factor(COOREV18_SF_TYPE, levels = typology_levels))) %>% 
  filter(!is.na(COOREV18_SF_TYPE_FCT))

coorev18_mf <- readr::read_rds("00-bookdown/data/model-all-20190305.rds") %>% 
  select(matches("GEOGRAPHY"), COOREV18_MF_TYPE) %>%  
  as_tibble() 

lvls <- tibble(COOREV18_MF_TYPE_FCT = fct_rev(factor(typology_levels, levels = typology_levels)))


coorev18_cnt_mf <- coorev18_mf %>%   
  count(COOREV18_MF_TYPE ) %>%  
  mutate(COOREV18_MF_TYPE_FCT = fct_rev(factor(COOREV18_MF_TYPE, levels = typology_levels))) %>% 
  filter(!is.na(COOREV18_MF_TYPE_FCT)) %>% 
  right_join(lvls) %>% 
  mutate(n = if_else(is.na(n),as.integer(0),n))


# PLOT --------------------------------------------------------------------

# showtext_auto()
# 
# grDevices::windows()

p1 <- ggplot(data = coorev18_cnt,
             aes(x = COOREV18_SF_TYPE_FCT, y = n))
p1 <- p1 + geom_bar(aes(fill = COOREV18_SF_TYPE_FCT),stat = "identity")
# p1 <- p1 + geom_segment(aes(x = COOREV18_SF_TYPE_FCT, y = 0, xend = COOREV18_SF_TYPE_FCT, yend = n), 
#                         color = colors_nct$darkgrey,
#                         size = 1) 
# p1 <- p1 + geom_point(aes(fill = COOREV18_SF_TYPE_FCT),
#                       color = colors_nct$darkgrey,
#                       shape = 21,
#                       # fill = "red",
#                       size = 5,
#                       stroke = 1.5)
p1 <- p1 + scale_discrete_nct("fill")
p1 <- p1 + scale_y_continuous(breaks = seq(0,70,by = 10))
p1 <- p1 + coord_flip()
p1 <- p1 + theme_nct
p1 <- p1 +labs(y = "Census Tracts")
p1 <- p1 + theme(
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_line(size = 0.5),
  panel.grid.minor.x = element_blank(), 
  axis.title.y = element_blank(),
  legend.position = "none")

p1


# PLOT --------------------------------------------------------------------

# showtext_auto()
# 
# grDevices::windows()

p1 <- ggplot(data = coorev18_cnt_mf,
             aes(x = COOREV18_MF_TYPE_FCT, y = n))
p1 <- p1 + geom_bar(aes(fill = COOREV18_MF_TYPE_FCT), stat = "identity")
# p1 <- p1 + geom_segment(aes(x = COOREV18_SF_TYPE_FCT, y = 0, xend = COOREV18_SF_TYPE_FCT, yend = n), 
#                         color = colors_nct$darkgrey,
#                         size = 1) 
# p1 <- p1 + geom_point(aes(fill = COOREV18_SF_TYPE_FCT),
#                       color = colors_nct$darkgrey,
#                       shape = 21,
#                       # fill = "red",
#                       size = 5,
#                       stroke = 1.5)
p1 <- p1 + scale_discrete_nct("fill")
p1 <- p1 + scale_y_continuous(breaks = seq(0,70,by = 10))
p1 <- p1 + coord_flip()
p1 <- p1 + theme_nct
p1 <- p1 +labs(y = "Census Tracts")
p1 <- p1 + theme(
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_line(size = 0.5),
  panel.grid.minor.x = element_blank(), 
  axis.title.y = element_blank(),
  legend.position = "none")

p1
