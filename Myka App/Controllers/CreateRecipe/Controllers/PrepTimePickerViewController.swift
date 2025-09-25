//
//  PrepTimePickerViewController.swift
//  My Kai
//
//  Created by YATIN  KALRA on 18/09/25.
//


import UIKit

final class PrepTimePickerViewController: UIViewController {

    // MARK: - Public
    /// Called when user taps Save. Returns (hours, minutes).
    var onSave: ((Int, Int) -> Void)?

    // MARK: - Private UI
    private let containerView = UIView()
    private let dragIndicator = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let picker = UIPickerView()
    private let saveButton = UIButton(type: .system)
    // Data
    private let hours = Array(0...23)
    private let minutes = stride(from: 0, through: 55, by: 5).map { $0 } // 0,5,10,...,55

    // Default selection
    private var selectedHour = 0
    private var selectedMinute = 15
    var totalMinutes: Int = 0
    var comeForm = ""
    // Layout constants
    private let containerHeight: CGFloat = 420

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        animatePresentation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set initial selection
        if let hourIndex = hours.firstIndex(of: selectedHour) { picker.selectRow(hourIndex, inComponent: 0, animated: false) }
        if let minuteIndex = minutes.firstIndex(of: selectedMinute) { picker.selectRow(minuteIndex, inComponent: 1, animated: false) }
        setInitial(totalMinutes: totalMinutes)
    }
    
    
    func setInitial(totalMinutes: Int) {
        selectedHour = totalMinutes / 60
        selectedMinute = totalMinutes % 60

        // snap to nearest available minute step (if using 5-min steps)
        if let minuteIndex = minutes.firstIndex(of: selectedMinute) {
            picker.selectRow(selectedHour, inComponent: 0, animated: false)
            picker.selectRow(minuteIndex, inComponent: 2, animated: false)
        } else {
            // fallback: pick closest valid step
            if let closest = minutes.min(by: { abs($0 - selectedMinute) < abs($1 - selectedMinute) }),
               let idx = minutes.firstIndex(of: closest) {
                selectedMinute = closest
                picker.selectRow(selectedHour, inComponent: 0, animated: false)
                picker.selectRow(idx, inComponent: 2, animated: false)
            }
        }
    }
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.alpha = 0 // will fade in

        // Container
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        view.addSubview(containerView)

        // Drag indicator
        dragIndicator.backgroundColor = UIColor(white: 0.85, alpha: 1)
        dragIndicator.layer.cornerRadius = 2.5
        containerView.addSubview(dragIndicator)

        // Title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
       
      
        titleLabel.textColor = .black
        containerView.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.text = "How long does it take to prepare this recipe?"
        subtitleLabel.textColor = UIColor(white: 0.45, alpha: 1)
        subtitleLabel.numberOfLines = 0
        containerView.addSubview(subtitleLabel)
        if comeForm == "cook" {
            titleLabel.text = "Cook time"
            subtitleLabel.text = "How long does it take to cook this recipe?"
        }else{
            titleLabel.text = "Prep time"
            subtitleLabel.text = "How long does it take to prepare this recipe?"
        }
        // Picker
        picker.dataSource = self
        picker.delegate = self
        containerView.addSubview(picker)
        setupPickerSelectionOverlay()
        // Save button
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1) // green
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 28
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        containerView.addSubview(saveButton)

        // Tap to dismiss when tapping outside container
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Container anchored to bottom
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Drag indicator
            dragIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            dragIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragIndicator.widthAnchor.constraint(equalToConstant: 60),
            dragIndicator.heightAnchor.constraint(equalToConstant: 5),

            // Title
            titleLabel.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            // Picker center area
            picker.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            picker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            picker.heightAnchor.constraint(equalToConstant: 180),

            // Save button
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            saveButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 12),
            saveButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
  
    private func setupPickerSelectionOverlay() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.picker.subviews[1].backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 0.09602649007)
        }
    }

    // MARK: - Actions
    @objc private func saveTapped() {
        onSave?(selectedHour, selectedMinute)
        dismissAnimated()
    }

    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismissAnimated()
        }
    }

    // MARK: - Presentation / Dismissal animations
    private func animatePresentation() {
        view.layoutIfNeeded()
        view.alpha = 0
        containerView.transform = CGAffineTransform(translationX: 0, y: containerHeight)
        UIView.animate(withDuration: 0.32, delay: 0, options: [.curveEaseOut]) {
            self.view.alpha = 1
            self.containerView.transform = .identity
        }
    }

    private func dismissAnimated() {
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerHeight)
            self.view.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }

    // MARK: - Public helper to preselect time before presenting (optional)
    func setInitial(hours: Int, minutes: Int) {
        selectedHour = hours
        // normalize minute to nearest step if needed
        let step = 5
        let normalized = (minutes / step) * step
        selectedMinute = minutes >= 0 ? normalized : 0
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension PrepTimePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count
        case 1: return 1
        case 2: return minutes.count
        case 3: return 1
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let total = view.bounds.width
        switch component {
        case 0: return total * 0.25
        case 1: return total * 0.20
        case 2: return total * 0.25
        case 3: return total * 0.20  
        default: return total / 4
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        switch component {
        case 0:
            label.text = "\(hours[row])"
        case 1:
            label.text = "hours"
        case 2:
            label.text = "\(minutes[row])"
        case 3:
            label.text = "min"
        default:
            label.text = ""
        }
        let selectedRow = pickerView.selectedRow(inComponent: component)
        if row == selectedRow && (component == 0 || component == 2) {
            label.textColor = UIColor.systemGreen
        } else {
            label.textColor = UIColor.lightGray
        }

        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHour = hours[row]
        } else if component == 2 {
            selectedMinute = minutes[row]
        }
        pickerView.reloadAllComponents()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PrepTimePickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // allow taps through containerView
        return touch.view == self.view
    }
}
