//
//  StatsVC.swift
//  Myka App
//
//  Created by Sumit on 11/12/24.
//

import UIKit
import Charts
import AppsFlyerLib
import Alamofire
import SDWebImage
 
struct GraphDataModelClass: Codable {
    var date: String
    var amount: Double
}

class StatsVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var ProfImg: UIImageView!
    @IBOutlet weak var ProfDescLbl: UILabel!
    @IBOutlet weak var YourSavingLbl: UILabel!
    @IBOutlet weak var TotalSpentLbl: UILabel!
    
    @IBOutlet weak var ScrollV: UIScrollView!
    
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var ChartScrollView: UIView!
    @IBOutlet weak var DateLbl: UILabel!
    
    var seldate = Date()
    
    var UserName = ""
    var UserPickUrl = ""
    
    var GraphDataArr = [GraphDataModelClass]()
     
    var x = 0.0
    
   
     
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBarChart()
//               setData()
        // Set the delegate
         barChartView.delegate = self
       
        planService.shared.Api_To_Get_ProfileData(vc: self) { result in
            
            switch result {
            case .success(let allData):
                let response = allData
                
                let Name = response?["name"] as? String ?? String()
                self.UserName = Name.capitalizedFirst
                
                self.ProfDescLbl.text = "Good job \(Name.capitalizedFirst) you're on track to big savings! Stick with your plan and watch the results add up."
                
                let ProfImg = response?["profile_img"] as? String ?? String()
                let img = "\(baseURL.imageUrl)\(ProfImg)"
                let ImgUrl = URL(string: img)
                self.ProfImg.sd_imageIndicator = SDWebImageActivityIndicator.medium
                self.ProfImg.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "DummyImg"))
                self.UserPickUrl = img
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        self.Api_To_Get_Graph()
        
    }
    
 
    func setupBarChart() {
        barChartView.renderer = RoundedBarChartRenderer(dataProvider: barChartView, animator: barChartView.chartAnimator, viewPortHandler: barChartView.viewPortHandler)
        
        barChartView.delegate = self // Important
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.GraphDataArr.map { String($0.date) })
                                                                    
        barChartView.xAxis.granularity = 1
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 700 // Adjust maximum value
        barChartView.leftAxis.labelCount = 5
        barChartView.legend.enabled = false
        barChartView.doubleTapToZoomEnabled = false
       // barChartView.isUserInteractionEnabled = false
        barChartView.isUserInteractionEnabled = true
        barChartView.highlightPerTapEnabled = true
        barChartView.highlightFullBarEnabled = false
        
        // Customize left axis grid lines (add dashed effect)
        barChartView.leftAxis.gridLineDashLengths = [4, 4] // Pattern: [dash length, space length]
        barChartView.leftAxis.gridColor = .lightGray // Color of dashed lines
        barChartView.leftAxis.gridLineWidth = 0.8
        barChartView.xAxis.drawGridLinesEnabled = false

        // Keep horizontal grid lines (Left Axis)
        barChartView.leftAxis.drawGridLinesEnabled = true

        // Remove extra space on the left and right
        barChartView.xAxis.axisMinimum = -0.5 // Aligns the first bar to the edge
        barChartView.xAxis.axisMaximum = Double(4) - 0.5 // Adjust according to the number of bars
        barChartView.fitBars = false

        // Remove "0" label from the y-axis and add $ before all values
        barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter { value, axis in
            if value == 0 {
                return "" // Remove the "0" label
            }
            return String(format: "$%.0f", value) // Add "$" before the value
        }
        
    }

    func setData() {
        let values: [Double] = self.GraphDataArr.map { ($0.amount) }
        let colors: [NSUIColor] = [.orange, .green, .red, .orange]

        var entries: [BarChartDataEntry] = []
        for (index, value) in values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            entries.append(entry)
        }

        let dataSet = BarChartDataSet(entries: entries, label: "")
        dataSet.colors = colors
        dataSet.valueColors = [.black]
         
        dataSet.valueFont = UIFont.systemFont(ofSize: 12)
        
        dataSet.valueFormatter = CurrencyValueFormatter()

        let data = BarChartData(dataSet: dataSet)

        // Completely remove space between bars
        data.barWidth = 1.0

        barChartView.data = data
        barChartView.notifyDataSetChanged() // Refresh the chart
    }
     

    @IBAction func CalanderBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatesCalendarVC") as! StatesCalendarVC
        vc.seldate = seldate
      //  vc.comesfrom = "StatsVC"
        vc.backAction = {date in
            self.seldate = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let formattedDate = dateFormatter.string(from: self.seldate)
            self.DateLbl.text = formattedDate
            self.Api_To_Get_Graph()
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
     
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func SeedetailBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Invitations") as! Invitations
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func InviteFrndBtn(_ sender: UIButton) {
        generateInviteLink { inviteLink in
            
            let AppUrl:URL = URL(string: inviteLink)!

//            let referralCode = UserDetail.shared.getUserRefferalCode() // Replace with the actual referral code
            
            let productImage = UIImage(named: "InviteAppLogo")
            
            let someText: String = """
            Hey, My Kai’s an all-in-one app that’s completely changed the way
            I shop. It saves me time, money, and even helps with meal planning without having to step into a supermarket. See for yourself with a free gift from me

            Click on the link below:
            \(AppUrl)   
            """
            // save reff code from signup, login, social login
            
            let itemsToShare: [Any] = [productImage!, someText]
            // 4. Create and present the UIActivityViewController
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            
            // Exclude irrelevant activities if needed
            activityViewController.excludedActivityTypes = [
              .addToReadingList,
              .saveToCameraRoll,
              .assignToContact
            ]
            
            // Present the activity view controller
            DispatchQueue.main.async {
                self.present(activityViewController, animated: true, completion: nil)
            }
            }
    }
    
    
    func generateInviteLink(completion: @escaping (String) -> Void) {
      //  let tempID = AppsFlyerLib().appleAppID
 
        let baseURL = "https://mykaimealplanner.onelink.me/mPqu/" //ns5ueabp    Replace with your OneLink template
     
        let userID = UserDetail.shared.getUserId() // Replace with your dynamic user identifier
  
        // Deep link URL for when the app is installed
        let deepLink = "mykai://property?" +
            "af_user_id=\(userID)" +
            "&Referrer=\(UserDetail.shared.getUserRefferalCode())" +
            "&providerName=\(self.UserName)" +
            "&providerImage=\(self.UserPickUrl)"
        
         
        // Web fallback URL (e.g., if app is not installed)
        let webLink = "https://www.mykaimealplanner.com" // Replace with your fallback web URL
         
        // Create the final URL with query parameters
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "af_dp", value: deepLink),
            URLQueryItem(name: "af_web_dp", value: webLink)
        ]
         
        // Convert to string and log or use the URL
        if let fullURL = components.url?.absoluteString {
            let referLink = fullURL
            completion(referLink)
            print("Generated OneLink URL: \(referLink)")
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            guard let barEntry = entry as? BarChartDataEntry else { return }
            print("Selected value: \(barEntry.y)")
            print("X value: \(barEntry.x)")
        
        self.x = barEntry.x
        
        let selBar = Int(barEntry.x)
        let FselBar = selBar + 1
          
        chartView.highlightValue(nil)
         
        let currentDate = self.seldate // Get the current date
        let calendar = Calendar.current

        // Extract the month and year
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let week = FselBar
         
        // Create a date from the year, month, and week
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.weekOfMonth = week
        dateComponents.weekday = calendar.firstWeekday + 1 // Start of the week (Sunday or Monday, based on locale)

        let startOfWeek = calendar.date(from: dateComponents) ?? Date()
            // Find the end of the week by adding 6 days to the start of the week
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
                // Format the dates for display (optional)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "yyyy-MM-dd"
              let startDate = dateFormatter.string(from: startOfWeek)
              let endDate =  dateFormatter.string(from: endOfWeek ?? Date())
           
         
        // pass Stored Data of the Previous Selected Bar
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatesForWeekOrYearVC") as! StatesForWeekOrYearVC
        vc.seldate = startOfWeek
        vc.StartDate = startDate
        vc.EndDate = endDate
        self.navigationController?.pushViewController(vc, animated: true)
        }

        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            print("No bar selected.")
               
            guard x > 0 else { return }
            print("Selected value: \(self.x)")
            
            let selBar = Int(self.x)
            let FselBar = selBar + 1
            
            let currentDate = self.seldate // Get the current date
            let calendar = Calendar.current

            // Extract the month and year
            let month = calendar.component(.month, from: currentDate)
            let year = calendar.component(.year, from: currentDate)
            let week = FselBar
             
            // Create a date from the year, month, and week
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.weekOfMonth = week
            dateComponents.weekday = calendar.firstWeekday // Start of the week (Sunday or Monday, based on locale)
            dateComponents.weekday = 2

            let startOfWeek = calendar.date(from: dateComponents) ?? Date()
                // Find the end of the week by adding 6 days to the start of the week
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
                    // Format the dates for display (optional)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    
                  let startDate = dateFormatter.string(from: startOfWeek)
                  let endDate =  dateFormatter.string(from: endOfWeek ?? Date())
               
            
           
            // pass Stored Data of the Previous Selected Bar
            let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StatesForWeekOrYearVC") as! StatesForWeekOrYearVC
            vc.seldate = startOfWeek
            vc.StartDate = startDate
            vc.EndDate = endDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
     }


