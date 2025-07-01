//
//  CookBooksTypeVc.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import DropDown
import Alamofire
import SDWebImage
import AppsFlyerLib
import LinkPresentation


struct DropDownModule {
    var name: String
    var image: String
}

class CookBooksTypeVc: UIViewController {

    @IBOutlet weak var TitleLbl: UILabel!
    
    @IBOutlet weak var CollV: UICollectionView!
    
    @IBOutlet var RemoveBgV: UIView!
    
    // Move PopUp view.
    @IBOutlet var MoveBgV: UIView!
    @IBOutlet weak var MoveDropLbl: UITextField!
    //
    @IBOutlet weak var PopupMsgLbl: UILabel!
    
    
    var titleTxt = ""
    var type = ""
    var cookBookImg:UIImage?
    let dropDown = DropDown()
    let CelldropDown = DropDown()
  
    var dropDownData = [DropDownModule(name: "Edit Cookbook", image: "Edit"),DropDownModule(name: "Share Cookbook", image: "ShareIcon"),DropDownModule(name: "Delete Cookbook", image: "DeleteIcon")]
    
    var CelldropDownData = [DropDownModule(name: "Remove Recipe", image: "Group 1171276393"),DropDownModule(name: "Move Recipe", image: "Group 1171275890")]
    
    var cookBookDataArr = [Datum]()
    
    var DropcookBooksData = [FavDropDownModel]()

    var uri = ""
    var selID = ""
    var cookbookID = ""
    
    // for editcookbook
    var EditcookBooksData = FavDropDownModel()
    //
    
    var Tag = 0
    
    var UserName = ""
    var UserPickUrl = ""
    
    var SelIndx = 0
    
    var Private_PublicStatus = 1 // 1 for public and 0 for Private.
    
    var comesfromInvite = false
    
    var backAction:()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RemoveBgV.frame = self.view.bounds
        self.view.addSubview(self.RemoveBgV)
        self.RemoveBgV.isHidden = true
        
        self.MoveBgV.frame = self.view.bounds
        self.view.addSubview(self.MoveBgV)
        self.MoveBgV.isHidden = true
        
        
        self.TitleLbl.text = "\(titleTxt)"// Collection"
        
        CollV.register(UINib(nibName: "CookBooksCollVCell", bundle: nil), forCellWithReuseIdentifier: "CookBooksCollVCell")
        CollV.delegate = self
        CollV.dataSource = self
        
