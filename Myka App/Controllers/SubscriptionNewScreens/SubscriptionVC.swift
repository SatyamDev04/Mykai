//
//  SubscriptionVC.swift
//  My Kai
//
//  Created by YES IT Labs on 08/04/25.
//

import UIKit
import AdvancedPageControl
import SwiftGifOrigin
import Alamofire
import StoreKit

class SubscriptionVC: UIViewController {
    
    @IBOutlet weak var CloseBtnO: UIButton!
    @IBOutlet weak var TitleLbl: UILabel!
    
    @IBOutlet weak var PointLbl1: UILabel!
    @IBOutlet weak var PointLbl2: UILabel!
    @IBOutlet weak var PointBgV1: UIView!
    @IBOutlet weak var PointBgV2: UIView!
    @IBOutlet weak var Point2TickImg: UIImageView!
    
    @IBOutlet weak var CollV: UICollectionView!
    
    @IBOutlet weak var CollVBottmomCons: NSLayoutConstraint!
    
    @IBOutlet weak var PageViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var pageView: AdvancedPageControlView!
    
    @IBOutlet weak var RestoreBtnO: UIButton!
    
    
    var titleTxtArr = ["Save Time, Save Money,\nEat Better", "Endless Meals to Explore", "Eat Smart, Every Day", "Maximum Savings, Zero Hassle", "Show Me the Money!"]
    
    var PointTxtArr1 = ["Kai plans your meals, Compares store prices, And creates your cart so you don’t have to.", "Kai gives you access to over 80,000 recipes", "Kai helps you plan your week with recipes tailored to your preferences", "One tap, and all your weekly ingredients are in your cart ready for delivery", "Users save an average of $64 a week that’s an amazing $256* a month!"]
    
    var PointTxtArr2 = ["", "", "Stay on top of your nutrition with Kai’s daily nutrition tracker", "Compare grocery prices at nearby stores & have them delivered  right to your door", "With Kai, smart choices aren't just smart. They’re money in the bank"]
     
    
    var ImgArr = ["", "subs2", "subs3", "subs4", "subs5"]
    
    var comesFrom = ""
    
    var lastPlan = ""
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CloseBtnO.isHidden = true
        
        self.RestoreBtnO.isHidden = true
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.CloseBtnO.isHidden = false
        }
        
         
        pageView.drawer = ExtendedDotDrawer(numberOfPages: PointTxtArr1.count,
                                            height: 10.0,
                                            width: 12.0,
                                            space: 10.0,
                                            raduis: 10.0,
                                                indicatorColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1),
                                            dotsColor: .lightGray,
                                                isBordered: false,
                                                borderWidth: 0.0,
                                                indicatorBorderColor: .clear,
                                                indicatorBorderWidth: 0.0)
        
       
       // pageView.numberOfPages = imgArr.count
        pageView.drawer.currentItem = 0

        self.setCollVSpaceAccordingToDevice()
        
        self.CollV.register(UINib(nibName: "SubscriptionCollVCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCollVCell")
        self.CollV.delegate = self
        self.CollV.dataSource = self
        
        self.TitleLbl.text = titleTxtArr[0]
        self.PointLbl1.text = PointTxtArr1[0]
        self.PointLbl2.text = PointTxtArr2[0]
        self.Point2TickImg.image = UIImage(named: "")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        self.Api_To_fetchSubscription()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        IAPManager.shared.fetchProducts()
    }
    
    func setCollVSpaceAccordingToDevice() {
        if UIDevice.current.hasNotch {
            //... consider notch
            let modelName = UIDevice.modelName
            print(modelName, "modelName")
            if modelName.contains(find: "mini"){//"iPhone 12 mini"{
                self.PageViewBottomConst.constant = 10
                self.CollVBottmomCons.constant = 15
            }else if modelName.contains(find: "Max"){
                self.PageViewBottomConst.constant = 20
                self.CollVBottmomCons.constant = 35
            }else if modelName.contains(find: "Pro"){
                self.PageViewBottomConst.constant = 20
                self.CollVBottmomCons.constant = 35
            }else{
                self.PageViewBottomConst.constant = 10
                self.CollVBottmomCons.constant = 15
            }
        }else{
            self.PageViewBottomConst.constant = 10
            self.CollVBottmomCons.constant = 15
        }
    }
     
@objc func listnerFunction(_ notification: NSNotification) {
    if notification.userInfo?["data"] as? String ?? "" == "Purchase successful" {
        let Receipt = notification.userInfo?["Receipt"] as? String ?? ""
        hideIndicator()
        if Receipt != ""{
  
            hideIndicator()
            sendReceiptToServer(Receipt: Receipt)
        }
    }
        
  }

func sendReceiptToServer(Receipt: String) {
    var params = [String: Any]()

    params["receipt_data"] = Receipt
   
               
        self.hideIndicator()
        showIndicator(withTitle: "", and: "")
      
    let loginURL = baseURL.baseURL + appEndPoints.subscription_apple
        print(loginURL,"loginURL")

    WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in

        self.hideIndicator()
         
         guard let dictData = json.dictionaryObject else{
             return
         }
            if dictData["success"] as! Bool == true{
                 
                if self.comesFrom == "Signup" {
                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
              
            }
        })
      }
    
    
    
    @IBAction func CloseBtn(_ sender: UIButton) {
        if comesFrom == "Profile"{
        self.navigationController?.popViewController(animated: true)
    }else{
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        var indexes = self.CollV.indexPathsForVisibleItems
            
        indexes.sort()
        var index = indexes.first!
        index.row = index.row + 1
        
        print(index[1])
        
        if index[1] == 5{
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BupPlanVC") as! BupPlanVC
            vc.comesfrom = self.comesFrom
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CollV.scrollToItem(at: index, at: .left, animated: true)
            CollV.reloadItems(at: [index])
        }
    }
    
    @IBAction func RestorePurchaseBtn(_ sender: UIButton) {
//        if self.lastPlan == "weekly_plan"{
//        }else if lastPlan == "monthly_plan"{
//        }else if lastPlan == "annual_plan"{
//        }else{}
        showIndicator(withTitle: "", and: "")
        IAPManager.shared.restorePurchases()
    }
    
}