extension StatsVC{
    func Api_To_Get_Graph(){
        var params = [String: Any]()
       
        let currentDate = self.seldate // Get the current date
        let calendar = Calendar.current

        // Extract the month and year
        let month = calendar.component(.month, from: currentDate)
        
        params["month"] = "\(month)"
     
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.graph
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let response = dictData["data"] as? NSDictionary ?? NSDictionary()
               
                let TotalSpent = response["total_spent"] as? Double ?? Double()
                let FTotalSpent = self.formatPrice(TotalSpent)
                self.TotalSpentLbl.text = "Total Spent $\(FTotalSpent)"
                
                
                let saving = response["saving"] as? Double ?? Double()
                let Fsaving = self.formatPrice(saving)
                self.YourSavingLbl.text = "Your savings are $\(Fsaving)"
                
                 
                let currentDate = self.seldate // Get the current date
                let calendar = Calendar.current

                // Extract the month and year
                let month = calendar.component(.month, from: currentDate)
                let year = calendar.component(.year, from: currentDate)
                
                let weekStartDates = self.getWeekStartDates(for: month, in: year)

                
                let GraphData = response["graph_data"] as? NSDictionary ?? NSDictionary()
                
                var valueArray: [Double] = []
                let week1 = GraphData["week_1"] as? Double ?? Double()
                valueArray.append(week1)
                let week2 = GraphData["week_2"] as? Double ?? Double()
                valueArray.append(week2)
                let week3 = GraphData["week_3"] as? Double ?? Double()
                valueArray.append(week3)
                let week4 = GraphData["week_4"] as? Double ?? Double()
                valueArray.append(week4)
                 
                if week1 == 0 && week2 == 0 && week3 == 0 && week4 == 0{
                    self.ChartScrollView.isHidden = false//false
                }else{
                    self.ChartScrollView.isHidden = true
                }
               
                self.GraphDataArr.removeAll()
                         
                for i in 0..<valueArray.count{
                    let amt = Double(valueArray[i])
                    let WeekDate = weekStartDates[i]
                    self.GraphDataArr.append(contentsOf: [GraphDataModelClass(date: "\(WeekDate)", amount: amt)])
                }
                
                
                self.setupBarChart()
                self.setData()
                  
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
    
    func getWeekStartDates(for month: Int, in year: Int) -> [String] {
        var weekStartDates: [String] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        
        // Start date for the given month and year
        guard let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            return []
        }
        
        // End date for the given month and year
        guard let endDate = calendar.date(from: DateComponents(year: year, month: month + 1, day: 0)) else {
            return []
        }
        
        var currentDate = startDate
        
        while currentDate <= endDate {
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start ?? currentDate
            
            // Check if the week start falls in the same month
            let weekStartMonth = calendar.component(.month, from: weekStart)
            if weekStartMonth == month {
                weekStartDates.append(dateFormatter.string(from: weekStart))
            }
            
            // Move to the next week
            guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: weekStart) else {
                break
            }
            currentDate = nextWeek
        }
        
