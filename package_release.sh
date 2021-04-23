#!/usr/bin/env bash

# Read first line of change log file
read -r version_number < changelog.txt

cd build

# Remove any existing zip file on the solstice-html folder
rm -rf solstice-html.zip

# Zip contents from solstice-html
zip solstice-html.zip solstice-html/*

for f in "solstice-win.x86-64.exe" "solstice-linux.x86_64" "solstice-mac.x86_64.zip" "solstice-html.zip"; 
do
    mv ./${f} ./${f%%.*}-${version_number}.${f#*.};
done;

cd ..

