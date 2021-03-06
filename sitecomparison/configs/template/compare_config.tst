#Headless browser option
browser:
  phantomjs: "phantomjs"
  # slimerjs: "slimerjs"

#If you want to have multiple snapping files, set the file name here
snap_file: "../javascript/snap.js"

# Type the name of the directory that shots will be stored in
directory: '../UICompare/current/<custName>'

# Add only 2 domains, key will act as a label
domains:
  <domainID>: "<custURL>"
  <domainID2>: "<custURL2>"

#Type screen widths below, here are a couple of examples
screen_widths:
  - 1024
  - 1280

#Type page URL paths below, here are a couple of examples
paths:
  <custName>: /
  <custName>_path_1: <custPath1>
  <custName>_path_2: <custPath2>

#Amount of fuzz ImageMagick will use
fuzz: '20%'

#Set the number of days to keep the site spider file
spider_days:
  - 10

#Choose how results are displayed, by default alphanumeric. Different screen widths are always grouped.
#alphanumeric - all paths (with, and without, a difference) are shown, sorted by path
#diffs_first - all paths (with, and without, a difference) are shown, sorted by difference size (largest first)
#diffs_only - only paths with a difference are shown, sorted by difference size (largest first)
mode: diffs_first

threshold: 5
