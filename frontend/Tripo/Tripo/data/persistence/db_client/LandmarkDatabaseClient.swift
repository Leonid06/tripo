//
//  LandmarkDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore

class LandmarkDatabaseClient : BaseDatabaseClient {
    func createLandmarkObject(remoteId : String, name : String, description : String, type : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            let landmark = transaction.create(Into<Landmark>())
            landmark.$remoteId = remoteId
            landmark.$name = name
            landmark.$description = description
            landmark.$type = type
            
        }, async_callback_closure: callback)
    }
    
    func getLandmarkObjectByRemoteId(remoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Landmark?>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> Landmark? in
            
            do {
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$remoteId == remoteId)
                )
                return landmark
            } catch CoreStoreError(let error) {
                throw CoreStoreError(error: error)
            }
        }, async_callback_closure: callback)
    }
    
    func updateLandmarkObjectRemoteId(oldRemoteId : String, newRemoteId : String,
      callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$remoteId == oldRemoteId)
                )
                landmark.$remoteId = newRemoteId
            } catch CoreStoreError(let error) {
                throw CoreStoreError(error: error)
            }
        }, async_callback_closure: callback)
    }
    
    func deleteLandmarkObjectByRemoteId(remoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                try transaction.deleteAll(
                    From<Landmark>().where(\.$remoteId == remoteId)
                )
            } catch CoreStoreError(let error) {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
}
