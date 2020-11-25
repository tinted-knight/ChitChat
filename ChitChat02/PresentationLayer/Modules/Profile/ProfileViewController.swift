//
//  ProfileViewController.swift
//  ChitChat02
//
//  Created by Timun on 20.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: FunViewController {

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

    let picker = UIImagePickerController()

    var model: IProfileModel?
    
    var themeModel: IThemeModel?
    
    var presentationAssembly: PresentationAssembly?

    override func viewDidLoad() {
        prepareUi()
        setupActions()

        model?.delegate = self
        model?.load()
        
        super.viewDidLoad()
    }

    private func prepareUi() {
        buttonSave.layer.cornerRadius = 14.0
        buttonSaveOperation.layer.cornerRadius = 14.0

        profileImageView.layer.cornerRadius = view.frame.width / 4
        profileImageView.layer.masksToBounds = true

        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()

        scrollView.isScrollEnabled = false
        
        applyTheme()
    }
    
    private func applyTheme() {
        guard let themeData = themeModel?.getThemeData() else { return }
        view.backgroundColor = themeData.backgroundColor
        buttonSave.backgroundColor = themeData.buttonBgColor
        buttonSaveOperation.backgroundColor = themeData.buttonBgColor
        textUserName.textColor = themeData.textColor
    }

    private func setupActions() {
        profileImageView.isUserInteractionEnabled = false
        profileImageView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(onProfilePictureTap)))

        buttonEditPicture.isEnabled = false
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
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
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
            model?.endEditing(name: textUserName.text,
                             description: textUserDescription.description,
                             avatar: profileImageView.image)
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

    private func saveUserData(with dataManagerType: DataManagerType) {
        let name = textUserName.text
        let description = textUserDescription.text
        model?.save(name: name, description: description, avatar: profileImageView.image, with: dataManagerType)
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

    @objc private func setEditUser(_ sender: UIButton) {
        model?.switchEditState()
        if let model = model, model.state == .modeEdit {
            sender.shake()
        } else {
            sender.stopShaking()
        }
    }

}

// MARK: TextField change handler
extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        model?.endEditing(name: textUserName.text,
                         description: textUserDescription.description,
                         avatar: profileImageView.image)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
        model?.endEditing(name: textUserName.text,
                         description: textUserDescription.description,
                         avatar: profileImageView.image)
    }
}
