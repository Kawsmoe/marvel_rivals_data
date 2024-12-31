# This is an R script used to scrape the data from the rivals.gg API for Marvels Rivals Data.
# This data includes player data as well as match data.


library(tidyverse)
library(jsonlite)
library(rvest)
library(RSelenium)
library(netstat)
library(XML)
library(lubridate)
library(wdman)

# URL for website API (Using my User Name "Kawsmoe")
url = "https://api.tracker.gg/api/v2/marvel-rivals/standard/profile/ign/Kawsmoe"

# Creating the Browser Driver
rs_driver_object = rsDriver(
  browser = "firefox",
  verbose = F,
  extraCapabilities = eCaps,
  port = free_port()
)
# Creating the client
remDr = rs_driver_object$client

# First we are going to collect data for the User itself. In this case my username ("Kawsmoe") 
# will be used

# Opening the browser and navigating to the website API
remDr$open
remDr$navigate(url)
# Sleep to allow the webpage to load
Sys.sleep(3)
# find and clicking the button to change to JSON
remDr$findElement(using = 'xpath','//*[@id="rawdata-tab"]')$clickElement()
# allow the webpage to load
Sys.sleep(5)

# Run Java script to return the XPATH of the body
json_data = remDr$executeScript("return document.evaluate('/html/body/div/div/div/div[2]/div/div/div[2]/pre', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;")

# Remove any extra backslashes, including escaping of quotes
json_data_clean <- gsub("\\\\", "", json_data)  # Remove backslashes

# Check if there are any unescaped quotes left in the string
json_data_clean <- gsub('\\"', '"', json_data)  # Replace escaped quotes

# Print the cleaned-up data to inspect
cat(substr(json_data_clean, 1, 100))  # Inspect the first 100 characters

# Parsing the JSON
parsed_json = fromJSON(json_data_clean)

# Creating values from the Parsed JSON
user = parsed_json$data$platformInfo$platformUserHandle
user_avatar_url = parsed_json$data$platformInfo$avatarUrl
matches_played = parsed_json$data$segments$stats$matchesPlayed$value
wins = parsed_json$data$segments$stats$matchesWon$value
kills = parsed_json$data$segments$stats$kills$value
deaths = parsed_json$data$segments$stats$deaths$value
assists = parsed_json$data$segments$stats$assists$value
kd_ratio = parsed_json$data$segments$stats$kdRatio$value
kda_ratio = parsed_json$data$segments$stats$kdaRatio$value
total_hero_damage = parsed_json$data$segments$stats$totalHeroDamage$value
total_hero_heal = parsed_json$data$segments$stats$totalHeroHeal$value
total_damage_taken = parsed_json$data$segments$stats$totalDamageTaken$value
last_kills = parsed_json$data$segments$stats$lastKills$value
head_kills = parsed_json$data$segments$stats$headKills$value
solo_kills = parsed_json$data$segments$stats$soloKills$value
max_survival_kills = parsed_json$data$segments$stats$maxSurvivalKills$value
double_kills = parsed_json$data$segments$stats$maxContinueKills$value
triple_kills = parsed_json$data$segments$stats$continueKills3$value
quad_kills = parsed_json$data$segments$stats$continueKills4$value
quintuple_kills = parsed_json$data$segments$stats$continueKills5$value
sextuple_kills = parsed_json$data$segments$stats$continueKills6$value
main_attacks = parsed_json$data$segments$stats$mainAttacks$value
main_attack_hits = parsed_json$data$segments$stats$mainAttackHits$value
shield_hits = parsed_json$data$segments$stats$shieldHits$value
summoner_hits = parsed_json$data$segments$stats$summonerHits$value
chaos_hits = parsed_json$data$segments$stats$chaosHits$value
total_mvp = parsed_json$data$segments$stats$totalMvp$value
total_svp = parsed_json$data$segments$stats$totalSvp$value
hero = parsed_json$data$segments$metadata$name
imageURL = parsed_json$data$segments$metadata$imageUrl
role = parsed_json$data$segments$metadata$roleName
season = parsed_json$data$segments$attributes$season

