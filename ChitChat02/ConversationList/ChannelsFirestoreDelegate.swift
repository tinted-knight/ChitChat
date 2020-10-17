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
            guard let self = self else { return }

            if !values.isEmpty {
                self.channels = values
            } else {
                self.emptyLabel.isHidden = false
            }
            self.chatTableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
}