        return weekStartDates
    }
}


import Charts

class CurrencyValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "$\(formatPrice1(value))" // Format with $ and two decimal places
    }
    
    func formatPrice1(_ netTotal: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: netTotal)) ?? "\(netTotal)"
    }
}

 
class RoundedBarChartRenderer: BarChartRenderer {
    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        guard let barData = dataProvider?.barData else { return }
        let transformer = dataProvider?.getTransformer(forAxis: dataSet.axisDependency)
        let phaseY = animator.phaseY
        
        var barRect = CGRect()
        let cornerRadius: CGFloat = 10 // Fixed corner radius
        
        for j in 0 ..< Int(ceil(Double(dataSet.entryCount) * animator.phaseX)) {
            guard let entry = dataSet.entryForIndex(j) as? BarChartDataEntry else { continue }
            
            // Calculate the bar's rectangle
            let bar = barData.barWidth / 2.0
            let x = entry.x
            let y = entry.y * Double(phaseY)
            
            barRect.origin.x = CGFloat(x - bar)
            barRect.origin.y = CGFloat(min(0.0, y))
            barRect.size.width = CGFloat(barData.barWidth)
            barRect.size.height = CGFloat(abs(y))
            
            transformer?.rectValueToPixel(&barRect)
            
            // Create a path with rounded corners for the top
            let path = UIBezierPath(
                roundedRect: barRect,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            context.setFillColor(dataSet.color(atIndex: j).cgColor)
            context.addPath(path.cgPath)
            context.fillPath()
        }
    }
    