# Creating win Percentage and Damage Per Match Values
win_perc = (wins/matches_played)*100
damage_per_match = total_hero_damage/matches_played

# Creating the Data frame
df = data.frame(user,season,hero,role,matches_played,wins,win_perc,kills,deaths,assists,kd_ratio,kda_ratio,total_hero_damage,damage_per_match,head_kills,total_mvp,total_svp,imageURL)
# Dropping NA's
df = na.omit(df)

# A New data frame just with the user and the avatarURL. This is not required and only used for relationships in PowerBi.
df2 = data.frame(user,user_avatar_url)

# Writing the Character Stats to csv. Imput file location and filename wanted
write.csv(df, "")

# writing the user info to CSV.
write.csv(df2,"C:/Users/seang/Desktop/RandomBi/marvel_rivals/user_info.csv")

# Now we are going to collect the data from the matches. 

# Navigating to the first page.
first_page <-"https://api.tracker.gg/api/v2/marvel-rivals/standard/matches/ign/Kawsmoe?season=1"
remDr$navigate(first_page)

# Waiting for page to load
Sys.sleep(3)

# Finding the button in firefox to click to conver to Raw JSON
remDr$findElement(using = 'xpath','//*[@id="rawdata-tab"]')$clickElement()

# Page Loading
Sys.sleep(5)

# Run Java script to return the XPATH of the body
current_matches = remDr$executeScript("return document.evaluate('/html/body/div/div/div/div[2]/div/div/div[2]/pre', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;")

# Remove any extra backslashes, including escaping of quotes
cur_matches_data_clean <- gsub("\\\\", "", current_matches)  # Remove backslashes

# Check if there are any unescaped quotes left in the string
cur_matches_data_clean <- gsub('\\"', '"', current_matches)  # Replace escaped quotes

# Check if the cleaned data looks valid
cat(substr(cur_matches_data_clean, 1, 100))  # Inspect the first 100 characters

# Parse the JSON data
cur_matches_json = fromJSON(cur_matches_data_clean)

#Creating values from the Parsed JSON
match_id = cur_matches_json$data$matches$attributes$id
mode = cur_matches_json$data$matches$attributes$mode
map_name = cur_matches_json$data$matches$metadata$mapName
mode_name = cur_matches_json$data$matches$metadata$mapModeName
timestamp = cur_matches_json$data$matches$metadata$timestamp
duration = cur_matches_json$data$matches$metadata$duration
team_id = cur_matches_json$data$matches$segments[[1]]$metadata$teamId
player_result = cur_matches_json$data$matches$segments[[1]]$metadata$outcome$result
team_result = cur_matches_json$data$matches$segments[[1]]$metadata$result
is_mvp = cur_matches_json$data$matches$segments[[1]]$metadata$isMvp
is_svp = cur_matches_json$data$matches$segments[[1]]$metadata$isSvp
map_image_url = cur_matches_json$data$matches$metadata$mapImageUrl
kills = cur_matches_json$data$matches$segments[[1]]$stats$kills$value
deaths = cur_matches_json$data$matches$segments[[1]]$stats$deaths$value
assists = cur_matches_json$data$matches$segments[[1]]$stats$assists$value
head_kills = cur_matches_json$data$matches$segments[[1]]$stats$headKills$value
last_kills = cur_matches_json$data$matches$segments[[1]]$stats$lastKills$value
solo_kills = cur_matches_json$data$matches$segments[[1]]$stats$soloKills$value
total_damage_dealt = cur_matches_json$data$matches$segments[[1]]$stats$totalDamageDealt$value
total_damage_taken = cur_matches_json$data$matches$segments[[1]]$stats$totalDamageTaken$value
total_hero_heal = cur_matches_json$data$matches$segments[[1]]$stats$totalHeal$value
main_attacks = cur_matches_json$data$matches$segments[[1]]$stats$mainAttacks$value
main_attacks_hit = cur_matches_json$data$matches$segments[[1]]$stats$mainAttacksHit$value


