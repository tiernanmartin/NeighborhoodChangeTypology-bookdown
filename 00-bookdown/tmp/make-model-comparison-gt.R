
# SETUP -------------------------------------------------------------------

source("00-bookdown/R/setup.R",echo = FALSE)

# LOAD DATA ---------------------------------------------------------------

comp_tbl <- readr::read_csv("00-bookdown/data/model-comparison-table-20190306.csv")  %>% 
  rename(groupname = MODEL)


# PLOT --------------------------------------------------------------------

comp_tbl %>% 
  gt() %>% 
  gt::tab_style(gt::cells_styles(bkgd_color = '#FFFFFF'), gt::cells_data(gt::everything()))
