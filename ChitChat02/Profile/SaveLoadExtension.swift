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
    func saveUserData() {
        guard let name = textUserName.text, let description = textUserDescription.text,
            name != repo.user.name || description != repo.user.description else {
                return
        }
        setSavingState()
        repo.save(UserModel(name: name, description: description))
    }
    
    func setSavingState() {
        state = .saving
        showLoadingControls(true)
        buttonUserEdit.setTitle("Edit", for: .normal)
    }
    
    func onSaveSucces() {
        showAlert("Данные сохранены")
        state = .hasSaved
        showLoadingControls(false)
    }
    
    func userSaveError(_ message: String) {
        showRetryAlert(
            message,
            onOk: { [weak self] in
                guard let self = self else { return }
                self.setLoadedState(self.repo.user)
            },
            onRetry: {[weak self] in
                self?.saveUserData()
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
    
    func setLoadedState(_ model: UserModel) {
        state = .hasLoaded
        textUserName.text = model.name
        textUserDescription.text = model.description
        showLoadingControls(false)
    }
    
    func showLoadingControls(_ isLoading: Bool) {
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
            buttonSave.isEnabled = false
            
            textUserName.text = repo.user.name
            textUserDescription.text = repo.user.description
        }
    }

    func setLoadError(_ message: String) {
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