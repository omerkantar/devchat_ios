# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'
 use_frameworks!


target 'Gitchat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # Pods for Gitchat
  
  pod 'Tailor', '~> 2.0'
  pod 'AlamofireImage', '~> 3.2'
  pod 'Alamofire', '~> 4.4'
  pod 'Socket.IO-Client-Swift', '~> 8.3'
  pod 'SwiftyJSON'


  target 'GitchatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GitchatUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
