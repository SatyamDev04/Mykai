//
//  AppDelegate.swift
//  Myka App
//
//  Created by YES IT Labs on 26/11/24.
//

import UIKit
import IQKeyboardManager
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseMessaging
import Firebase
import Stripe
import StripeApplePay
import AppsFlyerLib
import AppTrackingTransparency


@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerLibDelegate {
     
    
    var window: UIWindow?

    var gcmMessageIDKey = "gcmMessageIDKey"
    static let shared = UIApplication.shared.delegate as! AppDelegate
      var deviceToken = String()
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        Thread.sleep(forTimeInterval: 3)
 
        AppsFlyerLib.shared().appsFlyerDevKey = "<M57zyjkFgb7nSQwHWN6isW>" //YOUR_DEV_KEY
        AppsFlyerLib.shared().appleAppID = "<6742851385>" //YOUR_APP_ID
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true // Enable for testing; disable for production
        // Handle deferred deep linking
        AppsFlyerLib.shared().deepLinkDelegate = self
        
       
         
        // Handle deep link if app is opened via URL (iOS 9 and above)
               if let url = launchOptions?[.url] as? URL {
                   AppsFlyerLib.shared().handleOpen(url) // Handle deep link
               }
        
        AppsFlyerLib.shared().start()
        
        //

        GMSServices.provideAPIKey("AIzaSyA7f3YXlTD-foNwy7phnJJHCsYDiWgURkQ")//("AIzaSyA-e6IRZ8axxpwrm1GEjlFOTzwb5KVQHgc")
        GMSPlacesClient.provideAPIKey("AIzaSyA7f3YXlTD-foNwy7phnJJHCsYDiWgURkQ")// client Api key.
        
        //    StripeAPI.defaultPublishableKey = "pk_live_51Qko2KEowij4RlG8jPdIDKTTaX12y4tNGgP2CWL2YAEOy4XMQx7vhEAeAtbmpaohAx7VOBPq0Z7iMBsAiygbJpAM00RcRMGU0W"//Live
            
         //   StripeAPI.defaultPublishableKey = "pk_test_51Qko2KEowij4RlG8Ehh3tKQVhxVJUMzAPIi0rTnsX77jwtz5F8LfHfSvS9d2PTg8G7I5NQ3x19JlqdMaAihRcXAn00MvY1CI0X"//Test
        
        StripeAPI.defaultPublishableKey = "pk_test_51RVEe2DujJKtntDw4WHj4B11GXtevi9wGVF9bY9XoHGbD69EUNDiEYaBaBswxzwBhzFjD3Oz55LWozIVPUfzIyqr00uPgzdErF"//Test
       
        
//        // Initialize Facebook SDK
            FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
         FirebaseApp.configure()
        
        
        if #available(iOS 10.0, *) {
                   // For iOS 10 display notification (sent via APNS)
                   UNUserNotificationCenter.current().delegate = self
                   
                   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                   UNUserNotificationCenter.current().requestAuthorization(
                       options: authOptions,
                       completionHandler: { _, _ in }
                   )
               } else {
                   let settings: UIUserNotificationSettings =
                   UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                   application.registerUserNotificationSettings(settings)
               }
               
               application.registerForRemoteNotifications()
               Messaging.messaging().delegate = self
               Messaging.messaging().isAutoInitEnabled = true
               Messaging.messaging().token { token, error in
                  // Check for error. Otherwise do what you will with token here
                   if let error = error {
                                  print("Error fetching remote instance ID: \(error)")
                              } else if let token = token {
                                 print("Remote instance ID token: \(token)")
                                  UserDefaults.standard.set(token, forKey: "token")
                                  self.deviceToken = token
                                  
                    }
               }
        
        
        return true
    }
    
    
   
    
    
    // for google signin
