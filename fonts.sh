#!/bin/sh

loc=$(curl -o /dev/null -sIw "%{redirect_url}" 'https://github.com/ryanoasis/nerd-fonts/releases/latest')
vers=${loc##*/}
zip=FantasqueSansMono.zip
fontName="$(basename "$zip" | sed 's/\(.*\)\..*/\1/')"

uri=${loc%/tag*}/download/$vers/$zip
echo "Downloading last Nerd Fonts $fontName at: $uri"
curl -sL "$uri" -o "/tmp/$zip"

echo "Installing /tmp/$zip"
unzip -o -q "/tmp/$zip" -d "/tmp/tmpFonts"
mv -S .bak -b /tmp/tmpFonts/*Mono.ttf ~/.local/share/fonts/
echo "fonts moved to ~/.local/share/fonts"
sudo rm -rf /tmp/*
