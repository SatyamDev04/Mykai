//
//  TabbarVC.swift
//  Myka App
//
//  Created by YES IT Labs on 03/12/24.
//

import UIKit
import Alamofire
  
class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var PlanTabTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // to remove top line of tabbar
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionuser(_:)), name: NSNotification.Name(rawValue: "notificationNameUser"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.addGreenDotToTabBarItem(at: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        addGreenDotToTabBarItem(at: 0)
    }
    
    @objc func listnerFunctionuser(_ notification: NSNotification) {
        let cookbooksID = notification.userInfo?["CookbooksID"] as? String ?? ""
        let screen = notification.userInfo?["ScreenName"] as? String ?? ""
        let ItmName = notification.userInfo?["ItmName"] as? String ?? ""
        
        if cookbooksID != ""{
            self.Api_To_SaveCookBook(CookBookID:cookbooksID)
        }
        
        if screen == "CookBooksType"{
            removeGreenDotAndHalfCircle()
            self.selectedIndex = 0
            addGreenDotToTabBarItem(at: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let data:[String: String] = ["CookbooksID": "\(cookbooksID)", "ScreenName": "\(screen)", "ItmName": "\(ItmName)"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameUserr"), object: nil, userInfo: data)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Increase the height of the tab bar
        if UIDevice.current.hasNotch {
            //... consider notch
            var tabFrame = tabBar.frame
            tabFrame.size.height = 90  // Set the desired height
            tabFrame.origin.y = view.frame.size.height - 90 // Ensure it stays at the bottom
            tabBar.frame = tabFrame
        } else{
            //... don't have to consider notch
            var tabFrame = tabBar.frame
            tabFrame.size.height = 60  // Set the desired height
            tabFrame.origin.y = view.frame.size.height - 60 // Ensure it stays at the bottom
            tabBar.frame = tabFrame
        }
    }

   
    // Method to add a green dot with a half circle behind it to a specific tab bar item
    
    func addGreenDotToTabBarItem(at index: Int) {
        guard let tabBarItems = tabBar.items else { return }
        
        let selectedItem = tabBarItems[index]
        
        // Create the half circle (semicircle) view (background for the dot)
        let halfCircle = UIView()
        halfCircle.frame.size = CGSize(width: 25, height: 25) // Size of the half circle (semicircle)
        halfCircle.tag = 100 // Tag to identify the half circle view
        
        // Create a semicircle shape using a UIBezierPath
        let path = UIBezierPath(arcCenter: CGPoint(x: halfCircle.bounds.width / 2, y: halfCircle.bounds.height),
                                radius: halfCircle.bounds.width / 2,
                                startAngle: 0, // Start from the top (0 radians)
                                endAngle: .pi,    // End at the bottom (π radians)
                                clockwise: false) // Draw counterclockwise
        
        // Create the shape layer to apply the semicircle mask
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        halfCircle.layer.mask = shapeLayer
        
        // Create the gradient layer for the semicircle
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = halfCircle.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor, // First color (clear)
            UIColor.white.cgColor  // Second color (white)
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // Gradient start point (top)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)   // Gradient end point (bottom)
        
        // Apply the gradient layer to the semicircle view
        halfCircle.layer.insertSublayer(gradientLayer, at: 0)
        
        // Rotate the semicircle 180 degrees to flip it so the flat edge is on top
        halfCircle.transform = CGAffineTransform(rotationAngle: .pi)
        
        // Create the green dot view
        let greenDot = UIView()
        greenDot.backgroundColor = UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1) // Green dot color
        greenDot.layer.cornerRadius = 7 // Half of the dot's size
        greenDot.layer.masksToBounds = true
        greenDot.frame.size = CGSize(width: 14, height: 14) // Dot size
        greenDot.tag = 99 // Tag to identify the dot later
        
        // Calculate the position for the semicircle and the green dot
        if let itemView = selectedItem.value(forKey: "view") as? UIView {
            let xPosition = itemView.frame.origin.x + itemView.frame.width / 2 - halfCircle.frame.width / 2
            let yPosition = itemView.frame.origin.y - halfCircle.frame.height + 24 // Adjust the value to move it higher
            
            halfCircle.frame.origin = CGPoint(x: xPosition, y: yPosition)
            greenDot.frame.origin = CGPoint(x: xPosition + (halfCircle.frame.width - greenDot.frame.width) / 2, y: yPosition - 6)

            // Add the semicircle and green dot to the tab bar
            tabBar.addSubview(halfCircle)
            tabBar.addSubview(greenDot)
        }
    }


    // Optionally, remove the green dot and half circle when another tab is selected
    func removeGreenDotAndHalfCircle() {
        for subview in tabBar.subviews where subview.tag == 99 || subview.tag == 100 {
            subview.removeFromSuperview()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           // Get the index of the currently selected tab
           guard let currentIndex = viewControllers?.firstIndex(of: selectedViewController!) else {
               return true
           }

           // Get the index of the tab being tapped
           guard let targetIndex = viewControllers?.firstIndex(of: viewController) else {
               return true
           }

           // Allow switching only if the target tab is not the second tab
        if targetIndex == 1 && currentIndex == 3 {
               let data:[String: String] = ["data": "SearchPopup"]
                       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
               return false // Prevent switching
           }
        
        //
        if currentIndex == 0 && targetIndex == 2 {
            let data: [String: String] = ["data": "AddRecipePopup"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameAddRecipeH"), object: nil, userInfo: data)
            return false // Prevent switching
        }
        
        if currentIndex == 1 && targetIndex == 2 {
            let data: [String: String] = ["data": "AddRecipePopup"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameAddRecipeS"), object: nil, userInfo: data)
            return false // Prevent switching
        }
        
        if currentIndex == 3 && targetIndex == 2 {
            let data: [String: String] = ["data": "AddRecipePopup"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameAddRecipeP"), object: nil, userInfo: data)
            return false // Prevent switching
        }
        
        if currentIndex == 4 && targetIndex == 2 {
            let data: [String: String] = ["data": "AddRecipePopup"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameAddRecipeY"), object: nil, userInfo: data)
            return false // Prevent switching
        }
        
     
        removeGreenDotAndHalfCircle()
        addGreenDotToTabBarItem(at: targetIndex)
        
           return true
       }
   

    // Call this when a tab is selected
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         
        
        if let index = tabBar.items?.firstIndex(of: item) {
            if StateMangerModelClass.shared.SearchClickFromPopup == true{
                removeGreenDotAndHalfCircle()
                addGreenDotToTabBarItem(at: index) // Re-add the half circle and dot for the newly selected tab
                StateMangerModelClass.shared.SearchClickFromPopup = false
            }
             
                let rootView = self.viewControllers![index] as! UINavigationController
                rootView.popToRootViewController(animated: false)
          //  }
        }
    }
    
//    func reinitializeTabAtIndex(_ index: Int) {
//        // Check if the index exists in the viewControllers array
//        if var viewControllers = self.viewControllers, viewControllers.count > index {
//            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
//            if let newViewController = storyboard.instantiateViewController(withIdentifier: "PlanVc") as? PlanVc {
//                // Assign the existing tabBarItem to the new view controller
//                newViewController.tabBarItem = viewControllers[index].tabBarItem
//                
//                viewControllers[index] = newViewController
//                self.viewControllers = viewControllers
//                print("Tab \(index) reinitialized.")
//            } else {
//                print("Failed to instantiate PlanVc.")
//            }
//        } else {
//            print("Invalid index or no viewControllers set.")
//        }
//    }
    
    func Api_To_SaveCookBook(CookBookID:String){
        
        var params:JSONDictionary = [:]
        
        params["cook_book_id"] = CookBookID
        
       
     //   showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.Updateprefrence
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
         //   self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
         //       self.getBasketListData()
            }else{
           //     let responseMessage = dictData["message"] as! String
            //    self.showToast(responseMessage)
            }
        })
    }
}