//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//              var handled: Bool
//     // return GIDSignIn.sharedInstance.handle(url)
//        
//              handled = GIDSignIn.sharedInstance.handle(url)
//              if handled {
//                return true
//              }
//                //  facebook login
//                  ApplicationDelegate.shared.application(
//                      app,
//                      open: url,
//                      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//                  )
//        
//        
//        
//                // Handle other custom URL types.
//        
//                // If not handled by this app, return false.
//                return false
//    }
    
 
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Google Sign-In handling
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        // Facebook Login handling
        if ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        ) {
            return true
        }
        
        // AppsFlyer deep link handling
        AppsFlyerLib.shared().handleOpen(url, options: options)
        //
            
        // Return false if no handler explicitly returns true
        return false
    }
    
  

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userInfo --> \(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//@available(iOS 13.0, *)
//public extension UIApplication {
//    
//    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//       /* if let SSASide = base as? KSideMenuVC {
//            if let nav = SSASide.mainViewController as? UINavigationController{
//                return topViewController(nav.visibleViewController)
//            }
//        } */
//        if let nav = base as? UINavigationController {
//            return topViewController(nav.visibleViewController)
//        }
//        
//        if let tab = base as? UITabBarController {
//            let moreNavigationController = tab.moreNavigationController
//            
//            if let top = moreNavigationController.topViewController, top.view.window != nil {
//                return topViewController(top)
//            } else if let selected = tab.selectedViewController {
//                return topViewController(selected)
//            }
//        }
//        
//        if let presented = base?.presentedViewController {
//            return topViewController(presented)
//        }
//        
//        return base
//    }
//}
 

  extension UIApplication {
    class func topViewController(
        _ base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}

 
extension AppDelegate:MessagingDelegate, UNUserNotificationCenterDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey:"fcmToken")
        
        if let fcmToken = fcmToken {
            print("Firebase registration token: \(fcmToken)")
            self.deviceToken = fcmToken
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        NotificationCenter.default.post(name: NSNotification.Name("didReceiveNotification"), object: 0)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userInfo forground --> \(userInfo)")
        if let kuponType = userInfo["noti_type"] as? String{
            print("kuponType --> \(kuponType)")
            
            
            NotificationCenter.default.post(Notification(name: Notification.Name("didReceiveNotification")))
            
           
            
            print(userInfo)
            
         
            
        }
        completionHandler([[.alert, .sound, .badge]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           let userInfo = response.notification.request.content.userInfo
           
          
           
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
           }
           print("userInfo --> \(userInfo)")
        
        print("type:",  userInfo["gcm.notification.type"] ?? "")
        
        print("screen:",  userInfo["gcm.notification.screen"] ?? "")
        
        
        var type = userInfo["gcm.notification.type"] ?? ""
        
        var screen = userInfo["gcm.notification.screen"] ?? ""
        
        
           // Print full message.
           print(userInfo)
        
                let state = UIApplication.shared.applicationState
        
//        let UserType = UserDetail.shared.getUserType()
//        if UserType == "User"{
//            if state == .active {
//                
//                let data:[String: String] = ["type": "\(type)", "screen": "\(screen)"]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameUser"), object: nil, userInfo: data)
//            }else{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    let data:[String: String] = ["type": "\(type)", "screen": "\(screen)"]
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameUser"), object: nil, userInfo: data)
//                }
//            }
//        }else{
//            if state == .active {
//                
//                let data:[String: String] = ["type": "\(type)", "screen": "\(screen)"]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
//            }else{
//               
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    let data:[String: String] = ["type": "\(type)", "screen": "\(screen)"]
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
//                }
//            }
//         }
           completionHandler()
       }
    
    
    
    // for appFlyer
//    func application(_ application: UIApplication,
//                     continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        // Handle AppsFlyer Universal Links
//        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
//        return true
//    }
    
    func application(_ application: UIApplication,
                        open url: URL,
                        sourceApplication: String?,
                        annotation: Any) -> Bool {
           AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
           return true
       }
    
 

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        // Bridge the restorationHandler to match AppsFlyer's expected type
        let appsFlyerRestorationHandler: ([Any]?) -> Void = { restoringObjects in
            restorationHandler(restoringObjects as? [UIUserActivityRestoring])
        }
        
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: appsFlyerRestorationHandler)
        return true
    }
 
        
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        print("Conversion data received: \(conversionInfo)")
        
        // Example: Parse conversion data
        if let status = conversionInfo["af_status"] as? String {
            if status == "Non-organic" {
                if let mediaSource = conversionInfo["media_source"] as? String,
                   let campaign = conversionInfo["campaign"] as? String {
                    
                    print("App was installed via \(mediaSource)")
                    
                    print("User came from a Non-organic source")
                    print("Media Source: \(mediaSource), Campaign: \(campaign)")
                }
            } else {
                print("User came from an Organic source")
            }
        }
        
        // Handle deep linking data if available
        if let deepLinkValue = conversionInfo["deep_link_value"] as? String {
            print("Deep Link Value: \(deepLinkValue)")
            // Navigate to a specific screen in your app
        }
     }
    
 

    func onConversionDataFail(_ error: Error) {
        print("Failed to retrieve conversion data: \(error.localizedDescription)")
        
        // Optionally, show an alert or retry
        // Example:
        // showAlert(title: "Error", message: "Failed to retrieve conversion data")
    }

}
 
 
extension AppDelegate: DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .found:
            if let deepLink = result.deepLink {
                 
                // Handle deep link data
                print("Deep link data: \(deepLink.clickEvent)")
                let Result = deepLink.clickEvent
                
                print("Resultdata: \(Result)")
                
                // Check if "referral_code" is available as a query parameter
                if let referralCode = Result.first(where: { $0.key == "referral_code" })?.value as? String {
                    print("Referral Code: \(referralCode)")
                    // Handle the referral code (e.g., save it, show it, or process it)
                }
                
                let ProvName = Result.first(where: { $0.key == "providerName" })?.value as? String ?? ""
                let ProvImage = Result.first(where: { $0.key == "providerImage" })?.value as? String ?? ""
                let Referrer = Result.first(where: { $0.key == "Referrer" })?.value as? String ?? ""
                
                StateMangerModelClass.shared.ProviderName = ProvName
                StateMangerModelClass.shared.ProviderImg = ProvImage
                StateMangerModelClass.shared.ReffCode = Referrer
                 
                
                let screenName = Result.first(where: { $0.key == "ScreenName" })?.value as? String ?? ""
                let cookbooksID = Result.first(where: { $0.key == "CookbooksID" })?.value as? String ?? ""
                let ItmName = Result.first(where: { $0.key == "ItemName" })?.value as? String ?? ""
                
                
                print("ScreenName: \(screenName)")
                print("CookbooksID: \(cookbooksID)")
                
                
                if screenName != "" && cookbooksID != "" {
                    let data:[String: String] = ["CookbooksID": "\(cookbooksID)", "ScreenName": "\(screenName)", "ItmName": "\(ItmName)"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameUser"), object: nil, userInfo: data)
                }
            }
        case .notFound:
            print("No deep link found.")
        case .failure:
            print("Error resolving deep link: \(result.error?.localizedDescription ?? "Unknown error")")
        @unknown default:
            break
        }
    }
}
