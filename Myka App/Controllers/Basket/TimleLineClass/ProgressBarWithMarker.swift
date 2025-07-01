//
//  ProgressBarWithMarker.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//


import UIKit

class ProgressView: UIView {

    private let backgroundBar = UIView() // Full background bar
    private let progressBar = UIView()   // Completed progress bar
    private let markerView = UIImageView() // Movable marker
    private var tickViews: [UIView] = [] // Array to store tick views
    private var labelViews: [UILabel] = [] // Array to store labels

    private let totalTicks = 6 // Total number of ticks (0 to 6)
    private var markerCenterXConstraint: NSLayoutConstraint? // Marker position constraint
    private var progressBarWidthConstraint: NSLayoutConstraint? // Progress bar width constraint

    private var progress: CGFloat = 0.5 { // Starting progress at 50%
        didSet { updateProgress() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        setupBars()
        setupMarker()
        addPanGesture()
    }

    private func setupBars() {
        // Background Bar
        backgroundBar.backgroundColor = .lightGray
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBar)

        // Progress Bar
        progressBar.backgroundColor = .orange
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)

        // Constraints for background and progress bar
        NSLayoutConstraint.activate([
            backgroundBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundBar.heightAnchor.constraint(equalToConstant: 6),

            progressBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: backgroundBar.centerYAnchor),
            progressBar.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor)
        ])

        // Store the progress bar width constraint for later use
        progressBarWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: bounds.width * progress)
        progressBarWidthConstraint?.isActive = true
    }

    private func setupTicks() {
        // Clear previous ticks and labels
        tickViews.forEach { $0.removeFromSuperview() }
        labelViews.forEach { $0.removeFromSuperview() }
        tickViews.removeAll()
        labelViews.removeAll()

        // Create evenly spaced ticks and labels
        for i in 0...totalTicks {
            let tick = UIView()
            tick.backgroundColor = .orange
            tick.translatesAutoresizingMaskIntoConstraints = false
            addSubview(tick)
            tickViews.append(tick)

            let label = UILabel()
            label.text = "\(i)"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .darkGray
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            labelViews.append(label)

            let positionRatio = CGFloat(i) / CGFloat(totalTicks) // Calculate position ratio

            // Create constraints that are relative to the backgroundBar
            NSLayoutConstraint.activate([
                // Tick position
                tick.centerXAnchor.constraint(equalTo: backgroundBar.leadingAnchor, constant: positionRatio * bounds.width),
                tick.centerYAnchor.constraint(equalTo: backgroundBar.centerYAnchor),
                tick.widthAnchor.constraint(equalToConstant: 3),
                tick.heightAnchor.constraint(equalToConstant: 25),

                // Label position
                label.centerXAnchor.constraint(equalTo: tick.centerXAnchor),
                label.topAnchor.constraint(equalTo: tick.bottomAnchor, constant: 5)
            ])
        }
    }

    private func setupMarker() {
        // Marker image
        markerView.image = UIImage(named: "MapIcon")
        markerView.tintColor = .orange
        markerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(markerView)

        // Store the marker position constraint
        markerCenterXConstraint = markerView.centerXAnchor.constraint(equalTo: backgroundBar.leadingAnchor, constant: progress * bounds.width)
        markerCenterXConstraint?.isActive = true

        NSLayoutConstraint.activate([
            markerView.bottomAnchor.constraint(equalTo: backgroundBar.topAnchor, constant: -10),
            markerView.widthAnchor.constraint(equalToConstant: 23),
            markerView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        markerView.isUserInteractionEnabled = true
        markerView.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let maxWidth = backgroundBar.bounds.width

        let newProgress = (markerView.center.x + translation.x - backgroundBar.frame.origin.x) / maxWidth
        progress = max(0, min(1, newProgress))

        gesture.setTranslation(.zero, in: self)
    }

    private func updateProgress() {
        // Update progress bar width and marker position
        progressBarWidthConstraint?.constant = bounds.width * progress
        markerCenterXConstraint?.constant = bounds.width * progress
        layoutIfNeeded()

        // Update the tick colors based on progress
        for (index, tick) in tickViews.enumerated() {
            if CGFloat(index) / CGFloat(totalTicks) <= progress {
                tick.backgroundColor = .orange
            } else {
                tick.backgroundColor = .lightGray
            }
        }
    }

    // Ensure setupTicks is only called once (after layout)
    override func layoutSubviews() {
        super.layoutSubviews()
        if tickViews.isEmpty {
            setupTicks() // Call once to set up the ticks
        }
        updateProgress()
    }
}


