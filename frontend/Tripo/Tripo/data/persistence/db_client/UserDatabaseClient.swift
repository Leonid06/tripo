//
//  UserDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore


class UserDatabaseClient : BaseDatabaseClient {
    func createUserObject(currentToken: String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            let user = transaction.create(Into<User>())
            user.currentToken = currentToken
            
        }, async_callback_closure: callback)
    }
    
    func updateUserObjectToken(oldToken : String, newToken : String,
      callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let user = try transaction.fetchOne(
                    From<User>().where(\.$currentToken == oldToken)
                )
                if let user = user {
                    user.currentToken = newToken
                }
                
            } catch  {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func deleteUserObjectByCurrentToken(currentToken: String,  callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                try transaction.deleteAll(
                    From<User>().where(\.$currentToken == currentToken)
                )
            } catch  {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
}
