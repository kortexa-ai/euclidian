#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 input.png"
  exit 1
fi

input=$1
temp_input="temp_rgba.png"

# magick input to RGBA format
magick "$input" -type TrueColorAlpha -colorspace sRGB -strip "$temp_input"

# Create temporary directories
mkdir -p iconset myicon.iconset
mkdir -p gen/apple/Assets.xcassets/AppIcon.appiconset

# Generate PNGs for all respiro
sizes=(16 32 64 128 256 512 1024) # For icns and ico
extra_sizes=(30 44 71 89 107 142 150 284 310) # For SquareXxXLogo.png
store_logo_size=50 # For StoreLogo.png
apple_sizes=(20 29 40 60 76 83.5 512 1024) # For iOS/macOS icons

# Generate base PNGs for icns, ico, and apple icons
for size in "${sizes[@]}" "${apple_sizes[@]}"; do
  magick "$temp_input" -resize ${size}x${size} iconset/icon_${size}x${size}.png
done

# Generate original PNGs from previous list
magick "$temp_input" -resize 32x32 32x32.png
magick "$temp_input" -resize 128x128 128x128.png
magick "$temp_input" -resize 256x256 128x128@2x.png
magick "$temp_input" -resize 512x512 icon.png
magick "$temp_input" -resize 50x50 StoreLogo.png
for size in "${extra_sizes[@]}"; do
  magick "$temp_input" -resize ${size}x${size} Square${size}x${size}Logo.png
done

# Generate iOS/macOS icons in subfolder
apple_output_dir="gen/apple/Assets.xcassets/AppIcon.appiconset"
magick "$temp_input" -resize 20x20 "$apple_output_dir/AppIcon-20x20@1x.png"
magick "$temp_input" -resize 40x40 "$apple_output_dir/AppIcon-20x20@2x.png"
magick "$temp_input" -resize 40x40 "$apple_output_dir/AppIcon-20x20@2x-1.png"
magick "$temp_input" -resize 60x60 "$apple_output_dir/AppIcon-20x20@3x.png"
magick "$temp_input" -resize 29x29 "$apple_output_dir/AppIcon-29x29@1x.png"
magick "$temp_input" -resize 58x58 "$apple_output_dir/AppIcon-29x29@2x.png"
magick "$temp_input" -resize 58x58 "$apple_output_dir/AppIcon-29x29@2x-1.png"
magick "$temp_input" -resize 87x87 "$apple_output_dir/AppIcon-29x29@3x.png"
magick "$temp_input" -resize 40x40 "$apple_output_dir/AppIcon-40x40@1x.png"
magick "$temp_input" -resize 80x80 "$apple_output_dir/AppIcon-40x40@2x.png"
magick "$temp_input" -resize 80x80 "$apple_output_dir/AppIcon-40x40@2x-1.png"
magick "$temp_input" -resize 120x120 "$apple_output_dir/AppIcon-40x40@3x.png"
magick "$temp_input" -resize 120x120 "$apple_output_dir/AppIcon-60x60@2x.png"
magick "$temp_input" -resize 180x180 "$apple_output_dir/AppIcon-60x60@3x.png"
magick "$temp_input" -resize 76x76 "$apple_output_dir/AppIcon-76x76@1x.png"
magick "$temp_input" -resize 152x152 "$apple_output_dir/AppIcon-76x76@2x.png"
magick "$temp_input" -resize 167x167 "$apple_output_dir/AppIcon-83.5x83.5@2x.png"
magick "$temp_input" -resize 1024x1024 "$apple_output_dir/AppIcon-512@2x.png"

# Create Contents.json for Xcode asset catalog
cat > "$apple_output_dir/Contents.json" << EOL
{
  "images": [
    {
      "idiom": "universal",
      "filename": "AppIcon-20x20@1x.png",
      "scale": "1x",
      "size": "20x20"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-20x20@2x.png",
      "scale": "2x",
      "size": "20x20"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-20x20@2x-1.png",
      "scale": "2x",
 się: "20x20"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-20x20@3x.png",
      "scale": "3x",
      "size": "20x20"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-29x29@1x.png",
      "scale": "1x",
      "size": "29x29"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-29x29@2x.png",
      "scale": "2x",
      "size": "29x29"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-29x29@2x-1.png",
      "scale": "2x",
      "size": "29x29"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-29x29@3x.png",
      "scale": "3x",
      "size": "29x29"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-40x40@1x.png",
      "scale": "1x",
      "size": "40x40"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-40x40@2x.png",
      "scale": "2x",
      "size": "40x40"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-40x40@2x-1.png",
      "scale": "2x",
      "size": "40x40"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-40x40@3x.png",
      "scale": "3x",
      "size": "40x40"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-60x60@2x.png",
      "scale": "2x",
      "size": "60x60"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-60x60@3x.png",
      "scale": "3x",
      "size": "60x60"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-76x76@1x.png",
      "scale": "1x",
      "size": "76x76"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-76x76@2x.png",
      "scale": "2x",
      "size": "76x76"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-83.5x83.5@2x.png",
      "scale": "2x",
      "size": "83.5x83.5"
    },
    {
      "idiom": "universal",
      "filename": "AppIcon-512@2x.png",
      "scale": "2x",
      "size": "512x512"
    }
  ],
  "info": {
    "author": "xcode",
    "version": 1
  }
}
EOL

# Create macOS icns
cp iconset/icon_16x16.png myicon.iconset/icon_16x16.png
cp iconset/icon_32x32.png myicon.iconset/icon_32x32.png
cp iconset/icon_64x64.png myicon.iconset/icon_64x64.png
cp iconset/icon_128x128.png myicon.iconset/icon_128x128.png
cp iconset/icon_256x256.png myicon.iconset/icon_256x256.png
cp iconset/icon_512x512.png myicon.iconset/icon_512x512.png
cp iconset/icon_1024x1024.png myicon.iconset/icon_1024x1024.png
cp iconset/icon_32x32.png myicon.iconset/icon_16x16@2x.png
cp iconset/icon_64x64.png myicon.iconset/icon_32x32@2x.png
cp iconset/icon_256x256.png myicon.iconset/icon_128x128@2x.png
cp iconset/icon_512x512.png myicon.iconset/icon_256x256@2x.png
cp iconset/icon_1024x1024.png myicon.iconset/icon_512x512@2x.png
iconutil -c icns myicon.iconset -o icon.icns

# Create Windows ico
magick iconset/icon_16x16.png iconset/icon_32x32.png iconset/icon_64x64.png iconset/icon_256x256.png -colors 256 icon.ico

# Clean up temporary files and directories
rm -f "$temp_input"
rm -rf iconset myicon.iconset

echo "Icons generated successfully!"
echo "iOS/macOS icons are in: gen/apple/Assets.xcassets/AppIcon.appiconset/"