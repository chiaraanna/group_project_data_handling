# ------------------------------------------------------------------------------
# AUTHOR:  Leroy Zahno
# DATE:    2026-10-31
# ------------------------------------------------------------------------------

# SETUP -------------------------------------------------------------------
library(httr2)
library(dplyr)


# 2.1.1 Retrieve data using your own API wrapper --------------------------
  
get_ilodata <- function(dataset_identifier, year_from, year_to, country = ""){
  if (country == ""){
    country <- "AFG+ZWE+YEM+ZMB+WLF+VNM+VEN+VUT+UZB+URY+VIR+USA+GBR+ARE+UKR+UGA+TUV+TCA+TKM+TUR+TUN+TTO+TON+TKL+TGO+TLS+TZA+THA+TJK+TWN+SYR+CHE+SWE+SUR+SDN+LKA+ESP+SSD+ZAF+SOM+SLB+SVN+SVK+SGP+SLE+SYC+SRB+SEN+SAU+STP+SMR+WSM+LCA+VCT+KNA+SHN+REU+RWA+RUS+ROU+QAT+PRI+PRT+POL+PER+PHL+PRY+PNG+PLW+PAN+PAK+OMN+PSE+NOR+MNP+MKD+NFK+NIU+NGA+NER+NIC+NZL+NCL+ANT+NLD+NPL+NRU+NAM+MMR+MOZ+MAR+MSR+MNE+MNG+MCO+MDA+FSM+MEX+MUS+MRT+MTQ+MHL+MLT+MLI+MDV+MWI+MYS+MDG+MAC+LUX+LTU+LBY+LIE+LBR+LSO+LBN+LVA+LAO+KGZ+KWT+KOS+KOR+KIR+KEN+KAZ+JOR+JEY+JPN+JAM+ITA+IMN+ISR+IRL+IRQ+IRN+IDN+IND+ISL+HUN+HKG+HND+HTI+GUY+GNB+GIN+GGY+GTM+GUM+GLP+GRD+GRL+GRC+GIB+GHA+DEU+GEO+GMB+GAB+PYF+GUF+FRA+FIN+FJI+FLK+FRO+ETH+SWZ+EST+GNQ+SLV+EGY+ECU+DOM+DMA+DJI+DNK+CIV+CZE+CYP+CUW+CUB+HRV+CRI+COK+COD+COG+COM+COL+CHN+CHL+TCD+CAF+CYM+CPV+CAN+CMR+KHM+BDI+BFA+BGR+BRN+VGB+BRA+BWA+BIH+BOL+BTN+BMU+BEN+BLZ+BEL+BLR+BRB+BGD+BHR+BHS+AZE+AUT+AUS+ABW+ARM+ARG+ATG+AIA+AGO+AND+ASM+DZA+ALB"
  }
  host_url <- "https://sdmx.ilo.org/rest/data/"
  agency <- "ILO"
  dataset_verison <- "1.0"
  query_url <- paste0(host_url,
                      agency, ",", 
                      dataset_identifier, ",", 
                      dataset_verison, "/", 
                      country, 
                      ".A..SEX_F.AGE_10YRBANDS_Y45-54?", 
                      "startPeriod=", year_from, "&",
                      "endPeriod=", year_to, "&",
                      "dimensionAtObservation=AllDimensions&",
                      "format=csvfilewithlabels")
  
  req <- request(query_url)
  resp <- req_perform(req) # Returns an error message, if the request fails and stops execution
  df <- read.csv(query_url) |> 
    select("Reference.area", "Sex", "TIME_PERIOD", "OBS_VALUE") |>
    rename(Country = Reference.area,
           Gender = Sex,
           Year = TIME_PERIOD,
           Value = OBS_VALUE
    )
}


# TESTING -----------------------------------------------------------------

# all_countries_data <- get_ilodata("DF_EAP_DWAP_SEX_AGE_RT", 1950, 2025)
# switzerland_data <- get_ilodata("DF_EAP_DWAP_SEX_AGE_RT", 1950, 2025, "CHE")
# incorrect_url <- get_ilodata("falserequest", 1950, 2025)