    override func drawValues(context: CGContext) {
        guard let barData = dataProvider?.barData else { return }

        let dataSets = barData.dataSets
        let phaseY = animator.phaseY

        for i in 0 ..< dataSets.count {
            guard let dataSet = dataSets[i] as? BarChartDataSetProtocol else { continue }
            guard isDrawingValuesAllowed(dataProvider: dataProvider!) else { continue }

            let valueFont = dataSet.valueFont
            let valueTextColor = dataSet.valueTextColor
            let formatter = dataSet.valueFormatter

            for j in 0 ..< dataSet.entryCount {
                guard let entry = dataSet.entryForIndex(j) as? BarChartDataEntry else { continue }

                let xPos = CGFloat(entry.x)
                let yPos = CGFloat(entry.y * Double(phaseY))

                var valuePosition = CGPoint(x: xPos, y: yPos)
                dataProvider?.getTransformer(forAxis: dataSet.axisDependency).pointValueToPixel(&valuePosition)

                if viewPortHandler.isInBoundsRight(valuePosition.x),
                   viewPortHandler.isInBoundsLeft(valuePosition.x),
                   viewPortHandler.isInBoundsY(valuePosition.y) {
                    let valueString = formatter.stringForValue(entry.y, entry: entry, dataSetIndex: i, viewPortHandler: viewPortHandler)

                    // Draw text using Core Graphics
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: valueFont,
                        .foregroundColor: valueTextColor
                    ]
                    let size = valueString.size(withAttributes: attributes)
                    let rect = CGRect(x: valuePosition.x - size.width / 2,
                                      y: valuePosition.y - size.height - 5, // Offset above the bar
                                      width: size.width,
                                      height: size.height)
                    valueString.draw(in: rect, withAttributes: attributes)
                }
            }
        }
    }
}
