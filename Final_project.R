#Load necessary packages
library(fmsb)
library(tidyverse)

#Read all data from the NHL df
data <- tidytuesdayR::tt_load("2024-01-09")

#Extract the roster information
rosters <- data$nhl_rosters

#Extract information regarding players birthdate
nhl_player_births <- data$nhl_player_births

#Extract information regarding all births in Canada
canada_births <- data$canada_births_1991_2022

#Extract information regarding name on NHL teams
nhl_teams <- data$nhl_teams


###############
#data cleaning#
unique(nhl_player_births$player_id) %>% length()

#it seems like there are players that are represented more than one in the nhl_players_births 
unique(nhl_player_births)

nhl_player_births %>% filter(duplicated(player_id)) 
duplicates <- nhl_player_births %>% filter(player_id %in% c(8480870, 8478449) )

#only keep distinct observations based on the player_id
nhl_player_births <- nhl_player_births %>%  distinct(player_id, .keep_all = TRUE)

#Join birth information to roster df
joined_data <- left_join(rosters, nhl_player_births, by = join_by(player_id))

#Generate histogram of each birth month
joined_data %>% ggplot(aes(x= as.integer(birth_month))) + 
  geom_histogram() +
  facet_wrap(. ~ position_type)+
  theme_bw()

#Generate histogram for each season
joined_data %>% ggplot(aes(x= as.integer(birth_month))) + 
  geom_histogram() +
  facet_wrap(. ~ season)+
  theme_bw()
#Radar chard
radar_chard <- joined_data %>% mutate(
  position_type_count = count(birth_)
) %>% select()

radar_chard <- joined_data %>% count(birth_month)

radar_chard <- radar_chard %>% mutate(
  max = 6000,
  min = 1000
) %>% relocate(max, min, n)

radar_wide <- pivot_wider(radar_chard,  values_from = c("max", "min", "n"))

radar_wide <- as_tibble(mradar_wide)

radarchart(radar_wide)





# Library
library(fmsb)

# Create data: note in High school for Jonathan:
data <- as.data.frame(matrix( sample( 2:20 , 10 , replace=T) , ncol=10))
colnames(data) <- c("math" , "english" , "biology" , "music" , "R-coding", "data-viz" , "french" , "physic", "statistic", "sport" )

# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
data <- rbind(rep(20,10) , rep(0,10) , data)

# Check your data, it has to look like this!
head(data)

# The default radar chart 
radarchart(data)

