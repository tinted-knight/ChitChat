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
        model?.load()
    }

    func onSaveError(_ message: String) {
        Log.arch("profile save error")
        retryAlert(
            title: "Save error",
            message: message,
            onOk: { [weak self] in
                self?.model?.load()
            },
            onRetry: {[weak self] in
                self?.model?.retry()
        })
    }
    
    func enableSaveControls() {
        buttonSave.isEnabled = true
        buttonSaveOperation.isEnabled = true
    }
    
    func showEditState(_ value: Bool) {
        if !value {
            buttonUserEdit.setTitle("Edit", for: .normal)
            
            textUserName.isEnabled = false
            textUserDescription.isEditable = false
            
            textUserName.text = model?.user.name
            textUserDescription.text = model?.user.description

            profileImageView.isUserInteractionEnabled = false
            buttonEditPicture.isEnabled = false
        } else {
            buttonUserEdit.setTitle("Cancel", for: .normal)

            textUserName.isEnabled = true
            textUserDescription.isEditable = true

            profileImageView.isUserInteractionEnabled = true
            buttonEditPicture.isEnabled = true
        }
    }
    
    func showLoading() {
        showEditState(false)
        showLoadingControls(true)
    }
}

extension ProfileViewController {
    
    func setLoadedState() {
        textUserName.text = model?.user.name
        textUserDescription.text = model?.user.description
        profileImageView.image = model?.profileImage
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
            
            textUserName.isHidden = true
            textUserDescription.isHidden = true
            profileImageView.isHidden = true
            buttonEditPicture.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            buttonUserEdit.isEnabled = true

            textUserName.isHidden = false
            textUserDescription.isHidden = false
            profileImageView.isHidden = false
            buttonEditPicture.isHidden = false
        }
    }
}
