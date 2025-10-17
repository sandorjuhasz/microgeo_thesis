### packages
library(data.table)
library(dplyr)


### 01 -- OPTEN data pieces -- showcase
### 02 -- Skill relatedness and input-output relatedness -- showcase




### 01 -- OPTEN data pieces -- showcase

# opten -- firm registry
rdf <- fread("../data/opten_ENG/opten_firm_registry.csv")


### opten -- annual reports
adf <- fread("../data/opten_ENG/opten_annual_report.csv")


### opten -- plant locations data
plant_loc <- fread("../data/opten_ENG/opten_plant_locations.csv")


### opten -- ownership data
ownership <- fread("../data/opten_ENG/opten_ownership.csv")


### opten -- foreign, final ownership
foreign_ownership <- fread("../data/opten_ENG/opten_foreign_ownership.csv")




### 02 -- Skill relatedness and input-output relatedness -- showcase
# Skill relatedess is the normalized labor flow between industries. Input-output relatedness is the normalized flow of money between industries.

# skill relatedness
sr_df <- fread("../data/skill_relatedness_edgelist_2015_2017.csv")

# input-output relatedness
io_df <- fread("../data/io_relatedness_edgelist_2015_2017.csv")





### 03 -- Location, industry aggregation
# Create a table for location, industry and number of firms, total number of employees.
# Location could be region, district, street or smaller.
# Industry categorization is available as 5 digit NACE codes in the main_activity_code column.

# opten -- firm registry
rdf <- fread("../data/opten_ENG/opten_firm_registry.csv")

# example -- lets choose district 9 in Budapest
test_df <- subset(rdf, hq_city == "Budapest")
test_df$district <- substr(test_df$hq_postcode, 2, 3)
test_df <- subset(test_df, district == "09")

# lets focus on firms with min 2 employees
test_df <- subset(test_df, employees_2019 >= 2)

# keep 2 digit industry codes (NACE codes)
test_df$NACE2 <- test_df$main_activity_code %/% 1000
test_df$NACE3 <- test_df$main_activity_code %/% 100
test_df$NACE4 <- test_df$main_activity_code %/% 10

# aggregation example
agg_df <- test_df %>%
  group_by(hq_street_name, NACE3) %>%
  summarise(
    nr_firms = n_distinct(firm_id_opten),
    total_emp = sum(employees_2019)
  ) %>%
  data.table()

