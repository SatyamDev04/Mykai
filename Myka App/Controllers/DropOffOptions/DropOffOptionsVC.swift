//
//  DropOffOptionsVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 06/03/25.
//

import UIKit
import Alamofire

struct ImageModel {
    var image = UIImage()
    var imageData:Data?
}

class DropOffOptionsVC: UIViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var MeetAtMyDoorLbl: UILabel!
    @IBOutlet weak var MeetOutSideLbl: UILabel!
    @IBOutlet weak var MeetAtReceptionLbl: UILabel!
    @IBOutlet weak var LeaveAtMyDoorLbl: UILabel!
    @IBOutlet weak var LeaveAtReceptionLbl: UILabel!
    @IBOutlet weak var InstructionTxtV: UITextView!
    
    @IBOutlet weak var PhotoCollV: UICollectionView!
    
    
    @IBOutlet weak var MeetAtMyDoorBtnO: UIButton!
    @IBOutlet weak var MeetOutSideBtnO: UIButton!
    @IBOutlet weak var MeetAtReceptionBtnO: UIButton!
    @IBOutlet weak var LeaveAtMyDoorBtnO: UIButton!
    @IBOutlet weak var LeaveAtReceptionBtnO: UIButton!
    
    @IBOutlet weak var HandsToMeBgV: UIView!
    @IBOutlet weak var LeaveAtMyDoorBgV: UIView!
    
    var imageArr = [ImageModel]()
    
    var imagePicker1: ImagePicker1!
    
    var dropOffDataArr = [DropOffModelData]()
    
    var SelOptionID = ""
    
    var backAction:(String)->() = {str in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PhotoCollV.register(UINib(nibName: "PhotoCollVCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollVCell")
        self.PhotoCollV.delegate = self
        self.PhotoCollV.dataSource = self
        
        imagePicker1 = ImagePicker1(presentationController1: self, delegate1: self)
        
        self.getDropOffListData()
    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func MeetAtMyDoorBtn(_ sender: UIButton) {
        self.MeetAtMyDoorBtnO.isSelected = true
        self.MeetOutSideBtnO.isSelected = false
        self.MeetAtReceptionBtnO.isSelected = false
        self.LeaveAtMyDoorBtnO.isSelected = false
        self.LeaveAtReceptionBtnO.isSelected = false
     
        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        
        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        
        SelOptionID = "Meet at my door"
        
    }
 
    @IBAction func MeetOutSideBtn(_ sender: UIButton) {
        self.MeetAtMyDoorBtnO.isSelected = false
        self.MeetOutSideBtnO.isSelected = true
        self.MeetAtReceptionBtnO.isSelected = false
        self.LeaveAtMyDoorBtnO.isSelected = false
        self.LeaveAtReceptionBtnO.isSelected = false
        
        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        
        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        
        SelOptionID = "Meet outside"
    }
    
    @IBAction func MeetAtReceptionBtn(_ sender: UIButton) {
        self.MeetAtMyDoorBtnO.isSelected = false
        self.MeetOutSideBtnO.isSelected = false
        self.MeetAtReceptionBtnO.isSelected = true
        self.LeaveAtMyDoorBtnO.isSelected = false
        self.LeaveAtReceptionBtnO.isSelected = false
        
        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        
        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        
        SelOptionID = "Meet at reception"
    }
    
    @IBAction func LeaveAtMyDoorBtn(_ sender: UIButton) {
        self.MeetAtMyDoorBtnO.isSelected = false
        self.MeetOutSideBtnO.isSelected = false
        self.MeetAtReceptionBtnO.isSelected = false
        self.LeaveAtMyDoorBtnO.isSelected = true
        self.LeaveAtReceptionBtnO.isSelected = false
        
        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        
        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        SelOptionID = "Leave at my door"
    }
    
    @IBAction func LeaveAtReceptionBtn(_ sender: UIButton) {
        self.MeetAtMyDoorBtnO.isSelected = false
        self.MeetOutSideBtnO.isSelected = false
        self.MeetAtReceptionBtnO.isSelected = false
        self.LeaveAtMyDoorBtnO.isSelected = false
        self.LeaveAtReceptionBtnO.isSelected = true
        
        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        SelOptionID = "Leave at reception"
    }
 

    @IBAction func AddPhotoBtn(_ sender: UIButton) {
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
    
 
    @IBAction func UpdateBtn(_ sender: UIButton) {
        guard self.SelOptionID != "" else {
            AlertControllerOnr(title: "", message: "Please select atleast one option")
            return
        }
        
        self.API_TO_Update_DropOff()
    }
}

extension DropOffOptionsVC:ImagePickerDelegate1{
     
    func didSelect1(image: UIImage?, tag: Int, info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = image else {
            return
        }
         
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                //self.sendImage(data: data)
                self.imageArr.append(contentsOf: [ImageModel(image: image, imageData: data)])
                self.PhotoCollV.reloadData()
            }
        }
    }
}

