#!/usr/bin/env ruby

require 'xcodeproj'
require 'fileutils'

puts "Updating Xcode project references for asset catalogs..."

# Path to the project
project_path = 'FitnessApp/FitnessApp.xcodeproj'

begin
  project = Xcodeproj::Project.open(project_path)
  
  # Get the main target
  target = project.targets.find { |t| t.name == 'FitnessApp' }
  
  if target
    # Find the main group for the project
    main_group = project.main_group.find_subpath('FitnessApp')
    
    if main_group
      # Check if Assets.xcassets is already in the project
      assets_file_ref = nil
      main_group.files.each do |file|
        if file.path == 'Assets.xcassets'
          assets_file_ref = file
          break
        end
      end
      
      if assets_file_ref.nil?
        # Create a reference to Assets.xcassets if it doesn't exist
        puts "Adding Assets.xcassets to project references"
        assets_file_ref = main_group.new_reference('Assets.xcassets')
        assets_file_ref.last_known_file_type = 'folder.assetcatalog'
        
        # Add the file reference to the resources build phase
        resources_phase = target.resources_build_phase
        resources_phase.add_file_reference(assets_file_ref)
      else
        puts "Assets.xcassets already exists in project references"
      end
      
      # Update build settings to ensure proper asset catalog usage
      target.build_configurations.each do |config|
        build_settings = config.build_settings
        
        # Set ASSETCATALOG_COMPILER_APPICON_NAME to AppIcon
        if build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] != 'AppIcon'
          build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
          puts "Updated ASSETCATALOG_COMPILER_APPICON_NAME to AppIcon for #{config.name} configuration"
        end
        
        # Set ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME to AccentColor
        if build_settings['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] != 'AccentColor'
          build_settings['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] = 'AccentColor'
          puts "Updated ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME to AccentColor for #{config.name} configuration"
        end
        
        # Remove AppIcon reference from development assets path if it exists
        if build_settings['DEVELOPMENT_ASSET_PATHS']
          build_settings['DEVELOPMENT_ASSET_PATHS'] = build_settings['DEVELOPMENT_ASSET_PATHS'].gsub(/ AppIcon/, '')
          puts "Cleaned up DEVELOPMENT_ASSET_PATHS for #{config.name} configuration"
        end
      end
      
      # Save the project
      project.save
      puts "Project updated successfully"
    else
      puts "FitnessApp group not found in the project"
    end
  else
    puts "Target 'FitnessApp' not found in the project"
  end
rescue => e
  puts "Error updating project: #{e.message}"
  puts e.backtrace.join("\n")
end

puts "Xcode project references updated" 