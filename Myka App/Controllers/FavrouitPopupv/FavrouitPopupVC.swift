//
//  FavrouitPopupVC.swift
//  Myka App
//
//  Created by YES IT Labs on 22/01/25.
//

import UIKit
import DropDown
import Alamofire

class FavrouitPopupVC: UIViewController {

    @IBOutlet weak var DropDownTxtLbl: UITextField!
    
    @IBOutlet weak var CreateNewCookBookBgV: UIView!
    
    @IBOutlet weak var DropDownBgV: UIView!
    
    var typeclicked = ""
    
    var comesFrom = ""
    
    let dropdown = DropDown()
    
    var FavDropDownArrList = [FavDropDownModel]()
    
    var selID = ""
    var uri = ""
    
    var backAction:()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Api_To_GetAllCookBooks()
    }
    
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func DropBtn(_ sender: UIButton) {
        CreateNewCookBookBgV.backgroundColor = UIColor.white
        DropDownBgV.backgroundColor = UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 0.04)
        
        self.dropdown.dataSource = self.FavDropDownArrList.map { String($0.name ?? "") }
        
        self.dropdown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 0// Adjust as needed
        self.dropdown.bottomOffset = CGPoint(x: -trailingSpace, y: self.DropDownBgV.bounds.height)
        self.dropdown.topOffset = CGPoint(x: -trailingSpace, y: -(self.dropdown.anchorView?.plainView.bounds.height ?? 0))
//        LevelDropDown.width = 80
        self.dropdown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
        self.dropdown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.dropdown.layer.shadowOpacity = 0
        self.dropdown.layer.shadowRadius = 4
        self.dropdown.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.dropdown.backgroundColor = .white
        self.dropdown.cellHeight = 40
        self.dropdown.textFont = UIFont.systemFont(ofSize: 18)

        self.dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
             
            self.DropDownTxtLbl.text = item
            
            selID = "\(self.FavDropDownArrList[index].id ?? 0)"
            
            typeclicked = "Favorites"
        }
         
        self.dropdown.show()
    
//            DropDownBgV.backgroundColor = UIColor.white
//            CreateNewCookBookBgV.backgroundColor = UIColor.white

      //  typeclicked = ""
  
    }
    
    @IBAction func CreateNewCookBookBtn(_ sender: UIButton) {
        CreateNewCookBookBgV.backgroundColor = UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 0.04)
        DropDownBgV.backgroundColor = UIColor.white
        typeclicked = "CookBook"
        self.DropDownTxtLbl.text = ""
        // navigate to cookBook Screen.
        let storyboard = UIStoryboard(name: "Fav", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateCookbookVC") as! CreateCookbookVC
        vc.comesfrom = self.comesFrom
        vc.uri = self.uri
        vc.backAction = { _ in
            self.backAction()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
  
    
    @IBAction func DoneBtn(_ sender: UIButton) {
        if typeclicked == "CookBook"{

        }else if typeclicked == "Favorites"{
            
            self.Api_To_AddFAv()
        }else{
            
        }
    }
    
}
//get-cook-book
extension FavrouitPopupVC {
    func Api_To_GetAllCookBooks(){
        var params = [String: Any]()
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_cook_book
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(FavDropDownModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data, list.count != 0 {
                        self.FavDropDownArrList = list
                    }
                    
                    self.FavDropDownArrList.insert(contentsOf: [FavDropDownModel(id: 0, userID: 0, name: "Favorites", image: "", status: 0, updatedAt: "", createdAt: "", deletedAt: "")], at: 0)
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    func Api_To_AddFAv(){
        var params = [String: Any]()
        
        params["uri"] = self.uri
        params["type"] = 1
        params["cook_book"] = self.selID
       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_favorite
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                let MSG = dictData["message"] as? String ?? ""
                self.navigationController?.showToast(MSG)
                self.backAction()
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
}
