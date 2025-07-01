//
//  ScheduleDeliveryVC.swift
//  My Kai
//
//  Created by YES IT Labs on 30/05/25.
//

import UIKit
import Alamofire

struct SlotsModelClass{
    var slotTime:String = ""
    var isSelected:Bool = false
    var offerDisc:String = ""
}

struct DaysModelClass{
    var dayName:String = ""
    var dateStr: String = ""
    var dateNumb: String = ""
    var isSelected:Bool = false
    var fullDayName:String = ""
}

class ScheduleDeliveryVC: UIViewController {

    @IBOutlet weak var ScheduleCollV: UICollectionView!
    
    @IBOutlet weak var ThreeHourSlotTblV: UITableView!
    @IBOutlet weak var ThreeHourSlotTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var OneHourSlotTblV: UITableView!
    @IBOutlet weak var OneHourSlotTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var ConfirmBtnO: UIButton!
    
    
    var DaysArray = [DaysModelClass]()
    
    var ThreeHourSlotsArray = [SlotsModelClass]()
    
    var OneHourSlotsArray = [SlotsModelClass]()
     
    
    // for api use only.
    var stertTimeStr:String = ""
    var endTimeStr:String = ""
    var SelDateStr:String = ""
    var discStr:String = ""
    //
    
    var BackAction:(String)->() = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScheduleCollV.register(UINib(nibName: "SecheduleCollV", bundle: nil), forCellWithReuseIdentifier: "SecheduleCollV")
        ScheduleCollV.delegate = self
        ScheduleCollV.dataSource = self
        
        self.ThreeHourSlotTblV.register(UINib(nibName: "SlotsTblV", bundle: nil), forCellReuseIdentifier: "SlotsTblV")
        self.ThreeHourSlotTblV.delegate = self
        self.ThreeHourSlotTblV.dataSource = self
        
        self.OneHourSlotTblV.register(UINib(nibName: "SlotsTblV", bundle: nil), forCellReuseIdentifier: "SlotsTblV")
        self.OneHourSlotTblV.delegate = self
        self.OneHourSlotTblV.dataSource = self
        
        self.setupTableView(ThreeHourSlotTblV, tag: 1)
        self.setupTableView(OneHourSlotTblV, tag: 2)
        
        self.ConfirmBtnO.isUserInteractionEnabled = false
        self.ConfirmBtnO.backgroundColor = UIColor.gray
        
