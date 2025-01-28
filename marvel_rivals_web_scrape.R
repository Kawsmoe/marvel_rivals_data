# This is an R script used to scrape the data from the rivals.gg API for Marvels Rivals Data.
# This data includes player data. Match data is under construction.

library(tidyverse)
library(jsonlite)
library(RSelenium)
library(netstat)
library(glue)

# Input your username
user = "Kawsmoe"

# Mode you want to search by (all, competitive, quick-match, conquest)
mode = "competitive"

# Season to search by (1 is Season 0, 2 is Season 1, etc.)
season = 2

# URL variable
url = glue("https://api.tracker.gg/api/v2/marvel-rivals/standard/profile/ign/{user}/segments/career?mode={mode}&season={season}")


# Create the Firefox Driver
rs_driver_object = rsDriver(
  browser = "firefox",
  verbose = F,
  port = free_port()
)

# Create the client
remDr = rs_driver_object$client

# Open The Driver, Navigate to URL and get JSON
remDr$open
remDr$navigate(url)
Sys.sleep(3)
remDr$findElement(using = 'xpath','//*[@id="rawdata-tab"]')$clickElement()
Sys.sleep(5)
json_data = remDr$executeScript("return document.evaluate('/html/body/div/div/div/div[2]/div/div/div[2]/pre', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;")

# Remove any extra backslashes, including escaping of quotes
json_data_clean <- gsub("\\\\", "", json_data)  # Remove backslashes

# Check if there are any unescaped quotes left in the string
json_data_clean <- gsub('\\"', '"', json_data)  # Replace escaped quotes

# Print the cleaned-up data to inspect
cat(substr(json_data_clean, 1, 100))  # Inspect the first 100 characters

# Parsed JSON
parsed_json = fromJSON(json_data_clean)

# Variable to get to Stats easier
stats = parsed_json$data$stats

# Collecting the stats
hero_id = parsed_json$data$attributes$heroId
hero_name = parsed_json$data$metadata$name
hero_url = parsed_json$data$metadata$imageUrl
time_played = stats$timePlayed$value
time_played_won = stats$timePlayedWon$value
matches_played = stats$matchesPlayed$value
matches_won = stats$matchesWon$value
matches_win_pct = stats$matchesWinPct$value
kills = stats$kills$value
deaths = stats$deaths$value
assists = stats$assists$value
kd_ratio = stats$kdRatio$value
kda_ratio = stats$kdaRatio$value
total_hero_damage = stats$totalHeroDamage$value
total_hero_damage_per_min = stats$totalHeroDamagePerMinute$value
damage_per_match = total_hero_damage/matches_played
total_hero_heal = stats$totalHeroHeal$value
total_hero_heal_per_min = stats$totalHeroHealPerMinute$value
heal_per_match = total_hero_heal/matches_played
total_damage_taken = stats$totalDamageTaken$value
total_damage_taken_per_min = stats$totalDamageTakenPerMinute$value
damage_taken_per_match = total_damage_taken/matches_played
last_kills = stats$lastKills$value
head_kills = stats$headKills$value
solo_kills = stats$soloKills$value
survival_kills = stats$survivalKills$value
double_kills = stats$continueKills$value
triple_kills = stats$continueKills3$value
quad_kills = stats$continueKills4$value
quint_kills = stats$continueKills5$value
team_kills = stats$continueKills6$value
main_attacks = stats$mainAttacks$value
main_attacks_hits = stats$mainAttackHits$value
main_attack_pct = (main_attacks_hits/main_attacks)*100
shield_hits = stats$shieldHits$value
summoner_hits = stats$summonerHits$value
chaos_hits = stats$chaosHits$value
total_mvp = stats$totalMvp$value
total_svp = stats$totalSvp$value
feature_normal_data_1 = stats$featureNormalData1$value
feature_normal_data_2 = stats$featureNormalData2$value
feature_normal_data_3 = stats$featureNormalData3$value
feature_critical_rate_1_crit_hits = stats$featureCriticalRate1CritHits$value
feature_critical_rate_1_hits = stats$featureCriticalRate1Hits$value
feature_critical_rate_2_crit_hits = stats$featureCriticalRate2CritHits$value
feature_critical_rate_2_hits = stats$featureCriticalRate2Hits$value
feature_hit_rate_1_use_count = stats$featureHitRate1UseCount$value
feature_hit_rate_1_real_hit_hero_count = stats$featureHitRate1RealHitHeroCount$value
feature_hit_rate_1_chaos_hits = stats$featureHitRate1ChaosHits$value
feature_hit_rate_1_all_hits = stats$featureHitRate1AllyHits$value
feature_hit_rate_1_hero_hits = stats$featureHitRate1HeroHits$value
feature_hit_rate_1_enemy_hits = stats$featureHitRate1EnemyHits$value
feature_hit_rate_1_shield_hits = stats$featureHitRate1ShieldHits$value
feature_hit_rate_1_summoner_hits = stats$featureHitRate1SummonerHits$value
feature_special_data_1_total = stats$featureSpecialData1Total$value
feature_special_data_1_value = stats$featureSpecialData1Value$value

# Create a datafram from the stats
hero_stats = data.frame(hero_id,hero_name,hero_url,time_played,time_played_won,
                        matches_played,matches_won,matches_win_pct,kills,deaths,
                        assists, total_hero_damage,total_hero_damage_per_min, damage_per_match,
                        total_hero_heal,total_hero_heal_per_min, heal_per_match, total_damage_taken,
                        total_damage_taken_per_min, damage_taken_per_match,last_kills,head_kills,solo_kills,
                        survival_kills,double_kills,triple_kills,quad_kills, quint_kills,
                        team_kills, main_attacks, main_attacks_hits, main_attack_pct,
                        shield_hits,summoner_hits,chaos_hits,total_mvp,total_svp,
                        feature_normal_data_1, feature_normal_data_2, feature_normal_data_3,
                        feature_critical_rate_1_crit_hits, feature_critical_rate_1_hits,
                        feature_critical_rate_2_crit_hits, feature_critical_rate_2_hits,
                        feature_hit_rate_1_use_count, feature_hit_rate_1_real_hit_hero_count,
                        feature_hit_rate_1_chaos_hits, feature_hit_rate_1_all_hits,
                        feature_hit_rate_1_hero_hits, feature_hit_rate_1_enemy_hits,
                        feature_hit_rate_1_shield_hits, feature_hit_rate_1_summoner_hits,
                        feature_special_data_1_total, feature_special_data_1_value)

# Removes the First two rows
clean_hero_stats = hero_stats [-c(1:2),]

# removes the last three rows (These are totals for the 3 hero types)
clean_hero_stats = slice(clean_hero_stats, 1:(n()-3))


# Writing to CSV. Put in location where you would like files
write.csv(clean_hero_stats,"C:/Users/user/Desktop/marvel_rivals_hero_stats.csv" )
