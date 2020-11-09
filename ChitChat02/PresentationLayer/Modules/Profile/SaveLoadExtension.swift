//
//  SaveLoadExtension.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

// MARK: DataManagerDelegate
extension ProfileViewController: IProfileModelDelegate {

    func onLoaded(_ model: UserModel) {
        Log.arch("profile loaded")
        setLoadedState()
    }

    func loadErrorAlert(title: String, message: String) {
        Log.arch("profile load error")
        showLoadingControls(false)
        showAlert(title: title, message: message)
        setLoadedState()
    }

    func onSaved() {
        Log.arch("profile saved")
        saveSuccess()
    }

    func onSaveError(_ message: String) {
        Log.arch("profile save error")
        userSaveError(message)
    }
}

extension ProfileViewController {
    func saveUserData(with dataManagerType: DataManagerType) {
        let name = textUserName.text
        let description = textUserDescription.text
        setSavingState()
        if avatarWasModified {
            model?.save(name: name, description: description, avatar: profileImage, with: dataManagerType)
        } else {
            model.save(name: name, description: description, avatar: nil, with: dataManagerType)
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
        model.load()
    }
    
    func userSaveError(_ message: String) {
        retryAlert(
            title: "Save error",
            message: message,
            onOk: { [weak self] in
                self?.model.load()
            },
            onRetry: {[weak self] in
                self?.model.retry()
        })
    }
    
    func loadUserData() {
        setLoadingState()
        model.delegate = self
        model.load()
    }
    
    func setLoadingState() {
        state = .loading
        showLoadingControls(true)
    }
    
    func setLoadedState() {
        state = .hasLoaded
        textUserName.text = model.user.name
        textUserDescription.text = model.user.description
        if let avatarUrl = model.user.avatar {
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
            
            textUserName.text = model.user.name
            textUserDescription.text = model.user.description
        }
    }

    func checkSaveControls() {
        let userDataWasModified = model.wasModified(name: textUserName.text, description: textUserDescription.text)
        let userDataIsValid = model.isValid(name: textUserName.text, description: textUserDescription.text)
        applog("\(#function), avatar \(avatarWasModified), data \(userDataWasModified), valid \(userDataIsValid)")
        if (avatarWasModified && userDataIsValid) || userDataWasModified {
            buttonSave.isEnabled = true
            buttonSaveOperation.isEnabled = true
        }
    }
}
