//
//  ChannelsFirestoreDelegate.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

// MARK: - View states
extension ChannelsViewController {
    func showLoading() {
        channelsTableView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func showLoaded() {
        channelsTableView.isHidden = false
        loadingIndicator.stopAnimating()
    }
}
