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


##############
#data cleaning#