library(tidyverse)
library(ggplot2)
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")

str(gapminder)

## Question 1 -----
popchange <- gapminder |>
  select(continent, country, year, pop) |>
  filter(year == c(2002, 2007)) |>
  pivot_wider(names_from = year, values_from = pop) |>
  mutate(pop_change_0207 = `2007` - `2002`)
popchange

ggplot(data = popchange[popchange$continent %in% c('Africa', 'Americas', 'Asia', 'Europe'),], mapping = aes(x = reorder(country, pop_change_0207), y = pop_change_0207)) +
  geom_col(aes(fill = continent)) +
  facet_wrap(~continent, scales = 'free') +
  theme_bw() +
  scale_fill_viridis_d() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  xlab("Country") +
  ylab("Change in Population Between 2002 and 2007")


# OR
popchange |>
  filter(continent != "Oceania") |>
  ggplot(aes(x = reorder(country, pop_change_0207), y = pop_change_0207)) + ...
