# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'FruityFusion' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FruityFusion
  pod 'Google-Mobile-Ads-SDK'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 最新の Xcode がサポートしない古い最小 iOS バージョンを、アプリと同じ 15.0 にそろえる
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
