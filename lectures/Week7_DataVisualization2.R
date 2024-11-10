library(tidyverse)
library(ggplot2)

# Data Visualization 2a: Plot Best Practices and GGPlot Review
## ggplot has four parts:
#data        ggplot(data=yourdata)
#plot type   geom_...
#aesthetics  aes()
#stats       stat_...

## Plot Best Practices ----- 
## Remove backgrounds, redundant labels, borders ; Reduce colors and special effects ; Remove bolding, lighten labels, remove lines, direct label

# Original code
ggplot(diamonds, aes(x= carat, y= price)) + 
  geom_point()
# All-over color
ggplot(diamonds, aes(x= carat, y= price)) +
  geom_point(color="blue")
# Color by variable
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2)

## Applying Plot Best Practices
# Adding a title and x/y labels
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $")

# Adding linear regression trend lines for each color
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $") + 
  stat_smooth(method = "lm")

## Color Palette Choices and Color-Blind Friendly Visualizations ----- 
# https://www.nature.com/articles/s41467-020-19160-7
# https://research.google/blog/turbo-an-improved-rainbow-colormap-for-visualization

## Types of Palettes:
# 1. Continuous
# 2. Ordinal: For showing least to most of something w zero at one end
# 3. Qualitative: For showing different categories that are non-ordered
# 4: Diverging: For showing a range of negative to positive values w zero in middle

## RColorBrewer has a collection of colorblind-friendly discrete color palettes
# Use with command scale_fill_brewer(palette = "palette name")
library("RColorBrewer")
display.brewer.all(colorblindFriendly = TRUE)

## CONTINUOUS ... Use scale_fill_viridis_c or scale_color_viridis_c 
# Set direction = -1 to reverse the direction of the colorscale
# Options have different color palettes
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_c(option = "A", direction = -1)
#To bin continuous data, use the suffix "_b" instead
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_b(option = "C", direction = -1)

## ORDINAL (Discrete Sequential)... Use scale_fill_viridis_d,scale_color_viridis_d
ggplot(diamonds, aes(x= cut, y= carat, fill = color)) +
  geom_boxplot() + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_fill_viridis_d("color")
# Note: Have to change the aes parameter from "fill =" to "color =" to match
ggplot(diamonds, aes(x= cut, y= carat, color = color)) +
  geom_boxplot(alpha = 0.2) + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_color_viridis_d("color")

## Adjusting Axis/Title Placement
ggplot(diamonds, aes(x = clarity, fill = cut)) + 
  geom_bar() +
  ggtitle("Clarity of Diamonds") +
  theme_classic() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5),
        plot.title = element_text(hjust = 0.5)) +
  scale_fill_viridis_d("cut", option = "B")


## QUALITATIVE CATEGORICAL
## From RColorBrewer:
ggplot(iris, 
       aes(x= Sepal.Length, y= Petal.Length, fill = Species)) +
  geom_point(shape=22, colour="black") + theme_classic() + 
  ggtitle("Sepal and Petal Length of Three Iris Species") + 
  scale_fill_brewer(palette = "Set2")

## From ggthemes package:
library(ggthemes)
ggplot(iris, aes(x= Sepal.Length, y= Petal.Length, color = Species)) +
  geom_point() + theme_classic() + 
  ggtitle("Sepal and Petal Length of Three Iris Species") + 
  scale_color_colorblind("Species") +
  xlab("Sepal Length in cm") + 
  ylab("Petal Length in cm")

## Manual Palette Design:
# Create a named vector of colors and use it as a manual fill.
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7")
names(cbPalette) <- levels(iris$Species)
# Don't need all the colors in the palette because there are only 3 categories, cut the vector length to 3
cbPalette <- cbPalette[1:length(levels(iris$Species))]

ggplot(iris, aes(x= Sepal.Length, y= Petal.Length, color = Species)) +
  geom_point() + theme_classic() + 
  ggtitle("Sepal and Petal Length of Three Iris Species") + 
  scale_color_manual(values = cbPalette) +
  xlab("Sepal Length in cm") + 
  ylab("Petal Length in cm")


## DIVERGING DISCRETE
myiris <- iris %>% group_by(Species) %>% mutate(size = case_when(
  Sepal.Length > 1.1* mean(Sepal.Length) ~ "very large",
  Sepal.Length < 0.9 * mean(Sepal.Length) ~ "very small",
  Sepal.Length < 0.94 * mean(Sepal.Length) ~ "small",
  Sepal.Length > 1.06 * mean(Sepal.Length) ~ "large",
  T ~ "average"
))
myiris$size <- factor(myiris$size, levels = c(
  "very small", "small", "average", "large", "very large"
))

ggplot(myiris, aes(x= Petal.Width, y= Petal.Length, color = size)) +
  geom_point(size = 2) + theme_gray() +
  ggtitle("Petal Size and Sepal Length") + 
  scale_color_brewer(palette = "RdYlBu")

# PaulTol also has developed qualitative, sequential, and diverging colorblind palettes:
#https://cran.r-project.org/web/packages/khroma/vignettes/tol.html
#you can enter the hex codes in manually just like the cbPalette example above

# Also check out the turbo color palette!
#https://docs.google.com/presentation/d/1Za8JHhvr2xD93V0bqfK--Y9GnWL1zUrtvxd_y9a2Wo8/edit?usp=sharing
#https://blog.research.google/2019/08/turbo-improved-rainbow-colormap-for.html
# To download it and use it in R, use this link
#https://rdrr.io/github/jlmelville/vizier/man/turbo.html


## Non-Visual Representations -----
## Braille package
mybarplot <- ggplot(diamonds, aes(x = clarity)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5)) +
  theme_classic() + ggtitle("Number of Diamonds by Clarity")
mybarplot

library(BrailleR)
VI(mybarplot)

library(sonify)
plot(iris$Petal.Width)
sonify(iris$Petal.Width)

detach("package:BrailleR", unload=TRUE)



# Data Visualization 2b: Publishing Plots and Saving Figures & Plots
## You can print multiple plots together, which is helpful for publications

library(cowplot)
## Make a few plots:
# plot.diamonds
plot.diamonds <- ggplot(diamonds, aes(clarity, fill = cut)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5))
#plot.cars
plot.cars <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + 
  geom_point(size = 2.5)
#plot.iris
plot.iris <- ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, fill=Species)) + geom_point(size=3, alpha=0.7, shape=21)

## Use plot_grid
panel_plot <- plot_grid(plot.cars, plot.iris, plot.diamonds,
                        labels = c("A", "B", "C"), ncol = 2, nrow = 2)
panel_plot

## You can fix the sizes for more control over the result
fixed_gridplot <- ggdraw() + draw_plot(plot.iris, x = 0, y = 0, width = 1, height = 0.5) +
  draw_plot(plot.cars, x=0, y=.5, width=0.5, height = 0.5) +
  draw_plot(plot.diamonds, x=0.5, y=0.5, width=0.5, height = 0.5) + 
  draw_plot_label(label = c("A","B","C"), x = c(0, 0.5, 0), y = c(1, 1, 0.5))
fixed_gridplot

## Saving Figures -----
## You can save images as .png, .jpeg, .tiff, .pdf, .bmp, or .svg
# For publications, use dpi of at least 700
ggsave("figures/gridplot.png", fixed_gridplot)

ggsave("figures/gridplot.png", fixed_gridplot, 
       width = 6, height = 4, units = "in", dpi = 700)

## Interactive Web Applications
library(plotly)

plot.iris <- ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, 
                                   fill=Species)) +
  geom_point(size=3, alpha=0.7, shape=21)

plotly::ggplotly(plot.iris)