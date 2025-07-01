//
//  BsktDtlSprMrktHeatedTblVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 16/12/24.
//

import UIKit
import SDWebImage
  
class BsktDtlSprMrktHeatedTblVCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var SectionTblV: UITableView!
    @IBOutlet weak var SectionTblVH: NSLayoutConstraint!
    
    var backAction:(_ index:Int) -> () = { _ in }
    
    var SuperMarketSecArrdata: BasketDetailsModelData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.SectionTblV.register(UINib(nibName: "BsktDtlSprMrktSectionTblVCell", bundle: nil), forCellReuseIdentifier: "BsktDtlSprMrktSectionTblVCell")
         
        self.SectionTblV.delegate = self
        self.SectionTblV.dataSource = self
        self.SectionTblV.isScrollEnabled = false
        
        SectionTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentSize", let tableView = object as? UITableView {
                SectionTblVH.constant = tableView.contentSize.height
            }
        }

        deinit {
            SectionTblV.removeObserver(self, forKeyPath: "contentSize")
        }
    
      
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
 
}
 

extension BsktDtlSprMrktHeatedTblVCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SuperMarketSecArrdata?.product?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        SectionTblV.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "BsktDtlSprMrktSectionTblVCell") as! BsktDtlSprMrktSectionTblVCell
        
        cell.NameLbl.text = SuperMarketSecArrdata?.product?[indexPath.row].pro_name ?? ""
        
        let priceValue = Double(SuperMarketSecArrdata?.product?[indexPath.row].pro_price ?? "") ?? 0
        let formattedPrice: String
        if priceValue == floor(priceValue) {
            // If the value is a whole number, show it as an integer
            formattedPrice = String(format: "%.0f", priceValue)
        } else {
            // If the value has decimals, round it to two decimal places
            formattedPrice = String(format: "%.2f", priceValue)
        }
        
        cell.Pricelbl.text = formattedPrice
        
        cell.Countlbl.text = "\(SuperMarketSecArrdata?.product?[indexPath.row].sch_id ?? 1)"
        
        let img = SuperMarketSecArrdata?.product?[indexPath.row].pro_img ?? ""
        let imgUrl = URL(string: img)
        
        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
       
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(MinusBtnAction(_:)), for: .touchUpInside)
        
        cell.PlusBtn.tag = indexPath.row
        cell.PlusBtn.addTarget(self, action: #selector(PlusBtnAction(_:)), for: .touchUpInside)
        
        cell.SwapBtn.tag = indexPath.row
        cell.SwapBtn.addTarget(self, action: #selector(SwapBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
    @objc func SwapBtnAction(_ sender: UIButton) {
        backAction(sender.tag)
    }
    
    @objc func MinusBtnAction(_ sender: UIButton) {
        var count = SuperMarketSecArrdata?.product?[sender.tag].sch_id ?? 1
        
        guard count > 1 else{return}
        
        count -= 1
        
        SuperMarketSecArrdata?.product?[sender.tag].sch_id = count
        
        self.SectionTblV.reloadData()
    }
    
    
    @objc func PlusBtnAction(_ sender: UIButton) {
        var count = SuperMarketSecArrdata?.product?[sender.tag].sch_id ?? 1

        count += 1
        
        SuperMarketSecArrdata?.product?[sender.tag].sch_id = count

        self.SectionTblV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
  

