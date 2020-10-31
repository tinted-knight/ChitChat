//
//  Navigation.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ConversationListViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let controller = segue.destination as? ConversationViewController,
//            let channel = sender as? Channel {
//            controller.channel = channel
//        }
//    }
    
    func openConversationScreen(for channel: ChannelEntity, with manager: MessagesManager) {
        if let viewController = ConversationViewController.instance() {
            viewController.channel = channel
            viewController.messageManager = manager
            viewController.myData = myData
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func openSettingsScreen(result: @escaping (Theme, Bool) -> Void) {
        if let themesViewController = ThemesViewController.instance() {
            themesViewController.activeTheme = currentTheme
            
            //themesViewController.delegate = self
            
            themesViewController.themePicked = { value in
                //
            }
            
            themesViewController.result = result
            
            navigationController?.pushViewController(themesViewController, animated: true)
        }
    }
    
    func openProfileScreen() {
        performSegue(withIdentifier: "segue_show_profile", sender: nil)
    }
}
