//
//  AddBankVC.swift
//  Myka App
//
//  Created by YES IT Labs on 19/12/24.
//

import UIKit
import Stripe
import Alamofire
import DropDown
import AVFoundation
import ProgressHUD

class AddBankVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, DocumentDelegate {
 
    
    @IBOutlet weak var BgV: UIView!
    
    @IBOutlet weak var BtnSubmit: UIButton!
    @IBOutlet weak var txt_accountHoldName: UITextField!
    
    @IBOutlet weak var txt_routingNumber: UITextField!
    @IBOutlet weak var txt_accountNumber: UITextField!
    @IBOutlet weak var txt_confirm_accountNumber: UITextField!
 
    @IBOutlet weak var Btn_FrontImg: UIButton!
    @IBOutlet weak var Btn_BackImg: UIButton!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_phoneNumber: UITextField!
    @IBOutlet weak var txt_dob: UITextField!
    
    @IBOutlet weak var txt_idType: UITextField!
    @IBOutlet weak var PersonalIdentificationNumTxtF: UITextField!
    @IBOutlet weak var txt_address: UITextField!
    @IBOutlet weak var txt_country: UITextField!
    @IBOutlet weak var txt_state: UITextField!
    
    @IBOutlet weak var txt_SSN: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_postalCode: UITextField!
    @IBOutlet weak var FrontFilelbl:UITextField!
    @IBOutlet weak var BackFilelbl:UITextField!
    
    
    @IBOutlet weak var ProofOfBankLbl: UITextField!
    @IBOutlet weak var ProofOfBankFileLbl: UITextField!
    
    @IBOutlet weak var BankProofDocBtn: UIButton!
        
        var BankProofArr = ["Bank account statement","Voided cheque","Bank letterhead"]
        var selectedBankProof = ""
        
        var arr_Country_Details = [ModelClass]()
        var arr_State_Details = [ModelClass]()
        var arr_City_Details = [ModelClass]()
        
        var countryCode = ""
        var stateCode = ""
         
        let countryDrop = DropDown()
        let stateDrop = DropDown()
        let cityDrop = DropDown()
        let BankProofDrop = DropDown()
        
        lazy var dropDowns: [DropDown] = {
            return [
                self.countryDrop,
                self.stateDrop,
                self.cityDrop,
                self.BankProofDrop
            ]
        }()
        
        
        var imagePicker1: ImagePicker!
        var imgStatus = 0
        var datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        var toolBar = UIToolbar()
        let screenWidth = UIScreen.main.bounds.width

        
        var imagePickerController = UIImagePickerController()
        var documentPicker: DocumentPicker!
        private let textShort    = "Please wait..."
        private var timer: Timer?
        var BankProofDOCName = ""
        var BankProofDOC = Data()
        var fileTypeName = ""
    
    private var frontImg: UIImage?
    private var BackImg: UIImage?
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            BgV.layer.cornerRadius = 15
            // Round top-left and top-right corners only
            BgV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

            self.txt_phoneNumber.delegate = self
            imagePicker1 = ImagePicker(presentationController: self, delegate: self)
            txt_routingNumber.delegate = self
            txt_routingNumber.delegate = self
            
            toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
            toolBar.sizeToFit()
            toolBar.tintColor = .systemBlue
            toolBar.isUserInteractionEnabled = true
     
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
            doneButton.tintColor = .black
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([flexibleSpace, doneButton], animated: false)
            //
            
