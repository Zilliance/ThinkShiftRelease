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
    
    private(set) var stressors: Results<Stressor>!
    
    init() {
        do {
            
            let config = Realm.Configuration(
                schemaVersion: 5,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 2) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
            })
            
            Realm.Configuration.defaultConfiguration = config
            
            self.realm = try Realm()
            
            stressors = self.realm.objects(Stressor.self)
            
            if let user = self.realm.objects(User.self).first
            {
                self.user = user
            }
            else
            {
                //first time launch, let's prepare the DB
                self.bootstrap()
            }
            
            
        } catch {
            print("realm initialization failed, aborting", error)
        }
    }
    
    fileprivate func bootstrap() {
        self.bootstrapUser()
        //todo: bootstrap rest of model if necessary
    }

    fileprivate func bootstrapUser() {
        guard self.realm.objects(User.self).count == 0 else {
            return
        }
        
        let user = User()
        
        add(realmObject: user)
        
        self.user = user
    }
    
}

//realm storage methods
extension Database {
    
    func save(storeLogic: () -> ()) {
        do {
            try realm.write(storeLogic)
        }
        catch let error {
            print(error)
        }
    }
    
    func delete(_ object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        }
        catch let error {
            print(error)
        }
    }
    
    func add(realmObject: Object, update: Bool = false) {
        do {
            try realm.write({
                realm.add(realmObject, update: update)
            })
        }
        catch let error {
            print(error)
        }
    }
    
}
