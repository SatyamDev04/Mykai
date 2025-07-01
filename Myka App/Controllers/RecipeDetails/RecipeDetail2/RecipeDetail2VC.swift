//
//  RecipeDetail2VC.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit
import SDWebImage
import Alamofire

class RecipeDetail2VC: UIViewController {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var ImgbottomBorder: UIView!
    @IBOutlet weak var ImgDescLbl: UILabel!
   
    
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    
    @IBOutlet weak var TimerLbl: UILabel!
    @IBOutlet weak var StartTimerBtnO: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ProgressLbl: UILabel!
    
    @IBOutlet weak var PreviousBtnO: UIButton!
    
    //CookedMeal PopupViews
    @IBOutlet var CookedMealPopupV: UIView!
    @IBOutlet weak var CookedMealPopupBGV: UIView!
    @IBOutlet weak var YesSeletImg: UIImageView!
    @IBOutlet weak var NoSelectIng: UIImageView!
    @IBOutlet weak var YesBtnO: UIButton!
    @IBOutlet weak var NoBtnO: UIButton!
    @IBOutlet weak var CookedMealBgV: UIView!
    //
    
    //Fridge PopupViews
    @IBOutlet var FridgePopupV: UIView!
    @IBOutlet weak var FridgePopupBGV: UIView!
    @IBOutlet weak var FridgeSeletImg: UIImageView!
    @IBOutlet weak var FreezerSelectImg: UIImageView!
    @IBOutlet weak var FridgeBtnO: UIButton!
    @IBOutlet weak var FreezerBtnO: UIButton!
    @IBOutlet weak var FridgeFreezerBgV: UIView!
    //
    
    var totalTimeInSeconds: Int = 0
        var timer: Timer?
    
    var RecipeDetailsData = [RecipeDetailModel]()
    
    var RecipeListArr = [String]()
    
    var MealType = ""
    
    var ProgressCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProgressLbl.text = "\(ProgressCount)/\(RecipeListArr.count)"
        let progressVw = Float(ProgressCount) / Float(RecipeListArr.count)
        progressView.progress = Float(progressVw)
        
        if ProgressCount == 1{
            self.PreviousBtnO.isHidden = true
        }
        
        let val = self.RecipeDetailsData.first?.recipe
        let img  = val?.images?.small?.url
        let imgUrl = URL(string: img ?? "")
        self.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
        self.ImgDescLbl.text = val?.label ?? ""
        //self.ImgDesc1Lbl.text = val?.source ?? ""
        
        self.TitleLbl.text = "Prepare the \(val?.label ?? ""):"
        
        self.CookedMealPopupV.frame = self.view.bounds
        self.view.addSubview(self.CookedMealPopupV)
        self.CookedMealPopupV.isHidden = true
        
        self.FridgePopupV.frame = self.view.bounds
        self.view.addSubview(self.FridgePopupV)
        self.FridgePopupV.isHidden = true
        
