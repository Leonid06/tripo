//
//  LandmarkDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore

class LandmarkDatabaseClient : BaseDatabaseClient {
    func createLandmarkObject(remoteId : String? = nil, name : String, description : String, type : String, callback : @escaping (AsynchronousDataTransaction.Result<UUID>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> (UUID) in
            let landmark = transaction.create(Into<Landmark>())
            if let remoteId = remoteId {
                landmark.remoteId = remoteId
            }
            landmark.name = name
            landmark.landmarkDescription = description
            landmark.type = type
            
            return landmark.identifier
        
            
        }, async_callback_closure: callback)
    }
    
    func updateLandmark(identifier: UUID, name: String? = nil, description: String? = nil, remoteId: String? = nil, type : String? = nil, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()) {
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            let landmark = try transaction.fetchOne(
                From<Landmark>().where(\.$identifier == identifier)
            )
            if let name = name {
                landmark?.name = name
            }
            if let description = description {
                landmark?.landmarkDescription = description
            }
            if let remoteId = remoteId {
                landmark?.remoteId = remoteId
            }
            if let type = type {
                landmark?.type = type
            }
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
            } catch  {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func updateLandmarkObjectRemoteId(id : UUID, remoteId : String,
      callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$identifier == id)
                )
                if let landmark = landmark {
                    landmark.remoteId = remoteId
                }
            } catch {
                throw CoreStoreError(error)
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
                if let landmark = landmark {
                    landmark.remoteId = newRemoteId
                }
            } catch {
                throw CoreStoreError(error)
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
            } catch  {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
}