#Creating the data frame
games2 = data.frame(match_id, mode, map_name, mode_name, timestamp, duration, team_id, player_result, team_result, is_mvp, is_svp, map_image_url,kills,deaths,assists,head_kills,last_kills,solo_kills,total_damage_dealt,total_damage_taken,total_hero_heal,main_attacks,main_attack_hits)

print(games2)

# Since there is a "&next=" added to the url when there is more than 1 page.
# 1 page is 25 entries.
# The loop below goes through the pages to ensure all data is captured.

# Define the base URL and starting page
base_url <- "https://api.tracker.gg/api/v2/marvel-rivals/standard/matches/ign/Kawsmoe?season=1&next="
next_page <- 2  # Start with the second page (assuming page numbering starts at 2)

# Create an empty data frame to store all games data
games_all <- data.frame()

# Start the loop to fetch data from each page
while (TRUE) {
  # Construct the URL for the current page
  page_url <- paste0(base_url, next_page)
  
  # Navigate to the page
  remDr$navigate(page_url)
  Sys.sleep(3)
  
  # Click the "rawdata" tab to show the JSON data (if applicable)
  remDr$findElement(using = 'xpath','//*[@id="rawdata-tab"]')$clickElement()
  Sys.sleep(5)
  
  # Get the raw JSON data from the page using JavaScript
  matches_data = remDr$executeScript("return document.evaluate('/html/body/div/div/div/div[2]/div/div/div[2]/pre', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;")
  
  # Clean the JSON data (remove any extra backslashes or escaped quotes)
  matches_data_clean <- gsub("\\\\", "", matches_data)  # Remove backslashes
  matches_data_clean <- gsub('\\"', '"', matches_data)  # Replace escaped quotes
  
  # Check if the cleaned data looks valid
  cat(substr(matches_data_clean, 1, 100))  # Inspect the first 100 characters
  
  # Parse the JSON data
  matches_json = fromJSON(matches_data_clean)
  
  # If no 'data' is found in the response, stop the loop (indicating no more data)
  if (is.null(matches_json$data) || length(matches_json$data$matches) == 0) {
    print("No more data, stopping the loop.")
    break
  }
  
  # Extract information from the JSON data
  match_id = matches_json$data$matches$attributes$id
  mode = matches_json$data$matches$attributes$mode
  map_name = matches_json$data$matches$metadata$mapName
  mode_name = matches_json$data$matches$metadata$mapModeName
  timestamp = matches_json$data$matches$metadata$timestamp
  duration = matches_json$data$matches$metadata$duration
  team_id = matches_json$data$matches$segments[[1]]$metadata$teamId
  player_result = matches_json$data$matches$segments[[1]]$metadata$outcome$result
  team_result = matches_json$data$matches$segments[[1]]$metadata$result
  is_mvp = matches_json$data$matches$segments[[1]]$metadata$isMvp
  is_svp = matches_json$data$matches$segments[[1]]$metadata$isSvp
  map_image_url = matches_json$data$matches$metadata$mapImageUrl
  
  
  # Create a data frame for the current page of results
  games = data.frame(match_id, mode, map_name, mode_name, timestamp, duration, team_id, player_result, team_result, is_mvp, is_svp, map_image_url)
  
  # Append the current page of data to the all games data
  games_all <- rbind(games_all, games)

  
  # Increment the next_page by 1 for the next iteration
  next_page <- next_page + 1
}

# Print or process the collected data

all = rbind(games2, games_all)

#print to ensure all data has collected
print(all)

#Writing to CSV. Insert File Location in quotes
write.csv(all,"")


