library(tidyverse)
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")

## Question 1 ----- 
## Calculate mean life expectancy on each continent. Then create a plot that shows how life expectancy has changed over time in each continent. 
gapminder %>% 
  group_by(continent) %>%
  summarize(mean_lifeExp = mean(lifeExp))

gapminder %>%
  group_by(continent, year) %>%
  summarize(mean_lifeExp = mean(lifeExp)) %>%
  ggplot(aes(x = year, y = mean_lifeExp, color = continent)) +
  geom_point() +
  geom_line() +
  facet_wrap(~continent, ncol = 2)


## Question 2 -----
## What do you think the scale_x_log10() line of code is achieving? What about the geom_smooth() line of code?

## The scale_x-log10() command transforms the x axis to the base10 logarithmic scale. The geom_smooth command plots a line that is the average of the variation in data and therefore "smoother."


## Question 3 -----
## Create a boxplot that shows the life expectancy for Brazil, China, El Salvador, Niger, and the United States, with the data points in the background using geom_jitter. Label the X and Y axis “Country” and “Life Expectancy” and title the plot “Life Expectancy of Five Countries”.
gapminder %>%
  ggplot(data = gapminder[gapminder$country %in% c('Brazil', 'China', 'El Salvador', 'Niger', 'United States'),], 
         mapping = aes(x = country, y = lifeExp)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.3) +
  scale_x_discrete(name = 'Country') +
  scale_y_continuous(name = 'Life Expectancy') +
  ggtitle("Life Expectancy of Five Countries") +
  theme_bw()

# OR

countries <- c("Brazil", "China", "El Salvador", "Niger", "United States")

gapminder %>% 
  filter(country %in% countries) %>% 
  ggplot(aes(x = country, y = lifeExp))+
  geom_boxplot() +
  geom_jitter(alpha = 0.3, color = "blue")+
  theme_minimal() +
  ggtitle("Life Expectancy of Five Countries")
  theme(plot.title = element_text(hjust = 0.5))
  xlab("Country") + ylab("Life Expectancy")

## Challenge ----- 
## Modify the below code to size the points in proportion to the population of the country.
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop)) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()
