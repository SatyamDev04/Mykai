//
//  EnterNameVC.swift
//  Myka App
//
//  Created by YES IT Labs on 26/11/24.
//

import UIKit

class EnterNameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var NameTxtF: UITextField!
    @IBOutlet weak var SelectGenderTxtF: UITextField!
    @IBOutlet weak var GenderDropBtnO: UIButton!
    @IBOutlet weak var DropImg: UIImageView!
    @IBOutlet weak var MaleBgV: UIView!
    @IBOutlet weak var FemaleBgV: UIView!
    @IBOutlet weak var MaleBtnO: UIButton!
    @IBOutlet weak var FemaleBtnO: UIButton!
    @IBOutlet weak var NextBtnO: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreDraft()
    }
    // MARK: - Setup
    private func setupUI() {
        MaleBgV.isHidden = true
        FemaleBgV.isHidden = true
        DropImg.image = UIImage(named: "DropDown")

        NameTxtF.delegate = self

        NextBtnO.backgroundColor = .lightGray
        NextBtnO.isUserInteractionEnabled = false
    }

    // MARK: - Restore Saved Data
    private func restoreDraft() {
        let draft = StateMangerModelClass.shared.onboardingSelectedData

        NameTxtF.text = draft.Username
        SelectGenderTxtF.text = draft.UserGender.isEmpty ? "Gender" : draft.UserGender

        updateNextButtonState()
    }

    // MARK: - Button State
    private func updateNextButtonState() {
        let isValid =
            !(NameTxtF.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) &&
            !(SelectGenderTxtF.text?.isEmpty ?? true) &&
            SelectGenderTxtF.text != "Gender"

        NextBtnO.backgroundColor = isValid
            ? #colorLiteral(red: 0.0235, green: 0.7568, blue: 0.4117, alpha: 1)
            : .lightGray

        NextBtnO.isUserInteractionEnabled = isValid
    }

    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard textField == NameTxtF else { return true }

        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        textField.text = newText

        
        StateMangerModelClass.shared.onboardingSelectedData.Username = newText

        updateNextButtonState()
        return false
    }

    // MARK: - Gender Dropdown
    @IBAction func GenderBtn(_ sender: UIButton) {
        GenderDropBtnO.isSelected.toggle()

        let show = GenderDropBtnO.isSelected
        MaleBgV.isHidden = !show
        FemaleBgV.isHidden = !show
        DropImg.image = UIImage(named: show ? "DropUp" : "DropDown")
    }

    @IBAction func MaleBtn(_ sender: UIButton) {
        selectGender("Male")
    }

    @IBAction func FemaleBtn(_ sender: UIButton) {
        selectGender("Female")
    }

    private func selectGender(_ gender: String) {
        GenderDropBtnO.isSelected = false
        MaleBgV.isHidden = true
        FemaleBgV.isHidden = true
        DropImg.image = UIImage(named: "DropDown")

        SelectGenderTxtF.text = gender

        StateMangerModelClass.shared.onboardingSelectedData.UserGender = gender

        updateNextButtonState()
    }

    // MARK: - Next
    @IBAction func NextBtn(_ sender: UIButton) {
        let nextVc = storyboard?.instantiateViewController(identifier: "CookingForVC") as! CookingForVC
        navigationController?.pushViewController(nextVc, animated: true)
    }
}
