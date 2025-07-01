//
//  EditProfioeVC.swift
//  Myka App
//
//  Created by YES IT Labs on 18/12/24.
//

import UIKit
import Alamofire

class EditProfioeVC: UIViewController,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var NAmeLbl: UITextField!
    
     var name = ""
     var image: UIImage?
    
    
    var imagePicker1: ImagePicker1!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NAmeLbl.text = name
        self.ImgV.image = image
        
        imagePicker1 = ImagePicker1(presentationController1: self, delegate1: self)
    }
    
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UploadImgBtn(_ sender: UIButton) {
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
 
    @IBAction func SaveBtn(_ sender: UIButton) {
        self.Api_To_Upload_ProfileData()
    }
}


extension EditProfioeVC:ImagePickerDelegate1{
     
    func didSelect1(image: UIImage?, tag: Int, info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = image else {
            return
        }
        ImgV.image = image
        ImgV.contentMode = .scaleToFill
        
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                //self.sendImage(data: data)
            }
        }
    }
}


extension EditProfioeVC{
    func Api_To_Upload_ProfileData(){
        var params = [String: Any]()
        
        params["name"] = self.NAmeLbl.text!
         
        
        let imgData = self.ImgV.image?.jpegData(compressionQuality: 0.5)
     
        
        showIndicator(withTitle: "", and: "")
         
        let loginURL = baseURL.baseURL + appEndPoints.profileImgUpdate
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.uploadImageWithParameter(request: loginURL, image: imgData, VC: self, parameters: params, imageName: "profile_img", withCompletion: { (json, statusCode) in
          
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
               // self.DoneBtnO.isHidden = true
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
                self.navigationController?.popViewController(animated: true)
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}
