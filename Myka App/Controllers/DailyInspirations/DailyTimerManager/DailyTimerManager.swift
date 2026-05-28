//
//  DailyTimerManager.swift
//  My-Kai
//
//  Created by YES IT Labs on 17/02/25.
//

import Foundation
import UIKit

class DailyTimerManager {
    static let shared = DailyTimerManager()
    
    private var timer: DispatchSourceTimer?
    private let lastShownKey = "lastShownDailyInspirations"
    
    private init() {}
    
    func startTimer() {
        // If the timer is already running, do nothing
        if timer != nil { return }
        
        // Create a timer
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        // Schedule the timer to fire every minute
        timer?.schedule(deadline: .now(), repeating: .seconds(60))
        
        timer?.setEventHandler { [weak self] in
            self?.checkAndShowDailyInspirations()
        }
        
        // Start the timer
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func checkAndShowDailyInspirations() {
        let currentDate = Date()
        let lastShownDate = UserDefaults.standard.object(forKey: lastShownKey) as? Date
        
        // Check if 24 hours have passed
        if let lastShownDate = lastShownDate {
            let timeInterval = currentDate.timeIntervalSince(lastShownDate)
            let hoursPassed = timeInterval / 3600
            if hoursPassed < 24 {
                return // Do nothing if less than 24 hours
            }
        }

        DispatchQueue.main.async {
            if self.presentDailyInspirationsVC() {
                UserDefaults.standard.set(currentDate, forKey: self.lastShownKey)
            }
        }
    }
    
    @discardableResult
    private func presentDailyInspirationsVC() -> Bool {
        guard let topController = UIApplication.topViewController() else { return false }
        
        guard UserDetail.shared.getLoginSession() == true else { return false }
        guard canPresentDailyInspirations(from: topController) else { return false }
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DailyInspirationsVC") as? DailyInspirationsVC {
            topController.addChild(vc)
            vc.view.frame = topController.view.frame
            topController.view.addSubview(vc.view)
            topController.view.bringSubviewToFront(vc.view)
            vc.didMove(toParent: topController)
            return true
        }

        return false
    }

    private func canPresentDailyInspirations(from topController: UIViewController) -> Bool {
        if topController is SplashViewController ||
            topController is letsStartVC ||
            topController is IntroVC ||
            topController is IntroVC1 ||
            topController is LoginVC ||
            topController is SignUpVC {
            return false
        }

        if topController is TabbarVC {
            return true
        }

        if topController.tabBarController is TabbarVC {
            return true
        }

        return false
    }
}
