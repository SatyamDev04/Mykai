//
//  AddMoreVc.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class AddMoreVc: UIViewController {
    
    
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    
    @IBOutlet var AddNewItemPopupV: UIView!
    @IBOutlet weak var CountLbl: UILabel!
    
    @IBOutlet var RemovePopUpV: UIView!
    
    
    var count = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddNewItemPopupV.frame = self.view.bounds
        self.view.addSubview(self.AddNewItemPopupV)
        self.AddNewItemPopupV.isHidden = true
        
        self.RemovePopUpV.frame = self.view.bounds
        self.view.addSubview(self.RemovePopUpV)
        self.RemovePopUpV.isHidden = true
        self.CountLbl.text = "\(self.count)"
        
        self.TblV.register(UINib(nibName: "AddMoreTblVCell", bundle: nil), forCellReuseIdentifier: "AddMoreTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        tableViewHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewHeight()
    }
    
    
    
    func tableViewHeight(){
        DispatchQueue.main.async {
            self.TblV.reloadData()
            self.TblV.layoutIfNeeded()
            self.TblVH.constant = self.TblV.contentSize.height
            self.TblV.layoutIfNeeded()
        }
    }
    
    @IBAction func BackBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoreBtnAction(_ sender: UIButton) {
        self.AddNewItemPopupV.isHidden = false
    }

    @IBAction func SaveBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // popup btns.
    
    @IBAction func MinusBtn(_ sender: UIButton) {
        if self.count > 1 {
            self.count -= 1
        }
        
        self.CountLbl.text = "\(self.count)"
    }
    
    
    @IBAction func PlusBtn(_ sender: UIButton) {
        self.count += 1
        self.CountLbl.text = "\(self.count)"
    }
    
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.AddNewItemPopupV.isHidden = true
    }
    
    
    @IBAction func AddBtn(_ sender: UIButton) {
        self.AddNewItemPopupV.isHidden = true
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.AddNewItemPopupV.isHidden = true
    }
    //
    // RemovePopUpV btns.
    @IBAction func RemoveCancelBtn(_ sender: UIButton) {
        self.RemovePopUpV.isHidden = true
    }
    
    @IBAction func RemoveBtn(_ sender: UIButton) {
        self.RemovePopUpV.isHidden = true
    }
    //
}

extension AddMoreVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddMoreTblVCell", for: indexPath) as! AddMoreTblVCell
            
        cell.RemoveBtn.tag = indexPath.row
        cell.RemoveBtn.addTarget(self, action: #selector(RemoveBtnAction), for: .touchUpInside)
        
        
            return cell
    }
    
    @objc func RemoveBtnAction(sender: UIButton) {
        self.RemovePopUpV.isHidden = false
    }
    
    
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
