//
//  ChannelsFirestoreDelegate.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

extension ConversationListViewController {
    func loadChannelList() {
        channelsManager?.loadChannelList { [weak self] (values) in
            self?.channels = values
            self?.chatTableView.reloadData()
        }
    }
}
