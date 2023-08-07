//
//  PlanToUserDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore

class PlanToUserDatabaseClient : BaseDatabaseClient {
    func createPlanToUserRelationship(planRemoteId : String, userCurrentToken : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                var plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == planRemoteId)
                )
                var user = try transaction.fetchOne(
                    From<User>().where(\.$currentToken == userCurrentToken)
                )
                if let plan = plan, let user = user {
                    var planToUser = transaction.create(Into<PlanToUser>())
                    plan.planToUser.insert(planToUser)
                    user.planToUser.insert(planToUser)
                }
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func createPlanToUserRelationship(planId : UUID, userCurrentToken : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                var plan = try transaction.fetchOne(
                    From<Plan>().where(\.$identifier == planId)
                )
                var user = try transaction.fetchOne(
                    From<User>().where(\.$currentToken == userCurrentToken)
                )
                if let plan = plan, let user = user {
                    var planToUser = transaction.create(Into<PlanToUser>())
                    plan.planToUser.insert(planToUser)
                    user.planToUser.insert(planToUser)
                }
        
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }

    
    func deletePlanToUserRelationship(planRemoteId : String, userCurrentToken: String,
                                          callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                var plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == planRemoteId)
                )
                var user = try transaction.fetchOne(
                    From<User>().where(\.$currentToken == userCurrentToken)
                )
                if let plan = plan, let user = user {
                    var planToUser = try transaction.fetchOne(
                        From<PlanToUser>().where(\.$plan == plan && \.$user == user)
                    )
                    if let planToUser = planToUser {
                        plan.planToUser.remove(planToUser)
                        user.planToUser.remove(planToUser)
                    }
                }
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
        
    }
    
    func deletePlanToUserRelationship(planId : UUID, userCurrentToken: String,
                                          callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                var plan = try transaction.fetchOne(
                    From<Plan>().where(\.$identifier == planId)
                )
                var user = try transaction.fetchOne(
                    From<User>().where(\.$currentToken == userCurrentToken)
                )
                if let plan = plan, let user = user {
                    var planToUser = try transaction.fetchOne(
                        From<PlanToUser>().where(\.$plan == plan && \.$user == user)
                    )
                    if let planToUser = planToUser {
                        plan.planToUser.remove(planToUser)
                        user.planToUser.remove(planToUser)
                    }
                }
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
        
    }
}
