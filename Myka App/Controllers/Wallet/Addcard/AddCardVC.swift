//
//  AddCardVC.swift
//  Myka App
//
//  Created by YES IT Labs on 19/12/24.
//

import UIKit
import Alamofire
import Stripe

class AddCardVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var NameTxtF: UITextField!
    @IBOutlet weak var CardNumTxtF: UITextField!
    @IBOutlet weak var CvvTxtF: UITextField!
    
    @IBOutlet weak var MonthBtnO: UIButton!
    @IBOutlet weak var MonthTxt: UITextField!
    @IBOutlet weak var YearTxt: UITextField!
    @IBOutlet weak var YearBtnO: UIButton!
    
    @IBOutlet weak var BgV: UIView!
    
    
    var months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var years = [""]
    
    private var pickerView: UIPickerView!
    private var pickerContainer: UIView!
    private var isMonthPicker = true // To track whether it's a month or year picker
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        years = Array(currentYear...(currentYear + 30)).map { String($0) }
        
        BgV.layer.cornerRadius = 15
        // Round top-left and top-right corners only
        BgV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        CardNumTxtF.delegate = self
        CvvTxtF.delegate = self
        MonthTxt.delegate = self
        YearTxt.delegate = self
    }

    
    private func setupPickerView(SelDateBtn: UIButton) {
        // Get the button's frame relative to the view
        let buttonFrame = SelDateBtn.convert(SelDateBtn.bounds, to: self.view)
        
        // Create the container view for the picker and its controls
        pickerContainer = UIView(frame: CGRect(x: buttonFrame.origin.x,
                                                y: buttonFrame.maxY,
                                                width: SelDateBtn.frame.width + 30,
                                                height: 250))
        
        pickerContainer.backgroundColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        
        // Create the UIPickerView
        pickerView = UIPickerView(frame: CGRect(x: 0,
                                                y: 50,
                                                width: SelDateBtn.frame.width + 30,
                                                height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Add a toolbar with a "Done" button
        let toolbar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: SelDateBtn.frame.width + 30,
                                              height: 40))
        toolbar.sizeToFit()
        
        // Set the color of the "Done" button to black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1) // Set the button color to green
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // Add the toolbar and picker to the container
        pickerContainer.addSubview(toolbar)
        pickerContainer.addSubview(pickerView)
        
        // Add the picker container to the view
        self.view.addSubview(pickerContainer)
        
        // Animate the picker container to appear smoothly
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = buttonFrame.maxY
        }
    }

    private func resetPickerView() {
        // Remove the picker and its container from the view hierarchy
        pickerContainer.removeFromSuperview()
        
        // Reset the picker to the first row or any default state if needed
        pickerView.selectRow(0, inComponent: 0, animated: false) // Reset to the first row
        
        // Optionally, reset the text fields or any other related state
//        MonthTxt.text = ""
//        YearTxt.text = ""
    }
     
   

    
    @IBAction func MonthDropBtn(_ sender: UIButton) {
        for subView in view.subviews {
            if subView == pickerContainer {
                resetPickerView()
            }
        }
        
        setupPickerView(SelDateBtn: MonthBtnO)
        isMonthPicker = true // Set the picker to month mode
          pickerView.reloadAllComponents()
          showPicker()
    }
    
    @IBAction func YearDropBtn(_ sender: UIButton) {
        for subView in view.subviews {
            if subView == pickerContainer {
                resetPickerView()
            }
        }
        
        setupPickerView(SelDateBtn: YearBtnO)
        isMonthPicker = false // Set the picker to year mode
           pickerView.reloadAllComponents()
           showPicker()
    }
    
    
    @IBAction func AddCardBtn(_ sender: UIButton) {
//        isCardAdded = true
        guard Validation() else {
            return
        }
        self.callFunc()
       
    }
     
    
    private func showPicker() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = self.MonthBtnO.frame.width
        }
    }
    
    @objc func doneTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        if isMonthPicker {
            // Convert the index to a numeric string with leading zero
            let selectedMonthNumber = String(format: "%02d", selectedRow + 1)
            MonthTxt.text = selectedMonthNumber
        } else {
            // Get the selected year
            YearTxt.text = years[selectedRow]
        }
        
        // Animate the picker container out of view
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = self.view.frame.height
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isMonthPicker ? months.count : years.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isMonthPicker ? months[row] : years[row]
    }
 

