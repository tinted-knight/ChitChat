//
//  ProfileViewController.swift
//  ChitChat02
//
//  Created by Timun on 20.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

private enum UIState {
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
    
    private var state: UIState = .loading
    
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
        textUserName.addTarget(self, action: #selector(nameTextHandler(_:)), for: .editingChanged)
        textUserDescription.delegate = self
    }
    
    private func populateUi() {
        if (state == .hasLoaded) {
            textUserName.text = repo.user.name
            textUserDescription.text = repo.user.description
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
        saveUserData()
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
// MARK: -Edit mode, save/load user data
extension ProfileViewController {
    private func saveUserData() {
        //        guard let name = textUserName.text, let description = textUserDescription.text,
        //            name != state.user.name || description != state.user.description else {
        //            return
        //        }
        let name = textUserName.text ?? repo.user.name
        let description = textUserDescription.text ??  repo.user.description
        setSavingState()
        repo.save(
            UserModel(name: name, description: description),
            onDone: { [weak self] in
                DispatchQueue.main.async {
                    self?.onSaveSucces()
                }
        },
            onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.onSaveError(error)
                }
        }
        )
    }
    
    private func setSavingState() {
        state = .saving
        showLoadingControls(true)
        buttonUserEdit.setTitle("Edit", for: .normal)
    }
    
    private func onSaveSucces() {
        showAlert("Saved")
        state = .hasSaved
        showLoadingControls(false)
    }
    
    private func onSaveError(_ message: String) {
        showLoadingControls(false)
        showRetryAlert(message) { [weak self] in
            self?.saveUserData()
        }
    }
    
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
                    self?.setLoadError(message)
                }
        }
        )
    }
    
    private func setLoadingState() {
        state = .loading
        showLoadingControls(true)
    }
    
    private func setLoadedState(_ model: UserModel) {
        state = .hasLoaded
        textUserName.text = model.name
        textUserDescription.text = model.description
        showLoadingControls(false)
    }
    
    private func showLoadingControls(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            buttonSave.isEnabled = false
            buttonEditPicture.isEnabled = false
            buttonUserEdit.isEnabled = false
            textUserName.isEnabled = false
            textUserDescription.isEditable = false
            profilePicture.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            buttonSave.isEnabled = false
            buttonEditPicture.isEnabled = true
            profilePicture.isUserInteractionEnabled = true
            buttonUserEdit.isEnabled = true
        }
    }
    
    private func switchEditState() {
        if state == .hasLoaded || state == .hasSaved {
            state = .modeEdit
            buttonUserEdit.setTitle("Cancel", for: .normal)

            textUserName.isEnabled = true
            textUserDescription.isEditable = true
        } else if state == .modeEdit {
            state = .hasLoaded
            buttonUserEdit.setTitle("Edit", for: .normal)
            
            textUserName.isEnabled = false
            textUserDescription.isEditable = false
            buttonSave.isEnabled = false
            
            textUserName.text = repo.user.name
            textUserDescription.text = repo.user.description
        }
    }

    private func setLoadError(_ message: String) {
        showLoadingControls(false)
        showRetryAlert(
            message,
            onOk: { [weak self] in
                self?.setLoadedState(newUser)
            },
            onRetry: { [weak self] in
                self?.loadUserData()
            }
        )
    }

    private func showRetryAlert(_ message: String, onOk: (() -> Void)? = nil, onRetry: @escaping () -> Void) {
        let alertView = UIAlertController(title: "Don't worry, be puppy", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Close", style: .default) { action in
            onOk?()
        }
        let retryAction = UIAlertAction(title: "Retry", style: .default) { action in
            onRetry()
        }
        alertView.addAction(doneAction)
        alertView.addAction(retryAction)
        present(alertView, animated: true, completion: nil)
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
