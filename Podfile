platform :ios, '16.0'

project 'FitnessApp/FitnessApp.xcodeproj'

# Disable warnings for cleaner builds
inhibit_all_warnings!

target 'FitnessApp' do
  use_frameworks!

  # Add the main Firebase pod
  pod 'Firebase', '~> 10.15.0'
  # Firebase modules
  pod 'Firebase/Core', '~> 10.15.0'
  pod 'Firebase/Auth', '~> 10.15.0'
  pod 'Firebase/Firestore', '~> 10.15.0'
  pod 'Firebase/Storage', '~> 10.15.0'
  pod 'Firebase/Analytics', '~> 10.15.0'
  pod 'FirebaseFirestoreSwift', '~> 10.15.0'

  # UI Components
  pod 'SnapKit', '~> 5.6.0'
  pod 'Kingfisher', '~> 7.0'

  # Utilities
  pod 'Alamofire', '~> 5.6.4'
  pod 'SwiftyJSON', '~> 5.0.1'

  target 'FitnessAppTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Configurar todas las dependencias para iOS 16+
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      
      # Desactivar Bitcode (ya no es necesario en iOS 16+)
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Add this to exclude arm64 from simulator builds - avoids -G flag issue
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      
      # Fix specific targets
      if target.name == 'BoringSSL-GRPC'
        config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        # Remove the problematic -G flag from OTHER_CFLAGS
        if config.build_settings['OTHER_CFLAGS'].is_a?(Array)
          config.build_settings['OTHER_CFLAGS'] = config.build_settings['OTHER_CFLAGS'].reject { |f| f == '-G' }
        elsif config.build_settings['OTHER_CFLAGS'].is_a?(String)
          config.build_settings['OTHER_CFLAGS'] = config.build_settings['OTHER_CFLAGS'].gsub('-G', '')
        end
        
        # Remove the problematic -G flag from OTHER_CXXFLAGS
        if config.build_settings['OTHER_CXXFLAGS'].is_a?(Array)
          config.build_settings['OTHER_CXXFLAGS'] = config.build_settings['OTHER_CXXFLAGS'].reject { |f| f == '-G' }
        elsif config.build_settings['OTHER_CXXFLAGS'].is_a?(String)
          config.build_settings['OTHER_CXXFLAGS'] = config.build_settings['OTHER_CXXFLAGS'].gsub('-G', '')
        end
        
        # Also check and fix COMPILER_FLAGS
        if config.build_settings['COMPILER_FLAGS'] && config.build_settings['COMPILER_FLAGS'].include?('-G')
          config.build_settings['COMPILER_FLAGS'] = config.build_settings['COMPILER_FLAGS'].gsub('-G', '')
        end
      end
      
      if target.name == 'FirebaseStorage'
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
        config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
      end
      
      # Also handle FirebaseFunctions specifically if it's included via dependencies
      if target.name.include?('FirebaseFunctions')
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO' 
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
        config.build_settings['OTHER_SWIFT_FLAGS'] << '-suppress-warnings'
      end
      
      # Ensure LD_RUNPATH_SEARCH_PATHS includes $(inherited)
      if config.build_settings['LD_RUNPATH_SEARCH_PATHS']
        if config.build_settings['LD_RUNPATH_SEARCH_PATHS'].is_a?(Array)
          unless config.build_settings['LD_RUNPATH_SEARCH_PATHS'].include?('$(inherited)')
            config.build_settings['LD_RUNPATH_SEARCH_PATHS'].unshift('$(inherited)')
          end
        elsif config.build_settings['LD_RUNPATH_SEARCH_PATHS'].is_a?(String)
          unless config.build_settings['LD_RUNPATH_SEARCH_PATHS'].include?('$(inherited)')
            config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = "$(inherited) #{config.build_settings['LD_RUNPATH_SEARCH_PATHS']}"
          end
        end
      end
      
      # Arreglar las advertencias de compilación
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      
      # Forzar el uso de Swift 5
      if config.build_settings['SWIFT_VERSION']
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
      
      # Manejar específicamente los problemas de opcionales en FirebaseStorage
      if target.name.include?('FirebaseStorage')
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
        config.build_settings['OTHER_SWIFT_FLAGS'] << '-suppress-warnings'
      end
    end
  end
  
  # Fix main project's build settings
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        # Ensure main targets have $(inherited) in LD_RUNPATH_SEARCH_PATHS
        if config.build_settings['LD_RUNPATH_SEARCH_PATHS']
          if config.build_settings['LD_RUNPATH_SEARCH_PATHS'].is_a?(Array)
            unless config.build_settings['LD_RUNPATH_SEARCH_PATHS'].include?('$(inherited)')
              config.build_settings['LD_RUNPATH_SEARCH_PATHS'].unshift('$(inherited)')
            end
          elsif config.build_settings['LD_RUNPATH_SEARCH_PATHS'].is_a?(String)
            unless config.build_settings['LD_RUNPATH_SEARCH_PATHS'].include?('$(inherited)')
              config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = "$(inherited) #{config.build_settings['LD_RUNPATH_SEARCH_PATHS']}"
            end
          end
        else
          config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = "$(inherited) @executable_path/Frameworks"
        end
      end
    end
  end
end 