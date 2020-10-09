//
//  ProfileViewController.swift
//  ChitChat02
//
//  Created by Timun on 20.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

private enum UILoadState {
    case loading
    case hasLoaded
    case saving
    case hasSaved
    case error
    case modeEdit
}

//private struct UIState {
//    let viewState: UILoadState
//    let user: UserModel
//}

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var textUserDescription: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonUserEdit: UIButton!
    @IBOutlet weak var buttonEditPicture: UIButton!
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let picker = UIImagePickerController()
    
    private var state: UILoadState = .loading
    
    private var user = UserModel(name: "noname", description: "nodesc")
    
    private let repo: Repository = GCDRepo()

    override func viewDidLoad() {
        prepareUi()
        populateUi()
        
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
    }
    
    private func populateUi() {
        if (state == .hasLoaded) {
            textUserName.text = user.name
            textUserDescription.text = user.description
        }
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
//        guard let name = textUserName.text, let description = textUserDescription.text,
//            name != state.user.name || description != state.user.description else {
//            return
//        }
        let name = textUserName.text ?? user.name
        let description = textUserDescription.text ??  user.description
        activityIndicator.startAnimating()
        repo.save(UserModel(name: name, description: description)) { result in
            applog("saving \(result)")
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
// MARK: -Edit mode, save/load user data
extension ProfileViewController {
    @objc private func setEditUser(_ sender: UIBarButtonItem) {
        switchEditState()
    }
    
    private func loadUserData() {
        setLoadingState()
        repo.load(
            onLoaded: { value in
                applog("onLoaded: \(value)")
                DispatchQueue.main.async { [weak self] in
                    self?.setLoadedState(value)
                }
        },
            onError: { message in
                applog("onError: \(message)")
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(message)
                }
        }
        )
    }
    
    private func setLoadingState() {
        state = .loading
        
        activityIndicator.startAnimating()
        buttonSave.isEnabled = false
        buttonEditPicture.isEnabled = false
        textUserName.isEnabled = false
        textUserDescription.isEditable = false
        profilePicture.isUserInteractionEnabled = false
    }
    
    private func setLoadedState(_ model: UserModel) {
        state = .hasLoaded
        user = model
        
        activityIndicator.stopAnimating()
        buttonSave.isEnabled = true
        buttonEditPicture.isEnabled = true
        profilePicture.isUserInteractionEnabled = true

        textUserName.text = model.name
        textUserDescription.text = model.description
    }
    
    private func switchEditState() {
        if state == .hasLoaded {
            state = .modeEdit
            buttonUserEdit.setTitle("Cancel", for: .normal)

            textUserName.isEnabled = true
            textUserDescription.isEditable = true
        } else if state == .modeEdit {
            state = .hasLoaded
            buttonUserEdit.setTitle("Edit", for: .normal)
            
            textUserName.isEnabled = false
            textUserDescription.isEditable = false
        }
    }

    private func showAlert(_ message: String) {
        state = .error
        
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
