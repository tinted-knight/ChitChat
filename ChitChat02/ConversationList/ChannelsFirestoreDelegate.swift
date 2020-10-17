//
//  ChannelsFirestoreDelegate.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

extension ConversationListViewController: FirestoreDelegate {
    func onData(_ values: [Channel]) {
        print(". \(values.count)")
        channels = values
        chatTableView.reloadData()
    }
}