        CalculateOnewWekDates()
    }
    
    func CalculateOnewWekDates(){
        let calendar = Calendar.current
        let today = Date()

        // Formatter for output date strings like "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
         
        // Formatter for short day name like "Mon", "Tue"
        let FulldateFormatter = DateFormatter()
        FulldateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Formatter for short day name like "Mon", "Tue"
        let shortDayFormatter = DateFormatter()
        shortDayFormatter.dateFormat = "EEE"

        // Formatter for "d MMM" format like "23 May"
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "d MMM"

        // Formatter for full day name like "Monday", "Tuesday"
        let fullDayFormatter = DateFormatter()
        fullDayFormatter.dateFormat = "EEEE"

        let todayString = dateFormatter.string(from: today)

        // Tomorrow
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { fatalError("Date calculation error") }
        let tomorrowString = dateFormatter.string(from: tomorrow)

        var weekDates: [String] = []
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                let dateStr = dateFormatter.string(from: date)
                weekDates.append(dateStr)
            }
        }

        print("Today: \(todayString)")
        print("Tomorrow: \(tomorrowString)")
        print("One week dates:")

        for dateStr in weekDates {
            // Convert string back to date object
            guard let date = dateFormatter.date(from: dateStr) else { continue }
            
            let Daydate = FulldateFormatter.string(from: date)
            
            let dayOfWeek = shortDayFormatter.string(from: date)     // "Mon"
            let shortDate = shortDateFormatter.string(from: date)    // "23 May"
            let fullDayName = fullDayFormatter.string(from: date)    // "Monday"

            let isSelected = (dateStr == todayString)
  
            if dateStr == todayString {
                DaysArray.append(contentsOf: [DaysModelClass(dayName: dayOfWeek, dateStr: shortDate, dateNumb: Daydate, isSelected: true, fullDayName: fullDayName)])
                self.getDeliverySchedule(day: fullDayName, date: Daydate, iscurrent: "1")
            }else{
                DaysArray.append(contentsOf: [DaysModelClass(dayName: dayOfWeek, dateStr: shortDate, dateNumb: Daydate, isSelected: false, fullDayName: fullDayName)])
            }

            print("\(fullDayName), \(shortDate) - selected: \(isSelected)")
        }
    }
    
    private func setupTableView(_ tableView: UITableView, tag: Int) {
        tableView.tag = tag
        // Add observer for contentSize
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // Observe value changes for the contentSize property
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            if tableView.tag == 1 {
                if tableView.contentSize.height < 55{
                    ThreeHourSlotTblVH.constant = 55
                }else{
                    ThreeHourSlotTblVH.constant = tableView.contentSize.height
                }
            } else if tableView.tag == 2 {
                if tableView.contentSize.height < 55{
                    OneHourSlotTblVH.constant = 55
                }else{
                    OneHourSlotTblVH.constant = tableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        // Remove observers
        ThreeHourSlotTblV.removeObserver(self, forKeyPath: "contentSize")
        OneHourSlotTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func DismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
     
    @IBAction func ConfirmBtn(_ sender: UIButton) {
        self.Api_To_SetSlots(startTime: self.stertTimeStr, endTime: self.endTimeStr, date: self.SelDateStr, discount: self.discStr)
    }
}

extension ScheduleDeliveryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.DaysArray.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecheduleCollV", for: indexPath) as! SecheduleCollV
           
           if indexPath.item == 0{
               cell.DayLbl.text = "Today"
           }else if indexPath.item == 1{
               cell.DayLbl.text = "Tomorrow"
           }else{
               cell.DayLbl.text = self.DaysArray[indexPath.item].dayName
           }
           
           cell.DateLbl.text = self.DaysArray[indexPath.item].dateStr
           
           let isSelected = self.DaysArray[indexPath.item].isSelected
           if isSelected == true{
                 cell.BgV.borderWidth = 2
                 cell.BgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
             }else{
                 cell.BgV.borderWidth = 2
                 cell.BgV.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
             }
             
               return cell
       }
    
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<(self.DaysArray.count){
                self.DaysArray[i].isSelected = false
            }

            self.DaysArray[indexPath.item].isSelected = true
        
           let fullDayName = self.DaysArray[indexPath.item].fullDayName
        
        let date = self.DaysArray[indexPath.item].dateNumb
        
        if indexPath.item == 0 {
            self.getDeliverySchedule(day: fullDayName, date: date, iscurrent: "1")
        }else{
            self.getDeliverySchedule(day: fullDayName, date: date, iscurrent: "0")
        }
        
            self.ScheduleCollV.reloadData()
    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: 130, height: collectionView.frame.height)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }
     }



extension ScheduleDeliveryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ThreeHourSlotTblV{
            return self.ThreeHourSlotsArray.count
        }else{
            return self.OneHourSlotsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ThreeHourSlotTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsTblV", for: indexPath) as! SlotsTblV
            cell.SlotLbl.text = self.ThreeHourSlotsArray[indexPath.row].slotTime
            
            if self.ThreeHourSlotsArray[indexPath.row].offerDisc != ""{
                cell.DiscountLbl.text = "-$\(self.ThreeHourSlotsArray[indexPath.row].offerDisc)"
            }else{
                cell.DiscountLbl.text = "\(self.ThreeHourSlotsArray[indexPath.row].offerDisc)"
            }
            
            if self.ThreeHourSlotsArray[indexPath.row].isSelected{
                cell.RadioBtn.isSelected = true
            }else{
                cell.RadioBtn.isSelected = false
            }
            
            cell.RadioBtn.tag = indexPath.row
            cell.RadioBtn.addTarget(self, action: #selector(ThreeHourSelectSlotTapped(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsTblV", for: indexPath) as! SlotsTblV
            cell.DiscountLbl.isHidden = true
            
            cell.SlotLbl.text = self.OneHourSlotsArray[indexPath.row].slotTime
            if self.OneHourSlotsArray[indexPath.row].isSelected{
                cell.RadioBtn.isSelected = true
            }else{
                cell.RadioBtn.isSelected = false
            }
            
            cell.RadioBtn.tag = indexPath.row
            cell.RadioBtn.addTarget(self, action: #selector(OneHourSelectSlotTapped(_:)), for: .touchUpInside)
              
            return cell
        }
    }
    
    @objc func ThreeHourSelectSlotTapped(_ sender: UIButton){
        for i in 0..<ThreeHourSlotsArray.count{
            ThreeHourSlotsArray[i].isSelected = false
        }
         
        for i in 0..<OneHourSlotsArray.count{
            OneHourSlotsArray[i].isSelected = false
        }
        
        ThreeHourSlotsArray[sender.tag].isSelected = true
        
        self.ThreeHourSlotTblV.reloadData()
        self.OneHourSlotTblV.reloadData()
        
        self.ConfirmBtnO.isUserInteractionEnabled = true
        self.ConfirmBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        let slots = ThreeHourSlotsArray[sender.tag].slotTime
        
        let startTime = slots.components(separatedBy: " - ").first ?? ""
        let endTime = slots.components(separatedBy: " - ").last ?? ""
        
        let disc = ThreeHourSlotsArray[sender.tag].offerDisc
        
        
        var date = ""
        
        if let indx = self.DaysArray.firstIndex(where: {$0.isSelected == true}){
            date = self.DaysArray[indx].dateNumb
        }
        
        self.stertTimeStr = startTime
        self.endTimeStr = endTime
        self.SelDateStr = date
        self.discStr = disc
    }
    
    @objc func OneHourSelectSlotTapped(_ sender: UIButton){
        for i in 0..<ThreeHourSlotsArray.count{
            ThreeHourSlotsArray[i].isSelected = false
        }
        
        for i in 0..<OneHourSlotsArray.count{
            OneHourSlotsArray[i].isSelected = false
        }
        
        OneHourSlotsArray[sender.tag].isSelected = true
        
        self.ThreeHourSlotTblV.reloadData()
        self.OneHourSlotTblV.reloadData()
        
        self.ConfirmBtnO.isUserInteractionEnabled = true
        self.ConfirmBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        let slots = OneHourSlotsArray[sender.tag].slotTime
        
        let startTime = slots.components(separatedBy: " - ").first ?? ""
        let endTime = slots.components(separatedBy: " - ").last ?? ""
        
        let disc = OneHourSlotsArray[sender.tag].offerDisc
        
        
        var date = ""
        
        if let indx = self.DaysArray.firstIndex(where: {$0.isSelected == true}){
            date = self.DaysArray[indx].dateNumb
        }
         
        
        self.stertTimeStr = startTime
        self.endTimeStr = endTime
        self.SelDateStr = date
        self.discStr = disc
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 55
    }
}

