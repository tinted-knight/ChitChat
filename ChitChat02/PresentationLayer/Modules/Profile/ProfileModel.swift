//
//  ProfileModel.swift
//  ChitChat02
//
//  Created by Timun on 09.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IProfileModel: class {
    var delegate: IProfileModelDelegate? { get set }

    var user: IUserModel { get }
    
    var profileImage: UIImage? { get set }

    func save(name: String?, description: String?, avatar: UIImage?, with type: DataManagerType)

    func load()
    
    func retry()
    
    func isValid(name: String?, description: String) -> Bool
    
    func wasModified(name: String?, description: String) -> Bool
    
    func endEditing(name: String?, description: String, avatar: UIImage?)
}

protocol IProfileModelDelegate: class {
    func onLoaded()
    func loadErrorAlert(title: String, message: String)
    
    func onSaved()
    func onSaveError(_ message: String)
    
    func enableSaveControls()
}

class ProfileModel: IProfileModel, IDataManagerDelegate {

    weak var delegate: IProfileModelDelegate?
    
    var user: IUserModel
    
    var profileImage: UIImage?
    
    private var profileService: IDataManagerService
    
    init(dataManager: IDataManagerService) {
        self.profileService = dataManager
        self.user = newUser
        self.profileImage = UIImage(named: "Profile temp")
        self.profileService.delegate = self
    }
    
    func save(name: String?, description: String?, avatar: UIImage?, with type: DataManagerType) {
        let newUser = UserModel(name: name ?? user.name, description: description ?? user.description, avatar: nil)
        DispatchQueue.global().async { [weak self] in
            let jpegData = avatar?.jpegData(compressionQuality: 1.0)
            self?.profileService.save(user: newUser, avatar: jpegData, with: type)
        }
    }
    
    func load() {
        profileService.load()
    }
    
    func retry() {
        //
    }
    
    func endEditing(name: String?, description: String, avatar: UIImage?) {
        let dataIsValid = isValid(name: name, description: description)
        let dataWasModified = wasModified(name: name, description: description)
        let avatarWasModified = avatar != profileImage
        if dataWasModified || (avatarWasModified && dataIsValid) {
            delegate?.enableSaveControls()
        }
    }
    
    func isValid(name: String?, description: String) -> Bool {
        guard let name = name else { return false }
        guard !name.isEmpty, !description.isEmpty else { return false }
        return true
    }
    
    func wasModified(name: String?, description: String) -> Bool {
        guard isValid(name: name, description: description) else { return false }
        return name != user.name || description != user.description
    }
    // MARK: - IDataManagerDelegate
    func onLoaded(_ model: UserModel) {
        applog("profile load, \(model)")
        user = model
        if let avatarUrl = user.avatar {
            DispatchQueue.global().async { [weak self] in
                do {
                    let data = try Data(contentsOf: avatarUrl)
                    let image = UIImage(data: data)
                    self?.profileImage = image
                    DispatchQueue.main.async {
                        self?.delegate?.onLoaded()
                    }
                } catch {
                    applog("cannot convert avatar's Data to UIImage")
                }
            }
        }
    }
    
    func onLoadError(_ message: String) {
        applog("profile load error")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.loadErrorAlert(title: "Похоже, что  ты новенький", message: "Введи свои данные и сохрани")
        }
    }
    
    func onSaved() {
        applog("profile saved")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSaved()
        }
    }
    
    func onSaveError(_ message: String) {
        applog("profile save error")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSaveError(message)
        }
    }
}
