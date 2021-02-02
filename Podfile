source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.2'
use_frameworks!

target 'PrayerOfTheDay' do
    
pod 'PinterestSDK'
pod 'AFNetworking'

end

target 'PrayerOfTheDayTests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['LD_NO_PIE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '4.2'
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end