extension ScheduleDeliveryVC{
    func getDeliverySchedule(day: String, date:String, iscurrent:String) {
        var params:JSONDictionary = [:]
        
        params["is_current"] = iscurrent // 1 means current date else 0
        params["date"] = date
        params["day"] = day
         
        showIndicator(withTitle: "", and: "")
   
        let loginURL = baseURL.baseURL + appEndPoints.schedule_time
        print(params,"Params")
        print(loginURL,"loginURL")
        
      
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(ScheduleDeliveryModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    let threeHrsSlots = allData?.the3Hour ?? []
                    let oneHrsSlots = allData?.the1Hour ?? []
                    
                    self.ThreeHourSlotsArray.removeAll()
                    self.OneHourSlotsArray.removeAll()
                    
                    for i in 0..<threeHrsSlots.count {
                        self.ThreeHourSlotsArray.append(contentsOf: [SlotsModelClass(slotTime: threeHrsSlots[i].time ?? "", isSelected: threeHrsSlots[i].selected ?? false, offerDisc: threeHrsSlots[i].offer ?? "")])
                        }
                     
                    for i in 0..<oneHrsSlots.count {
                        self.OneHourSlotsArray.append(contentsOf: [SlotsModelClass(slotTime: oneHrsSlots[i].time ?? "", isSelected: oneHrsSlots[i].selected ?? false, offerDisc: oneHrsSlots[i].offer ?? "")])
                    }
 
                    
                    if self.OneHourSlotsArray.count > 0{
                        self.OneHourSlotTblV.setEmptyMessage("")
                    }else{
                        self.OneHourSlotTblV.setEmptyMessage("No Slots Available")
                    }
                    
                    if self.ThreeHourSlotsArray.count > 0{
                        self.ThreeHourSlotTblV.setEmptyMessage("")
                    }else{
                        self.ThreeHourSlotTblV.setEmptyMessage("No Slots Available")
                    }
                    
                    
                    self.ScheduleCollV.reloadData()
                    
                    self.ThreeHourSlotTblV.reloadData()
                    
                    self.OneHourSlotTblV.reloadData()
                     
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    func Api_To_SetSlots(startTime: String, endTime: String, date: String, discount: String){
        
        var params:JSONDictionary = [:]
        
        params["start_time"] =  startTime
        params["end_time"] =  endTime
        params["date"] =  date
        if discount == ""{
            params["discount"] = "0"
        }else{
            params["discount"] = discount
        }
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.set_schedule
        
        print(params,"params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                let disc = dictData["data"] as? String ?? ""
                self.discStr = disc
                self.stertTimeStr = ""
                self.endTimeStr = ""
                self.SelDateStr = ""

                self.dismiss(animated: true, completion: {
                    self.BackAction(disc)
                })
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
