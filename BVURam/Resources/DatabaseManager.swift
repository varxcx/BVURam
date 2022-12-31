//
//  DatabaseManager.swift
//  BVURam
//
//  Created by Vardhan Chopada on 12/22/22.
//

import FirebaseDatabase


public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: - Public
    
    ///Check if Username and email is available
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping(Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username], withCompletionBlock: { error, _ in
            if error == nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        })
    }
    
}
