
#Load necessary packages
library(fmsb)
library(tidyverse)
library(dplyr)

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




#Radar chard

radar_chard <- joined_data %>% count(birth_month)

radar_chard <- radar_chard %>% mutate(
  max = 6000,
  min = 3000
) 

radar_chard <- radar_chard%>% relocate("max","min","n")


radar_chard <-  t(radar_chard)%>%as_tibble(,.name_repair)
radar_chard_plot <-radar_chard[-4,]


new_names<- c(January = "V1", 
              February = "V2", 
              March = "V3",
              April = "V4",
              May = "V5",
              June = "V6",
              July = "V7",
              August = "V8",
              September = "V9",
              October = "V10",
              November = "V11",
              December = "V12")

radar_chard_plot <- radar_chard_plot %>% rename(all_of(new_names))

radarchart(radar_chard_plot, title = "Number of NHL players")



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



#####Data after 2010#####
joined_data_1991 <- joined_data %>% filter(birth_year>=1991)

joined_data_1991 %>% ggplot(aes(x = as.integer(birth_month)))+
  geom_histogram() +
  facet_wrap(. ~ position_type)




#Radar chard

radar_chard_1991 <- joined_data_1991 %>% count(birth_month)

canada_births %>% group_by(month) %>% 
  summarise(total = sum(births)) %>%
  rename(birth_month = "month") %>%
  left_join(., radar_chard_1991) %>%
  mutate(promille = n/total*1000, max = 1, min = 0) %>%
  select(max, min, promille) -> radar_chard_1991


radar_chard_1991 <-  t(radar_chard_1991)%>%as_tibble(,.name_repair)

radar_chard_1991 <- radar_chard_1991 %>% rename(all_of(new_names))

radarchart(radar_chard_1991, title = "Promille of NHL players")


## posirion

df_defensemen<-joined_data_1991 %>% filter(position_type == "defensemen")
df_forwards<-joined_data_1991 %>% filter(position_type == "forwards")
df_goalies<-joined_data_1991 %>% filter(position_type == "goalies")

#Def
radar_chard_1991_def <- df_defensemen %>% count(birth_month)

canada_births %>% group_by(month) %>% 
  summarise(total = sum(births)) %>%
  rename(birth_month = "month") %>%
  left_join(., radar_chard_1991_def) %>%
  mutate(promille = n/total*1000, max = 1, min = 0) %>%
  select(max, min, promille) -> radar_chard_1991_def


radar_chard_1991_def <-  t(radar_chard_1991_def)%>%as_tibble(,.name_repair)

radar_chard_1991_def <- radar_chard_1991_def %>% rename(all_of(new_names))

radarchart(radar_chard_1991_def, title = "Promille of NHL players")

# for
radar_chard_1991_for <- df_forwards %>% count(birth_month)

canada_births %>% group_by(month) %>% 
  summarise(total = sum(births)) %>%
  rename(birth_month = "month") %>%
  left_join(., radar_chard_1991_for) %>%
  mutate(promille = n/total*1000, max = 1, min = 0) %>%
  select(max, min, promille) -> radar_chard_1991_for


radar_chard_1991_for <-  t(radar_chard_1991_for)%>%as_tibble(,.name_repair)

radar_chard_1991_for <- radar_chard_1991_for %>% rename(all_of(new_names))

radarchart(radar_chard_1991_for, title = "Promille of NHL players")

# goal
radar_chard_1991_goal <- df_goalies %>% count(birth_month)

canada_births %>% group_by(month) %>% 
  summarise(total = sum(births)) %>%
  rename(birth_month = "month") %>%
  left_join(., radar_chard_1991_goal) %>%
  mutate(promille = n/total*1000, max = 1, min = 0) %>%
  select(max, min, promille) -> radar_chard_1991_goal


radar_chard_1991_goal <-  t(radar_chard_1991_goal)%>%as_tibble(,.name_repair)

radar_chard_1991_goal <- radar_chard_1991_goal %>% rename(all_of(new_names))

radarchart(radar_chard_1991_goal, title = "Promille of NHL players")

