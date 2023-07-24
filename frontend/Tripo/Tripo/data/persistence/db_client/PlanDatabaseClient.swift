//
//  PlanDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore


class PlanDatabaseClient : BaseDatabaseClient {
    func createPlanObject(remoteId : String, name : String, description : String, completed : Bool, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            let plan = transaction.create(Into<Plan>())
            plan.$remoteId = remoteId
            plan.$name = name
            plan.$description = description
            plan.$completed = completed
            
        }, async_callback_closure: callback)
    }
    
    func getPlanObjectByRemoteId(remoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Plan?>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> Plan? in
            
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == remoteId)
                )
                return plan
            } catch CoreStoreError(let error) {
                throw CoreStoreError(error: error)
            }
        }, async_callback_closure: callback)
    }
    
    func updatePlanObjectRemoteId(oldRemoteId : String, newRemoteId : String,
      callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == oldRemoteId)
                )
                plan.$remoteId = newRemoteId
            } catch CoreStoreError(let error) {
                throw CoreStoreError(error: error)
            }
        }, async_callback_closure: callback)
    }
    
    func deletePlanObjectByRemoteId(remoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                try transaction.deleteAll(
                    From<Plan>().where(\.$remoteId == remoteId)
                )
            } catch CoreStoreError(let error) {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
}
