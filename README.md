# Overview
- Get-ANStats: Parse the airnodes stats from the dashboard.
- Get-ANCoords: extracts the centers of the hexagons where the nodes are located

# Usage
- Install chromedriver and Selenium
- Update nodes.csv with your nodes ids
- Update the username and the pass variables with your values
- Run the script: . 'C:\Users\john\Get-ANStats.ps1' | Out-File an-stats-1.csv
- Run the script: . 'C:\Users\john\Get-ANCoords.ps1' | Out-File an-coords.csv

# How to fill nodes.csv file
- browse to dashboard --> airnodes
- click on Stats for each node from the list
- the browser Url will be something like this:
  - for Link: https://airnode.worldmobile.net/app/airnodes/operate-cpe/f0f6c204-d2bf-4034-8037-2bdf6d776f4x
  - for Spark: https://airnode.worldmobile.net/app/airnodes/operate-spark/052d4111-fb76-4e7a-b914-781da8ad9cxd
- the node id is the last part of the url
- put the node id and the node type (spark or link) in the csv file