        planService.shared.Api_To_Get_ProfileData(vc: self) { result in
            
            switch result {
            case .success(let allData):
                let response = allData
                
                let Name = response?["name"] as? String ?? String()
                self.UserName = Name.capitalizedFirst
                
                let ProfImg = response?["profile_img"] as? String ?? String()
                let img = "\(baseURL.imageUrl)\(ProfImg)"
                self.UserPickUrl = img
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        
        if self.comesfromInvite == true{
            self.Api_To_AddCookBookFromInvite()
            self.comesfromInvite = false
        }else{
            self.Api_To_GetCookBookType()
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddRecipeBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateRecipeVC") as! CreateRecipeVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ThreeDotBtn(_ sender: UIButton) {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        dropDown.dataSource = self.dropDownData.map { $0.name }
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 160 // Adjust as needed
          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
          dropDown.width = 180
          dropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          dropDown.layer.shadowOpacity = 0
          dropDown.layer.shadowRadius = 4
          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
          dropDown.backgroundColor = .white
          dropDown.cellHeight = 35

          // Use custom cell configuration
          dropDown.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
          dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
              guard let cell = cell as? CustomDropDownCell else { return }
              guard let self = self else { return }
              let img = self.dropDownData[index].image
              cell.logoImageView.image = UIImage(named: img)
          }
          
          // Handle selection
          dropDown.selectionAction = { [weak self] (index: Int, item: String) in
              guard let self = self else { return }
              print(index)
              if index == 0 {
                
                  let storyboard = UIStoryboard(name: "Fav", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "CreateCookbookVC") as! CreateCookbookVC
                  vc.comesfrom = "EditcookBooks"
                  vc.EditcookBooksData = self.EditcookBooksData
                  vc.titleStr = self.titleTxt
                  vc.backAction = { data  in
                      self.EditcookBooksData.image = data.image
                      self.EditcookBooksData.name = data.name
                      self.EditcookBooksData.status = data.status
                      
                      self.titleTxt = data.name ?? ""
                      self.TitleLbl.text = "\(self.titleTxt)"
                  }
                  self.navigationController?.pushViewController(vc, animated: true)
             
              }else if index == 1 {
                  guard self.Private_PublicStatus == 1 else{
                      AlertControllerOnr(title: "", message: "You can't share this cookbook as it is private.")
                      return
                  }
                  generateInviteLink { inviteLink in
                      let productImage = self.cookBookImg
                      
                      guard let inviteURL = URL(string: inviteLink) else { return }
                      
                      // 1. Product details with title and link included in the text
                      let productText = "Hey! I put together this cookbook in My Kai, and I think you’ll love it! It’s packed with delicious meals, check it out and let me know what you think!\n\nCookbook: \(self.titleTxt)\n"
                      
                      // 3. Prepare items to share
                      let itemsToShare: [Any] = [productText, productImage!, inviteURL]
                      
                      // 4. Create and present the UIActivityViewController
                      let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                      
                      // Exclude irrelevant activities if needed
                      activityViewController.excludedActivityTypes = [
                        .addToReadingList,
                        .saveToCameraRoll,
                        .assignToContact
                      ]
                      
                      // Present the activity view controller
                      DispatchQueue.main.async {
                          self.present(activityViewController, animated: true, completion: nil)
                      }
        
                    }
              }else{
                  self.PopupMsgLbl.text = "Do you really want to remove this cookbook?"
                  self.RemoveBgV.isHidden = false
                  self.Tag = 0
              }
          }
          dropDown.show()
    }
    
    func generateInviteLink(completion: @escaping (String) -> Void) {
//        let tempID = AppsFlyerLib().appleAppID
//        
//        
//        let baseURL = "https://mykaimealplanner.onelink.me/mPqu/" //ns5ueabp      Replace with your OneLink template
//        
//        let add = AppsFlyerLib()
//      
//        let userID = UserDetail.shared.getUserId() // Replace with your dynamic user identifier
//        let parameters: [String: String] = [
//           // "af_sub1": "invite",
//            "tempId": tempID,
//            "af_user_id": userID,
//            "CookbooksID":self.type,
//            "ScreenName":"CookBooksType",
//            "ItemName":self.titleTxt,
//            "providerName": self.UserName,
//            "providerImage": self.UserPickUrl,
//            "Referrer":UserDetail.shared.getUserRefferalCode()
//        ]
//        
//        
//        var components = URLComponents(string: baseURL)
//        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//
//        if let fullURL = components?.url?.absoluteString {
//            completion(fullURL)
//        } else {
//            print("Failed to create invite link.")
//        }
      
 
        let userID = UserDetail.shared.getUserId()
        let afUserId = userID
        let referrerCode = UserDetail.shared.getUserRefferalCode()
        let providerName = self.UserName
        let providerImage = self.UserPickUrl
        let CookBookType = "CookBooksType"
        let cookBookID = self.type
        let Name = self.titleTxt
       
    
         
        // Base URL for the OneLink template
        let baseURL = "https://mykaimealplanner.onelink.me/mPqu/" // Replace with your OneLink template
         
        // Deep link URL for when the app is installed
        let deepLink = "mykai://property?" +
            "af_user_id=\(afUserId)" +
            "&Referrer=\(referrerCode)" +
            "&providerName=\(providerName)" +
            "&providerImage=\(providerImage)" +
            "&CookbooksID=\(cookBookID)" +
            "&ItemName=\(Name)" +
            "&ScreenName=\(CookBookType)"
            
        
        // Web fallback URL (e.g., if app is not installed)
        let webLink = "https://www.mykaimealplanner.com" // Replace with your fallback web URL
         
        // Create the final URL with query parameters
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "af_dp", value: deepLink),
            URLQueryItem(name: "af_web_dp", value: webLink)
        ]
         
        // Convert to string and log or use the URL
        if let fullURL = components.url?.absoluteString {
            let referLink = fullURL

            completion(referLink)

            print("Generated OneLink URL: \(referLink)")
        }
    }
 //
   
    // with border image and text.
