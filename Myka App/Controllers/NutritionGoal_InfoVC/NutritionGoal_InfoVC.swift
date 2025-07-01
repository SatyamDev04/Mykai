//
//  NutritionGoal_InfoVC.swift
//  My Kai
//
//  Created by YES IT Labs on 10/06/25.
//

import UIKit
import Charts

class NutritionGoal_InfoVC: UIViewController {
    
    @IBOutlet weak var Viewpopup: UIView!
    @IBOutlet weak var DragDownView: UIView!
    
    @IBOutlet weak var macroTitleLbl: UILabel!
    @IBOutlet weak var macroDescLbl: UILabel!
    
    @IBOutlet weak var macrosTypeLbl: UILabel!
    @IBOutlet weak var chartTitleLbl: UILabel!
     
    @IBOutlet weak var disclamerTitleLbl: UILabel!
    @IBOutlet weak var disclamerDescLbl: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var scrollVTopConst: NSLayoutConstraint!
    
    var macroOptions = ""
    var disclaimer = ""
    var SelectedMacroType:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.macroDescLbl.text = self.macroOptions
        self.disclamerDescLbl.text = self.disclaimer
        self.macrosTypeLbl.text = self.SelectedMacroType
        self.chartTitleLbl.text = "\(self.SelectedMacroType) Macro Distribution"
        
        if UIDevice.current.hasNotch {
            //... consider notch
            let modelName = UIDevice.modelName
            
            if modelName.contains(find: "mini"){//"iPhone 12 mini"{
                self.scrollVTopConst.constant = 80
            }else if modelName.contains(find: "Max"){// == "iPhone 12 mini"{
                self.scrollVTopConst.constant = 180
            }else if modelName.contains(find: "Pro"){
                self.scrollVTopConst.constant = 180
            }else{
                self.scrollVTopConst.constant = 130
            }
        }else{
            self.scrollVTopConst.constant = 80
        }
        
        
        setupPieChart()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        DragDownView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        guard let rootView = Viewpopup, let rootWindow = rootView.window else { return }
        let rootWindowHeight: CGFloat = rootWindow.frame.size.height
        
        let touchPoint = sender.location(in: Viewpopup?.window)
        var initialTouchPoint = CGPoint.zero
        let blankViewHeight =  (rootWindowHeight - Viewpopup.frame.size.height)
        let dismissDragSize: CGFloat = 200.00
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            // dynamic alpha
            if touchPoint.y > (initialTouchPoint.y + blankViewHeight)  { // change dim background (alpha)
                Viewpopup.frame.origin.y = (touchPoint.y - blankViewHeight) - initialTouchPoint.y
            }
            
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > (dismissDragSize + blankViewHeight) {
                self.view.backgroundColor = UIColor.clear
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.Viewpopup.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: self.Viewpopup.frame.size.width,
                                                  height: self.Viewpopup.frame.size.height)
                })
                // alpha = 1
            }
        case .failed, .possible:
            break
        }
    }
    
    func setupPieChart() {
        let entries = [
            PieChartDataEntry(value: 62, label: "Carbs (\(62)%)"),
            PieChartDataEntry(value: 25, label: "Fat (\(25)%)"),
            PieChartDataEntry(value: 13, label: "Protein (\(13)%)")
        ]
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [#colorLiteral(red: 1, green: 0.6549019608, blue: 0.1607843137, alpha: 1), #colorLiteral(red: 0.3019607843, green: 0.7137254902, blue: 0.6745098039, alpha: 1), #colorLiteral(red: 0.7294117647, green: 0.4078431373, blue: 0.7843137255, alpha: 1)]
        
        // Configure values and labels
        dataSet.valueTextColor = .black
        dataSet.valueFont = UIFont(name: "Poppins Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        dataSet.xValuePosition = .outsideSlice // Display labels outside
        dataSet.yValuePosition = .insideSlice  // Display values inside
        
        // Leader lines (for labels outside the slices)
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.8
        dataSet.valueLinePart2Length = 0.8
        dataSet.valueLineColor = .clear // Set line color
        
        // Set chart data
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(InsideValueFormatter()) // Format percentages inside slices
        pieChartView.data = data
        
        // Pie chart appearance
        pieChartView.usePercentValuesEnabled = true
        pieChartView.legend.enabled = false
        pieChartView.drawEntryLabelsEnabled = true // Enable entry labels
        pieChartView.entryLabelFont = UIFont(name: "Poppins Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        pieChartView.entryLabelColor = .black
        pieChartView.holeRadiusPercent = 0.0 // Disable donut hole
        pieChartView.holeColor = .clear
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.rotationEnabled = false
        pieChartView.rotationAngle = 45
        pieChartView.isUserInteractionEnabled = false
    }
}
    // Formatter for percentages inside slices
    class InsideValueFormatter: NSObject, ValueFormatter {
        func stringForValue(_ value: Double,
                            entry: ChartDataEntry,
                            dataSetIndex: Int,
                            viewPortHandler: ViewPortHandler?) -> String {
            return String(format: "%.0f%%", value)
        }
    }
