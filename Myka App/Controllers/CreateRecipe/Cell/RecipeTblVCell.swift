//
//  RecipeTblVCell.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//



import UIKit
import SkeletonView

class RecipeTblVCell: UITableViewCell {

    @IBOutlet weak var stepLbl: UILabel!
    @IBOutlet weak var recipeLbl: UILabel!
    @IBOutlet weak var paddingView:UIView!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var editingView: UIView!
    @IBOutlet weak var editInstructionTextView: UITextView!

    var onSaveEdit: ((_ instruction: String) -> Void)?
    var onCancelEdit: (() -> Void)?

    private var skeletonViews: [UIView] {
        [stepLbl, recipeLbl]
    }
    private let inlineHeaderContainer = UIView()
    private let inlineHeaderButton = UIButton(type: .system)
    private let inlineHeaderTextField = UITextField()

    var editedHeader: String {
        inlineHeaderTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    
    var type: IngredientCellType = .normal {
        didSet {
          if  type == .withHeader{
              paddingView.isHidden = false
          }else{
              paddingView.isHidden = true
          }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureEditingControls()
        stepLbl.isSkeletonable = true
        stepLbl.linesCornerRadius = 4
        recipeLbl.isSkeletonable = true
        recipeLbl.linesCornerRadius = 4
        recipeLbl.skeletonTextNumberOfLines = 3
        recipeLbl.lastLineFillPercent = 70
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        showNormalMode()
        onSaveEdit = nil
        onCancelEdit = nil
    }

    func configureEditMode(instruction: String, header: String = "") {
        normalView.isHidden = true
        editingView.isHidden = false
        editInstructionTextView.text = instruction
        configureHeaderValue(header)
    }

    func showNormalMode() {
        normalView.isHidden = false
        editingView.isHidden = true
    }

    func focusEditField() {
        editInstructionTextView.becomeFirstResponder()
    }

    private func configureEditingControls() {
        showNormalMode()
        recipeLbl.numberOfLines = 0
        recipeLbl.lineBreakMode = .byWordWrapping
        editInstructionTextView.tintColor = UIColor(
            red: 254 / 255,
            green: 159 / 255,
            blue: 69 / 255,
            alpha: 1
        )
        editInstructionTextView.inputAccessoryView = makeActionToolbar()
        editInstructionTextView.layer.cornerRadius = 8
        editInstructionTextView.layer.borderWidth = 1
        editInstructionTextView.layer.borderColor = UIColor(
            red: 254 / 255,
            green: 159 / 255,
            blue: 69 / 255,
            alpha: 1
        ).cgColor
        configureInlineHeaderControls()
    }

    private func configureInlineHeaderControls() {
        inlineHeaderContainer.translatesAutoresizingMaskIntoConstraints = false
        inlineHeaderButton.translatesAutoresizingMaskIntoConstraints = false
        inlineHeaderTextField.translatesAutoresizingMaskIntoConstraints = false
        editingView.addSubview(inlineHeaderContainer)
        inlineHeaderContainer.addSubview(inlineHeaderButton)
        inlineHeaderContainer.addSubview(inlineHeaderTextField)

        inlineHeaderButton.contentHorizontalAlignment = .left
        inlineHeaderButton.setTitleColor(
            UIColor(red: 254 / 255, green: 159 / 255, blue: 69 / 255, alpha: 1),
            for: .normal
        )
        inlineHeaderButton.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        inlineHeaderButton.addTarget(self, action: #selector(showHeaderEditor), for: .touchUpInside)

        inlineHeaderTextField.isHidden = true
        inlineHeaderTextField.borderStyle = .roundedRect
        inlineHeaderTextField.placeholder = "Header (optional)"
        inlineHeaderTextField.font = UIFont(name: "Poppins-Regular", size: 14)
        inlineHeaderTextField.tintColor = UIColor(
            red: 254 / 255,
            green: 159 / 255,
            blue: 69 / 255,
            alpha: 1
        )
        inlineHeaderTextField.returnKeyType = .done
        inlineHeaderTextField.delegate = self
        inlineHeaderTextField.inputAccessoryView = makeActionToolbar()

        NSLayoutConstraint.activate([
            inlineHeaderContainer.leadingAnchor.constraint(equalTo: editingView.leadingAnchor, constant: 10),
            inlineHeaderContainer.trailingAnchor.constraint(equalTo: editingView.trailingAnchor, constant: -10),
            inlineHeaderContainer.topAnchor.constraint(equalTo: editingView.topAnchor, constant: 8),
            inlineHeaderContainer.heightAnchor.constraint(equalToConstant: 36),

            inlineHeaderButton.leadingAnchor.constraint(equalTo: inlineHeaderContainer.leadingAnchor),
            inlineHeaderButton.trailingAnchor.constraint(equalTo: inlineHeaderContainer.trailingAnchor),
            inlineHeaderButton.topAnchor.constraint(equalTo: inlineHeaderContainer.topAnchor),
            inlineHeaderButton.bottomAnchor.constraint(equalTo: inlineHeaderContainer.bottomAnchor),

            inlineHeaderTextField.leadingAnchor.constraint(equalTo: inlineHeaderContainer.leadingAnchor),
            inlineHeaderTextField.trailingAnchor.constraint(equalTo: inlineHeaderContainer.trailingAnchor),
            inlineHeaderTextField.topAnchor.constraint(equalTo: inlineHeaderContainer.topAnchor),
            inlineHeaderTextField.bottomAnchor.constraint(equalTo: inlineHeaderContainer.bottomAnchor)
        ])
    }

    private func configureHeaderValue(_ header: String) {
        let trimmedHeader = header.trimmingCharacters(in: .whitespacesAndNewlines)
        inlineHeaderTextField.text = trimmedHeader
        inlineHeaderTextField.isHidden = true
        inlineHeaderButton.isHidden = false
        inlineHeaderButton.setTitle(trimmedHeader.isEmpty ? "+ Header" : trimmedHeader, for: .normal)
    }

    @objc private func showHeaderEditor() {
        inlineHeaderButton.isHidden = true
        inlineHeaderTextField.isHidden = false
        inlineHeaderTextField.becomeFirstResponder()
    }

    private func makeActionToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEditTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEditTapped))
        ]
        return toolbar
    }

    @objc private func saveEditTapped() {
        let instruction = editInstructionTextView.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        onSaveEdit?(instruction)
    }

    @objc private func cancelEditTapped() {
        onCancelEdit?()
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading

        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            stepLbl.text = " "
            recipeLbl.text = " "
            skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            skeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecipeTblVCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveEditTapped()
        return false
    }
}
