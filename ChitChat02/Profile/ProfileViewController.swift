//
//  ProfileViewController.swift
//  ChitChat02
//
//  Created by Timun on 20.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var buttonEdit: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var textUserDescription: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    
    private let fakeUserName = "Timur Tharkahov"
    private let fakeUserDescription = """
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
UX/UI designer, web-designer, Moscow, Russia
"""
    
    private let picker = UIImagePickerController()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        applog("\(buttonEdit.frame)")
        // При попытке обращение к buttonEdit приложение падает
        // с сообщением о том, что невозможно `расколупать` Optional
        //
        // В интернетах пишут, что `coder` нужен при работе с `iOS serialization APIs`
        // Судя по всему, в момент вызова просто ещё ничего нет, поэтому и ссылка
        // на кнопку `nil`
    }
    
    override func viewDidLoad() {
//        applog("ProfileViewController::\(#function)")
//        applog("buttonEdit.frame: \(buttonEdit.frame)")

        prepareUi()
        populateUi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        applog("ProfileViewController::\(#function)")
//        applog("buttonEdit.frame: \(buttonEdit.frame)")
        // frame отличается, потому что здесь размер view
        // пересчитан с учётом констрейнтов,
        // расположения и размера родительских и соседних view
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
        textUserDescription.text = fakeUserDescription
    }
    
    @objc private func onProfilePictureTap() {
        showChooseDialog()
    }
    @IBAction func onEditButtonTap(_ sender: Any) {
        showChooseDialog()
    }
    
    private func showAlert(_ message: String) {
        let alertView = UIAlertController(title: "Don't worry, be puppy", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
}

//MARK: -Profile picture choose
extension ProfileViewController {
    private func showChooseDialog() {
        let alertController = UIAlertController(title: nil, message: "Think twice. Everyone all over the Internet will see your face.", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Make a foto", style: .default) { [weak self] UIAlertAction in
            self?.chooseFromCamera()
        }
        let galleryAction = UIAlertAction(title: "From galley", style: .default) { [weak self] UIAlertAction in
            self?.chooseFromGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            // todo cancel handler
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
        } else {
            showAlert("Device has no gallery")
        }
    }
    
    private func chooseFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            showAlert("No camera on device! You are in safe!")
        }
    }
}

// MARK: -UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            showAlert("Something has gone very wrong")
            return
        }
        profilePicture.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
