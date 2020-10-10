//
//  ProfileViewController.swift
//  ChitChat02
//
//  Created by Timun on 20.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

enum UIState {
    case loading
    case hasLoaded
    case saving
    case hasSaved
    case error
    case modeEdit
}

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var textUserDescription: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonUserEdit: UIButton!
    @IBOutlet weak var buttonEditPicture: UIButton!
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let picker = UIImagePickerController()
    
    var state: UIState = .loading
    
    var repo: DataManager = GCDDataManager()
//    var repo: DataManager = OperationDataManager()

    override func viewDidLoad() {
        prepareUi()

        view.backgroundColor = ThemeManager.get().backgroundColor
        buttonSave.backgroundColor = ThemeManager.get().buttonBgColor

        loadUserData()
    }
    
    private func prepareUi() {
        buttonSave.layer.cornerRadius = 14.0

        profilePicture.layer.cornerRadius = view.frame.width / 4
        profilePicture.layer.masksToBounds = true
        
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onProfilePictureTap)))

        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()

        buttonUserEdit.addTarget(self, action: #selector(setEditUser(_:)), for: .touchUpInside)
        textUserName.addTarget(self, action: #selector(nameTextHandler(_:)), for: .editingChanged)
        textUserDescription.delegate = self
    }
    
    @objc private func onProfilePictureTap() {
        showChooseDialog()
    }
    
    @IBAction func onEditButtonTap(_ sender: Any) {
        showChooseDialog()
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveTap(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        saveUserData()
    }
    @objc private func setEditUser(_ sender: UIBarButtonItem) {
        switchEditState()
    }

}
// MARK: -TextField change handler
extension ProfileViewController: UITextViewDelegate {
    @objc private func nameTextHandler(_ textField: UITextField) {
        compare(textField.text, with: repo.user.name)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        compare(textView.text, with: repo.user.description)
    }
    
    private func compare(_ text: String?, with source: String) {
        buttonSave.isEnabled = text != source
    }
}
// MARK: -DataManagerDelegate
extension ProfileViewController: DataManagerDelegate {
    func onLoaded(_ model: UserModel) {
        DispatchQueue.main.async { [weak self] in
            self?.setLoadedState(model)
        }
    }
    
    func onLoadError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.setLoadError(message)
        }
    }
    
    func onSaved() {
        DispatchQueue.main.async { [weak self] in
            self?.onSaveSucces()
        }
    }

    func onSaveError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userSaveError(message)
        }
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
            showAlert("Error", message: "Device has no gallery")
        }
    }
    
    private func chooseFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            showAlert("Error", message: "No camera on device! You are in safe!")
        }
    }
}

// MARK: -UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            showAlert("Error", message: "Something has gone very wrong")
            return
        }
        profilePicture.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
