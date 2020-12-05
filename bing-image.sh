#!/bin/zsh

# $bing is needed to form the fully qualified URL for
# the Bing pic of the day
bing="www.bing.com"

# $xmlURL is needed to get the xml data from which
# the relative URL for the Bing pic of the day is extracted
#
# The mkt parameter determines which Bing market you would like to
# obtain your images from.
# Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
#
# The idx parameter determines where to start from. 0 is the current day,
# 1 the previous day, etc.
xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=1&n=1&mkt=en-US"

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir="$HOME/Pictures/.bing-images/"

# Create saveDir if it does not already exist
mkdir -p $saveDir

# Set picture options
# Valid options are: none,wallpaper,centered,scaled,stretched,zoom,spanned
picOpts="zoom"

# The desired Bing picture resolution to download
# Valid options: "_1024x768" "_1280x720" "_1366x768" "_1920x1200"
desiredPicRes="_1366x768"

# The file extension 
picExt=".jpg"

# Extract the relative URL of the Bing pic of the day from
# the XML data retrieved from xmlURL, form the fully qualified
# URL for the pic of the day, and store it in $picURL

# Form the URL for the desired pic resolution
desiredPicURL=$bing$(echo $(curl -s $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$desiredPicRes$picExt

# Form the URL for the default pic resolution
defaultPicURL=$bing$(echo $(curl -s $xmlURL) | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

# $picName contains the filename of the Bing pic of the day
# Set picName to the todaye's date
picName=$(date +'%Y-%m-%d')

# Attempt to download the desired image resolution. If it doesn't
# exist then download the default image resolution
if wget --quiet --spider "$desiredPicURL"
then

    # Download the Bing pic of the day at desired resolution
    curl -s -o $saveDir$picName$picExt $desiredPicURL
else
    
    # Download the Bing pic of the day at default resolution
    curl -s -o $saveDir$picName$picExt $defaultPicURL 
fi

# Set the GNOME3 wallpaper
gsettings set org.gnome.desktop.background picture-uri "file://$saveDir$picName"

# Set the GNOME 3 wallpaper picture options
gsettings set org.gnome.desktop.background picture-options $picOpts

# Remove pictures older than 7 days
#find $saveDir -atime 7 -delete

# Exit the script
exit

