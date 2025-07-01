//
//  CalendarCell.swift
//  Myka App
//
//  Created by YES IT Labs on 04/12/24.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
          //  updateSelection(isSelected: false)
        }
        
        func configure(with date: Date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEEE"
            dayLabel.text = formatter.string(from: date)
            
            formatter.dateFormat = "d"
            dateLabel.text = formatter.string(from: date)
            
    
        }
        
        func updateSelection(isSelected: Bool) {
            indicatorView.backgroundColor = isSelected ? #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) : UIColor.white
            dayLabel.textColor = isSelected ? .white : .black
            dateLabel.textColor = isSelected ? .white : .black
        }
    
}