extension SubscriptionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PointTxtArr1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollVCell", for: indexPath) as! SubscriptionCollVCell
        
        let img = ImgArr[indexPath.item]
        
        if indexPath.item == 0{
            cell.FirstIndxBgV.isHidden = false
            cell.SecondIndxBgV.isHidden = true
            
            cell.GifImageV.image = UIImage.gif(name: "Paywall Gift Wiggle")
             
            let Attributes1: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Inter Medium", size: 20.0) ?? UIFont.systemFont(ofSize: 20)
            ]
            let Attributes2: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Inter Semi Bold", size: 20.0) ?? UIFont.systemFont(ofSize: 20)
            ]
             
                let helloString = NSAttributedString(string: "You’ve got a gift from", attributes: Attributes1)
            
            var worldString = NSAttributedString()
            
            if UserDetail.shared.getiSfromSignup() == true{
                let imgUrl = URL(string: StateMangerModelClass.shared.ProviderImg) ?? nil
                cell.ProfileImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "Prof"))
                
                if let firstName = StateMangerModelClass.shared.ProviderName.split(separator: " ").first {
                    cell.UserCookBookLbl.text = "\(firstName)’s secret cookbook"
                }else{
                    cell.UserCookBookLbl.text = "\(StateMangerModelClass.shared.ProviderName)’s secret cookbook"
                }
                
                worldString = NSAttributedString(string: "\n\(StateMangerModelClass.shared.ProviderName)", attributes: Attributes2)
            }else{
                cell.ProfileImg.image = UIImage(named: "Prof")
                
                cell.UserCookBookLbl.text = "Kai’s secret cookbook"
                
                worldString = NSAttributedString(string: "\nKai", attributes: Attributes2)
            }
                
                let fullString = NSMutableAttributedString()
                fullString.append(helloString)
                fullString.append(worldString)
            cell.TitleLbl.attributedText = fullString
             
        }else{
            cell.FirstIndxBgV.isHidden = true
            cell.SecondIndxBgV.isHidden = false
            cell.ImgV.image = UIImage(named: "\(img)")
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.CollV.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.CollV.cellForItem(at: index)!
        let position = self.CollV.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
           index.row = index.row+1
        }
//        if index[1] == 0 {
//            self.NextBtnBGV.isHidden = false
//            self.LetsGetBtnBGV.isHidden = true
//            UserDetail.shared.setOnboardingStatus(false)
//        }else if index[1] == 2{
//            self.NextBtnBGV.isHidden = true
//            self.LetsGetBtnBGV.isHidden = false
//            UserDetail.shared.setOnboardingStatus(true)
//        }else{
//            self.NextBtnBGV.isHidden = false
//            self.LetsGetBtnBGV.isHidden = true
//            UserDetail.shared.setOnboardingStatus(false)
//        }
        
        self.CollV.scrollToItem(at: index, at: .left, animated: true )
        //self.CollV.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let visibleRect = CGRect(origin: self.CollV.contentOffset, size: self.CollV.bounds.size)
           let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
           if let visibleIndexPath = self.CollV.indexPathForItem(at: visiblePoint) {
               
               let index = visibleIndexPath.row
               
               self.TitleLbl.text = titleTxtArr[index]
               self.PointLbl1.text = PointTxtArr1[index]
               self.PointLbl2.text = PointTxtArr2[index]
               
               if index == 0 || index == 1 {
                   self.Point2TickImg.image = UIImage(named: "")
               }else{
                   self.Point2TickImg.image = UIImage(named: "circle fill")
               }
               
               self.pageView.setPage(index)
              // CollV.reloadItems(at: [visibleIndexPath])
               
             //  updateCollectionViewFrame()
           }
    }
        
    
    func updateCollectionViewFrame() {
        // Force layout update
        self.CollV.layoutIfNeeded()
        
        // Calculate the new height
        let contentHeight = self.CollV.collectionViewLayout.collectionViewContentSize.height
        
        // Update the frame
        self.CollV.frame.size.height = contentHeight
    }
  }

extension SubscriptionVC : UICollectionViewDelegateFlowLayout {

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let collectionViewHeight = collectionView.frame.height
       print(collectionViewHeight, "collectionViewHeight")
    return CGSize(width: collectionView.frame.width, height: collectionViewHeight)
       
   }
 
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 10
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        CollV.collectionViewLayout.invalidateLayout() // Ensures layout is recalculated
//        CollV.reloadData()
//    }
    
}

extension SubscriptionVC{
    func Api_To_fetchSubscription(){
        
        var params:JSONDictionary = [:]

       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.checkSubscription
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                let Result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let SubscriptionStatus = Result["Subscription_status"] as? Int ?? Int()
                
                let last_plan = Result["last_plan"] as? String ?? String()
                
                self.lastPlan = last_plan
                
                if SubscriptionStatus == 1 && last_plan != ""{
                    self.RestoreBtnO.isHidden = false
                    }else{
                        self.RestoreBtnO.isHidden = true
                    }
   
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