            txt_dob.inputView = datePicker
            txt_dob.inputAccessoryView = toolBar
            txt_dob.delegate = self
            datePicker.minimumDate = .none
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            
            documentPicker = DocumentPicker(presentationController:
                                                self, delegate: self)
            
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == txt_dob {
                datePicker.datePickerMode = .date
                datePicker.maximumDate = Date()
            }
        }
        
        @objc func doneButtonTapped() {
            if txt_dob.isFirstResponder {
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "MM/dd/yyyy"
                txt_dob.text = dateFormatter.string(from: datePicker.date)
            }
            self.view.endEditing(true)
        }
        
        

        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.API_TO_Get_Country()
        }
    
        @IBAction func btn_idType(_ sender: UIButton) {
//                    guard txt_city.text != "" || txt_country.text != "" else {
//                        self.AlertControllerOnr(title: alertTitle.alert_alert, message: "Please select country first")
//                        return
//                    }
    
            let arr : [String] = ["Passport","Drivers license"]
            self.stateDrop.anchorView = sender
            self.stateDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
            self.stateDrop.textColor = .black
            self.stateDrop.separatorColor = .clear
            self.stateDrop.selectionBackgroundColor = .clear
            self.stateDrop.backgroundColor = #colorLiteral(red: 0.8541120291, green: 0.9235828519, blue: 0.9914466739, alpha: 1)
            self.stateDrop.dataSource.removeAll()
            self.stateDrop.cellHeight = 35
            self.stateDrop.dataSource.append(contentsOf: arr)
    
            self.stateDrop.selectionAction = { [unowned self] (index, item) in
    
                self.txt_idType.text = item
            }
            self.stateDrop.show()
        }
    

    @IBAction func btn_Country(_ sender: UIButton) {
        
        self.countryDrop.anchorView = sender
        self.countryDrop.direction = .bottom
        self.countryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.countryDrop.textColor = .black
        self.countryDrop.separatorColor = .clear
        self.countryDrop.selectionBackgroundColor = .clear
        self.countryDrop.backgroundColor = #colorLiteral(red: 0.8541120291, green: 0.9235828519, blue: 0.9914466739, alpha: 1)
        self.countryDrop.dataSource.removeAll()
        self.countryDrop.cellHeight = 35
        self.countryDrop.dataSource = arr_Country_Details.map {$0.name}
        
        self.countryDrop.selectionAction = { [unowned self] (index, item) in
            
            self.txt_country.text = item
            self.txt_state.text = ""
            self.txt_city.text = ""
            self.txt_postalCode.text = ""
            self.countryCode = self.arr_Country_Details[index].iso2
            let StateCode = self.arr_Country_Details[index].iso2
            self.API_TO_Get_States(States: StateCode)
        }
        self.countryDrop.show()
    }
    
    @IBAction func btn_State(_ sender: UIButton) {
        guard txt_country.text != "" else {
            self.AlertControllerOnr(title: alertTitle.alert_alert, message: "Please select country first")
            return
        }

     
        self.stateDrop.anchorView = sender
        self.stateDrop.direction = .bottom
        self.stateDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.stateDrop.textColor = .black
        self.stateDrop.separatorColor = .clear
        self.stateDrop.selectionBackgroundColor = .clear
        self.stateDrop.backgroundColor = #colorLiteral(red: 0.8541120291, green: 0.9235828519, blue: 0.9914466739, alpha: 1)
        self.stateDrop.dataSource.removeAll()
        self.stateDrop.cellHeight = 35
        self.stateDrop.dataSource = arr_State_Details.map {$0.name}
        
        self.stateDrop.selectionAction = { [unowned self] (index, item) in
            
            self.txt_state.text = item
            self.txt_city.text = ""
            self.txt_postalCode.text = ""
            self.stateCode = self.arr_State_Details[index].iso2
            let cityCode = self.arr_State_Details[index].iso2
            self.API_TO_Get_Cities(Cities: cityCode)
        }
        self.stateDrop.show()
    }
    
    
    @IBAction func btn_city(_ sender: UIButton) {
        
        guard txt_country.text != "" || txt_state.text != "" else {
            self.AlertControllerOnr(title: alertTitle.alert_alert, message: "Please select country first")
            return
        }
        guard txt_state.text != "" else {
            self.AlertControllerOnr(title: alertTitle.alert_alert, message: "Please select state first")
            return
        }

        self.cityDrop.anchorView = sender
        self.cityDrop.direction = .bottom
        self.cityDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.cityDrop.textColor = .black
        self.cityDrop.separatorColor = .clear
        self.cityDrop.selectionBackgroundColor = .clear
        self.cityDrop.backgroundColor = #colorLiteral(red: 0.8541120291, green: 0.9235828519, blue: 0.9914466739, alpha: 1)
        self.cityDrop.dataSource.removeAll()
        self.cityDrop.cellHeight = 35
        self.cityDrop.dataSource = arr_City_Details.map {$0.name}
        self.cityDrop.selectionAction = { [unowned self] (index, item) in
            self.txt_city.text = item
        }
        self.cityDrop.show()
    }
    
    
    @IBAction func btn_frontImg(_ sender:UIButton) {
        imgStatus = 1
        imagePicker1.present(from: sender)
        
    }
    
    @IBAction func btn_backImg(_ sender:UIButton) {
        imgStatus = 2
        imagePicker1.present(from: sender)
    }
    
    @IBAction func Bank_Proof_Dropdown_Btn(_ sender: UIButton) {
        self.BankProofDrop.anchorView = sender
        self.BankProofDrop.direction = .bottom
        self.BankProofDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.BankProofDrop.textColor = .black
        self.BankProofDrop.separatorColor = .clear
        self.BankProofDrop.selectionBackgroundColor = .clear
        self.BankProofDrop.backgroundColor = #colorLiteral(red: 0.8541120291, green: 0.9235828519, blue: 0.9914466739, alpha: 1)
        self.BankProofDrop.dataSource.removeAll()
        self.BankProofDrop.cellHeight = 35
        self.BankProofDrop.dataSource.append(contentsOf: self.BankProofArr)
        self.BankProofDrop.selectionAction = { [unowned self] (index, item) in
            self.ProofOfBankLbl.text = item
            if item == "Bank account statement"{
                self.selectedBankProof = "statement"
            }else if item == "Voided cheque"{
                self.selectedBankProof = "cheque"
            }else{
                self.selectedBankProof = "letterhead"
            }
        }
        self.BankProofDrop.show()
    }
    
    @IBAction func Bank_Proof_Doc_Btn(_ sender: UIButton) {
        guard ProofOfBankLbl.text != "" else {
            self.AlertControllerOnr(title: alertTitle.alert_alert, message: "Please select proof of bank account first")
            return
        }
        
        let ac = UIAlertController(title: "Photo Source", message: "Choose A Source", preferredStyle: .actionSheet )
        let cameraBtn = UIAlertAction(title: "Open Camera", style: .default) {[weak self] (_) in
            
            // Check if the camera is available on the device as a source type
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined: self?.requestCameraPermission()
                    
                case .authorized: self?.presentCamera()
                    
                case .restricted, .denied: self?.alertCameraAccessNeeded()
                    
                @unknown default:
                    self?.alertCameraAccessNeeded()
                    break
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: ("You don't have camera."), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ("OK"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Open Gallery", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let DocBtn = UIAlertAction(title: "Open Document", style: .default) {[weak self] (_) in
            self?.openDocPicker()
        }
        
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(DocBtn)
        ac.addAction(cancelBtn)
        self.present(ac, animated: true, completion: nil)
    }
    
    
    func presentCamera() {
        self.showImagePicker(selectedSource: .camera)
        let imagePicker = UIImagePickerController()
        
        // set its delegate, set its source type
        imagePicker.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
     
            imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.presentCamera()
        })
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to capture photo in this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func NextBtn(_ sender: UIButton) {
        //if View_Content.isUserInteractionEnabled == true {
            guard validation1() else {
                return
            }
            guard validation() else {
                return
            }
            
            self.callFunc()
//        }else{
//            self.AlertControllerOnr(title: alertTitle.alert_error, message: "You can't change the account information once you verified.")
//        }
    }
}