//    func generateProductImage(title1: String, image: UIImage, desc: String) -> UIImage{
//        // Constants for padding, colors, and image size
//          let textToImagePadding: CGFloat = 20 // Space above and below the image
//          let imageSize: CGSize = CGSize(width: 150, height: 150)
//          let cornerRadius: CGFloat = 10
//        let titleBackgroundColor = UIColor(white: 1.0, alpha: 0.0) // Light gray background
//        let descBackgroundColor = UIColor(white: 1.0, alpha: 0.0) // Light gray background
//
//          // Title Attributes
//          let title1ParagraphStyle = NSMutableParagraphStyle()
//          title1ParagraphStyle.lineBreakMode = .byWordWrapping
//          title1ParagraphStyle.alignment = .left
//
//          let title1Attributes: [NSAttributedString.Key: Any] = [
//              .font: UIFont.systemFont(ofSize: 20, weight: .medium),
//              .foregroundColor: UIColor.black,
//              .paragraphStyle: title1ParagraphStyle
//          ]
//
//          // Calculate Title Height
//          let title1BoundingRect = title1.boundingRect(
//              with: CGSize(width: 375, height: CGFloat.greatestFiniteMagnitude),
//              options: .usesLineFragmentOrigin,
//              attributes: title1Attributes,
//              context: nil
//          )
//          let title1Height = ceil(title1BoundingRect.height)
//
//          // Description Attributes
//          let descParagraphStyle = NSMutableParagraphStyle()
//          descParagraphStyle.lineBreakMode = .byWordWrapping
//          descParagraphStyle.alignment = .left
//
//          let descAttributes: [NSAttributedString.Key: Any] = [
//              .font: UIFont.systemFont(ofSize: 20, weight: .medium),
//              .foregroundColor: UIColor.black,
//              .paragraphStyle: descParagraphStyle
//          ]
//
//          // Calculate Description Height
//          let descBoundingRect = desc.boundingRect(
//              with: CGSize(width: 375, height: CGFloat.greatestFiniteMagnitude),
//              options: .usesLineFragmentOrigin,
//              attributes: descAttributes,
//              context: nil
//          )
//          let descHeight = ceil(descBoundingRect.height)
//
//          // Calculate Total Canvas Height
//          let totalHeight = title1Height + textToImagePadding + imageSize.height + textToImagePadding + descHeight
//          let canvasSize = CGSize(width: 375, height: totalHeight)
//
//          // Render Image
//          let renderer = UIGraphicsImageRenderer(size: canvasSize)
//
//          return renderer.image { context in
//              // Background color
//              UIColor.white.setFill()
//              context.fill(CGRect(origin: .zero, size: canvasSize))
//
//              // Draw Title Background
//              let title1BackgroundRect = CGRect(x: 0, y: 0, width: canvasSize.width, height: title1Height)
//              let title1Path = UIBezierPath(roundedRect: title1BackgroundRect, cornerRadius: cornerRadius)
//              titleBackgroundColor.setFill()
//              title1Path.fill()
//
//              // Draw Title
//              title1.draw(with: title1BackgroundRect.insetBy(dx: 10, dy: 0), options: .usesLineFragmentOrigin, attributes: title1Attributes, context: nil)
//
//              // Draw Image
//              let imageYPosition = title1BackgroundRect.maxY + textToImagePadding
//              let imageRect = CGRect(x: (canvasSize.width - imageSize.width) / 2, y: imageYPosition, width: imageSize.width, height: imageSize.height)
//              image.draw(in: imageRect)
//
//              // Draw Description Background
//              let descYPosition = imageRect.maxY + textToImagePadding
//              let descBackgroundRect = CGRect(x: 0, y: descYPosition, width: canvasSize.width, height: descHeight)
//              let descPath = UIBezierPath(roundedRect: descBackgroundRect, cornerRadius: cornerRadius)
//              descBackgroundColor.setFill()
//              descPath.fill()
//
//              // Draw Description
//              desc.draw(with: descBackgroundRect.insetBy(dx: 10, dy: 0), options: .usesLineFragmentOrigin, attributes: descAttributes, context: nil)
//          }
//      }
      
    
    // remove popup btns
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.RemoveBgV.isHidden = true
    }
    
    @IBAction func RemoveBtn(_ sender: UIButton) {
        self.RemoveBgV.isHidden = true
        if self.Tag != 0{
            self.Api_To_RemoveFavMeal()
        }else{
            self.Api_To_Delete_CookBook()
        }
    }
     
    
    // remove popup btns
    
    @IBAction func MoveDropBtn(_ sender: UIButton) {
        CelldropDown.dataSource = DropcookBooksData.map { $0.name ?? "" }
        CelldropDown.anchorView = sender
        CelldropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        CelldropDown.show()
        CelldropDown.setupCornerRadius(10)
        CelldropDown.backgroundColor = .white
        CelldropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        CelldropDown.layer.shadowOpacity = 0
        CelldropDown.layer.shadowRadius = 4
        CelldropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        CelldropDown.selectionAction = { [self] (index: Int, item: String) in
            self.MoveDropLbl.text = item
            print(index)
            self.selID = "\(cookBookDataArr[sender.tag].id ?? 0)"
            self.cookbookID = "\(DropcookBooksData[index].id ?? 0)"
        }
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.MoveBgV.isHidden = true
    }
    
    @IBAction func MoveBtn(_ sender: UIButton) {
        self.Api_To_MoveMeal()
    }
}


