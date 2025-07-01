//
//  ImagePicker.swift
//  Caviar
//
//  Created by YATIN  KALRA on 16/07/20.
//  Copyright © 2020 Ankur. All rights reserved.
//

import UIKit
 
public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
        public func present(from sourceView: UIView) {

            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

//            if let action = self.action(for: .camera, title: "Take a photo") {
//                alertController.addAction(action)
//            }
            if let action = self.action(for: .photoLibrary, title: "Choose from gallery ") {
                alertController.addAction(action)
            }
            if let action = self.action(for: .camera, title: "Take a photo") {
                alertController.addAction(action)
            }

            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            }

            self.presentationController?.present(alertController, animated: true)
            
        }
    
    public func presentCamera(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .photoLibrary, title: "Take a photo") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
        
    }
    
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}
 
extension ImagePicker: UINavigationControllerDelegate {
    
}
//

public protocol ImagePickerDelegate1: AnyObject {

    func didSelect1(image: UIImage?,tag:Int,info:[UIImagePickerController.InfoKey: Any])
}

open class ImagePicker1: NSObject, UINavigationControllerDelegate {

    private let pickerController1: UIImagePickerController
    private weak var presentationController1: UIViewController?
    private weak var delegate1: ImagePickerDelegate1?
    private  var tag : Int = 0
    
    public init(presentationController1: UIViewController, delegate1: ImagePickerDelegate1,tag:Int = 0) {
        self.pickerController1 = UIImagePickerController()
        self.tag = tag
        super.init()

        self.presentationController1 = presentationController1
        self.delegate1 = delegate1

        self.pickerController1.delegate = self
        self.pickerController1.allowsEditing = true
        self.pickerController1.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController1.sourceType = type
            self.presentationController1?.present(self.pickerController1, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//        if let action = self.action(for: .camera, title: "Take a photo1") {
//            alertController.addAction(action)
//        }
        if let action = self.action(for: .photoLibrary, title: "Choose from gallery ") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .camera, title: "Take a photo") {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController1?.present(alertController, animated: true)
    }
    public func presentCamera(from sourceView: UIView) {
        if let action = self.action(for: .camera, title: "  Take a photo  ") {
            
            self.pickerController1.sourceType = .camera
            self.tag = sourceView.tag
            self.presentationController1?.present(self.pickerController1, animated: true)
        }else{
            if let action = self.action(for: .photoLibrary, title: "Choose from gallery ") {
                self.pickerController1.sourceType = .photoLibrary
                self.tag = sourceView.tag
                self.presentationController1?.present(self.pickerController1, animated: true)
            }
        }
    }
    public func presentGallery(from sourceView: UIView) {
        if let action = self.action(for: .photoLibrary, title: "Choose from gallery ") {
            self.pickerController1.sourceType = .photoLibrary
            self.tag = sourceView.tag
            self.presentationController1?.present(self.pickerController1, animated: true)
            
        }
    }
    private func pickerController1(_ controller: UIImagePickerController, didSelect image: UIImage?,info:[UIImagePickerController.InfoKey: Any]) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate1?.didSelect1(image: image, tag: self.tag, info: info)
    }
}

extension ImagePicker1: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController1(picker, didSelect: nil,info: [:])
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController1(picker, didSelect: nil,info: info)
        }
        self.pickerController1(picker, didSelect: image,info: info)
    }
}

 

extension UIImageView {
    func pavan_tapToSeeFullImage() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else{
            return
        }
        guard let im = imageView.image else {
            return
        }
        
        let newImageView = UIImageView(image: im)
        let frame = self.window!.convert(imageView.frame, from:imageView)
        //        new_img = frame
        newImageView.frame = frame
        if #available(iOS 11.0, *) {
            newImageView.accessibilityFrame = frame
        } else {
            newImageView.accessibilityFrame = frame
            // Fallback on earlier versions
        }
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        tap.direction = .init(arrayLiteral: .up,.down)
        self.window!.addSubview(newImageView)
        
        UIView.animate(withDuration: 0.5, animations: {
            newImageView.frame = UIScreen.main.bounds
        }) { (_) in
            newImageView.frame = UIScreen.main.bounds
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        self.window!.addSubview(newImageView)
        let f = imageView.accessibilityFrame
        UIView.animate(withDuration: 0.5, animations: {
            newImageView.frame = f
        }) { (_) in
            newImageView.removeFromSuperview()
        }
    }
    
    
}
