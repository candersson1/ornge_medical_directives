platform :ios, '12.4'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Ornge' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ornge
  pod 'SwiftRichString', '~> 3.0.3'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.4'
    end
  end
end
