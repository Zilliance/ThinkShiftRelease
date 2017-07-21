//
//  Database.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/20/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    static let shared = Database()
    
    private(set) var realm: Realm!
    fileprivate(set) var user: User!

}
