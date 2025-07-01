//
//  Invitations.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit
import DropDown
import AppsFlyerLib
import Alamofire

struct InvitationsModelData {
    let name: String
    let type: String
  //  let color: UIColor
}

class Invitations: UIViewController {

    @IBOutlet weak var TblV: UITableView!
    
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    
    @IBOutlet weak var DropLbl: UILabel!
    
    @IBOutlet weak var InvitedFriendsCountLbl: UILabel!
  
    @IBOutlet weak var RedeemBgV: UIView!
    
    let dropDown = DropDown()
 
    
    var InvitationsArray = [InvitationsModelData]()
    var InvitationsArray1 = [InvitationsModelData]()
    
    var InvitationsArrayList = [InvitationModel]()
    
    var UserName = ""
    var UserPickUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.TblV.register(UINib(nibName: "InvitationsTblVCell", bundle: nil), forCellReuseIdentifier: "InvitationsTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
          
        self.TblV.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        
        self.RedeemBgV.isHidden = true
         
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
        
        self.Api_To_get_referralFriendsList()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newContentSize = tableView.contentSize
            // Update the height constraint or perform actions as needed
            updateTableViewHeight(newContentSize.height)
        }
    }
    
    func updateTableViewHeight(_ height: CGFloat) {
        TblVH.constant = height
        view.layoutIfNeeded()
    }
    
    
    deinit {
        TblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DropDownBtn(_ sender: UIButton) {
        dropDown.dataSource = ["All", "Trial", "Trial over", "Myka", "Redeemed"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: -100, y: sender.frame.size.height)
        dropDown.show()
        dropDown.layer.cornerRadius = 10
        dropDown.backgroundColor = .white
        dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dropDown.layer.shadowOpacity = 0
        dropDown.layer.shadowRadius = 4
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropDown.selectionAction = { [self] (index: Int, item: String) in
            self.DropLbl.text = item
 
            let SelTxt = "\(item)"
            
            self.InvitationsArray = self.InvitationsArray1.filter({ (item) -> Bool in
                             let value: InvitationsModelData = item as InvitationsModelData
                return ((value.type.range(of: SelTxt, options: .caseInsensitive)) != nil)
                         })

            if item == "All" {
                self.InvitationsArray = self.InvitationsArray1
            }

            self.TblV.reloadData()
            DispatchQueue.main.async {
                self.TblV.reloadData()
                self.TblV.layoutIfNeeded()
                self.TblVH.constant = self.TblV.contentSize.height
                self.TblV.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func RedeemNowBtn(_ sender: UIButton) {
        self.API_TO_Redeeme()
    }
    
    
    @IBAction func ShareAppBtn(_ sender: UIButton) {
        generateInviteLink { inviteLink in
            
            let AppUrl:URL = URL(string: inviteLink)!
            let someText: String = """
                Hey, My Kai’s an all-in-one app that’s completely changed the way
                I shop. It saves me time, money, and even helps with meal planning without
                having to step into a supermarket. See for yourself with a free gift from
                me

            Click on the link below:
            \(AppUrl)
            """
            let objectsToShare:URL? = nil
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view

            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

            self.present(activityViewController, animated: true, completion: nil)
            }
    }
    
    func generateInviteLink(completion: @escaping (String) -> Void) {
        let tempID = AppsFlyerLib().appleAppID
 
        let baseURL = "https://mykaimealplanner.onelink.me/mPqu/" // Replace with your OneLink template
        
        let add = AppsFlyerLib()
      
        let userID = UserDetail.shared.getUserId() // Replace with your dynamic user identifier
        let parameters: [String: String] = [
            "tempId": tempID,
            "af_user_id": userID,
            "providerName": self.UserName,
            "providerImage": self.UserPickUrl,
            "Referrer":UserDetail.shared.getUserRefferalCode()
        ]
       // "Hi, I am inviting you to download ROAM app!\n\nClick on the link below:\n\(AppUrl)"

        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        if let fullURL = components?.url?.absoluteString {
            completion(fullURL)
        } else {
            print("Failed to create invite link.")
        }
    }
    
}

extension Invitations: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.InvitationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationsTblVCell", for: indexPath) as! InvitationsTblVCell
        cell.NameLbl.text = self.InvitationsArray[indexPath.row].name
        
      //  cell.TypeBgV.backgroundColor = self.InvitationsArray[indexPath.row].color
        
        cell.TypeLbl.text = self.InvitationsArray[indexPath.row].type
        
        if indexPath.row == self.InvitationsArray.count - 1 {
            cell.LineLbl.isHidden = true
        }
        
        if self.InvitationsArray[indexPath.row].type == "Trial"{
            cell.TypeBgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        }else if self.InvitationsArray[indexPath.row].type == "Trial Over"{
            cell.TypeBgV.backgroundColor = #colorLiteral(red: 1, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        }else if self.InvitationsArray[indexPath.row].type == "My Kai"{
            cell.TypeBgV.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }else if self.InvitationsArray[indexPath.row].type == "Redeemed"{
                cell.TypeBgV.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        }else{
            cell.TypeBgV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
          
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
 
//InvitationModelClass InvitationModel
extension Invitations{
    func Api_To_get_referralFriendsList(){
        
        
      //  showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.referral
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion: { (json, statusCode) in
            
          //  self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(InvitationModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    self.InvitationsArrayList = allData ?? []
                    
                    for item in self.InvitationsArrayList{
                        if item.name ?? "" != ""{
                            print(item.status ?? "")
                            self.InvitationsArray.append(contentsOf: [InvitationsModelData(name: item.name ?? "", type: item.status ?? "")])
                        }
                    }
                    
                    self.InvitationsArray1 = self.InvitationsArray
                    
                  
                    let countMyKai = self.InvitationsArray.filter { $0.type == "My Kai" }.count
                    
                    if countMyKai > 0{
                        self.RedeemBgV.isHidden = false
                    }else{
                        self.RedeemBgV.isHidden = true
                    }
                    
                    self.TblV.reloadData()
                    
                    
                    let count = self.InvitationsArray1.count
                    let baseString = "You have invited \(count) friends to use My Kai"

                    // Create an attributed string
                    let attributedString = NSMutableAttributedString(string: baseString)

                    // Find the range of "My Kai"
                    if let range = baseString.range(of: "My Kai") {
                        let nsRange = NSRange(range, in: baseString)
                        
                        // Apply bold font with a different size to "My Kai"
                        let customFont = UIFont(name: "Poppins SemiBold", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
                        attributedString.addAttributes([.font: customFont], range: nsRange)
                    }

                    // Set this attributed string to a label
                    self.InvitedFriendsCountLbl.attributedText = attributedString
                    
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    func API_TO_Redeeme(){
        var params = [String: Any]()
     
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.reedem
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}
