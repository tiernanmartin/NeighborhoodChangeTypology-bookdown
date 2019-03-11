# SETUP -------------------------------------------------------------------

source("00-bookdown/R/setup.R",echo = FALSE)

# LOAD DATA ---------------------------------------------------------------

coorev18 <- readr::read_rds("00-bookdown/data/model-all-20190305.rds") %>% 
  select(matches("GEOGRAPHY"), matches("COOREV18")) %>%  
  as_tibble() 

# GT ---------------------------------------------------------------

format_pctpt <- function(x){
  case_when(
    x == 0 ~ "0%",
    x > 0 ~ scales::percent_format(accuracy = 1,prefix = "+",suffix = "%pts.")(x),
    x < 0 ~  scales::percent_format(accuracy = 1,prefix = "",suffix = "%pts.")(x)
  )
}

coorev18_dat <- 
coorev18 %>% 
  filter(!is.na(GEOGRAPHY_COMMUNITY_NAME)) %>% 
  filter(GEOGRAPHY_TYPE %in% "tract") %>% 
  mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME, ", King County, Washington")) %>% 
  mutate(GEOGRAPHY_NAME = str_remove(GEOGRAPHY_NAME, "Census ")) %>% 
  select(GEOGRAPHY_NAME, 
         GEOGRAPHY_COMMUNITY_NAME,
         COOREV18_VULN_POC_EST_PCT_2013_2017,
         COOREV18_VULN_LOWED_EST_PCT_2013_2017, 
         COOREV18_VULN_LOWINCAMI_EST_PCT_2011_2015,
         COOREV18_VULN_RENTHH_EST_PCT_2013_2017,
         COOREV18_DEMOCHNG_HIGHED_DIFF_PCT_2007_2011_TO_2013_2017,
         COOREV18_DEMOCHNG_INCOME_DIFF_MED_2007_2011_TO_2013_2017,
         COOREV18_DEMOCHNG_WHITE_DIFF_PCT_2007_2011_TO_2013_2017,
         COOREV18_DEMOCHNG_OWNHH_DIFF_PCT_2007_2011_TO_2013_2017,
         COOREV18_HOUSMRKT_RENTPRICE_EST_MED_2013_2017,
         COOREV18_HOUSMRKT_SFHOMEVALKC_EST_MED_2018_2018,
         COOREV18_HOUSMRKT_SFSALEPRICESQFT_EST_MED_2018_2018,
         COOREV18_HOUSMRKT_SFHOMEVALKC_DIFF_MED_2010_2010_TO_2018_2018,
         COOREV18_HOUSMRKT_SFSALEPRICESQFT_DIFF_MED_2010_2010_TO_2018_2018,
         COOREV18_HOUSMRKT_SFSALERATE_EST_PCT_2016_2018) %>% 
   mutate_at(vars(matches("EST_PCT")),scales::percent_format(accuracy = 1)) %>% 
  mutate_at(vars(matches("DIFF_PCT")),format_pctpt) %>% 
  mutate_at(vars(matches("DIFF_MED")),scales::percent_format(accuracy = 1)) %>%  
  rename("POC '13-'17" = COOREV18_VULN_POC_EST_PCT_2013_2017,
         "LOWED '13-'17" = COOREV18_VULN_LOWED_EST_PCT_2013_2017, 
         "LOWINC '11-'15" = COOREV18_VULN_LOWINCAMI_EST_PCT_2011_2015,
         "RENTHH '13-'17" = COOREV18_VULN_RENTHH_EST_PCT_2013_2017,
         "HIGHED '07-'17" = COOREV18_DEMOCHNG_HIGHED_DIFF_PCT_2007_2011_TO_2013_2017,
         "MEDIANINC '07-'17" = COOREV18_DEMOCHNG_INCOME_DIFF_MED_2007_2011_TO_2013_2017,
         "WHITE '07-'17" = COOREV18_DEMOCHNG_WHITE_DIFF_PCT_2007_2011_TO_2013_2017,
         "OWNHH '07-'17" = COOREV18_DEMOCHNG_OWNHH_DIFF_PCT_2007_2011_TO_2013_2017,
         RENTPRICE = COOREV18_HOUSMRKT_RENTPRICE_EST_MED_2013_2017,
         HOMEVAL = COOREV18_HOUSMRKT_SFHOMEVALKC_EST_MED_2018_2018,
         SALEPRICESQFT = COOREV18_HOUSMRKT_SFSALEPRICESQFT_EST_MED_2018_2018,
         "HOMEVALAPPR '10-'18" = COOREV18_HOUSMRKT_SFHOMEVALKC_DIFF_MED_2010_2010_TO_2018_2018,
         "SALEPRICESQFTAPPR '10-'18" = COOREV18_HOUSMRKT_SFSALEPRICESQFT_DIFF_MED_2010_2010_TO_2018_2018,
         "SALERATE '16-'18" = COOREV18_HOUSMRKT_SFSALERATE_EST_PCT_2016_2018) %>% 
  mutate(RENTPRICE = dollar(RENTPRICE),
         HOMEVAL = dollar(HOMEVAL),
         SALEPRICESQFT = as.character(glue("{dollar(SALEPRICESQFT)}/sqft"))) %>% 
  rename("RENTPRICE '13-'17" = RENTPRICE,
         "HOMEVAL '18" = HOMEVAL,
         "SALEPRICESQFT '18" = SALEPRICESQFT)

vulndemo <- coorev18_dat %>% select(-matches("PRICE|VAL|RATE"))

hous <- coorev18_dat %>% select(matches("GEOG"),
                                matches("PRICE|VAL|RATE"))

gt_vulndemo <- vulndemo %>% 
  group_by(GEOGRAPHY_COMMUNITY_NAME) %>%  
gt(rowname_col = "GEOGRAPHY_NAME") %>% 
   tab_spanner(
    label = md("VULNERABILITY"),
    columns = vars("POC '13-'17" , "LOWED '13-'17", "LOWINC '11-'15", "RENTHH '13-'17")
  ) %>%  
   tab_spanner(
    label = md("DEMOGRAPHIC CHANGE"),
    columns = vars("HIGHED '07-'17", "MEDIANINC '07-'17", "WHITE '07-'17", "OWNHH '07-'17")
  ) 
  
 gt_hous <-  hous %>% 
  group_by(GEOGRAPHY_COMMUNITY_NAME) %>%   
    gt(rowname_col = "GEOGRAPHY_NAME") %>% 
   tab_spanner(
    label = md("HOUSING MARKET"),
    columns = vars("RENTPRICE '13-'17",  "HOMEVAL '18",  "SALEPRICESQFT '18", "HOMEVALAPPR '10-'18", "SALEPRICESQFTAPPR '10-'18", "SALERATE '16-'18")
  )