extension AddBankVC : UITextFieldDelegate{
    
    func validation() -> Bool {
        
        if txt_accountHoldName.text?.count == 0 && txt_routingNumber.text?.count == 0 && txt_accountNumber.text?.count == 0 && txt_confirm_accountNumber.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmptyField)
            return false
        }
        
        
        if self.txt_accountHoldName.text == "" || txt_accountHoldName.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAccountName)
            return false
        }
        
        if self.txt_routingNumber.text == " " || txt_routingNumber.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mRoutingNumber)
            return false
        }
        
        if txt_routingNumber.text!.count < 9  {
            self.AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mValidRoutingNumber)
            return false
        }
        
        if self.txt_accountNumber.text == " " || txt_accountNumber.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBankAccount)
            return false
        }
        
        if self.txt_confirm_accountNumber.text == " " || txt_confirm_accountNumber.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mConfirmBankAccount)
            return false
        }
        if txt_accountNumber.text != txt_confirm_accountNumber.text {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAccountmatch)
            return false
        }
        
        if self.ProofOfBankLbl.text == " "{
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mProofofbank)
            return false
        }
        
        if self.ProofOfBankFileLbl?.text == " " || self.ProofOfBankFileLbl?.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBankProofDoc)
            return false
        }
        
        if self.FrontFilelbl?.text == "" || self.FrontFilelbl?.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mFrontID)
            return false
        }
        
        if self.BackFilelbl?.text == "" || self.BackFilelbl?.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBackID)
            return false
        }
        return true
    }
    
    
    func validation1() -> Bool {
        
        if txt_firstName.text?.count == 0 && txt_lastName.text?.count == 0 && txt_email.text?.count == 0 && txt_phoneNumber.text?.count == 0 && txt_dob.text?.count == 0 && txt_idType.text?.count == 0 && PersonalIdentificationNumTxtF.text?.count == 0 && txt_address.text?.count == 0 && txt_country.text?.count == 0 && txt_state.text?.count == 0 && txt_city.text?.count == 0 && txt_postalCode.text?.count == 0{
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmptyField)
            return false
        }
        
        
        if self.txt_firstName.text == " " || txt_firstName.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mFirstName)
            return false
        }
        
        if self.txt_lastName.text == " " || txt_lastName.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mLastName)
            return false
        }
        
        if self.txt_email.text == " " || txt_email.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmail)
            return false
        }
        
        if self.txt_email.text!.contains("@")  {
            if !self.isValidEmail(testStr: self.txt_email.text!) {
                AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mValidEmail)
                return false
            }
        }
        
        if self.txt_phoneNumber.text == " " || txt_phoneNumber.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPhoneNumber)
            return false
        }
        
        if self.txt_dob.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mDob)
            return false
        }
        
        
        if self.txt_idType.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mIdType)
            return false
        }
        
         
        if self.PersonalIdentificationNumTxtF.text == " " || PersonalIdentificationNumTxtF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.DlNum)
            return false
        }
