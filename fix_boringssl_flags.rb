#!/usr/bin/env ruby
require "xcodeproj"

# Open the project
project_path = "Pods/Pods.xcodeproj"
project = Xcodeproj::Project.open(project_path)

# Count modifications
modified_files = 0

# Find all build files with problematic flags
project.objects.each do |object|
  # Process only PBXBuildFile objects that have settings
  if object.is_a?(Xcodeproj::Project::Object::PBXBuildFile) && object.settings
    # Check if the compiler flags contain the problematic flag
    if object.settings["COMPILER_FLAGS"] && object.settings["COMPILER_FLAGS"].include?("-GCC_WARN_INHIBIT_ALL_WARNINGS")
      # Replace the problematic flag with proper Xcode warning inhibition
      object.settings["COMPILER_FLAGS"] = object.settings["COMPILER_FLAGS"].gsub("-GCC_WARN_INHIBIT_ALL_WARNINGS", "-Wno-everything")
      modified_files += 1
    end
  end
end

puts "Modified #{modified_files} files in the project"

# Save the project
project.save
puts "Project saved at #{project_path}" 