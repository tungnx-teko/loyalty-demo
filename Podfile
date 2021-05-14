# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

$TekoSpecs = 'https://' + ENV['GITHUB_USER_TOKEN'] + '@github.com/teko-vn/Specs-ios.git'
source 'https://github.com/CocoaPods/Specs.git'
source $TekoSpecs

target 'LoyaltyDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LoyaltyDemo
  pod 'Janus', '~> 3.2.1'
  pod 'JanusGoogle', '~> 3.2.3'
  pod 'Toast-Swift'
  pod 'TekIdentityService'
  pod 'LoyaltyConsumer'
end

$not_distribution_frameworks = [

]

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if $not_distribution_frameworks.include?(target.name)
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'NO'
      else
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end
