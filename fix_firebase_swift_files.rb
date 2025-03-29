#!/usr/bin/env ruby

require 'fileutils'

puts "Fixing Firebase Swift files directly..."

# Directly fix the AsyncAwait.swift file
async_await_file = 'Pods/FirebaseStorage/FirebaseStorage/Sources/AsyncAwait.swift'
if File.exist?(async_await_file)
  puts "Creating backup of #{async_await_file}"
  FileUtils.cp(async_await_file, "#{async_await_file}.backup") unless File.exist?("#{async_await_file}.backup")
  
  content = File.read(async_await_file)
  # Replace the two @available annotations with one correct one
  content = content.gsub(/@available\(iOS 13, tvOS 13, macOS 10.15, macCatalyst 13, watchOS 7, \*\)\n  public @available\(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, \*\)/, 
                          '@available(iOS 13.0, tvOS 13.0, macOS 10.15, macCatalyst 13.0, watchOS 7.0, *)')
  
  puts "Writing fixes to #{async_await_file}"
  File.write(async_await_file, content)
  puts "Fixed #{async_await_file}"
end

# Fix the Result.swift file
result_swift_file = 'Pods/FirebaseStorage/FirebaseStorage/Sources/Result.swift'
if File.exist?(result_swift_file)
  puts "Creating backup of #{result_swift_file}"
  FileUtils.cp(result_swift_file, "#{result_swift_file}.backup") unless File.exist?("#{result_swift_file}.backup")
  
  temp_file = "#{result_swift_file}.new"
  File.open(temp_file, 'w') do |new_file|
    # Add a Swift.Result import to the top of the file
    new_file.puts "// Copyright 2020 Google LLC"
    new_file.puts "//"
    new_file.puts "// Licensed under the Apache License, Version 2.0 (the \"License\");"
    new_file.puts "// you may not use this file except in compliance with the License."
    new_file.puts "// You may obtain a copy of the License at"
    new_file.puts "//"
    new_file.puts "//      http://www.apache.org/licenses/LICENSE-2.0"
    new_file.puts "//"
    new_file.puts "// Unless required by applicable law or agreed to in writing, software"
    new_file.puts "// distributed under the License is distributed on an \"AS IS\" BASIS,"
    new_file.puts "// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied."
    new_file.puts "// See the License for the specific language governing permissions and"
    new_file.puts "// limitations under the License."
    new_file.puts ""
    new_file.puts "import Foundation"
    new_file.puts ""
    new_file.puts "/// Generates a closure that returns a `Swift.Result` type from a closure that returns an optional type"
    new_file.puts "/// and `Error`."
    new_file.puts "///"
    new_file.puts "/// - Parameters:"
    new_file.puts "///   - completion: A completion block returning a `Swift.Result` enum with either a generic object or"
    new_file.puts "///                 an `Error`."
    new_file.puts "/// - Returns: A closure parameterized with an optional generic and optional `Error` to match"
    new_file.puts "///            Objective-C APIs."
    new_file.puts "private func getResultCallback<T>(completion: @escaping (Swift.Result<T, Error>) -> Void) -> (_: T?,"
    new_file.puts "                                                                                        _: Error?)"
    new_file.puts "  -> Void {"
    new_file.puts "  return { (value: T?, error: Error?) in"
    new_file.puts "    if let value = value {"
    new_file.puts "      completion(.success(value))"
    new_file.puts "    } else if let error = error {"
    new_file.puts "      completion(.failure(StorageError.swiftConvert(objcError: error as NSError)))"
    new_file.puts "    } else {"
    new_file.puts "      completion(.failure(StorageError.internalError(\"Internal failure in getResultCallback\")))"
    new_file.puts "    }"
    new_file.puts "  }"
    new_file.puts "}"
    
    # Now read the rest of the original file starting from line 30 and replace 'Result' with 'Swift.Result'
    lines = File.readlines(result_swift_file)
    lines[30..].each do |line|
      # Replace Result with Swift.Result, but only in the context of a return type or parameter
      modified_line = line.gsub(/\((Result)<([^>]+)>/) { "(Swift.Result<#{$2}>" }
                          .gsub(/: (Result)<([^>]+)>/) { ": Swift.Result<#{$2}>" }
      new_file.puts modified_line
    end
  end
  
  # Replace the original file with the new content
  FileUtils.mv(temp_file, result_swift_file)
  puts "Fixed #{result_swift_file}"
end

# Fix the Storage.swift file
storage_swift_file = 'Pods/FirebaseStorage/FirebaseStorage/Sources/Storage.swift'
if File.exist?(storage_swift_file)
  puts "Creating backup of #{storage_swift_file}"
  FileUtils.cp(storage_swift_file, "#{storage_swift_file}.backup") unless File.exist?("#{storage_swift_file}.backup")
  
  content = File.read(storage_swift_file)
  # Ensure the FirebaseCore import is present
  unless content.include?('import FirebaseCore')
    content = content.gsub(/import Foundation/, "import Foundation\nimport FirebaseCore")
    puts "Added FirebaseCore import to #{storage_swift_file}"
  end
  
  # Write the modified content back to the file
  File.write(storage_swift_file, content)
  puts "Fixed #{storage_swift_file}"
end

puts "Firebase Swift files fixed directly" 