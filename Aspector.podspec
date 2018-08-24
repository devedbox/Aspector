Pod::Spec.new do |s|
  s.name         = "Aspector"
  s.version      = "0.0.2"
  s.summary      = "The kit to code aspectly."
  s.description  = <<-DESC
                    The kit to code aspectly. iOS and macOS available.
                   DESC

  s.homepage     = "https://github.com/devedbox/Aspector"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "devedbox" => "devedbox@qq.com" }
  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  #

  s.source       = { :git => "https://github.com/devedbox/Aspector.git", :tag => "#{s.version}" }

  s.source_files  = "Sources", "Sources/**/*.{h,m,swift}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  s.requires_arc = true
  s.swift_version = '4.2'
  s.static_framework = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
