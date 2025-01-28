# Marvel Rivals Web Scraper

This is a R based program that will collect player data from tracker.gg's Marvel Rivals API. Match Data to come soon.

# How it works

1. Written in R
2. Uses the [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) library
3. Creates an instance in [Firefox](https://www.mozilla.org/en-US/firefox/) using RSelenium
4. Collects JSON data and parses it
5. Removes any extra characters drops NA's and unneeded rows,
6. Writes to CSV

# Player Data

## This is defaulted to my username ("Kawsmoe") and to competitive season 1. If you want data for different usernames, seasons or modes, change code to reflect.

We are still unsure as to what the "Feature" Data is as of yet. Alot of these values are NA, so be careful when dropping NA's.

 Data collected in the player set is as follows:

 1. Hero ID
 3. Hero Name
 4. Hero_URL (URL for image)
 5. Time Played
 6. Time Played & Won
 7. Matches Played
 8. Matches Won
 9. Matches Win Percentage
 10. Kills
 11. Deaths
 12. Assists
 13. Kill/Death Ratio
 14. Kill/Death/Assists Ratio
 15. Total Hero Damage
 16. Total Hero Damage Per Minute
 17. Damage Per Match
 18. Total Hero Heal
 19. Total Hero Heal Per Minute
 20. Heal Per Match
 21. Total Damage Taken
 22. Total Damage Taken Per Minute
 23. Damage Taken Per Match
 24. Last Kills
 25. Head Kills
 26. Solo Kills
 27. Survival Kills
 28. Double Kills
 29. Triple Kills
 30. Quad Kills
 31. Quint Kills
 32. Team Kills
 33. Main Attacks
 34. Main Attacks Hits
 35. Main Attack Hit Percentage
 36. Shield Hits
 37. Summoner Hits
 38. Chaos Hits
 39. Total MVP
 40. Total SVP
 41. Feature Normal Data 1
 42. Feature Normal Data 2
 43. Feature Normal Data 3
 44. Feature Critical Rate 1 Crit Hits
 45. Feature Critical Rate 1 Hits
 46. Feature Critical Rate 2 Crit Hits
 47. Feature Critical Rate 2 Hits
 48. Feature Hit Rate 1 Use Count
 49. Feature Hit Rate 1 Real Hit Hero Count
 50. Feature Hit Rate 1 Chaos Hits
 51. Feature Hit Rate 1 All Hits
 52. Feature Hit Rate 1 Hero Hits
 53. Feature Hit Rate 1 Enemy Hits
 54. Feature Hit Rate 1 Shield Hits
 55. Feature Hit Rate 1 Summoner Hits
 56. Feature Special Data 1 Total
 57. Feature Special Data 1 Value


# Match Data

## Match Data is being worked on and is under construction.
