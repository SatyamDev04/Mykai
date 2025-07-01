//
//  Searched_IngredientsListVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 03/02/25.
//

import UIKit
import SDWebImage

class Searched_IngredientsListVC: UIViewController {
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var Viewpopup: UIView!
    @IBOutlet weak var DragDownView: UIView!
    
    @IBOutlet weak var IMg: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubTitleLbl: UILabel!
    
       
    var SearchbyUrlList = ByUrl_IngredientsModel()
    
    var backaction:()->() = {}

       override func viewDidLoad() {
           super.viewDidLoad()
           self.TitleLbl.text = self.SearchbyUrlList.label ?? ""
           
           if self.SearchbyUrlList.source ?? "" != ""{
               self.SubTitleLbl.text = "by \(self.SearchbyUrlList.source ?? "")"
           }
           
           let img = self.SearchbyUrlList.images?.small?.url ?? ""
           self.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
           self.IMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
            

           tblV.register(UINib(nibName: "MissingIngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "MissingIngredientsTblVCell")
           tblV.delegate = self
           tblV.dataSource = self
           
           let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                      action: #selector(panGestureRecognizerHandler(_:)))
           DragDownView.addGestureRecognizer(gestureRecognizer)
       }
       
       @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
                 guard let rootView = view, let rootWindow = rootView.window else { return }
                 let rootWindowHeight: CGFloat = rootWindow.frame.size.height
       
                 let touchPoint = sender.location(in: view?.window)
                 var initialTouchPoint = CGPoint.zero
                 let blankViewHeight =  (rootWindowHeight - Viewpopup.frame.size.height)
                 let dismissDragSize: CGFloat = 200.00
       
                 switch sender.state {
                 case .began:
                     initialTouchPoint = touchPoint
                 case .changed:
                     // dynamic alpha
                     if touchPoint.y > (initialTouchPoint.y + blankViewHeight)  { // change dim background (alpha)
                         view.frame.origin.y = (touchPoint.y - blankViewHeight) - initialTouchPoint.y
                     }
       
                 case .ended, .cancelled:
                     if touchPoint.y - initialTouchPoint.y > (dismissDragSize + blankViewHeight) {
                         self.backaction()
                         self.willMove(toParent: nil)
                         self.view.removeFromSuperview()
                         self.removeFromParent()
                         self.navigationController?.popViewController(animated: true)
                     } else {
                         UIView.animate(withDuration: 0.2, animations: {
                             self.view.frame = CGRect(x: 0,
                                                      y: 0,
                                                      width: self.view.frame.size.width,
                                                      height: self.view.frame.size.height)
                         })
                         // alpha = 1
                     }
                 case .failed, .possible:
                     break
                 }
             }
    
    
    @IBAction func CancelBtn(_ sender: UIButton) {
      //  dismiss(animated: true, completion: nil)
        self.backaction()
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func FavBtn(_ sender: UIButton) {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavrouitPopupVC") as! FavrouitPopupVC
        vc.comesFrom = "FullCookingScheduleVC"
        vc.uri = self.SearchbyUrlList.uri ?? ""
        vc.selID = ""
        vc.typeclicked = ""
        vc.backAction = {
           // self.dismiss(animated: true) { self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            self.backaction()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.navigationController?.popViewController(animated: true)
           // }
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    func SubscriptionPopUp()  {
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionPopUpVC") as! SubscriptionPopUpVC
        vc.BackAction = {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BupPlanVC") as! BupPlanVC
            vc.comesfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
   }

extension Searched_IngredientsListVC:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SearchbyUrlList.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MissingIngredientsTblVCell") as! MissingIngredientsTblVCell
        
        cell.NameLbl.text = self.SearchbyUrlList.ingredients?[indexPath.row].food ?? ""
        
        let img = self.SearchbyUrlList.ingredients?[indexPath.row].image ?? ""
        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
         
        let Qnt = self.SearchbyUrlList.ingredients?[indexPath.row].quantity ?? 0
        let roundedValue = roundedFormattedValue(Qnt, decimalPlaces: 2)
        cell.QuentityLbl.text = "\(roundedValue) \(self.SearchbyUrlList.ingredients?[indexPath.row].measure ?? "")"
         
        cell.CheckBtn.isHidden = true
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
