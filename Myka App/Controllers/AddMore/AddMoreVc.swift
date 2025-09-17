//
//  AddMoreVc.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import DropDown

class AddMoreVc: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    @IBOutlet weak var SaveBtnO: UIButton!
    @IBOutlet var RemovePopUpV: UIView!
    
    // popup outlets
    @IBOutlet var AddNewItemPopupV: UIView!
    @IBOutlet weak var CountLbl: UILabel!
    @IBOutlet weak var ItemNameTxtF: UITextField!
    @IBOutlet weak var SearchBgV: UIView!
    
    // MARK: - Private
    private var viewModel: AddMoreViewModel!
    private var dropDown = DropDown()
    private var count = 1
    private var currentIndex = 0
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddMoreViewModel(vc: self)
        setupUI()
        bindViewModel()
        tableViewHeight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewHeight()
    }
    
    // MARK: - Setup
    private func setupUI() {
        SaveBtnO.isUserInteractionEnabled = false
        SaveBtnO.backgroundColor = UIColor.lightGray
        
        AddNewItemPopupV.frame = view.bounds
        view.addSubview(AddNewItemPopupV)
        AddNewItemPopupV.isHidden = true
        
        RemovePopUpV.frame = view.bounds
        view.addSubview(RemovePopUpV)
        RemovePopUpV.isHidden = true
        
        CountLbl.text = "\(count)"
        
        TblV.register(UINib(nibName: "AddMoreTblVCell", bundle: nil), forCellReuseIdentifier: "AddMoreTblVCell")
        TblV.delegate = self
        TblV.dataSource = self
        
        ItemNameTxtF.delegate = self
        ItemNameTxtF.addTarget(self, action: #selector(TextSearch(sender:)), for: .editingChanged)
        
        // DropDown basic config
        dropDown.backgroundColor = .white
        dropDown.anchorView = SearchBgV
        dropDown.bottomOffset = CGPoint(x: 0, y: SearchBgV.frame.size.height)
        dropDown.direction = .bottom
        dropDown.setupCornerRadius(10)
        dropDown.width = SearchBgV.frame.width
    }
    
    private func bindViewModel() {
        viewModel.onIngredientsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.TblV.reloadData()
                self?.tableViewHeight()
                self?.SaveBtnO.isUserInteractionEnabled = !(self?.viewModel.numberOfIngredients() == 0)
                self?.SaveBtnO.backgroundColor = (self?.SaveBtnO.isUserInteractionEnabled ?? false) ? #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) : UIColor.lightGray
            }
        }
        
        viewModel.onDislikesChanged = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let items = self.viewModel.dislikesNames()
                if items.isEmpty {
                    self.dropDown.hide()
                } else {
                    self.dropDown.dataSource = items
                    self.dropDown.show()
                    self.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                        self?.ItemNameTxtF.text = item
                    }
                }
            }
        }
        
        viewModel.onShowLoading = { [weak self] show in
            DispatchQueue.main.async {
                if show {
                    self?.showIndicator(withTitle: "", and: "")
                } else {
                    self?.hideIndicator()
                }
            }
        }
        
        viewModel.onShowToast = { [weak self] message in
            DispatchQueue.main.async {
                self?.showToast(message)
            }
        }
    }
    
    // MARK: - Utilities
    func tableViewHeight() {
        DispatchQueue.main.async {
            self.TblV.reloadData()
            self.TblV.layoutIfNeeded()
            self.TblVH.constant = self.TblV.contentSize.height
            self.TblV.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc func TextSearch(sender: UITextField) {
        let text = sender.text ?? ""
        if text.isEmpty {
            viewModel.debouncedSearchIngredients(query: "")
            dropDown.hide()
        } else {
            viewModel.debouncedSearchIngredients(query: text)
        }
    }
    
    @IBAction func BackBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoreBtnAction(_ sender: UIButton) {
        AddNewItemPopupV.isHidden = false
    }
    
    @IBAction func SaveBtn(_ sender: UIButton) {
        viewModel.apiToSaveIngredients { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // popup btns.
    @IBAction func MinusBtn(_ sender: UIButton) {
        if count > 1 { count -= 1 }
        CountLbl.text = "\(count)"
    }
    
    @IBAction func PlusBtn(_ sender: UIButton) {
        count += 1
        CountLbl.text = "\(count)"
    }
    
    @IBAction func CancelBtn(_ sender: UIButton) {
        AddNewItemPopupV.isHidden = true
    }
    
    @IBAction func AddBtn(_ sender: UIButton) {
        guard let name = ItemNameTxtF.text, !name.isEmpty else {
            AlertControllerOnr(title: "", message: "Please enter item name.")
            return
        }
        viewModel.addCustomIngredient(name: name, schID: count)
        AddNewItemPopupV.isHidden = true
        count = 1
        ItemNameTxtF.text = ""
        SaveBtnO.isUserInteractionEnabled = true
        SaveBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        AddNewItemPopupV.isHidden = true
    }
    
    // Remove popup btns
    @IBAction func RemoveCancelBtn(_ sender: UIButton) {
        RemovePopUpV.isHidden = true
       
    }
    
    @IBAction func RemoveBtn(_ sender: UIButton) {
      
        RemovePopUpV.isHidden = true
        viewModel.removeIngredient(at: currentIndex)
    }
}

// MARK: - Table
extension AddMoreVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel.numberOfIngredients()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMoreTblVCell", for: indexPath) as! AddMoreTblVCell
        let product = viewModel.ingredientAt(indexPath.row)
        cell.CountLbl.text = "\(product.sch_id ?? 0)"
        cell.selectionStyle = .none
        let img = product.pro_img ?? ""
        let priceValue = product.pro_price ?? ""
     
        if (img == "Not available" || img.isEmpty) && (priceValue == "Not available" || priceValue.isEmpty) {
            let text = "\(product.pro_name ?? "")\nNot Available"
            let attributedString = NSMutableAttributedString(string: text)
            if let nameRange = text.range(of: product.pro_name ?? "") {
                let nsRange = NSRange(nameRange, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
            }
            if let notAvailableRange = text.range(of: "Not Available") {
                let nsRange = NSRange(notAvailableRange, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: nsRange)
            }
            cell.NameLbl.attributedText = attributedString
        } else {
            cell.NameLbl.text = product.pro_name ?? ""
        }
        
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(IngServCountMinusBtn(_:)), for: .touchUpInside)
        cell.PlusBtn.tag = indexPath.row
        cell.PlusBtn.addTarget(self, action: #selector(IngServCountPlusBtn(_:)), for: .touchUpInside)
        cell.RemoveBtn.tag = indexPath.row
        cell.RemoveBtn.addTarget(self, action: #selector(RemoveBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func IngServCountMinusBtn(_ sender: UIButton) {
        viewModel.decreaseServCount(at: sender.tag)
    }
    
    @objc func IngServCountPlusBtn(_ sender: UIButton) {
        viewModel.increaseServCount(at: sender.tag)
    }

    @objc func RemoveBtnAction(_ sender: UIButton) {
        currentIndex = sender.tag
        RemovePopUpV.isHidden = false
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 80 }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
}
 
// MARK: - UITextFieldDelegate
extension AddMoreVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
