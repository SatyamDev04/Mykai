//
//  Constant.swift
//  My Meeting Card
//
//  Created by pranjali kashyap on 04/03/22.
//


import UIKit

class UserDetail: NSObject {
    
static let shared = UserDetail()
    private override init() { }
    
    func setLoginSession(_ sUserId:Bool) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.LoginSession.rawValue)
        print(sUserId)
    }
    func getLoginSession() -> Bool {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.LoginSession.rawValue) as? Bool
        {
            return userId
        }
        return false
    }
    
    func removeLoginSession() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.UserType.rawValue)
    }
    
    //
    func setUserType(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.UserType.rawValue)
        print(sUserId)
    }
    func getUserType() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.UserType.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeUserType() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.UserType.rawValue)
    }
    //
    
    func setUserId(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.userid.rawValue)
        print(sUserId)
    }
    func getUserId() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.userid.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeUserId() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.userid.rawValue)
    }
     
    //
    func setTokenWith(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.Token.rawValue)
        print(sUserId)
    }
    func getTokenWith() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.Token.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeTokenWith() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.Token.rawValue)
    }
    
    func setisSignInWith(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.isSignIn.rawValue)
        print(sUserId)
    }
    func getisSignInWith() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.isSignIn.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeisSignInWith() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.isSignIn.rawValue)
    }
    
    //
    func setLocationStatus(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.LocationStatus.rawValue)
        print(sUserId)
    }
    
    func getLocationStatus() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.LocationStatus.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeLocationStatus() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.LocationStatus.rawValue)
    }
    
    //
    func setOnboardingStatus(_ sUserId:Bool) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.OngoingStatus.rawValue)
        print(sUserId)
    }
    
    func getOnboardingStatus() -> Bool {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.OngoingStatus.rawValue) as? Bool
        {
            return userId
        }
        return false
    }
    
    func removeOnboardingStatus() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.OngoingStatus.rawValue)
    }
    
    //
    func setLogoutStatus(_ sUserId:Bool) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.LogoutStatus.rawValue)
        print(sUserId)
    }
    
    func getLogoutStatus() -> Bool {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.LogoutStatus.rawValue) as? Bool
        {
            return userId
        }
        return false
    }
    
    
    func setiSfromSignup(_ sUserId:Bool) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.iSfromSignup.rawValue)
        print(sUserId)
    }
    
    func getiSfromSignup() -> Bool {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.iSfromSignup.rawValue) as? Bool
        {
            return userId
        }
        return false
    }
    
    
    
  
    // login credentials.
    
    func setUserEmail_Phone(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.email_Phone.rawValue)
        print(sUserId)
    }
    func getUserEmail_Phone() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.email_Phone.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeUserEmail_Phone() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.email_Phone.rawValue)
    }
    
    func setUserPass(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.pass.rawValue)
        print(sUserId)
    }
    func getUserPass() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.pass.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeUserPass() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.pass.rawValue)
    }
    //
    
    func setUserRefferalCode(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.RefferalCode.rawValue)
        print(sUserId)
    }
    func getUserRefferalCode() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.RefferalCode.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func seturlSearch(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.urlSearch.rawValue)
        print(sUserId)
    }
    func geturlSearch() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.urlSearch.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func setfavorite(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.favorite.rawValue)
        print(sUserId)
    }
    func getfavorite() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.favorite.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func setaddmeal(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.addmeal.rawValue)
        print(sUserId)
    }
    func getaddmeal() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.addmeal.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func setimageSearch(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.imageSearch.rawValue)
        print(sUserId)
    }
    
    func getimageSearch() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.imageSearch.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    //
    func setSubscriptionStatus(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.SubscriptionStatus.rawValue)
        print(sUserId)
    }
    func getSubscriptionStatus() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.SubscriptionStatus.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeSubscriptionStatus() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.SubscriptionStatus.rawValue)
    }
}
  
    
enum UserKeys:String {
    case UserType = "UserType"
    case userid = "user_id"
    case Token = "Token"
    case isSignIn = "isSignIn"
    case LocationStatus = "LocationStatus"
    case OngoingStatus = "OngoingStatus"
    case LoginSession = "LoginSession"
    case LogoutStatus = "LogoutStatus"
    case SubscriptionStatus = "SubscriptionStatus"
    case email_Phone = "email_Phone"
    case pass = "pass"
    case RefferalCode = "RefferalCode"
    case imageSearch = "imageSearch"
    case addmeal = "addmeal"
    case favorite = "favorite"
    case urlSearch = "urlSearch"
    case iSfromSignup = "iSfromSignup"
}
 
