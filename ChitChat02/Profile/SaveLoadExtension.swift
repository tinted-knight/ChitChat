//
//  SaveLoadExtension.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

// MARK: -Edit mode, save/load user data
extension ProfileViewController {
    func saveUserData(with dataManagerType: DataManagerType) {
        guard userDataWasModified || avatarWasModified else { return }

        let name = textUserName.text ?? repo.user.name
        let description = textUserDescription.text ?? repo.user.description
        setSavingState()
        let userData = UserModel(name: name, description: description)
        if avatarWasModified {
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak profileImage, weak repo] in
                // https://stackoverflow.com/a/10632187
                let jpegData = profileImage?.jpegData(compressionQuality: 1.0)
                repo?.save(user: userData, avatar: jpegData, with: dataManagerType)
            }
        } else {
            repo.save(user: userData, with: dataManagerType)
        }
    }
    
    func setSavingState() {
        state = .saving
        showLoadingControls(true)
        buttonUserEdit.setTitle("Edit", for: .normal)
    }
    
    func saveSuccess() {
        showAlert("Данные сохранены")
        state = .hasSaved
        repo.load()
    }
    
    func userSaveError(_ message: String) {
        showRetryAlert(
            message,
            onOk: { [weak self] in
                self?.repo.load()
            },
            onRetry: {[weak self] in
                self?.repo.retry()
            })
    }
    
    func loadUserData() {
        setLoadingState()
        repo.delegate = self
        repo.load()
    }
    
    func setLoadingState() {
        state = .loading
        showLoadingControls(true)
    }
    
    func setLoadedState() {
        state = .hasLoaded
        textUserName.text = repo.user.name
        textUserDescription.text = repo.user.description
        if let avatarUrl = repo.user.avatar {
            profileImage = UIImage(contentsOfFile: avatarUrl.path)
        }
        profileImageView.image = profileImage
        showLoadingControls(false)
    }
    
    func showLoadingControls(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            buttonSave.isEnabled = false
            buttonSaveOperation.isEnabled = false
            buttonEditPicture.isEnabled = false
            buttonUserEdit.isEnabled = false
            textUserName.isEnabled = false
            textUserDescription.isEditable = false
            profileImageView.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
//            buttonSave.isEnabled = false
            buttonEditPicture.isEnabled = true
            profileImageView.isUserInteractionEnabled = true
            buttonUserEdit.isEnabled = true
        }
    }
    
    func switchEditState() {
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
            
            textUserName.text = repo.user.name
            textUserDescription.text = repo.user.description
        }
    }

    func showSaveControls() {
        if avatarWasModified || userDataWasModified {
            buttonSave.isEnabled = true
            buttonSaveOperation.isEnabled = true
        }
    }
    
    func setLoadError(_ message: String) {
        showLoadingControls(false)
        showRetryAlert(
            message,
            onOk: { [weak self] in
                self?.setLoadedState()
            },
            onRetry: { [weak self] in
                self?.loadUserData()
            }
        )
    }

    func showRetryAlert(_ message: String, onOk: (() -> Void)? = nil, onRetry: @escaping () -> Void) {
        let alertView = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default) { action in
            onOk?()
        }
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { action in
            onRetry()
        }
        alertView.addAction(doneAction)
        alertView.addAction(retryAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String, message: String? = nil) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
}