func Validation() -> Bool {

    if NameTxtF.text == "" {
        self.AlertControllerOnr(title: "Alert", message: "Please enter name on card.", BtnTitle: "OK")
        return false
    }
    
    if CardNumTxtF.text == "" {
        self.AlertControllerOnr(title: "Alert", message: "Please enter card number.", BtnTitle: "OK")
        return false
    }
    if CardNumTxtF.text!.count < 16  {
        self.AlertControllerOnr(title: "Alert", message: "Please enter a valid card number.", BtnTitle: "OK")
        return false
    }
    if MonthTxt.text == "" {
        self.AlertControllerOnr(title: "Alert", message: "Please enter Expiry Month and Year.", BtnTitle: "OK")
        return false
    }
    if MonthTxt.text!.count < 2 {
        self.AlertControllerOnr(title: "Alert", message: "Please enter a valid Month .", BtnTitle: "OK")
        return false
    }
    
    if YearTxt.text == "" {
        self.AlertControllerOnr(title: "Alert", message: "Please enter Expiry Year.", BtnTitle: "OK")
        return false
    }
    
    if YearTxt.text!.count < 4 {
        self.AlertControllerOnr(title: "Alert", message: "Please enter a valid Year.", BtnTitle: "OK")
        return false
    }
    
    if CvvTxtF.text == "" {
        self.AlertControllerOnr(title: "Alert", message: "Please enter CVV.", BtnTitle: "OK")
        return false
    }
    if CvvTxtF.text!.count < 3 {
        self.AlertControllerOnr(title: "Alert", message: "Please enter a valid CVV.", BtnTitle: "OK")
        return false
    }
    return true
}

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField == CardNumTxtF {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format2(with: "XXXX XXXX XXXX XXXX", phone: newString)
        return false
    } else if textField == MonthTxt {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format2(with: "XX", phone: newString)
        return false
    } else if textField == YearTxt {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format2(with: "XXXX", phone: newString)
        return false
    } else if textField == CvvTxtF {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format2(with: "XXX", phone: newString)
        return false
    }
    return true
}

func format2(with mask: String, phone: String) -> String {
       let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
       var result = ""
       var index = numbers.startIndex
       for ch in mask where index < numbers.endIndex {
           if ch == "X" {
               result.append(numbers[index])
               index = numbers.index(after: index)

           } else {
               result.append(ch)
           }
       }
       return result
   }
}


//add_Card
extension AddCardVC {
    func callFunc() {
        showIndicator(withTitle: "", and: "")

        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = CardNumTxtF.text!
        cardParams.expMonth = NSNumber(value: Int(MonthTxt.text!)!)
        cardParams.expYear = NSNumber(value: Int(YearTxt.text!)!)
        cardParams.cvc = CvvTxtF.text!

        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.name = NameTxtF.text!

        let paymentMethodParams = STPPaymentMethodParams(
            card: cardParams,
            billingDetails: billingDetails,
            metadata: nil
        )

        STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { paymentMethod, error in
            self.hideIndicator()

            if let error = error {
                self.AlertControllerOnr(
                    title: "Alert",
                    message: error.localizedDescription,
                    BtnTitle: "OK"
                )
                return
            }

            guard let paymentMethod = paymentMethod else { return }

            print("✅ PaymentMethod ID:", paymentMethod.stripeId)

            self.API_TO_Add_Cards(
                stripe_Paymt_meth0d_ID: paymentMethod.stripeId
            )
        }
    }
  }

//save_card
extension AddCardVC{
    
    func API_TO_Add_Cards(stripe_Paymt_meth0d_ID: String) {

        var params = [String: Any]()
        let cardno = self.CardNumTxtF.text!
        let cardType = detectCardType(cardNumber: cardno)

        params["stripe_token"] = stripe_Paymt_meth0d_ID
       

        showIndicator(withTitle: "", and: "")

        let loginURL = baseURL.baseURL + appEndPoints.add_Card

        WebService.shared.postServiceURLEncoding(
            loginURL,
            VC: self,
            andParameter: params
        ) { json, statusCode in

            self.hideIndicator()

            guard let dictData = json.dictionaryObject else { return }

            let message = dictData["message"] as? String ?? ""

            if dictData["success"] as? Bool == true {
                StateMangerModelClass.shared.isCardAdded = true
                self.showToast(message)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showToast(message)
            }
        }
    }
 
}
