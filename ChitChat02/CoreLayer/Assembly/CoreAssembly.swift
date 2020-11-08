//
//  CoreAssembly.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var storage: IStorage { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var storage: IStorage = NewSchoolStorage()
}
