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

    func save(name: String?, description: String?, avatar: UIImage?, with type: DataManagerType)

    func load()
    
    func retry()
    
    func isValid(name: String?, description: String) -> Bool
    
    func wasModified(name: String?, description: String) -> Bool
}

protocol IProfileModelDelegate: class {
    func onLoaded(_ model: UserModel)
    func loadErrorAlert(title: String, message: String)
    func onSaved()
    func onSaveError(_ message: String)
}

class ProfileModel: IProfileModel, IDataManagerDelegate {

    weak var delegate: IProfileModelDelegate?
    
    var user: IUserModel
    
    private var profileService: IDataManagerService
    
    init(dataManager: IDataManagerService) {
        self.profileService = dataManager
        self.user = newUser
        self.profileService.delegate = self
    }
    
    func save(name: String?, description: String?, avatar: UIImage?, with type: DataManagerType) {
        let newUser = UserModel(name: name ?? user.name, description: description ?? user.description, avatar: nil)
        if let avatar = avatar {
            DispatchQueue.global().async { [weak self] in
                let jpegData = avatar.jpegData(compressionQuality: 1.0)
                self?.profileService.save(user: newUser, avatar: jpegData, with: type)
            }
        } else {
            profileService.save(user: newUser, avatar: nil, with: type)
        }
    }
    
    func load() {
        profileService.load()
    }
    
    func retry() {
        //
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
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onLoaded(model)
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