//        if self.txt_SSN.text == " " || txt_SSN.text?.count == 0  {
//
//            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPIN)
//            return false
//        }
        
        
        if self.txt_address.text == " " || txt_address.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAddress)
            return false
        }
        
 
        
        if self.txt_state.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mState)
            return false
        }
        
        if self.txt_city.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mCity)
            return false
        }
        
        if self.txt_postalCode.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPostalCode)
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  txt_accountHoldName {
            
            if string.count == 0 {
                return true
            }
            if string == " " {
                return true
            }
            if !self.pavan_checkAlphabet(Str: string) {
                return false
            }
            return true
        } else if textField ==  txt_firstName && textField ==  txt_lastName{
            
            if string.count == 0 {
                return true
            }
            if string == " " {
                return true
            }
            if !self.pavan_checkAlphabet(Str: string) {
                return false
            }
            return true
        }else if textField == txt_phoneNumber{
            guard let text = self.txt_phoneNumber.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            
            self.txt_phoneNumber.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
            return false
        }
        
        return true
    }
}


extension AddBankVC : ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let img = image else {
            return
        }
         
        let name = Date.getCurrentDateForName()
        
        if imgStatus == 1 {
            self.frontImg = image
            self.FrontFilelbl.text = "\(name)\(3).jpeg"
        }
        
        if imgStatus == 2{
            self.BackImg = image
            self.BackFilelbl.text = "\(name)\(3).jpeg"
        }
    }
}

