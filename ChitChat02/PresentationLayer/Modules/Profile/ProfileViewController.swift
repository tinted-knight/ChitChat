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

class ProfileViewController: UIViewController {

    static func instance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProfileViewController
    }

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textUserDescription: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonSaveOperation: UIButton!
    @IBOutlet weak var buttonUserEdit: UIButton!
    @IBOutlet weak var buttonEditPicture: UIButton!
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!

    private var activeField: UIView?

    private let picker = UIImagePickerController()
    var profileImage: UIImage?

    var state: UIState = .loading
    var avatarWasModified = false

    var repo: SmartDataManager = SmartDataManager(dataManagerType: .gcd)

    override func viewDidLoad() {
        prepareUi()
        setupActions()

        repo.delegate = self
        loadUserData()
        
        super.viewDidLoad()
    }

    private func prepareUi() {
        buttonSave.layer.cornerRadius = 14.0
        buttonSaveOperation.layer.cornerRadius = 14.0

        profileImageView.layer.cornerRadius = view.frame.width / 4
        profileImageView.layer.masksToBounds = true
        profileImage = UIImage(named: "Profile temp")

        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()

        view.backgroundColor = ThemeManager.get().backgroundColor
        buttonSave.backgroundColor = ThemeManager.get().buttonBgColor
        buttonSaveOperation.backgroundColor = ThemeManager.get().buttonBgColor
        textUserName.textColor = ThemeManager.get().textColor

        scrollView.isScrollEnabled = false
    }

    private func setupActions() {
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(onProfilePictureTap)))

        buttonUserEdit.addTarget(self, action: #selector(setEditUser(_:)), for: .touchUpInside)
        textUserDescription.delegate = self
        textUserName.delegate = self

        buttonSave.addTarget(self, action: #selector(onSaveViaGcd), for: .touchUpInside)
        buttonSaveOperation.addTarget(self, action: #selector(onSaveViaOperation), for: .touchUpInside)
        // keyboard handle https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(adjustForKeyboard(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(adjustForKeyboard(_:)),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil)
    }

    // MARK: UI Actions
    @objc private func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let kbScreenEndFrame = keyboardValue.cgRectValue
        let kbViewEndFrame = view.convert(kbScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            scrollView.isScrollEnabled = false
            checkSaveControls()
        } else {
            scrollView.contentInset = UIEdgeInsets(
                    top: 0.0,
                    left: 0.0,
                    bottom: kbViewEndFrame.height - view.safeAreaInsets.bottom,
                    right: 0.0
            )
            scrollView.isScrollEnabled = true
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset

    }

    @objc private func onSaveViaGcd() {
        saveUserData(with: .gcd)
    }

    @objc private func onSaveViaOperation() {
        saveUserData(with: .operation)
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

    @objc private func setEditUser(_ sender: UIBarButtonItem) {
        switchEditState()
    }

}

// MARK: TextField change handler
extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
    }
}

// MARK: DataManagerDelegate
extension ProfileViewController: IDataManagerDelegate {

    func onLoaded(_ model: UserModel) {
        DispatchQueue.main.async { [weak self] in
            self?.setLoadedState()
        }
    }

    func onLoadError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.setLoadError(message)
        }
    }

    func onSaved() {
        DispatchQueue.main.async { [weak self] in
            self?.saveSuccess()
        }
    }

    func onSaveError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userSaveError(message)
        }
    }
}

// MARK: Profile picture choose
extension ProfileViewController {
    private func showChooseDialog() {
        let alertController = UIAlertController(title: nil, message: "Think twice. Everyone all over the Internet will see your face.", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Make a foto", style: .default) { [weak self] _ in
            self?.chooseFromCamera()
        }
        let galleryAction = UIAlertAction(title: "From galley", style: .default) { [weak self] _ in
            self?.chooseFromGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
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
            showAlert(title: "Error", message: "Device has no gallery")
        }
    }

    private func chooseFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: "No camera on device! You are in safe!")
        }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        applog("\(info[.imageURL] ?? "nothing")")
        guard let image = info[.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "Something has gone very wrong")
            return
        }
        profileImage = image
        profileImageView.image = profileImage
        avatarWasModified = true
        checkSaveControls()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
