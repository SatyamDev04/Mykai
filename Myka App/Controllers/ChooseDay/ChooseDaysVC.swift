//
//  ChooseDaysVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class ChooseDaysVC: UIViewController {
    
    @IBOutlet weak var ChooseDayBgV: UIView!
    @IBOutlet weak var ChoosedaysTblV: UITableView!
    @IBOutlet weak var ChooseDayWeekLabel: UILabel!
    //
  
    
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var currentWeekDates: [Date] = []
    
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath?
    
    var seldate = Date()
     
    var backAction:(_ SelDate: Date ) -> () = {_  in}
    
    var backActionCookbook:(_ SelDate: [[String: String]] ) -> () = {_  in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ChoosedaysTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChoosedaysTblV.delegate = self
        self.ChoosedaysTblV.dataSource = self
        self.ChoosedaysTblV.separatorStyle = .none
        
        
        calendar.firstWeekday = 2 // Start the week on Monday
        setupInitialWeek()
       
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChooseDayBgV.addGestureRecognizer(tapGesture)
       }
     
       // Action method called when the view is tapped
  
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        for indx in 0..<ChooseDayData.count{
            ChooseDayData[indx].isSelected = false
        }
        
        ChoosedaysTblV.reloadData()
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    private func setupInitialWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
        }
    
 
    
    @IBAction func previousWeekTapped(_ sender: UIButton) {
//        if let firstDate = currentWeekDates.first {
//            currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
//            updateWeekLabel()
//        }
        
        let today = Date()
        let VfirstDate = currentWeekDates.first ?? Date()
        guard VfirstDate >= today else{
                 return // Exit if the previous week's start date is earlier than today
             }
        
        if let firstDate = currentWeekDates.first {
                currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
                updateWeekLabel()
            }
       }

       @IBAction func nextWeekTapped(_ sender: UIButton) {
           if let lastDate = currentWeekDates.last {
                 currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: 7, to: lastDate)!)
                 updateWeekLabel()
             }
       }
    
    @IBAction func ChoosedaysDoneBtn(_ sender: UIButton) {
        let dateformatter = DateFormatter()
        
        var SerArray = [[String: String]]()
        
        for i in 0..<self.currentWeekDates.count {
            let date = self.currentWeekDates[i]
            dateformatter.dateFormat = "yyyy-MM-dd"
            let Sdate = dateformatter.string(from: date)
            
            dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
            let dayOfWeek = dateformatter.string(from: date)
            
            let matchingDays = self.ChooseDayData.filter { $0.isSelected && $0.Name == dayOfWeek }
            if !matchingDays.isEmpty {
                print("\(dayOfWeek), \(Sdate) is selected!")
                
                let dictionary1: [String: String] = ["date": Sdate, "day": dayOfWeek]
                SerArray.append(dictionary1)
            }
        }
        
        guard SerArray.count > 0 else {
            AlertControllerOnr(title: "", message: "Please select atleast one day")
            
            return
        }
        
        self.backAction(seldate)
        self.backActionCookbook(SerArray)
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
    }
 
}
 
extension ChooseDaysVC: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ChooseDayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.NameLbl.text = ChooseDayData[indexPath.row].Name
            cell.TickImg.image = ChooseDayData[indexPath.row].isSelected ? UIImage(named: "chck") : UIImage(named: "Unchck")
            cell.selectedBgImg.image = ChooseDayData[indexPath.row].isSelected ? UIImage(named: "Yelloborder") : UIImage(named: "Group 1171276489")
            cell.DropIMg.isHidden = true
            cell.selectionStyle = .none
            return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
        if ChooseDayData[indexPath.row].isSelected {
            ChooseDayData[indexPath.row].isSelected = false
        }else{
            
            let dateformatter = DateFormatter()
                let date = self.currentWeekDates[indexPath.row]
                dateformatter.dateFormat = "yyyy-MM-dd"
                let Sdate = dateformatter.string(from: date)
            dateformatter.dateFormat = "yyyy-MM-dd"
            let ReconvertDate = dateformatter.date(from: Sdate)!
                
                dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
                let dayOfWeek = dateformatter.string(from: date)
            let selDay = ChooseDayData[indexPath.row].Name
            
            guard selDay == dayOfWeek else { return }
            
            dateformatter.dateFormat = "yyyy-MM-dd"
            let Cdate = dateformatter.string(from: Date())
            dateformatter.dateFormat = "yyyy-MM-dd"
            let cReconvertDate = dateformatter.date(from: Cdate)!
            
            guard ReconvertDate >= cReconvertDate else { return }
            
            ChooseDayData[indexPath.row].isSelected = true
        }
        ChoosedaysTblV.reloadData()
    }
 
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 50
        }
    }

extension ChooseDaysVC {
    func calculateWeekDates(for date: Date) -> [Date] {
        // Ensure the first day of the week is Monday
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
        let startOfWeek = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: weekInterval.start) - 2), to: weekInterval.start)!

        // Return all dates from Monday to Sunday
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    func updateWeekLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        if let start = currentWeekDates.first, let end = currentWeekDates.last {
//            weekLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
            
            ChooseDayWeekLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "d" // For the day number
            let startDay = formatter1.string(from: start)
            let endDay = formatter1.string(from: end)

            formatter1.dateFormat = "MMM" // For the month abbreviation (e.g., Dec)
            let month = formatter1.string(from: start)

           // FromDateToLbl.text = "\(startDay) - \(endDay) \(month)"
            for j in 0..<ChooseDayData.count {
                ChooseDayData[j].isSelected = false
            }
            
            ChoosedaysTblV.reloadData()
            }
        }
    }
 
