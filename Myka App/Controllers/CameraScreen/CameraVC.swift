//
//  CameraVC.swift
//  Myka App
//
//  Created by Sumit on 14/12/24.
//

import UIKit
import UIKit
import AVFoundation

class CameraVC: UIViewController {

    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var SaveBtn: UIButton!
    
    private let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var isFlashOn = false
    
    var captureImg: UIImage?
    
    var backAction:(_ img: UIImage) -> () = { img in }
    
    var headerTitle = ""

        override func viewDidLoad() {
            super.viewDidLoad()
            if headerTitle == "SearchTab" {
                TitleLbl.text = "Recipe"
            }
            
            SaveBtn.isHidden = true
            setupCamera()
            styleCaptureButton()
        }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let previewLayer = previewLayer {
            previewLayer.frame = previewView.bounds
        }
    }
    
    private func setupCamera() {
        // 1. Check if the camera is available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Not Available", message: "This device does not have a camera.")
            return
        }

        // 2. Setup session
        session.sessionPreset = .photo
        
        // 3. Setup input (camera)
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            showAlert(title: "Error", message: "Unable to access the camera.")
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // 4. Setup output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        // 5. Setup preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewView.layer.insertSublayer(previewLayer, at: 0)
        
        // 6. Start session
        session.startRunning()
    }

        
        private func styleCaptureButton() {
            captureButton.layer.cornerRadius = captureButton.frame.size.width / 2
            captureButton.layer.borderWidth = 5
            captureButton.layer.borderColor = UIColor.white.cgColor
            captureButton.clipsToBounds = true
        }
        
        // MARK: - Button Actions
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SaveBtn(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backAction(self.captureImg ?? UIImage())
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
        @IBAction func captureButtonTapped(_ sender: UIButton) {
            if !session.isRunning {
                   showAlert(title: "Camera Unavailable", message: "The camera is not ready. Please try again.")
                   return
               }
            let settings = AVCapturePhotoSettings()
            settings.flashMode = isFlashOn ? .on : .off
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
        
        @IBAction func galleryButtonTapped(_ sender: UIButton) {
            // Open photo library
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
        @IBAction func flashButtonTapped(_ sender: UIButton) {
            // Toggle flash
            isFlashOn.toggle()
            
            let flashIcon = isFlashOn ? "Flash" : "FlashOff"
            flashButton.setImage(UIImage(named: flashIcon), for: .normal)
            toggleFlash(on: isFlashOn)
        }
    }

    // MARK: - AVCapturePhotoCaptureDelegate
extension CameraVC: AVCapturePhotoCaptureDelegate {
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            if let error = error {
                print("Error capturing photo: \(error.localizedDescription)")
                return
            }
            
            // Convert photo to UIImage
            if let data = photo.fileDataRepresentation(),
               let image = UIImage(data: data) {
                // Save photo or pass to next screen
               // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("Photo captured and saved to library")
                display(image: image)
            }
        }
    }

    // MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                // Handle the selected image
                print("Selected image: \(image)")
                display(image: image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
    private func display(image: UIImage) {
        // Remove any existing image views to avoid stacking
        previewView.subviews.forEach { $0.removeFromSuperview() }
        
        // Create a new UIImageView
        let imageView = UIImageView(frame: previewView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        captureImg = image
        // Add the image view to previewView
        previewView.addSubview(imageView)
        
        captureButton.isHidden = true
        galleryButton.isHidden = true
        flashButton.isHidden = true
        SaveBtn.isHidden = false
         
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    }

func toggleFlash(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else {
        print("No video device available")
        return
    }

    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            
            if on {
                device.torchMode = .on
                // Optionally, adjust the brightness level
                // device.setTorchModeOn(level: 0.5) // Level between 0.0 and 1.0
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    } else {
        print("Torch is not available on this device")
    }
}