// for stripe BankAcc.
extension AddBankVC {
    func callFunc() {
        showIndicator(withTitle: "", and: "")
        let BankParams = STPBankAccountParams()
         let accNo = self.txt_confirm_accountNumber.text!
        let final_account_num =  accNo.removeSpaces
        BankParams.accountNumber = final_account_num
        BankParams.routingNumber = self.txt_routingNumber.text!
        BankParams.currency = "USD"
        BankParams.country = "US"
        BankParams.accountHolderType = .individual
        BankParams.accountHolderName = self.txt_accountHoldName.text!
  
        print("CardDetail====",BankParams)
        
        STPAPIClient.shared.createToken(withBankAccount: BankParams, completion: { (token: STPToken?, error: Error?) in
        
            print(error)
            self.hideIndicator()
            
            guard let token111 = token, error == nil else {
                // Present error to user...
                self.hideIndicator()
                let UserInfo = error.unsafelyUnwrapped.localizedDescription
                self.AlertControllerOnr(title: "Alert", message: UserInfo, BtnTitle: "OK")
                
                return
            }
            self.hideIndicator()
            
            print(token111.tokenId)
            print(token111.bankAccount?.bankName ?? "", "Bank name")
            print(token111.bankAccount?.accountHolderName ?? "", "name")
            print(token111.bankAccount?.routingNumber ?? "", "RoutingNo")
            print(token111.bankAccount?.accountHolderType ?? "", "AccHolderType")
            print(token111.bankAccount?.stripeID ?? "", "Stripe ID")
     
            
            let tokenNum = token111.tokenId
            let Routingnum = token111.bankAccount?.routingNumber ?? ""
            let AccHName = token111.bankAccount?.accountHolderName ?? ""
            let BnkName = token111.bankAccount?.bankName ?? ""
            let StripeID = token111.bankAccount?.stripeID ?? ""
            let accType = token111.bankAccount?.accountHolderType ?? STPBankAccountHolderType.individual
                       
            self.API_TO_Add_bank(Token: tokenNum, bank_id: StripeID)
        })
    }
}
 
//save_card
extension AddBankVC{
    
    func API_TO_Add_bank(Token: String, bank_id: String){
            var params = [String: Any]()
            
            let p = self.txt_phoneNumber.text ?? ""
            let k = p.removeSpaces
            let o = k.replace(string: "(", withString: "")
            let t = o.replace(string: ")", withString: "")
            let I = t.replace(string: "-", withString: "")
            let c = I.replace(string: "+", withString: "")
            let numb = c.dropFirst()
            
            
            params["token_type"] = "bank_account"
            params["stripe_token"] = Token
            params["save_card"] = ""
            params["amount"] =  ""
            params["payment_type"] = ""
            params["firstname"] = self.txt_firstName.text!
            params["lastname"] = self.txt_lastName.text!
            params["email"] = self.txt_email.text!
            params["phone"] = "\(numb)"
            params["dob"] = self.txt_dob.text!
            params["id_number"] = self.PersonalIdentificationNumTxtF.text!
            params["id_type"] = self.txt_idType.text!
        //  params["pin_number"] = self.txt_PIN.text!
            params["ssn"] = self.txt_SSN.text!
            params["address"] = self.txt_address.text!
            params["country"] = self.countryCode
            params["state_code"] = self.stateCode
            params["city"] = self.txt_city.text!
            params["postal_code"] = self.txt_postalCode.text!
            params["bank_id"] = bank_id
            params["bank_proof_type"] = self.selectedBankProof
            params["device_type"] = "ios"
        
        let temp = self.frontImg?.jpegData(compressionQuality: 0.5) ?? Data()
        let temp1 = self.BackImg?.jpegData(compressionQuality: 0.5) ?? Data()
         
          
            showIndicator(withTitle: "", and: "")
            let loginURL = baseURL.baseURL + appEndPoints.Add_Bank
            
        WebService.shared.uploadLicenseImageWithParameter(loginURL, temp, temp1, self.BankProofDOC, VC: self, params, imageFrontName: "document_front", imageBackName: "document_back", BanKProofDoc: "bank_proof", FileType: self.fileTypeName, withCompletion: { (json, statusCode) in
 
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
                
                if dictData["success"] as? Bool == true{
                    let responseMessage = dictData["message"] as! String
                    self.showToast(responseMessage)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let responseMessage = dictData["message"] as! String
                    self.showToast(responseMessage)
                }
            })
            
        }
        
    }

