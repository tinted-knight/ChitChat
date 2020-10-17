//
//  ChannelListAlerts.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func inputAlert(title: String, message: String? = nil, okHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            okHandler(text)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            Log.fire("action canceled")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
