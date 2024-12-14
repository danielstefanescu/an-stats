# Overview
- Get-ANStats: Parse the airnodes stats from the dashboard.
- Get-ANCoords: extracts the centers of the hexagons where the nodes are located

# Usage
- Install chromedriver and Selenium
- Update nodes.csv with your nodes values
- Update the username and the pass variables with your values
- Run the script: . 'C:\Users\john\Get-ANStats.ps1' | Out-File an-stats-1.csv
- Run the script: . 'C:\Users\john\Get-AN-Coords.ps1' | Out-File an-coords.csv
