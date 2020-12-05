#!/bin/zsh

# $bing is needed to form the fully qualified URL for the Bing pic of the day
bing="www.bing.com"

# $url (xmlURL) is needed to get the xml data from which
# the relative URL for the Bing pic of the day is extracted
#
# The mkt parameter determines which Bing market you would like to
# obtain your images from.
# Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
#
# The idx parameter determines where to start from. 0 is the current day,
# 1 the previous day, etc.
url="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=1&n=1&mkt=en-US"

# $save_dir is used to set the location where Bing pics of the day are stored. 
# $HOME holds the path of the current user's home directory
save_dir="$HOME/Pictures/.bing-images/"

# Create save_dir if it does not already exist
mkdir -p $save_dir

# Form the URL for the image
image_url=$bing$(echo $(curl -s $url) | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

# Set imaage Name to the current date
image_name=$(date +'%Y-%m-%d')".jpg"

# Download the Bing pic of the day 
curl -s -o $save_dir$image_name $image_url

# Set the GNOME3 wallpaper
gsettings set org.gnome.desktop.background picture-uri "file://$save_dir$image_name"

# Remove pictures older than 7 days
#find $saveDir -atime 7 -delete

# Exit the script
exit

