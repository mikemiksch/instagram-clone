//
//  HomeViewController.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/27/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social

class HomeViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    
    let filterNames = [FilterName.vintage, FilterName.blackAndWhite, FilterName.sepia, FilterName.comic, FilterName.blur, FilterName.posterize, FilterName.invert, FilterName.fade]
    
    let filterLabelNames = ["Vintage", "B&W", "Sepia", "Comic", "Blur", "Posterize", "Invert", "Fade"]
   
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        Filters.originalImage = self.imageView.image
        setupGalleryDelegate()
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
        let openHeight : CGFloat = 150
        let closedHeight : CGFloat = 0
        
        if self.collectionViewHeightConstraint.constant == openHeight {
            self.collectionViewHeightConstraint.constant = closedHeight
        } else if self.collectionViewHeightConstraint.constant == closedHeight {
            self.collectionViewHeightConstraint.constant = openHeight
        }
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
//    let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle: .alert)
//    
//    func filterAction(title: String, name: FilterName) {
//        let action = UIAlertAction(title: title, style: .default) { (action) in
//            Filters.filter(name: name, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        alertController.addAction(action)
//    }
//    
//    let blackAndWhiteAction = filterAction(title: "Black and White", name: .blackAndWhite)
//    let vitnageAction = filterAction(title: "Vintage", name: .vintage)
//    let sepiaAction = filterAction(title: "Sepia", name: .sepia)
//    let comicAction = filterAction(title: "Comic", name: .comic)
//    let blurAction = filterAction(title: "Blur", name: .blur)
//    let posterizeAction = filterAction(title: "Posterize", name: .posterize)
//    let invertAction = filterAction(title: "Invert", name: .invert)
//    let fadeAction = filterAction(title: "Fade", name: .fade)
//    
//    let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (action) in
//        Filters.history.popLast()
//        self.imageView.image = Filters.history.last
//        
//    }
//    
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//    
//    if Filters.history.count > 1 {
//    alertController.addAction(undoAction)
//    }
//    
//    alertController.addAction(cancelAction)
//    
//    self.present(alertController, animated: true, completion: nil)
//    
    }

    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)) {
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
            composeController.add(self.imageView.image)
            self.present(composeController, animated: true, completion: nil)
        }
        
    }
    
    func presentActionSheet() {
        let actionSheetController = UIAlertController(title: "Source", message: "Please select Source Type", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (action) in
            Filters.history.popLast()
            guard let lastImage = Filters.history.last else { return }
            self.imageView.image = lastImage
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(undoAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
}

//MARK: setupGalleryDelegate
extension HomeViewController : UINavigationControllerDelegate {
    func setupGalleryDelegate() {
        if let tabBarController = self.tabBarController {
            guard let viewControllers = tabBarController.viewControllers else { return }
            guard let galleryController = viewControllers[1] as? GalleryViewController else { return }
            galleryController.delegate = self
        }
    }
}

//MARK: UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        guard let originalImage = Filters.originalImage else { return filterCell }
        guard let resizedImage = originalImage.resize(size: CGSize(width: 150, height: 150)) else { return filterCell }
        let filterName = self.filterNames[indexPath.row]
        let filterLabelText = self.filterLabelNames[indexPath.row]
        
        Filters.filter(name: filterName, image: resizedImage, filterLabelText) { (filteredImage) in
            filterCell.imageView.image = filteredImage
            filterCell.filterLabel.text = filterLabelText
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = self.filterNames[indexPath.row]
        guard let finalImage = self.imageView.image else { return }
        Filters.filter(name: selectedFilter, image: finalImage, nil) { (filteredImage) in
            self.imageView.image = filteredImage
            Filters.history.append(filteredImage)

        }
    }
    
}


//MARK: GalleryViewControllerDelegate
extension HomeViewController : GalleryViewControllerDelegate {
    func galleryController(didSelect image: UIImage) {
        self.imageView.image = image
        self.collectionViewHeightConstraint.constant = 0
        self.tabBarController?.selectedIndex = 0
    }
}


//MARK: UIImagePickerControllerDelegate
extension HomeViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = chosenImage
            Filters.originalImage = chosenImage
            Filters.history = [chosenImage]
            self.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
