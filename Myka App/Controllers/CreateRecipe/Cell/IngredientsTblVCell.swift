//
//  IngredientsTblVCell.swift
//  My Kai
//  Created by YATIN  KALRA on 11/09/25.

import UIKit
import SkeletonView

enum IngredientCellType{
    case withHeader
    case normal
}

enum IngredientInlineEditKind {
    case ingredient
    case cookware
}

class IngredientsTblVCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var upperlblV:UIView!
    @IBOutlet weak var amout_MeasurmentLbl:UILabel!
    @IBOutlet weak var ingredientlbl:UILabel!
    @IBOutlet weak var checkBoxView:UIView!
    @IBOutlet weak var checkBoxBtn:UIButton!
    @IBOutlet weak var paddingView:UIView!
    
    @IBOutlet weak var editingView:UIView!
    @IBOutlet weak var normalView:UIView!
    @IBOutlet weak var addIngredientTF: UITextField!
    @IBOutlet weak var addIngredientMesurementTF: UITextField!
    @IBOutlet weak var addIngredientAmoutTF: UITextField!
    @IBOutlet weak var ingredientFinalLbl: UILabel!
    @IBOutlet weak var editImageView: UIImageView!

    var onNameChanged: ((String) -> Void)?
    var onQuantityChanged: ((String) -> Void)?
    var onUnitRequested: (() -> Void)?
    var onSaveEdit: ((_ name: String, _ amount: String, _ unit: String, _ imageReference: String) -> Void)?
    var onCancelEdit: (() -> Void)?
    var onImageRequested: ((UIView) -> Void)?
    var onHeaderEditingStarted: (() -> Void)?

    private(set) var editedImageReference = ""
    private var editKind: IngredientInlineEditKind = .ingredient
    private let inlineHeaderContainer = UIView()
    private let inlineHeaderButton = UIButton(type: .system)
    private let inlineHeaderTextField = UITextField()
    private var editingViewHeightConstraint: NSLayoutConstraint?
    private var editImageTopConstraint: NSLayoutConstraint?
    private var editImageBottomConstraint: NSLayoutConstraint?

    var editedHeader: String {
        inlineHeaderTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var skeletonViews: [UIView] {
        [img, ingredientlbl, amout_MeasurmentLbl, checkBoxView]
    }

    private func updateImageAppearance() {
        img.clipsToBounds = true
        img.layer.cornerRadius = img.bounds.height / 2
    }

    private func updateEditImageAppearance() {
        editImageView.clipsToBounds = true
        editImageView.contentMode = .scaleAspectFill
        editImageView.layer.cornerRadius = min(editImageView.bounds.width, editImageView.bounds.height) / 2
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
    
    func configure(with model: IngredientDataModel, type: IngredientCellType) {
        self.type = type
        self.ingredientlbl?.text = model.name
        if let quantity = model.quantity, let unit = model.unit {
            self.amout_MeasurmentLbl?.text = "\(quantity) \(unit)".trimmingCharacters(in: .whitespaces)
        } else {
            self.amout_MeasurmentLbl?.text = ""
        }
        setImage(model.img ?? "", on: img, placeholder: UIImage(named: "No_Image"))
     //   self.checkBoxView.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateImageAppearance()
        configureEditingControls()
        updateEditImageAppearance()
        img.isSkeletonable = true
        img.skeletonCornerRadius = Float(img.bounds.height / 2)
        ingredientlbl.isSkeletonable = true
        ingredientlbl.linesCornerRadius = 4
        amout_MeasurmentLbl.isSkeletonable = true
        amout_MeasurmentLbl.linesCornerRadius = 4
        checkBoxView.isSkeletonable = true
        checkBoxView.skeletonCornerRadius = 12
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateImageAppearance()
        updateEditImageAppearance()
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        showNormalMode()
        onNameChanged = nil
        onQuantityChanged = nil
        onUnitRequested = nil
        onSaveEdit = nil
        onCancelEdit = nil
        onImageRequested = nil
        onHeaderEditingStarted = nil
        editedImageReference = ""
    }

    func configureEditMode(
        with model: IngredientDataModel,
        kind: IngredientInlineEditKind,
        header: String = ""
    ) {
        editKind = kind
        normalView.isHidden = true
        editingView.isHidden = false

        addIngredientTF.text = model.name
        addIngredientAmoutTF.text = model.quantity
        addIngredientMesurementTF.text = model.unit
        editedImageReference = model.img ?? ""
        ingredientFinalLbl.isHidden = true

        let isIngredient: Bool
        switch kind {
        case .ingredient:
            isIngredient = true
        case .cookware:
            isIngredient = false
        }

        editingViewHeightConstraint?.constant = isIngredient ? 130 : 90
        editImageTopConstraint?.constant = isIngredient ? 50 : 10
        editImageBottomConstraint?.constant = 10
        configureHeaderValue(header, isVisible: isIngredient)
        addIngredientAmoutTF.isHidden = !isIngredient
        addIngredientMesurementTF.isHidden = !isIngredient
        setImage(
            editedImageReference,
            on: editImageView,
            placeholder: UIImage(named: isIngredient ? "NewRec" : "addCook")
        )
        updateEditImageAppearance()
    }

    func showNormalMode() {
        normalView.isHidden = false
        editingView.isHidden = true
    }

    func focusEditField() {
        addIngredientTF.becomeFirstResponder()
    }

    func applySuggestion(
        name: String,
        unit: String?,
        imageReference: String,
        saveAfterSelection: Bool = false
    ) {
        let previousName = addIngredientTF.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ?? ""
        let selectedName = name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        let isIngredient: Bool
        switch editKind {
        case .ingredient:
            isIngredient = true
        case .cookware:
            isIngredient = false
        }
        let ingredientChanged = isIngredient && previousName != selectedName

        addIngredientTF.text = name

        if ingredientChanged {
            addIngredientAmoutTF.text = ""
            addIngredientMesurementTF.text = ""
        } else if let unit = unit, !unit.isEmpty {
            addIngredientMesurementTF.text = unit
        }

        if ingredientChanged {
            editedImageReference = imageReference
        } else if !imageReference.isEmpty {
            editedImageReference = imageReference
        }
        let placeholderName: String
        switch editKind {
        case .ingredient:
            placeholderName = "NewRec"
        case .cookware:
            placeholderName = "addCook"
        }
        setImage(editedImageReference, on: editImageView, placeholder: UIImage(named: placeholderName))

        if saveAfterSelection {
            saveEditTapped()
        }
    }

    func applyPickedImage(_ image: UIImage, imageReference: String) {
        editImageView.image = image
        updateEditImageAppearance()
        editedImageReference = imageReference
    }

    func applyUnit(_ unit: String, saveAfterSelection: Bool = false) {
        addIngredientMesurementTF.text = unit
        if saveAfterSelection {
            saveEditTapped()
        }
    }

    func applyDisplayImage(reference: String, placeholder: UIImage?) {
        setImage(reference, on: img, placeholder: placeholder)
    }

    private func setImage(_ reference: String, on imageView: UIImageView, placeholder: UIImage?) {
        if reference.hasPrefix("http://") || reference.hasPrefix("https://") {
            imageView.setRemoteImage(URL(string: reference), placeholder: placeholder)
        } else if let data = Data(base64Encoded: reference, options: .ignoreUnknownCharacters),
                  let image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.image = placeholder
        }
    }

    private func configureEditingControls() {
        showNormalMode()

        addIngredientTF.delegate = self
        addIngredientAmoutTF.delegate = self
        addIngredientMesurementTF.delegate = self
        addIngredientTF.tintColor = UIColor(
            red: 254 / 255,
            green: 159 / 255,
            blue: 69 / 255,
            alpha: 1
        )
        addIngredientAmoutTF.keyboardType = .decimalPad
        addIngredientTF.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        addIngredientAmoutTF.addTarget(self, action: #selector(quantityDidChange), for: .editingChanged)

        addIngredientTF.inputAccessoryView = makeActionToolbar()
        addIngredientAmoutTF.inputAccessoryView = makeFractionToolbar()
        configureInlineHeaderControls()

        editImageView.isUserInteractionEnabled = true
        editImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editImageTapped)))
    }

    private func configureInlineHeaderControls() {
        editingViewHeightConstraint = editingView.constraints.first {
            $0.firstAttribute == .height && $0.secondItem == nil
        }
        editImageTopConstraint = editingView.constraints.first {
            ($0.firstItem as? UIView) === editImageView
                && $0.firstAttribute == .top
                && ($0.secondItem as? UIView) === editingView
                && $0.secondAttribute == .top
        }
        editImageBottomConstraint = editingView.constraints.first {
            ($0.firstItem as? UIView) === editingView
                && $0.firstAttribute == .bottom
                && ($0.secondItem as? UIView) === editImageView
                && $0.secondAttribute == .bottom
        }

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
            inlineHeaderContainer.topAnchor.constraint(equalTo: editingView.topAnchor, constant: 5),
            inlineHeaderContainer.heightAnchor.constraint(equalToConstant: 35),

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

    private func configureHeaderValue(_ header: String, isVisible: Bool) {
        let trimmedHeader = header.trimmingCharacters(in: .whitespacesAndNewlines)
        inlineHeaderContainer.isHidden = !isVisible
        inlineHeaderTextField.text = trimmedHeader
        inlineHeaderTextField.isHidden = true
        inlineHeaderButton.isHidden = false
        inlineHeaderButton.setTitle(trimmedHeader.isEmpty ? "+ Header" : trimmedHeader, for: .normal)
    }

    @objc private func showHeaderEditor() {
        onHeaderEditingStarted?()
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

    private func makeFractionToolbar() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        container.backgroundColor = .systemBackground

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 6

        ["1/2", "1/3", "1/4", "1/8", "2/3"].forEach { fraction in
            let button = UIButton(type: .system)
            button.setTitle(fraction, for: .normal)
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = 12
            button.addAction(UIAction { [weak self] _ in
                self?.addIngredientAmoutTF.text = fraction
                self?.quantityDidChange()
            }, for: .touchUpInside)
            stack.addArrangedSubview(button)
        }

        let cancel = UIButton(type: .system)
        cancel.setTitle("Cancel", for: .normal)
        cancel.addTarget(self, action: #selector(cancelEditTapped), for: .touchUpInside)
        stack.addArrangedSubview(cancel)

        let save = UIButton(type: .system)
        save.setTitle("Save", for: .normal)
        save.setTitleColor(.white, for: .normal)
        save.backgroundColor = .systemBlue
        save.layer.cornerRadius = 12
        save.addTarget(self, action: #selector(saveEditTapped), for: .touchUpInside)
        stack.addArrangedSubview(save)

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6)
        ])
        return container
    }

    @objc private func nameDidChange() {
        onNameChanged?(addIngredientTF.text ?? "")
    }

    @objc private func quantityDidChange() {
        onQuantityChanged?(addIngredientAmoutTF.text ?? "")
    }

    @objc private func editImageTapped() {
        onImageRequested?(editImageView)
    }

    @objc private func saveEditTapped() {
        onSaveEdit?(
            addIngredientTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            addIngredientAmoutTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            addIngredientMesurementTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            editedImageReference
        )
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
            updateImageAppearance()
            img.image = nil
            ingredientlbl.text = " "
            amout_MeasurmentLbl.text = " "
            checkBoxBtn.setImage(nil, for: .normal)
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

        
    }
    
}

extension IngredientsTblVCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addIngredientMesurementTF {
            onUnitRequested?()
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveEditTapped()
        return false
    }
}