       // ImgbottomBorder.roundCorners([.bottomLeft, .bottomRight], radius: 22.0)
        // Do any additional setup after loading the view.
        let time = "\(val?.totalTime ?? 0)"//"0: 25: 21"
                totalTimeInSeconds = parseTimeString(time)
        TimerLbl.text = formatTime(totalTimeInSeconds)
                 
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        CookedMealPopupBGV.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap1(_:)))
        FridgePopupBGV.addGestureRecognizer(tapGesture1)
       }
     
       // Action method called when the view is tapped
       @objc func handleTap(_ sender: UITapGestureRecognizer) {
           print("View was tapped!")
           self.CookedMealPopupV.isHidden = true
           self.YesBtnO.isSelected = false
           self.NoBtnO.isSelected = false
           self.YesSeletImg.image = UIImage(named: "RadioOff")
           self.NoSelectIng.image = UIImage(named: "RadioOff")
           self.FridgeBtnO.isSelected = false
           self.FreezerBtnO.isSelected = false
           self.FridgeSeletImg.image = UIImage(named: "RadioOff")
           self.FreezerSelectImg.image = UIImage(named: "RadioOff")
       }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        self.FridgePopupV.isHidden = true
        self.YesBtnO.isSelected = false
        self.NoBtnO.isSelected = false
        self.YesSeletImg.image = UIImage(named: "RadioOff")
        self.NoSelectIng.image = UIImage(named: "RadioOff")
        self.FridgeBtnO.isSelected = false
        self.FreezerBtnO.isSelected = false
        self.FridgeSeletImg.image = UIImage(named: "RadioOff")
        self.FreezerSelectImg.image = UIImage(named: "RadioOff")
    }
    
    func parseTimeString(_ time: String) -> Int {
            let components = time.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 3,
                  let hours = Int(components[0]),
                  let minutes = Int(components[1]),
                  let seconds = Int(components[2]) else {
                print("Invalid time format")
                return 0
            }
            return hours * 3600 + minutes * 60 + seconds
        }

        func startCountdown() {
            guard totalTimeInSeconds > 0 else {
                print("Time is already zero")
                return
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.totalTimeInSeconds -= 1
                self.TimerLbl.text = self.formatTime(self.totalTimeInSeconds)
                
                if self.totalTimeInSeconds <= 0 {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.showCountdownFinishedAlert()
                }
            }
        }

        func formatTime(_ seconds: Int) -> String {
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            let seconds = (seconds % 3600) % 60
            return String(format: "%02d: %02d: %02d", hours, minutes, seconds)
        }

        func showCountdownFinishedAlert() {
            let alert = UIAlertController(title: "Countdown Finished", message: "The countdown has reached zero.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            timer?.invalidate() // Stop timer when the view is no longer visible
        }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func StartTimerBtn(_ sender: UIButton) {
        // Start the countdown
        startCountdown()
    }
    
    
    @IBAction func PrevStepBtn(_ sender: UIButton) {
        guard RecipeListArr.count > 0 else{ return}
        guard ProgressCount != 1 else{ return}
        ProgressCount -= 1
        self.ProgressLbl.text = "\(ProgressCount)/\(RecipeListArr.count)"
        let progressVw = Float(ProgressCount) / Float(RecipeListArr.count)
        progressView.progress = Float(progressVw)
        if ProgressCount == 1{
            self.PreviousBtnO.isHidden = true
        }
        self.DescLbl.text = RecipeListArr[ProgressCount-1]
    }
    
    
    @IBAction func NextStepBtn(_ sender: UIButton) {
        guard RecipeListArr.count > 0 else{ return}
        self.PreviousBtnO.isHidden = false
        if ProgressCount != RecipeListArr.count{
            ProgressCount += 1
            self.ProgressLbl.text = "\(ProgressCount)/\(RecipeListArr.count)"
            let progressVw = Float(ProgressCount) / Float(RecipeListArr.count)
            progressView.progress = Float(progressVw)
            self.DescLbl.text = RecipeListArr[ProgressCount-1]
        }else{
            self.CookedMealPopupV.isHidden = false
        } 
    }
    
    // cooked meal Btns.
    
    @IBAction func YesBtn(_ sender: UIButton) {
        self.YesSeletImg.image = UIImage(named: "RadioOn")
        self.NoSelectIng.image = UIImage(named: "RadioOff")
        YesBtnO.isSelected = true
        NoBtnO.isSelected = false
    }
    
    @IBAction func NoBtn(_ sender: UIButton) {
        self.YesSeletImg.image = UIImage(named: "RadioOff")
        self.NoSelectIng.image = UIImage(named: "RadioOn")
        YesBtnO.isSelected = false
        NoBtnO.isSelected = true
    }
    
    @IBAction func CookedMealNextBtn(_ sender: UIButton) {
        guard YesBtnO.isSelected != true && NoBtnO.isSelected != false || YesBtnO.isSelected != false && NoBtnO.isSelected != true else{
            AlertControllerOnr(title: "", message: "Please select one option.")
            return
        }
        
        if NoBtnO.isSelected == true {
            YesBtnO.isSelected = false
            NoBtnO.isSelected = false
            self.YesSeletImg.image = UIImage(named: "RadioOff")
            self.NoSelectIng.image = UIImage(named: "RadioOff")
            self.CookedMealPopupV.isHidden = true
        }else{
            self.CookedMealPopupV.isHidden = true
            self.FridgePopupV.isHidden = false
        }
    }
    //
    
    // Fridge Freezer Btns.
    
    @IBAction func FridgeBtn(_ sender: UIButton) {
        self.FridgeSeletImg.image = UIImage(named: "RadioOn")
        self.FreezerSelectImg.image = UIImage(named: "RadioOff")
        FridgeBtnO.isSelected = true
        FreezerBtnO.isSelected = false
    }
    
    @IBAction func FreezerBtn(_ sender: UIButton) {
        self.FridgeSeletImg.image = UIImage(named: "RadioOff")
        self.FreezerSelectImg.image = UIImage(named: "RadioOn")
        FridgeBtnO.isSelected = false
        FreezerBtnO.isSelected = true
    }
    
    @IBAction func DoneBtn(_ sender: UIButton) {
        guard FridgeBtnO.isSelected != true && FreezerBtnO.isSelected != false  || FridgeBtnO.isSelected != false && FreezerBtnO.isSelected != true else{
            AlertControllerOnr(title: "", message: "Please select one option.")
            return
        }
            self.Api_For_AddToPlan()
         
    }
    //
}


extension RecipeDetail2VC {
    func Api_For_AddToPlan(){
        var params = [String: Any]()
        
        let uri = RecipeDetailsData.first?.recipe?.uri ?? ""
        
        params["type"] = self.MealType
        if FridgeBtnO.isSelected{
            params["plan_type"] = "1"
        }else{
            params["plan_type"] = "2"
        }
        params["uri"] = uri
        
     
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_meal_type
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            let Msg = dictData["message"] as? String ?? ""
            
            if dictData["success"] as? Bool == true{
                self.FridgePopupV.isHidden = true
                
                self.AlertControllerCuston(title: "", message: Msg, BtnTitle: ["OK"]) { dict in
                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RateYourMealVC") as! RateYourMealVC
                    vc.uri = uri
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else{
                self.showToast(Msg)
            }
        })
    }
    
//    func Api_For_AddToPlan(){
//        var params = [String: Any]()
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd"
//        let Cdate = dateformatter.string(from: Date())
//        
//        let uri = RecipeDetailsData.first?.recipe?.uri ?? ""
//        
//        
//        params["type"] = self.MealType
//        if FridgeBtnO.isSelected{
//            params["plan_type"] = "1"
//        }else{
//            params["plan_type"] = "2"
//        }
//        params["uri"] = uri
//        params["date"] = Cdate
//        
//        
//        let token  = UserDetail.shared.getTokenWith()
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.AddMeal
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, headers: headers, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            guard let dictData = json.dictionaryObject else{
//                return
//            }
//            
//            let Msg = dictData["message"] as? String ?? ""
//            
//            if dictData["success"] as? Bool == true{
//                self.FridgePopupV.isHidden = true
//                
//                self.AlertControllerCuston(title: "", message: Msg, BtnTitle: ["OK"]) { dict in
//                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "RateYourMealVC") as! RateYourMealVC
//                    vc.uri = uri
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                
//            }else{
//                self.showToast(Msg)
//            }
//        })
//    }
    
}
