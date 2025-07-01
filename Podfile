# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'My Kai' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for My Kai
    pod 'AdvancedPageControl'
    pod 'IQKeyboardManager'
    pod 'MBProgressHUD'
    pod 'RSLoadingView'
    pod 'SDWebImage'
    pod 'FSCalendar'
    pod 'Cosmos'
    pod 'Charts'
    pod 'DropDown'
    pod 'ScrollingPageControl'
    pod "TTGTagCollectionView"
    pod 'Blurberry'
    pod 'Stripe'
    pod 'NVActivityIndicatorView'
    pod 'SwiftyJSON'
    pod 'ReachabilitySwift'
    pod 'Alamofire'
    pod 'MBProgressHUD'
    pod 'FirebaseMessaging'
    pod 'FirebaseAnalytics'
    pod 'Firebase/Crashlytics'
    pod 'FirebaseFirestore'
    pod 'FirebaseAuth'
    pod 'FirebaseDynamicLinks'
    pod 'GoogleSignIn'
    pod 'FBSDKLoginKit'
    pod 'FBSDKCoreKit'
    pod 'SDWebImage'
    pod 'Firebase/Messaging'
    pod 'ProgressHUD'
    pod 'GoogleAPIClientForREST/Vision'
    pod 'GTMAppAuth'
    pod 'AppAuth'
    pod 'AppsFlyerFramework'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'SwiftGifOrigin'
    pod 'ADCountryPicker'
    pod 'RangeSeekSlider'


  target 'My KaiTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'My KaiUITests' do
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