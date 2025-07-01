//
//  CreateCookbookVC.swift
//  Myka App
//
//  Created by YES IT Labs on 06/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class CreateCookbookVC: UIViewController,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var AddImgCamImgO: UIImageView!
    
    
    @IBOutlet weak var CookBookTitleTxt: UITextField!
    @IBOutlet weak var PrivateBtnO: UIButton!
    @IBOutlet weak var PublicBtnO: UIButton!
    @IBOutlet weak var DoneBtnO: UIButton!
   
    var comesfrom = ""
    
    var imagePicker1: ImagePicker1!
    
    var titleStr: String = ""
   
    var uri = ""
    
    var selID = ""
    
    // for editcookbook
    var EditcookBooksData = FavDropDownModel()
    //
    
    var backAction:(_ data: FavDropDownModel)->() = {_ in}
    
    var ReloadBackAction:()->() = { }

    override func viewDidLoad() {
        super.viewDidLoad()
        if titleStr != "" {
            TitleLbl.text = "Edit \(self.titleStr)"
        }
        
        
        // to edit Cookbook
        if self.comesfrom == "EditcookBooks"{
            self.DoneBtnO.setTitle("Update", for: .normal)
            
            let img = EditcookBooksData.image ?? ""
            if img != ""{
                Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                Img.sd_setImage(with: URL(string: baseURL.imageUrl + img), placeholderImage: UIImage(named: "No_Image"))
                AddImgCamImgO.isHidden = true
                Img.contentMode = .scaleToFill
            }else{
                Img.image = UIImage(named: "AddImg")
                Img.contentMode = .scaleAspectFit
                AddImgCamImgO.isHidden = false
            }
            
            self.CookBookTitleTxt.text = titleStr
            
            let status = EditcookBooksData.status ?? 0
            
            if status == 1 {
                PublicBtnO.isSelected = true
                PrivateBtnO.isSelected = false
            }else{
                PublicBtnO.isSelected = false
                PrivateBtnO.isSelected = true
            }
            
            selID = "\(EditcookBooksData.id ?? 0)"
        }else{
            PrivateBtnO.isSelected = true
        }
        //
       
        
 
        imagePicker1 = ImagePicker1(presentationController1: self, delegate1: self)
    }
    
    @IBAction func InfoBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Fav", bundle: nil)
            let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
            popoverContent.MSg = "If your cookbook is public, the people you invite will have a snapshot of this cookbook."
            popoverContent.modalPresentationStyle = .popover

            if let popover = popoverContent.popoverPresentationController {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds // Attach to the button bounds
                popover.permittedArrowDirections = .up // Force the popover to show below the button
                popover.delegate = self
                popoverContent.preferredContentSize = CGSize(width: 250, height: 110)
            }

            self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
   
    
    @IBAction func PrivateBtn(_ sender: UIButton) {
        PrivateBtnO.isSelected = true
        PublicBtnO.isSelected = false
    }
    
    @IBAction func PublicBtn(_ sender: UIButton) {
        PrivateBtnO.isSelected = false
        PublicBtnO.isSelected = true
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UploadImage_Btn(_ sender:UIButton){
//        imagePicker1.present(from: sender)
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Choose from gallery ", style: .default, handler: { (s) in
            self.imagePicker1.presentGallery(from: sender)
        }))
        alertController.addAction(UIAlertAction(title: "Take a photo ", style: .default, handler: { (s) in
            self.imagePicker1.presentCamera(from: sender)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sender
            alertController.popoverPresentationController?.sourceRect = sender.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.present(alertController, animated: true)
    }
    
    @IBAction func DoneBtn(_ sender: UIButton) {
        let placeholderImage = UIImage(named: "AddImg")!
        let data1 = placeholderImage.pngData()
        let data2 = self.Img.image!.pngData()
        
        if data1 == data2 {
            AlertControllerOnr(title: "", message: "Please upload an image.")
        }else if self.CookBookTitleTxt.text ?? "" == ""{
            AlertControllerOnr(title: "", message: "Please enter cookbook name.")
        }else{
            self.Api_To_createCookBook()
        }
    }
}


extension CreateCookbookVC:ImagePickerDelegate1{
     
    func didSelect1(image: UIImage?, tag: Int, info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = image else {
            return
        }
        Img.image = image
        Img.contentMode = .scaleToFill
        AddImgCamImgO.isHidden = true
        
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                //self.sendImage(data: data)
            }
        }
    }
}

extension CreateCookbookVC{
    
func Api_To_createCookBook(){
    var params = [String: Any]()
    
    params["name"] = self.CookBookTitleTxt.text ?? ""
    
    if PrivateBtnO.isSelected{
        params["status"] = 0
    }else{
        params["status"] = 1
    }
       
    if self.comesfrom == "EditcookBooks"{
        params["id"] = self.selID
    }
    
    let temp = self.Img.image?.pngData() ?? Data()
    
  
    showIndicator(withTitle: "", and: "")
    
    let loginURL = baseURL.baseURL + appEndPoints.Add_Cook_Book
    print(params,"Params")
    print(loginURL,"loginURL")
    
    WebService.shared.uploadImageWithParameter(request: loginURL, image: temp, VC: self, parameters: params, imageName: "image", withCompletion: { (json, statusCode) in
    
        self.hideIndicator()
        
        guard let dictData = json.dictionaryObject else{
            return
        }
    
        if dictData["success"] as? Bool == true{
             
            if self.comesfrom == "EditcookBooks"{
                
                self.navigationController?.showToast("Updated Successfully.")
            }else{
              //  self.navigationController?.showToast("Added Successfully.")
            }
                
            
            if self.comesfrom == "FullCookingScheduleVC"{
                let val = dictData["data"] as? NSDictionary ?? NSDictionary()
                let id = val["id"] as? Int ?? 0
                self.selID = "\(id)"
                
                self.Api_To_AddFAv()
                
            }else if self.comesfrom == "EditcookBooks"{
                let val = dictData["data"] as? NSDictionary ?? NSDictionary()
                let status = val["status"] as? String ?? "0"
                
                let image = val["image"] as? String ?? ""
                
                let name = val["name"] as? String ?? ""
                
               
                 
                self.EditcookBooksData.name = name
                
                self.EditcookBooksData.image = image
             
                self.EditcookBooksData.status = Int(status)
                
                
                self.backAction(self.EditcookBooksData)
                self.navigationController?.popViewController(animated: true)
            }else if self.comesfrom == "Cookbooks"{
                let val = dictData["data"] as? NSDictionary ?? NSDictionary()
                let id = val["id"] as? Int ?? 0
                self.selID = "\(id)"
                if self.uri != ""{
                    self.Api_To_AddFAv()
                }else{
                    self.ReloadBackAction()
                    self.navigationController?.popViewController(animated: true)
                }
               // self.navigationController?.popViewController(animated: true)
            }
           }else{
               let responseMessage = dictData["message"] as? String ?? ""
               self.showToast(responseMessage)
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
                
                if self.comesfrom == "Cookbooks"{
                    
                }else{
                    self.backAction(self.EditcookBooksData)
                    self.navigationController?.showToast(MSG)
                }
                
                
                self.ReloadBackAction()
                self.navigationController?.popViewController(animated: true)
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
}


