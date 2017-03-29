//
//  HomeViewController.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/27/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit
import MobileCoreServices

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        filterButtonTopConstraint.constant = 8
        postButtonBottomConstraint.constant = 8
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = chosenImage
            Filters.originalImage = chosenImage
            Filters.history = [chosenImage]
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image!")
        self.presentActionSheet()
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if let image = self.imageView.image {
            
            let newPost = Post(image: image)
            CloudKit.shared.save(post: newPost, completion: { (success) in
                 
                if success {
                    print("Successfully Saved Post to CloudKit")
                } else {
                    print("We did not succeed in saving post to CloudKit")
                }
            })
            
        }
        
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        
        guard let image = self.imageView.image else { return }
        
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle: .alert)
        
        func filterAction(title: String, name: FilterName) {
            let action = UIAlertAction(title: title, style: .default) { (action) in
                Filters.filter(name: name, image: image, completion: { (filteredImage) in
                    self.imageView.image = filteredImage
                })
            }
            alertController.addAction(action)
        }
        
        let blackAndWhiteAction = filterAction(title: "Black and White", name: .blackAndWhite)
        let vitnageAction = filterAction(title: "Vintage", name: .vintage)
        let sepiaAction = filterAction(title: "Sepia", name: .sepia)
        let comicAction = filterAction(title: "Comic", name: .comic)
        let blurAction = filterAction(title: "Blur", name: .blur)
        let posterizeAction = filterAction(title: "Posterize", name: .posterize)
        let invertAction = filterAction(title: "Invert", name: .invert)
        let fadeAction = filterAction(title: "Fade", name: .fade)
        
        let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (action) in
            Filters.history.popLast()
            self.imageView.image = Filters.history.last

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if Filters.history.count > 1 {
            alertController.addAction(undoAction)
        }

        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func presentActionSheet() {
        let actionSheetController = UIAlertController(title: "Source", message: "Please select Source Type", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
}
