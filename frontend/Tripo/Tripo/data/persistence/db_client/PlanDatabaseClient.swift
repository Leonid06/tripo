//
//  PlanDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore


class PlanDatabaseClient : BaseDatabaseClient {
    func createPlanObject(remoteId : String? = nil, name : String, description : String, completed : Bool, callback : @escaping (AsynchronousDataTransaction.Result<UUID>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> (UUID) in
            let plan = transaction.create(Into<Plan>())
            if let remoteId = remoteId {
                plan.remoteId = remoteId
            }
            plan.name = name
            plan.planDescription = description
            plan.completed = completed
            
            return plan.identifier
            
            
        }, async_callback_closure: callback)
    }
    
    func updatePlanObject(identifier: UUID, name: String? = nil, description: String? = nil, remoteId: String?, completed : Bool?, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()) {
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            let plan = try transaction.fetchOne(
                From<Plan>().where(\.$identifier == identifier)
            )
            if let name = name {
                plan?.name = name
            }
            if let description = description {
                plan?.planDescription = description
            }
            if let remoteId = remoteId {
                plan?.remoteId = remoteId
            }
            if let completed = completed {
                plan?.completed = completed
            }
        }, async_callback_closure: callback)
    }
    
    func getPlanObjectByRemoteId(remoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Plan?>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction  -> Plan? in
            
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == remoteId)
                )
                return plan
            } catch {
                throw CoreStoreError(error)
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
                if let plan = plan {
                    plan.remoteId = newRemoteId
                }
            } catch  {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func updatePlanObjectRemoteId(id : UUID, remoteId : String,
      callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$identifier == id)
                )
                if let plan = plan {
                    plan.remoteId = remoteId
                }
            } catch  {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func deletePlanObject(remoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                try transaction.deleteAll(
                    From<Plan>().where(\.$remoteId == remoteId)
                )
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func deletePlanObject(identifier: UUID, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                try transaction.deleteAll(
                    From<Plan>().where(\.$identifier == identifier)
                )
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
}