// Country
extension AddBankVC{
    func API_TO_Get_Country(){
        var params = [String: Any]()
      
        params["url"] = "https://api.countrystatecity.in/v1/countries/"
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_countries
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in

            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let Result = dictData["data"] as? [[String:Any]] ?? [[String:Any]]()
                self.arr_Country_Details.removeAll()
                self.arr_Country_Details = ModelClass.Get_arr_State_Details(responseArray: Result)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}


// States
extension AddBankVC{
    func API_TO_Get_States(States: String){
        var params = [String: Any]()
      
        params["url"] = "https://api.countrystatecity.in/v1/countries/\(States)/states"
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_countries
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in

            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let Result = dictData["data"] as? [[String:Any]] ?? [[String:Any]]()
                self.arr_State_Details.removeAll()
                self.arr_State_Details = ModelClass.Get_arr_State_Details(responseArray: Result)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}

// Cities
extension AddBankVC{
    func API_TO_Get_Cities(Cities: String){
        var params = [String: Any]()
      
        params["url"] = "https://api.countrystatecity.in/v1/countries/US/states/\(Cities)/cities"

        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_countries
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let Result = dictData["data"] as? [[String:Any]] ?? [[String:Any]]()
                self.arr_City_Details.removeAll()
                self.arr_City_Details = ModelClass.Get_arr_City_Details(responseArray: Result)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}

@available(iOS 13.0, *)
extension AddBankVC{
    
    func showImagePicker(selectedSource : UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource)
        else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK:-imagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage ?? UIImage()
        
        let imageUrl = info[.imageURL] as? URL
        /// do what you want with the file URL
        //   print(FileURL)
        
        let name = imageUrl?.lastPathComponent
        var fileName = name
        if name == nil{
            let Newname = Date.getCurrentDateForName()
            fileName = "\(Newname)\(3).jpeg"
        }
//        let fileArray = fileName?.components(separatedBy: ".")
//        let firstName = fileArray?.first
//        let finalFileName = fileArray?.last
//        self.fileTypeName = finalFileName ?? ""
        
        let DataFile = selectedImage.jpegData(compressionQuality: 0.5) ?? Data()
        
       // self.BankImg_CoverDotted.isHidden = true
        self.BankProofDOC = DataFile
        self.ProofOfBankFileLbl.text = "\(fileName ?? "")"
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //
    
    func openDocPicker(){
        documentPicker.displayPicker()
        documentPicker.pickerController?.allowsMultipleSelection = false
    }
    
    func didPickDocument(document: Document?) {
        if let pickedDoc = document {
            let FileURL = pickedDoc.fileURL
            /// do what you want with the file URL
            //   print(FileURL)
            
            let name = FileURL.lastPathComponent
            let fileName = name
            let fileArray = fileName.components(separatedBy: ".")
            let firstName = fileArray.first
            let finalFileName = fileArray.last
            self.fileTypeName = finalFileName ?? ""
            
            do {
                let DataFile = try Data(contentsOf: FileURL as URL)
      
                actionProgressStart(textShort)
                ProgressHUD.colorAnimation = .systemBlue
                ProgressHUD.colorProgress = .systemBlue
     
               // self.BankImg_CoverDotted.isHidden = true
                self.BankProofDOC = DataFile
                self.ProofOfBankFileLbl.text = "\(fileName)"
              //  self.BankIMG.image = UIImage(named: "pdfpng") // docs
                
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    // progress bar.
    func actionProgressStart(_ status: String? = nil) {
        
        timer?.invalidate()
        timer = nil
        
        var intervalCount: CGFloat = 0.0

        ProgressHUD.progress(status, intervalCount/100)
        timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
            intervalCount += 1
            ProgressHUD.progress(status, intervalCount/100)
            if (intervalCount >= 100) {
                self.actionProgressStop()
            }
        }
    }
    
    func actionProgressStop() {
        
        timer?.invalidate()
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            ProgressHUD.succeed(interaction: false)
        }
    }
  }

