//
//  SaveLoadExtension.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

// MARK: Edit mode, save/load user data
extension ProfileViewController {
    func saveUserData(with dataManagerType: DataManagerType) {
        let name = textUserName.text ?? repo.user.name
        let description = textUserDescription.text ?? repo.user.description
        setSavingState()
        let userData = UserModel(name: name, description: description)
        if avatarWasModified {
            DispatchQueue.global().async { [weak profileImage, weak repo] in
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
        showAlert(title: "Данные сохранены")
        state = .hasSaved
        repo.load()
    }
    
    func userSaveError(_ message: String) {
        retryAlert(
            title: "Save error",
            message: message,
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
            DispatchQueue.global().async { [weak self] in
                do {
                    let data = try Data(contentsOf: avatarUrl)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.profileImage = image
                        self?.profileImageView.image = self?.profileImage
                        self?.showLoadingControls(false)
                    }
                } catch {
                    applog("cannot convert avatar's Data to UIImage")
                    DispatchQueue.main.async { [weak self] in
                        self?.showLoadingControls(false)
                    }
                }
            }
        } else {
            showLoadingControls(false)
        }
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

    func checkSaveControls() {
        let userDataWasModified = repo.wasModified(name: textUserName.text, description: textUserDescription.text)
        let userDataIsValid = repo.isValid(name: textUserName.text, description: textUserDescription.text)
        applog("\(#function), avatar \(avatarWasModified), data \(userDataWasModified), valid \(userDataIsValid)")
        if (avatarWasModified && userDataIsValid) || userDataWasModified {
            buttonSave.isEnabled = true
            buttonSaveOperation.isEnabled = true
        }
    }
    
    func setLoadError(_ message: String) {
        showLoadingControls(false)
        showAlert(title: "Похоже, что  ты новенький", message: "Введи свои данные и сохрани")
        setLoadedState()
    }
}
