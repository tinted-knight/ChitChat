//
//  AvatarPickerExtension.swift
//  ChitChat02
//
//  Created by Timun on 10.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

// MARK: Profile picture choose
extension ProfileViewController {
    func showChooseDialog() {
        let alertController = UIAlertController(title: nil, message: "Think twice. Everyone all over the Internet will see your face.", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Make a foto", style: .default) { [weak self] _ in
            self?.chooseFromCamera()
        }

        let galleryAction = UIAlertAction(title: "From galley", style: .default) { [weak self] _ in
            self?.chooseFromGallery()
        }

        let collectionAction = UIAlertAction(title: "From collection", style: .default) { [weak self] _ in
            self?.chooseFromCollection()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // todo cancel handler
        }

        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(collectionAction)
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
    
    private func chooseFromCollection() {
        guard let controller = presentationAssembly?.avatarCollectionViewController(self) else { return }
        present(controller, animated: true, completion: nil)
    }
}
// MARK: AvatarCollectionDelegate
extension ProfileViewController: AvatarCollectionDelegate {
    func onPicked(_ image: UIImage) {
        profileImageView.image = image
        model?.endEditing(name: textUserName.text,
                          description: textUserDescription.description,
                          avatar: profileImageView.image)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        Log.profile("\(info[.imageURL] ?? "nothing")")
        guard let image = info[.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "Something has gone very wrong")
            return
        }
        profileImageView.image = image
        model?.endEditing(name: textUserName.text,
                         description: textUserDescription.description,
                         avatar: profileImageView.image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
