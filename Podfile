# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TalkingVideos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'IQKeyboardManagerSwift'
pod 'Alamofire', '~> 4.9'
pod 'AlamofireImage', '~> 3.5'
pod 'SwiftyJSON'
pod 'SDWebImage'
pod 'IQKeyboardToolbarManager'

  # Pods for TalkingVideos

  target 'TalkingVideosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TalkingVideosUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
