surveys <- read.csv("data/portal_data_joined.csv")
glimpse(surveys)

## Question 1 -----
## Using a for loop, print to the console the longest species name of each taxon.
for(i in unique(surveys$taxa)){
  taxanames <- surveys[surveys$taxa == i, ]
  longtaxon <- taxanames[nchar(taxanames$species) == max(nchar(taxanames$species)),] |>
    select(species)
  print(paste0("The longest species name(s) among ", i, "s is/are: "))
  print(unique(longtaxon$species))
}

## Question 2 -----
## Use the map function from purrr to print the max of each of the following columns: “windDir”,“windSpeed_m_s”,“baro_hPa”,“temp_C_2m”,“temp_C_10m”,“temp_C_towertop”,“rel_humid”,and “precip_intens_mm_hr”.

mloa <- read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
glimpse(mloa)

maxval <- mloa |>
  select("windDir","windSpeed_m_s","baro_hPa","temp_C_2m",
         "temp_C_10m","temp_C_towertop","rel_humid", "precip_intens_mm_hr") |>
  map(max, na.rm = TRUE)


## Question 3 -----
## Make a function called C_to_F that converts Celsius to Fahrenheit. Hint: first you need to multiply the Celsius temperature by 1.8, then add 32. Make three new columns called “temp_F_2m”, “temp_F_10m”, and “temp_F_towertop” by applying this function to columns “temp_C_2m”, “temp_C_10m”, and “temp_C_towertop”.
C_to_F <- function(tempF) {
  return((tempC * 1.8) + 32)
}

mloa1 <- mloa |>
  mutate(temp_F_2m = C_to_F(mloa$temp_C_2m), 
         temp_F_10m = C_to_F(mloa$temp_C_10m), 
         temp_F_towertop = C_to_F(mloa$temp_C_towertop))
glimpse(mloa1)


## Bonus -----
## Do the above by using map_df. Don’t forget to name your new columns “temp_F…” and not “temp_C…”!
mloa2 <- mloa |>
  select("temp_C_2m", "temp_C_10m","temp_C_towertop") |>
  map_df(C_to_F) |>
  rename("temp_F_2m"="temp_C_2m", "temp_F_10m"="temp_C_10m", "temp_F_towertop"="temp_C_towertop") |>
  cbind(mloa)

## CHALLENGE -----
## Use lapply to create a new column of the surveys dataframe that includes the genus and species name together as one string.

surveys$genusspecies <- lapply(1:length(surveys$species), function(i){
  paste0(surveys$genus[i], " ", surveys$species[i])
})
