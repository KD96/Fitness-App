#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'FitnessApp/FitnessApp.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.find { |t| t.name == 'FitnessApp' }
if target
  target.build_configurations.each do |config|
    config.build_settings['SWIFT_OBJC_BRIDGING_HEADER'] = 'FitnessApp/FitnessApp-Bridging-Header.h'
    config.build_settings['HEADER_SEARCH_PATHS'] = '$(inherited) "${PODS_ROOT}/FirebaseCore/FirebaseCore/Sources" "${PODS_ROOT}/Headers/Public"'
    config.build_settings['SWIFT_INCLUDE_PATHS'] = '$(inherited) ${PODS_ROOT}'
  end
  project.save
  puts "Successfully added bridging header configuration to project"
else
  puts "Target 'FitnessApp' not found!"
end
