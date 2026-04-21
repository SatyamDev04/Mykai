//
//  HSAppleSignIn.swift
//  YesChef
//
//  Created by Hitesh Surani on 13/02/20.
//  Copyright © 2020 Hitesh Surani. All rights reserved.
//

import Foundation
import AuthenticationServices

typealias AppleSignInBlock = ((_ userInfo:AppleInfoModel?,_ errorMessge:String?)->())?


class HSAppleSignIn : NSObject {
    
//    static let shared = HSAppleSignIn()
    
    var appleSignInBlock:AppleSignInBlock!
    weak var presentationWindow: UIWindow?
    
    override init() {
        
    }
    
    
    @available(iOS 13.0, *)
    func loginWithApple(view:UIView? = nil,type:ASAuthorizationAppleIDButton.ButtonType? = .signIn,style:ASAuthorizationAppleIDButton.Style? = .white,completionBlock:AppleSignInBlock){
        
        let appleButton = ASAuthorizationAppleIDButton.init(type: type!, style:style!)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(self.didTapLoginWithApple), for: .touchUpInside)
        
        if let view = view{
            view.addSubview(appleButton)
            
            let topConstraint = NSLayoutConstraint(item: appleButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: appleButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            
            let trailingConstraint = NSLayoutConstraint(item: appleButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: appleButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            
            
            NSLayoutConstraint.activate([topConstraint, bottomConstraint, trailingConstraint, leadingConstraint])
        }
        appleSignInBlock = completionBlock
    }
    
    
    @available(iOS 13.0, *)
    func getAppleSignInButtonTo(type:ASAuthorizationAppleIDButton.ButtonType? = .signIn,style:ASAuthorizationAppleIDButton.Style? = .white,completionBlock:AppleSignInBlock) -> ASAuthorizationAppleIDButton{
        
        let appleButton = ASAuthorizationAppleIDButton.init(type: type!, style:style!)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(self.didTapLoginWithApple), for: .touchUpInside)
        appleSignInBlock = completionBlock
        return appleButton
    }
}

extension HSAppleSignIn:ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    @objc func didTapLoginWithApple()
    {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
    }
    func didTapLoginWithApple1(from window: UIWindow?, completionBlock:AppleSignInBlock)
    {
        presentationWindow = window
        appleSignInBlock = completionBlock
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let presentationWindow = presentationWindow {
            return presentationWindow
        }

        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            return keyWindow
        }

        return ASPresentationAnchor()
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential
        {
        case let credential as ASAuthorizationAppleIDCredential:
            
            DispatchQueue.main.async {
                let userid = credential.user
                let email = credential.email ?? Keychain.email ?? ""
                let firstName = credential.fullName?.givenName ?? Keychain.firstName ?? ""
                let lastName = credential.fullName?.familyName ?? Keychain.lastName ?? ""
                let fullName = firstName + " " + lastName
                
                
                Keychain.userid = userid
                Keychain.firstName = firstName
                Keychain.lastName = lastName
                Keychain.email = email
                
                let userInfo = AppleInfoModel(userid: userid, email: email, firstName: firstName, lastName: lastName,fullName:fullName)
                self.appleSignInBlock?(userInfo,nil)
            }
            
            break
        default:
            break
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError

        if nsError.code == ASAuthorizationError.canceled.rawValue {
            return
        }

        if nsError.code == ASAuthorizationError.unknown.rawValue {
            appleSignInBlock?(nil,"Apple Sign In is temporarily unavailable. Please try again.")
            return
        }

        appleSignInBlock?(nil,error.localizedDescription)
    }
}
