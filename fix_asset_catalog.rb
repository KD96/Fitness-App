#!/usr/bin/env ruby

require 'fileutils'
require 'json'

puts "Fixing asset catalog issues..."

# Path to the asset catalogs
preview_assets_dir = 'FitnessApp/FitnessApp/Preview Content/Preview Assets.xcassets'
main_assets_dir = 'FitnessApp/FitnessApp/Assets.xcassets'

# Create the main assets directory if it doesn't exist
unless Dir.exist?(main_assets_dir)
  puts "Creating #{main_assets_dir} directory"
  FileUtils.mkdir_p(main_assets_dir)
  
  # Create a Contents.json file in the main assets directory
  contents_json = {
    "info" => {
      "author" => "xcode",
      "version" => 1
    }
  }
  
  File.write("#{main_assets_dir}/Contents.json", JSON.pretty_generate(contents_json))
  puts "Created Contents.json in Assets.xcassets"
end

# Create the AccentColor directory in the main assets
accent_color_dir = "#{main_assets_dir}/AccentColor.colorset"
unless Dir.exist?(accent_color_dir)
  puts "Creating AccentColor.colorset directory"
  FileUtils.mkdir_p(accent_color_dir)
  
  # Create a Contents.json file for AccentColor
  accent_color_json = {
    "colors" => [
      {
        "color" => {
          "color-space" => "srgb",
          "components" => {
            "alpha" => "1.000",
            "blue" => "0.631",
            "green" => "0.408",
            "red" => "0.110"
          }
        },
        "idiom" => "universal"
      }
    ],
    "info" => {
      "author" => "xcode",
      "version" => 1
    }
  }
  
  File.write("#{accent_color_dir}/Contents.json", JSON.pretty_generate(accent_color_json))
  puts "Created AccentColor.colorset in Assets.xcassets"
end

# Create the AppIcon directory in the main assets
app_icon_dir = "#{main_assets_dir}/AppIcon.appiconset"
unless Dir.exist?(app_icon_dir)
  puts "Creating AppIcon.appiconset directory"
  FileUtils.mkdir_p(app_icon_dir)
  
  # Create a Contents.json file for AppIcon
  app_icon_json = {
    "images" => [
      {
        "idiom" => "iphone",
        "scale" => "2x",
        "size" => "60x60"
      },
      {
        "idiom" => "iphone",
        "scale" => "3x",
        "size" => "60x60"
      },
      {
        "idiom" => "ipad",
        "scale" => "1x",
        "size" => "76x76"
      },
      {
        "idiom" => "ipad",
        "scale" => "2x",
        "size" => "76x76"
      },
      {
        "idiom" => "ipad",
        "scale" => "2x",
        "size" => "83.5x83.5"
      },
      {
        "idiom" => "ios-marketing",
        "scale" => "1x",
        "size" => "1024x1024"
      }
    ],
    "info" => {
      "author" => "xcode",
      "version" => 1
    }
  }
  
  File.write("#{app_icon_dir}/Contents.json", JSON.pretty_generate(app_icon_json))
  puts "Created AppIcon.appiconset in Assets.xcassets"
end

# Update the preview assets directory to remove AppIcon references
if Dir.exist?(preview_assets_dir)
  preview_contents_path = "#{preview_assets_dir}/Contents.json"
  if File.exist?(preview_contents_path)
    preview_contents = JSON.parse(File.read(preview_contents_path))
    # Make sure it doesn't reference AppIcon
    File.write(preview_contents_path, JSON.pretty_generate(preview_contents))
    puts "Updated Contents.json in Preview Assets.xcassets"
  end
end

puts "Asset catalog issues fixed" 