extension DropOffOptionsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollVCell", for: indexPath) as! PhotoCollVCell
        
        cell.ImgV.image = self.imageArr[indexPath.row].image
        
        cell.RemoveBtn.tag = indexPath.row
        cell.RemoveBtn.addTarget(self, action: #selector(removeimage(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func removeimage(_ sender: UIButton) {
        self.imageArr.remove(at: sender.tag)
        self.PhotoCollV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 5
     }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
             return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
     }

 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 5
     }
}
 
//  self.dropOffDataArr
extension DropOffOptionsVC{
    
    func getDropOffListData() {
        var params:JSONDictionary = [:]
        
//        params["latitude"] = AppLocation.lat
//        params["longitude"] = AppLocation.long
        
        showIndicator(withTitle: "", and: "")
         
        let loginURL = baseURL.baseURL + appEndPoints.get_notes
        print(params,"Params")
        print(loginURL,"loginURL")
       
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(DropOffModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    self.InstructionTxtV.text = d.instruction ?? ""
                      
                    self.dropOffDataArr = allData ?? []
                    
                    self.MeetAtMyDoorLbl.text = self.dropOffDataArr[0].name ?? ""
                    self.MeetOutSideLbl.text = self.dropOffDataArr[1].name ?? ""
                    self.MeetAtReceptionLbl.text = self.dropOffDataArr[2].name ?? ""
                    self.LeaveAtMyDoorLbl.text = self.dropOffDataArr[3].name ?? ""
                    self.LeaveAtReceptionLbl.text = self.dropOffDataArr[4].name ?? ""
                    
                    if self.dropOffDataArr[0].status ?? 0 == 1{
                        self.SelOptionID = "\(self.dropOffDataArr[0].name ?? "")"
                        self.MeetAtMyDoorBtnO.isSelected = true
                        self.MeetOutSideBtnO.isSelected = false
                        self.MeetAtReceptionBtnO.isSelected = false
                        self.LeaveAtMyDoorBtnO.isSelected = false
                        self.LeaveAtReceptionBtnO.isSelected = false
                     
                        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        
                        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
                      
                    }else if self.dropOffDataArr[1].status ?? 0 == 1{
                        self.SelOptionID = "\(self.dropOffDataArr[1].name ?? "")"
                        self.MeetAtMyDoorBtnO.isSelected = false
                        self.MeetOutSideBtnO.isSelected = true
                        self.MeetAtReceptionBtnO.isSelected = false
                        self.LeaveAtMyDoorBtnO.isSelected = false
                        self.LeaveAtReceptionBtnO.isSelected = false
                        
                        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        
                        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
                        
                    }else if self.dropOffDataArr[2].status ?? 0 == 1{
                        self.SelOptionID = "\(self.dropOffDataArr[2].name ?? "")"
                        self.MeetAtMyDoorBtnO.isSelected = false
                        self.MeetOutSideBtnO.isSelected = false
                        self.MeetAtReceptionBtnO.isSelected = true
                        self.LeaveAtMyDoorBtnO.isSelected = false
                        self.LeaveAtReceptionBtnO.isSelected = false
                        
                        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        
                        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
                    }else if self.dropOffDataArr[3].status ?? 0 == 1{
                        self.SelOptionID = "\(self.dropOffDataArr[3].name ?? "")"
                        
                        self.MeetAtMyDoorBtnO.isSelected = false
                        self.MeetOutSideBtnO.isSelected = false
                        self.MeetAtReceptionBtnO.isSelected = false
                        self.LeaveAtMyDoorBtnO.isSelected = true
                        self.LeaveAtReceptionBtnO.isSelected = false
                        
                        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        
                        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
                        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    }else if self.dropOffDataArr[4].status ?? 0 == 1{
                        self.SelOptionID = "\(self.dropOffDataArr[4].name ?? "")"
                        
                        self.MeetAtMyDoorBtnO.isSelected = false
                        self.MeetOutSideBtnO.isSelected = false
                        self.MeetAtReceptionBtnO.isSelected = false
                        self.LeaveAtMyDoorBtnO.isSelected = false
                        self.LeaveAtReceptionBtnO.isSelected = true
                        
                        self.MeetAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetOutSideLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.MeetAtReceptionLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtMyDoorLbl.textColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
                        self.LeaveAtReceptionLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        
                        self.HandsToMeBgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
                        self.LeaveAtMyDoorBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    }
                                        
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    func API_TO_Update_DropOff(){
    var params = [String: Any]()
  
        params["pickup"] = self.SelOptionID
        params["description"] = self.InstructionTxtV.text ?? ""
   
 
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.add_notes

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         self.backAction(self.SelOptionID)
         self.navigationController?.popViewController(animated: true)
        }else{
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
 })

 }
}
