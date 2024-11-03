## Data Visualization 1a: ggplot
## Grammar of Graphics is a tidyverse plotting package that makes plots. 
## Plot are made from 3 components: data, coordinate system (what gets mapped), and geoms (how to graphical represent the data)
## Syntax... ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPING>))

library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv") %>%
  filter(complete.cases(.)) 
surveys


# Geom Commands -----
## Commands in "ggplot" alter graphics for the entire dataset while "geom" alters graphics for only the specified data

## Specific geom settings
ggplot(data = surveys, mapping = aes(x = weight, y= hindfoot_length)) +
  geom_point(aes(color = genus)) +
  geom_smooth(aes(color = genus))

## Universal geom settings
ggplot(data = surveys, mapping = aes(x = weight, y= hindfoot_length, color=genus)) +
  geom_point() +
  geom_smooth()

# Box Plots ----- 
## geom_boxplot creates a box plot, order of commands defines what is on the top layer = last command
## Various graphic commands include geom_jitter (helps with overplotting), alpha (transparency), color (colors outline), fill (colors inside), etc
sum_weight <- summary(surveys$weight)
surveys_wt_cat <- surveys %>% 
  mutate(weight_cat = case_when(
    weight <= sum_weight[[2]] ~ "small", 
    weight > sum_weight[[2]] & weight < sum_weight[[5]] ~ "medium",
    weight >= sum_weight[[5]] ~ "large"
  )) 
table(surveys_wt_cat$weight_cat)


ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_point(aes(color = weight_cat))
ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_boxplot(aes(color = weight_cat))

## Additional options
ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_boxplot(aes(color = "orange"))
ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_boxplot(aes(fill = "orange"))

ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_boxplot(aes(color = weight_cat, alpha = 0.8)) +
  geom_jitter(alpha = 0.1)

# What if we want to switch order of weight_cat? factor!
surveys_wt_cat$weight_cat <- factor(surveys_wt_cat$weight_cat, c("small", "medium", "large"))



## Data Visualization 1b: Time Series -----

library(tidyverse)
surveys_complete <- read_csv("data/portal_data_joined.csv") %>%
  filter(complete.cases(.)) 
surveys_complete

# these are two different ways of doing the same thing
head(surveys_complete %>% count(year, species_id))
head(surveys_complete %>% group_by(year, species_id) %>% tally())

yearly_counts <- surveys_complete %>% count(year, species_id)

ggplot(data = yearly_counts, mapping = aes(x = year, y=n, group = species_id)) +
  geom_line() +
  geom_point()
ggplot(data = yearly_counts, mapping = aes(x = year, y=n, color = species_id)) +
  geom_line() +
  geom_point()

## facet_grid specifies x/y grid, facet_wrap creates multiple graphs
ggplot(data = yearly_counts, mapping = aes(x = year, y=n, color = species_id)) +
  geom_line() +
  facet_wrap(~species_id)

ggplot(data = yearly_counts, mapping = aes(x = year, y=n, color = species_id)) +
  geom_line() +
  facet_wrap(~species_id, scales = 'free')

ggplot(data = yearly_counts[yearly_counts$species_id %in% c('BA', 'DM', 'DO', 'DS'),], mapping = aes(x = year, y=n, group = species_id)) +
  geom_line() +
  facet_wrap(~species_id, scales = 'free_y', ncol = 1) +
  scale_y_continuous(name = 'obs', n.breaks = 12, breaks = seq(0,600,100)) +
  theme_bw()



library(ggthemes)
library(tigris) #US Census geodatabase
library(sf)

ca_counties = tigris::counties(state = 'CA', class = 'sf')
ggplot(data = ca_counties) + geom_sf(aes(fill=AWATER)) + theme_map()