extension CookBooksTypeVc: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cookBookDataArr.count
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CookBooksCollVCell", for: indexPath) as! CookBooksCollVCell
        
        let data = cookBookDataArr[indexPath.row].data?.recipe
        cell.NameLbl.text = data?.label
        cell.TimeLbl.text = "\(data?.totalTime ?? 0) min"
        
            let imgUrl =  data?.images?.large?.url ?? ""
        cell.img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
        
       // cell.DotBtn.isHidden = true
            cell.DotBtn.tag = indexPath.row
            cell.DotBtn.addTarget(self, action: #selector(OptnsBtnTapped), for: .touchUpInside)
             
            cell.CartBtn.tag = indexPath.row
            cell.CartBtn.addTarget(self, action: #selector(AddtoBasketBtnClick), for: .touchUpInside)
            
        cell.AddToPlanBtn.tag = indexPath.row
        cell.AddToPlanBtn.addTarget(self, action: #selector(AddToPlanBtnTapped), for: .touchUpInside)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let data = cookBookDataArr[indexPath.item].data?.recipe
           
            guard data?.label != nil else {
                AlertControllerOnr(title: "", message: "You can view this recipe after 45 minutes")
                return
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            let Type = cookBookDataArr[indexPath.item].data?.recipe?.mealType?[0] ?? ""
            let type = Type.prefix(while: { $0 != "/" })
            vc.MealType = "\(type)"
            vc.uri = self.cookBookDataArr[indexPath.item].data?.recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    
    @objc func OptnsBtnTapped(sender: UIButton){
        dropDown.dataSource = self.CelldropDownData.map { $0.name }
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 120 // Adjust as needed
          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
          dropDown.width = 140
          dropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          dropDown.layer.shadowOpacity = 0
          dropDown.layer.shadowRadius = 4
          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
          dropDown.backgroundColor = .white
          dropDown.cellHeight = 32
          dropDown.textFont = UIFont.systemFont(ofSize: 11)

          // Use custom cell configuration
          dropDown.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
          dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
              guard let cell = cell as? CustomDropDownCell else { return }
              guard let self = self else { return }
              let img = self.CelldropDownData[index].image
              cell.logoImageView.image = UIImage(named: img)
          }
          
          // Handle selection
          dropDown.selectionAction = { [weak self] (index: Int, item: String) in
              guard let self = self else { return }
              print(index)
              if index == 0 {
                  self.PopupMsgLbl.text = "Do you really want to remove this recipe?"
                  self.Tag = 1
                  self.RemoveBgV.isHidden = false
                  self.uri = cookBookDataArr[sender.tag].uri ?? ""
                  self.selID = "\(cookBookDataArr[sender.tag].id ?? 0)"
                  self.SelIndx = sender.tag
              }else{
                  self.MoveBgV.isHidden = false
              }
          }
          
          dropDown.show()
    }
     
    @objc func AddtoBasketBtnClick(_ sender: UIButton)   {
        
        let data = cookBookDataArr[sender.tag].data?.recipe
       
        guard data?.label != nil else {
            AlertControllerOnr(title: "", message: "You can view this recipe after 45 minutes")
            return
        }
       
        let uri = self.cookBookDataArr[sender.tag].data?.recipe?.uri ?? ""
        
        let mealType = self.cookBookDataArr[sender.tag].data?.recipe?.mealType?.first ?? ""
        
        let Type = mealType.components(separatedBy: "/").first ?? ""
        self.Api_To_AddToBasket_Recipe(uri: uri, type: Type)
      }
    
    @objc func AddToPlanBtnTapped(sender: UIButton){
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let data = cookBookDataArr[sender.tag].data?.recipe
       
        guard data?.label != nil else {
            AlertControllerOnr(title: "", message: "You can view this recipe after 45 minutes")
            return
        }
         
        let uri = cookBookDataArr[sender.tag].data?.recipe?.uri ?? ""
        let Type = cookBookDataArr[sender.tag].data?.recipe?.mealType?[0] ?? ""
        let type = Type.prefix(while: { $0 != "/" })
         
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseDaysVC") as! ChooseDaysVC
        vc.backActionCookbook = { Date in
            let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseMealTypeVC") as! ChooseMealTypeVC
            vc.SelDateArray = Date
            vc.uri = uri
            vc.type = "\(type)"
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            self.view.bringSubviewToFront(vc.view)
            vc.didMove(toParent: self)
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let padding: CGFloat = 10
                let itemsPerRow: CGFloat = 2
                let totalPadding = padding * (itemsPerRow + 1)
                let availableWidth = collectionView.frame.size.width - totalPadding
                let itemWidth = availableWidth / itemsPerRow
                
                return CGSize(width: itemWidth, height: 235)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 10
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

extension CookBooksTypeVc {
    
    func Api_To_GetCookBookType(){
        var params = [String: Any]()
        params["type"] = self.type
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.cook_book_type_list
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(CookBookTypeModel.self, from: data)
                if d.success == true {
                    self.hideIndicator()
                    self.cookBookDataArr.removeAll()
                    self.cookBookDataArr = d.data ?? []
                    self.CollV.reloadData()
                   
                        if self.cookBookDataArr.count == 0 {
                            self.CollV.setEmptyMessage("No recipe yet", UIImage())
                        }else{
                            self.CollV.setEmptyMessage("", UIImage())
                        }
                     
                }else{
                    self.hideIndicator()
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                self.hideIndicator()
                print(error)
            }
        })
    }
    
    func Api_To_RemoveFavMeal(){
        var params = [String: Any]()
 
        params["uri"] = self.uri
        params["type"] = 0
        params["cook_book"] = self.selID
     
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_favorite
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let MSG = dictData["message"] as? String ?? ""
                self.showToast(MSG)
                self.RemoveBgV.isHidden = true
              //  self.Api_To_GetCookBookType()
                self.cookBookDataArr.remove(at: self.SelIndx)
                
                if self.cookBookDataArr.count == 0 {
                    self.CollV.setEmptyMessage("No recipe yet", UIImage())
                }else{
                    self.CollV.setEmptyMessage("", UIImage())
                }
                
                self.CollV.reloadData()
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
 
    
    func Api_To_MoveMeal(){
        var params = [String: Any]()
        
        params["id"] = self.selID
        params["cook_book"] = self.cookbookID
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.move_recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                let MSG = dictData["message"] as? String ?? ""
                self.showToast(MSG)
                self.MoveBgV.isHidden = true
                self.Api_To_GetCookBookType()
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
  
    
    func Api_To_AddToBasket_Recipe(uri: String, type: String){
        var params = [String: Any]()
            params["uri"] = uri
            params["quantity"] = ""
            params["type"] = type
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_basket
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                self.showToast("Added to basket.")
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
    
    
  //  remove-cook-book
    func Api_To_Delete_CookBook(){
        var params = [String: Any]()
        params["id"] = self.type
     
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.remove_cook_book
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                self.navigationController?.showToast("Deleted successfully.")
                self.backAction()
                self.navigationController?.popViewController(animated: true)
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
    
//    func Api_To_Get_ProfileData(){
//        var params = [String: Any]()
//       
//       
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.getUserProfile
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            guard let dictData = json.dictionaryObject else{
//                return
//            }
//            
//            if dictData["success"] as? Bool == true{
//                let response = dictData["data"] as? NSDictionary ?? NSDictionary()
//                let Name = response["name"] as? String ?? String()
//                self.UserName = Name.capitalizedFirst
//                
//                let ProfImg = response["profile_img"] as? String ?? String()
//                let img = "\(baseURL.imageUrl)\(ProfImg)"
//                self.UserPickUrl = img
//                 
//            }else{
//                let responseMessage = dictData["message"] as? String ?? ""
//                self.showToast(responseMessage)
//            }
//        })
//    }
     
    
    func Api_To_AddCookBookFromInvite(){
        var params = [String: Any]()
 
        params["cook_book_id"] = self.type
         
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.update_user_prefrence
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
             
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let id = dictData["id"] as? Int ?? 0
                self.type = "\(id)"
//                "cook_book" : {
//                  "id" : 162,
//                  "user_id" : 359,
//                  "status" : 0,
//                  "shared" : 1,
                self.Api_To_GetCookBookType()
            }else{
                self.hideIndicator()
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}


 
// CustomActivityItemSource should implement the UIActivityItemSource protocol
class CustomActivityItemSource: NSObject, UIActivityItemSource {
    let metadata: LPLinkMetadata

    init(metadata: LPLinkMetadata) {
        self.metadata = metadata
    }

    // Provide the data for the activity item
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return metadata
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        // Ensure a non-optional return value by providing a default if title is nil
        return metadata.title ?? "Default Title"
    }
}
