//
//  CalendarVC.swift
//  Myka App
//
//  Created by Sumit on 09/12/24.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {

    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet weak var BgView: UIView!
    
    @IBOutlet weak var TitleLbl: UILabel!
    
    var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    var seldate = Date()
    
    let abbreviatedWeekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"]
    
    var backAction:(_ SelDate: Date ) -> () = {_  in}
    
    override func loadView() {
        super.loadView()
        self.calenderView.delegate = self
        self.calenderView.dataSource = self
        self.calenderView.appearance.headerDateFormat = "dd MMMM, yyyy"
        self.calenderView.appearance.headerTitleFont = UIFont(name: "Montserrat Bold", size: 15)
        self.calenderView.appearance.weekdayFont = UIFont(name: "Poppins Medium", size: 12)
        
        self.calenderView.appearance.titleFont = UIFont(name: "Poppins Regular", size: 14)
        self.calenderView.appearance.titleDefaultColor = UIColor.black
        self.calenderView.today = nil
        
        self.calenderView.weekdayHeight = 45
        self.calenderView.placeholderType = .none // to hide placeholder.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let df = DateFormatter()
        df.dateFormat = "dd MMMM, yyyy"
        let date = df.string(from: seldate)
        
        TitleLbl.text = date
         
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        BgView.addGestureRecognizer(tapGesture)
       }
       
       // Action method called when the view is tapped
       @objc func handleTap(_ sender: UITapGestureRecognizer) {
           print("View was tapped!")
               self.willMove(toParent: nil)
               self.view.removeFromSuperview()
               self.removeFromParent()
       }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  if today <= seldate{
            self.calenderView.select(self.seldate)
            self.currentPage = self.seldate
             self.calenderView.setCurrentPage(self.seldate, animated: true)
        //}
    }

    @IBAction func calPreviousMonthBtn(_ sender: UIButton) {
        //            let _calendar = Calendar.current
        //            var dateComponents = DateComponents()
        //            dateComponents.month = -1 // For next button
        //
        //            self.currentPage = _calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
        //
        //            self.calenderView.setCurrentPage(self.currentPage ?? Date(), animated: true)
        
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        
        let dateformattter = DateFormatter()
        dateformattter.dateFormat = "MM"
        
        let Month = Int(dateformattter.string(from: self.currentPage ?? Date())) ?? 0
        let cMonth = Int(dateformattter.string(from: Date())) ?? 0
        
        dateformattter.dateFormat = "yyyy"
        let Year = dateformattter.string(from: self.currentPage ?? Date())
        let cYear = dateformattter.string(from: Date())
        guard Year >= cYear else{return}
        
        if Year == cYear && Month > cMonth{
            dateComponents.month = -1 // For prev button
            self.currentPage = _calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
            self.calenderView.setCurrentPage(self.currentPage ?? Date(), animated: true)
            
            
            // for custom Header title
            let df = DateFormatter()
            df.dateFormat = "MMMM, yyyy"
            let CMonth = df.string(from: self.currentPage ?? Date())
            
            df.dateFormat = "dd"
            let datee = df.string(from: seldate)
            
            TitleLbl.text = "\(datee) \(CMonth)"
            //
            
        }else if Year > cYear{
            dateComponents.month = -1 // For prev button
            self.currentPage = _calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
            self.calenderView.setCurrentPage(self.currentPage ?? Date(), animated: true)
            
            // for custom Header title
            let df = DateFormatter()
            df.dateFormat = "MMMM, yyyy"
            let CMonth = df.string(from: self.currentPage ?? Date())
            
            df.dateFormat = "dd"
            let datee = df.string(from: seldate)
            
            TitleLbl.text = "\(datee) \(CMonth)"
            //
        }
    }
        
        @IBAction func calNextMonthBtn(_ sender: UIButton) {
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = 1 // For next button
            
            self.currentPage = _calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
            
            self.calenderView.setCurrentPage(self.currentPage ?? Date(), animated: true)
            
            // for custom Header title
            let df = DateFormatter()
            df.dateFormat = "MMMM, yyyy"
            let CMonth = df.string(from: self.currentPage ?? Date())

            df.dateFormat = "dd"
            let datee = df.string(from: seldate)
            
            TitleLbl.text = "\(datee) \(CMonth)"
            //
        }
        
        fileprivate let dateformatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            return dateFormatter
        }()
        
        private func moveCurrentPage(moveUp: Bool) {
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = moveUp ? 1 : -1
            
            self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
            self.calenderView.setCurrentPage(self.currentPage ?? Date(), animated: true)
        }
}


    extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {
        
         
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            let cDate = dateformatter.string(from: Date())
            let selDate = dateformatter.string(from: date)
            
            if date .compare(Date()) == .orderedAscending { // to disable previous date.
                if selDate ==  cDate{
                    return true
                }else{
                    return false
                }
            }
            else {
                return true
            }
        }
     
        

        
        func minimumDate(for calendar: FSCalendar) -> Date {
            // Update weekday labels
            for i in 0..<self.calenderView.calendarWeekdayView.weekdayLabels.count {
                self.calenderView.calendarWeekdayView.weekdayLabels[i].text = self.abbreviatedWeekdayNames[i]
            }

            // Use seldate or fallback to current date if seldate is nil
            let minDate = Date()//self.seldate
            

            // Optionally, normalize to the start of the day if needed
            let calendar = Calendar.current
            let normalizedMinDate = calendar.startOfDay(for: minDate)

            return normalizedMinDate
        }
         
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
           
            calendar.today = nil
            self.seldate = date
            
            let df = DateFormatter()
            df.dateFormat = "dd MMMM, yyyy"
            let datee = df.string(from: seldate)
            
            TitleLbl.text = datee
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.backAction(self.seldate)
                
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
           
            let date1 = self.dateformatter.string(from: date)
            print("calendar did select date \(self.dateformatter.string(from: date))")
            
        }
    }
