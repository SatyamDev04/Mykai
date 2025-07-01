//
//  OrderHistoryVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 27/02/25.
//

import UIKit
import Alamofire
import SDWebImage

class OrderHistoryVC: UIViewController {
    
    @IBOutlet var NoOrderPopUpView: UIView!
    
    @IBOutlet weak var TblV: UITableView!
    
    var OrderHistoryArrList = [OrderHistoryModelData]()
    
    var comesfrom = ""
    
    var historyStatus: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.NoOrderPopUpView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.NoOrderPopUpView)
        // Add constraints
        NSLayoutConstraint.activate([
            self.NoOrderPopUpView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            self.NoOrderPopUpView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.NoOrderPopUpView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.NoOrderPopUpView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.NoOrderPopUpView.isHidden = true
        
        
        
        self.TblV.register(UINib(nibName: "OrderHistoryVCTblVCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryVCTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.Api_To_get_OrderHistory()
    }
    

    @IBAction func BackBtn(_ sender: UIButton) {
        if self.comesfrom == "Profile"{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func Start_An_OrderBtn(_ sender: UIButton) {
        if historyStatus == 0{
            if let tabBar = self.tabBarController?.tabBar,
               let items = tabBar.items,
               items.count > 4 {
                let item = items[3] // Get the UITabBarItem at index 4
                self.tabBarController?.tabBar(tabBar, didSelect: item)
                self.tabBarController?.selectedIndex = 3
            }
        }else{
            let storyboard = UIStoryboard(name: "Basket", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BasketVC") as! BasketVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension OrderHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OrderHistoryArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryVCTblVCell", for: indexPath) as! OrderHistoryVCTblVCell
        
        let img = self.OrderHistoryArrList[indexPath.row].storeLogo ?? ""
        let ImgUrl = URL(string: img)
        
        cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
        
        let dateString = self.OrderHistoryArrList[indexPath.row].date ?? ""
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = inputFormatter.date(from: dateString) ?? Date()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM"
        let formattedDate = outputFormatter.string(from: date)
        print(formattedDate) // Output: "29 Jan"
            
        let Status = self.OrderHistoryArrList[indexPath.row].status ?? 0
        var StatusTxt = ""
        if Status == 1{
            StatusTxt = "Placed"
            cell.ViewOrdrBtn.setTitle("Track order", for: .normal)
        }else{
            StatusTxt = "Delivered"
            cell.ViewOrdrBtn.setTitle("View order", for: .normal)
        }
        
        let FullTxt = "\(formattedDate) • $\(self.OrderHistoryArrList[indexPath.row].order?.finalQuote?.totalWithTip ?? 0) • \(self.OrderHistoryArrList[indexPath.row].order?.finalQuote?.items?.count ?? 0) items\n\(StatusTxt) -  \(self.OrderHistoryArrList[indexPath.row].address ?? "")"
        
        cell.TxtLbl.text = FullTxt
        
        
        cell.ViewOrdrBtn.tag = indexPath.row
        cell.ViewOrdrBtn.addTarget(self, action: #selector(ShowOrderDetailsVC(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  115
    }
    
    
    @objc func ShowOrderDetailsVC(sender: UIButton) {
        let index = sender.tag
        let Status = self.OrderHistoryArrList[index].status ?? 0
        let trackLink = self.OrderHistoryArrList[index].order?.trackingLink ?? ""
        
        if Status == 1{
            let storyboard = UIStoryboard(name: "Basket", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TrackingVC") as! TrackingVC
            vc.comesfrom = "OrderHistory"
            vc.WebUrl = trackLink
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OrderHistoryDetailVC") as! OrderHistoryDetailVC
            vc.OrderHistoryArrList = self.OrderHistoryArrList[index]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
 
extension OrderHistoryVC {
    func Api_To_get_OrderHistory(){
        
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.order_history
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(OrderHistoryModelClass.self, from: data)
                if d.success == true {
                    
                    self.historyStatus = d.history_status ?? 0
                    
                    let allData = d.data
                    
                    self.OrderHistoryArrList = allData ?? []
                    self.TblV.reloadData()
                    
                    if self.OrderHistoryArrList.count == 0 {
                        self.NoOrderPopUpView.isHidden = false
                    }else{
                        self.NoOrderPopUpView.isHidden = true
                    }
                    
                    
                }else{
                    self.NoOrderPopUpView.isHidden = true
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
}
