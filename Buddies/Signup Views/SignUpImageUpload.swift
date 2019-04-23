//
//  SignUpImageUpload.swift
//  Buddies
//
//  Created by Dima Ilin on 4/2/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

//TODO: Setup memory efficient photo switching, so that firebase deletes a photo that you decided not to upload.
//TODO: Setup image cropping to correct aspect ratio: https://stackoverflow.com/questions/9041732/set-dimensions-for-uiimagepickercontroller-move-and-scale-cropbox/9101576#9101576

import UIKit
import Firebase
import ImageIO

class SignUpImageUpload: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePreview1: UIImageView!
    @IBOutlet weak var imagePreview2: UIImageView!
    @IBOutlet weak var imagePreview3: UIImageView!
    @IBOutlet weak var imagePreview4: UIImageView!
    @IBOutlet weak var imagePreview5: UIImageView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var selectedImage: UIImage!
    var ref: DatabaseReference!
    private var userID = Auth.auth().currentUser!.uid
    let storage = Storage.storage()
    var storageRef:StorageReference!
    private var senderTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        ref = Database.database().reference()
        storageRef = storage.reference()
        // Do any additional setup after loading the view.
    }
    
    func uploadImg (sender: Int) {
        
        if let imageData = selectedImage.jpegData(compressionQuality: 0.2) {
            let imgUID = NSUUID().uuidString
            let metaData = StorageMetadata()
            let imageRef = storageRef.child("users").child(userID).child("User Images").child(imgUID)
            imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                guard metadata != nil else {
                    print("Broken1")
                    return
                }
                
                // Metadata contains file metadata such as size, content-type.
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Broken2")
                        return
                    }
                    self.ref.child("users").child(self.userID).setValue(["userImg": downloadURL.absoluteString] as [String: Any])
                    
                    switch sender {
                    case 1:
                        self.imagePreview1.load(url: downloadURL)
                        break
                    case 2:
                        self.imagePreview2.load(url: downloadURL)
                        break
                    case 3:
                        self.imagePreview3.load(url: downloadURL)
                        break
                    case 4:
                        self.imagePreview4.load(url: downloadURL)
                        break
                    case 5:
                        self.imagePreview5.load(url: downloadURL)
                        break
                    default:
                        let alert = UIAlertController(title: "An Error Occured", message: nil, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        break
                    }
                }
            }
        }
        
    }

    @IBAction func uploadImgButton(_ sender: UIButton) {
        senderTag = sender.tag
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        //Ipad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else{
            let alert  = UIAlertController(title: "Error", message: "No image found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        selectedImage = image
        uploadImg(sender: senderTag)
        
    }

}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


