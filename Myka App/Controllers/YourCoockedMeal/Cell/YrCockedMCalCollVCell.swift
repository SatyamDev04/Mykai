//
//  YrCockedMCalCollVCell.swift
//  Myka App
//
//  Created by Sumit on 11/12/24.
//

import UIKit

class YrCockedMCalCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var BraekFstV: UIView!
    @IBOutlet weak var LunchV: UIView!
    @IBOutlet weak var DinnerV: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            updateSelection(isSelected: false)
        }
        
        func configure(with date: Date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEEE"
            dayLabel.text = formatter.string(from: date)
            
            formatter.dateFormat = "d"
            dateLabel.text = formatter.string(from: date)
        }
    
        func updateSelection(isSelected: Bool) {
            indicatorView.backgroundColor = isSelected ? UIColor.orange : UIColor.white
            dayLabel.textColor = isSelected ? .white : .black
            dateLabel.textColor = isSelected ? .white : .black
        }

}
