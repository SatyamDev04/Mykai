//
//  SelectMarketVC.swift
//  Myka App
//
//  Created by YES IT Labs on 16/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class SelectMarketVC: UIViewController {
    
    @IBOutlet weak var CollV: UICollectionView!
    
    @IBOutlet weak var Viewpopup: UIView!
    @IBOutlet weak var DragDownView: UIView!
    
    var SuperMarketArr = [MarketModel]()
    
    var currentPage = 1
    var hasReachedEnd = false
    var lastContentOffset: CGFloat = 0
    
    var backAction:()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        CollV.register(UINib(nibName: "SupermarketCollVCell", bundle: nil), forCellWithReuseIdentifier: "SupermarketCollVCell")//SelectMarketCollVCell
        CollV.delegate = self
        CollV.dataSource = self
         
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
                      dismiss(animated: true, completion: nil)
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
}

extension SelectMarketVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.SuperMarketArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupermarketCollVCell", for: indexPath) as! SupermarketCollVCell
//            
//        let Imgurl = SuperMarketArr[indexPath.item].image ?? ""
//        let URL = URL(string: Imgurl)
//        
//        cell.Img.sd_setImage(with: URL, placeholderImage: UIImage(named: "Market5"))
//        cell.Namelbl.text = self.SuperMarketArr[indexPath.item].storeName
//        cell.priceLbl.text = ""//self.SuperMarketArr[indexPath.item]
//        cell.PriceLblH.constant = 0
//        
//        let isSelected = self.SuperMarketArr[indexPath.item].isSlected ?? 0 // if 1 selected
//        
//        if isSelected == 1{
//            cell.BgV.borderWidth = 2
//            cell.BgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
//        }else{
//            cell.BgV.borderWidth = 2
//            cell.BgV.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupermarketCollVCell", for: indexPath) as! SupermarketCollVCell
        
        if SuperMarketArr[indexPath.item].isOpen == true{
            cell.ClosedBgV.isHidden = true
        }else{
            cell.ClosedBgV.isHidden = false
            
            let val = SuperMarketArr[indexPath.item].operationalHours ?? nil
           
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let CurrentDay = dateFormatter.string(from: today)
             
            var todayHours: String?
            
            switch CurrentDay {
            case "Sunday":
                todayHours = val?.sunday
            case "Monday":
                todayHours = val?.monday
            case "Tuesday":
                todayHours = val?.tuesday
            case "Wednesday":
                todayHours = val?.wednesday
            case "Thursday":
                todayHours = val?.thursday
            case "Friday":
                todayHours = val?.friday
            case "Saturday":
                todayHours = val?.saturday
            default:
                todayHours = nil
            }
             
            
            
            if let hours = todayHours {
                   print("Today's operational hours: \(hours)")
                let firstPart = hours.components(separatedBy: " - ").first ?? ""
                   cell.ClosedLbl.text = "Closed now\nOpen at \(firstPart)"
               } else {
                   print("No operational hours found for \(CurrentDay).")
               }
        }
        
      let img = SuperMarketArr[indexPath.item].image ?? ""
      let imgUrl = URL(string: img)
      
      cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
      cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
      
      let priceValue = SuperMarketArr[indexPath.item].total ?? 0
      let formattedPrice: String
      if priceValue == floor(priceValue) {
          // If the value is a whole number, show it as an integer
          formattedPrice = String(format: "%.0f", priceValue)
      } else {
          // If the value has decimals, round it to two decimal places
          formattedPrice = String(format: "%.2f", priceValue)
      }
      
      cell.priceLbl.text = "$\(formattedPrice)"
        
        let Dist = SuperMarketArr[indexPath.item].distance ?? ""
        let FDist = formatQuantity(Dist)
        cell.Mileslbl.text = "\(FDist) miles"
      
      let isSelected = SuperMarketArr[indexPath.item].isSlected ?? 0 // if 1 selected
      if isSelected == 1{
          cell.BgV.borderWidth = 2
          cell.BgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
      }else{
          cell.BgV.borderWidth = 2
          cell.BgV.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      }
      
      let isMissing = SuperMarketArr[indexPath.item].missing ?? 0 // if 0 all item avaialble
      if isMissing == 0{
          cell.Namelbl.text = "ALL ITEMS"
          cell.Namelbl.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
      }else{
          cell.Namelbl.text = "\(isMissing) ITEMS\nMISSING"
          cell.Namelbl.textColor = #colorLiteral(red: 1, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
      }

        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storeid = self.SuperMarketArr[indexPath.item].storeUUID ?? ""
        let StoreName = self.SuperMarketArr[indexPath.item].storeName ?? ""
        self.Api_To_UpdateSuperMarket(Storename: StoreName, StoreID: Storeid)
    }
    
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width/3 - 5, height: 185)
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
     }
    
    // UIScrollViewDelegate method for detecting scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Detect scrolling direction
        let isScrollingDown = offsetY > lastContentOffset
        lastContentOffset = offsetY

        // Define a buffer to detect nearing the bottom
        let buffer: CGFloat = 0.0 // Adjust as needed

        if isScrollingDown {
            // Reached near the bottom
            if offsetY >= contentHeight - frameHeight - buffer && !hasReachedEnd {
                hasReachedEnd = true
                print("Reached bottom")
                self.getSuperMarketData()
            }
        } else {
            // Detect scrolling out of bottom
            if hasReachedEnd && offsetY < contentHeight - frameHeight - buffer {
                hasReachedEnd = false
                print("Scrolled out of bottom")
                // Add actions for scrolling out of bottom if needed
            }
        }
    }
    
 
}

extension SelectMarketVC{
    
    func getSuperMarketData() {
        var params:JSONDictionary = [:]
        
        params["latitude"] = AppLocation.lat
        params["longitude"] = AppLocation.long
        params["page"] = self.currentPage
        
        showIndicator(withTitle: "", and: "")
        
        
        
        let loginURL = baseURL.baseURL + appEndPoints.super_markets
        print(params,"Params")
        print(loginURL,"loginURL")
     
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(MarketModelClass.self, from: data)
                if d.success == true {
                    self.hasReachedEnd = false
                    
                    let allData = d.data
                    
                    self.SuperMarketArr.append(contentsOf: allData ?? [])
                    
                    self.SuperMarketArr = self.SuperMarketArr.filter { store in
                        store.total != nil && store.total != 0.0
                    }
                     
                    self.CollV.reloadData()
                    
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
 
        func Api_To_UpdateSuperMarket(Storename:String, StoreID:String){
            var params = [String: Any]()
             
            params["store_name"] = Storename
            params["store_id"] = StoreID
          
            
            showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.select_store_product
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
                
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
                
                if dictData["success"] as? Bool == true{
                    self.dismiss(animated: true) {
                        self.backAction()
                    }
                }else{
                    let responseMessage = dictData["message"] as? String ?? ""
                    self.showToast(responseMessage)
                }
            })
        }
}
