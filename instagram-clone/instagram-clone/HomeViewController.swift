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
        
        let blackAndWhiteAction = UIAlertAction(title: "Black and White", style: .default) { (action) in
            Filters.filter(name: .blackAndWhite, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let sepiaAction = UIAlertAction(title: "Sepia Tone", style: .default) { (action) in
            Filters.filter(name: .sepia, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let comicAction = UIAlertAction(title: "Comic", style: .default) { (action) in
            Filters.filter(name: .comic, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let blurAction = UIAlertAction(title: "Blur", style: .default) { (action) in
            Filters.filter(name: .blur, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        
        let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (action) in
            Filters.history.popLast()
            self.imageView.image = Filters.history.last

        }
        
//        let undoAllAction = UIAlertAction(title: "Undo All", style: .destructive) { (action) in
//            print("Filters.originalImage: \(Filters.originalImage)")
//            print("Filters.history[0]: \(Filters.history[0])")
//            Filters.originalImage = Filters.history[0]
//            print("Filters.history before removeAll: \(Filters.history)")
//            Filters.history.removeAll()
//            print("Filters.history after removeAll: \(Filters.history)")
//            Filters.history = [Filters.originalImage]
//            print("Filters.originalImage: \(Filters.originalImage)")
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(sepiaAction)
        alertController.addAction(comicAction)
        alertController.addAction(blurAction)
        if Filters.history.count > 1 {
            alertController.addAction(undoAction)
        }
//        if Filters.history.count > 2 {
//            alertController.addAction(undoAllAction)
//        }
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
