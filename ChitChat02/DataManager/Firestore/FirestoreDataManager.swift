//
//  FirestoreDataManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreDelegate {
    func snapshot(_ snapshot: QuerySnapshot)
}

class FirestoreDataManager {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    var delegate: FirestoreDelegate?
    
    init() {
        reference.addSnapshotListener { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            self?.delegate?.snapshot(snapshot)
        }
    }
}
