# Marvel Rivals Web Scraper

This is a R based program that will collect player and match data from tracker.gg's Marvel Rivals API.

# How it works

1. Written in R
2. Uses the [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) library
3. Creates an instance in [Firefox](https://www.mozilla.org/en-US/firefox/) using RSelenium
4. Collects JSON data and parses it
5. Removes any extra characters and drops NA's
6. Writes to CSV

# Player Data
 Data collected in the player set is as follows:

 1. User
 2. Season (This is hard coded and needs to be updated when seasons change.)
 3. Hero
 4. Role
 5. Matches Played
 6. Wins
 7. Win Percentage
 8. Kills
 9. Deaths
 10. Assists
 11. Kill/Death Ratio
 12. Kill/Death/Assists Ratio
 13. Total Hero Damage
 14. Damage Per Match
 15. Head Kills
 16. Total MVP
 17. Total SVP
 18. Hero Image

| user | season | hero | role | matches_played | wins | win_perc | kills | deaths | assists | kd_ratio | kda_ratio | total_hero_damage | damage_per_match | head_kills | total_mvp | total_svp | imageURL |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | 
| kawsmoe | 1 | The Punisher | Duelist | .0372086 | 0 | 0 | 4 | 3 | 0 | 1.333333 | 1.333333 | 1884.914 | 5065.799 | 0 | 0 | 0 | https://trackercdn.com/cdn/tracker.gg/marvel-rivals/images/heroes/square/1014.png?v=1734906790 |

# Match Data

## Match Data is being worked on and is under construction.

Data Collected in the match set is as follows:

1. Match ID
2. Mode
3. Map Name
4. Mode Name
5. Timestamp
6. Duration
7. Team ID
8. Player Result
9. Team Result
10. Is MVP?
11. Is SVP?
12. Kills
13. Deaths
14. Assists
15. Head Kills
16. Last Kills
17. Solo Kills
18. Total Damage Dealt
19. Total Damage Taken
20. Total Hero Heal
21. Main Attacks
22. Main Attacks Hit
23. Shields Hit
24. Summoners Hit
25. Chaoses Hit
26. Hit Rate
27. Map Image URL
