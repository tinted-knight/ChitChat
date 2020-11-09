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

    func onLoaded() {
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
        showAlert(title: "Данные сохранены")
        state = .hasSaved
        model.load()
    }

    func onSaveError(_ message: String) {
        Log.arch("profile save error")
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
    
    func enableSaveControls() {
        buttonSave.isEnabled = true
        buttonSaveOperation.isEnabled = true
    }
}

extension ProfileViewController {
    func saveUserData(with dataManagerType: DataManagerType) {
        let name = textUserName.text
        let description = textUserDescription.text
        setSavingState()
        model?.save(name: name, description: description, avatar: profileImageView.image, with: dataManagerType)
    }
    
    func setSavingState() {
        state = .saving
        showLoadingControls(true)
        buttonUserEdit.setTitle("Edit", for: .normal)
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
        profileImageView.image = model.profileImage
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
}
