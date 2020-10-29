//
//  FirestoreDataManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

// после многочисленных рефакторингов здесь ничего не осталось
// пусть будет на будущее
// может можно логи тут слушать или ещё что-нибудь
class FirestoreDataManager {
    lazy var db = Firestore.firestore()
}
