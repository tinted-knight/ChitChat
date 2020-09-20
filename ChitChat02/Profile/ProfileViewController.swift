//
//  ProfileViewController.swift
//  ChitChat02
//
//  Created by Timun on 20.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : ViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var buttonEdit: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelUserDescription: UILabel!
    @IBOutlet weak var buttonSave: UIButton!
    
    private let fakeUserName = "Timur Tharkahov"
    private let fakeUserDescription = "UX/UI designer, web-designer, Moscow, Russia"
    
    private let picker = UIImagePickerController()

    override func viewDidLoad() {
        applog("ProfileViewController::\(#function)")

        prepareUi()
        populateUi()
    }
    
    private func prepareUi() {
        buttonSave.layer.cornerRadius = 14.0
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.height / 2
        profilePicture.layer.masksToBounds = true
        
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onProfilePictureTap)))
    }
    
    private func populateUi() {
        labelUserName.text = fakeUserName
        labelUserDescription.text = fakeUserDescription
    }
    
    @objc private func onProfilePictureTap() {
        showChooseDialog()
    }
    
    private func showChooseDialog() {
        let alertController = UIAlertController(title: nil, message: "Think twice. Everyone all over the Internet will see your face.", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Make a foto", style: .default) { UIAlertAction in
            applog("camera")
        }
        let galleryAction = UIAlertAction(title: "From galley", style: .default) { UIAlertAction in
            self.chooseFromGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            applog("cancel")
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func chooseFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            
            present(picker, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            applog("!!!!! Error")
            return
        }
        profilePicture.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
