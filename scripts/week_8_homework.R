mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
glimpse(mloa)

## Question 1 -----
## Remove observations with missing values in rel_humid, temp_C_2m, and windSpeed_m_s.
## Question 2 -----
## Generate a column called “datetime” using the year, month, day, hour24, and min columns. Next, create a column called “datetimeLocal” that converts the datetime column to Pacific/Honolulu time.

mloa1 <- mloa |>
  filter(rel_humid != -99) |>
  filter(temp_C_2m != -999.9) |>
  filter(windSpeed_m_s != -999.9)
  mutate(datetime = ymd_hm(paste0(year, "-", month, "-", day, " ", 
                                  hour24, ":", min), tz = "UTC")) |>
  mutate(datetimeLocal = with_tz(datetime, tzone = "Pacific/Honolulu"))

## Question 3 -----
## Use dplyr to calculate the mean hourly temperature each month using the temp_C_2m column and the datetimeLocal columns.
## Question 4 -----
## Make a ggplot scatterplot of the mean monthly temperature, with points colored by local hour.

mloa1 |>
    mutate(localMon = month(datetimeLocal, label = TRUE),
           localHour = hour(datetimeLocal)) |>
    group_by(localMon, localHour) |>
    summarize(meantemp = mean(temp_C_2m)) |>
    ggplot(aes(x = localMon, y = meantemp)) +
    geom_point(aes(color = localHour)) +
    scale_color_viridis_c(option = "magma") +
    ggtitle("Mean Hourly Temperature by Month") +
    labs(color = "Hour (24h)") +
    xlab("Month") +
    ylab("Temperature (\u00B0C)") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  