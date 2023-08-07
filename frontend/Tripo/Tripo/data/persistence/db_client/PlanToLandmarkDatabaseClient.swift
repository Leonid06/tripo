//
//  PlanToLandmarkDatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore


class PlanToLandmarkDatabaseClient : BaseDatabaseClient {
    func createPlanToLandmarkRelationship(planRemoteId : String, landmarkRemoteId : String, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == planRemoteId)
                )
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$remoteId == landmarkRemoteId)
                )
                if let plan = plan, let landmark = landmark {
                    let planToLandmark = transaction.create(Into<PlanToLandmark>())
                    plan.planToLandmark.insert(planToLandmark)
                    landmark.planToLandmark.insert(planToLandmark)
                }
                
        
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func createPlanToLandmarkRelationship(planId : UUID, landmarkId: UUID, callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$identifier == planId)
                )
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$identifier == landmarkId)
                )
                if let plan = plan, let landmark = landmark {
                    var planToLandmark = transaction.create(Into<PlanToLandmark>())
                    plan.planToLandmark.insert(planToLandmark)
                    landmark.planToLandmark.insert(planToLandmark)
                }
        
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
    }
    
    func deletePlanToLandmarkRelationship(planRemoteId : String, landmarkRemoteId : String,
                                          callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$remoteId == planRemoteId)
                )
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$remoteId == landmarkRemoteId)
                )
                if let plan = plan, let landmark = landmark {
                    let planToLandmark = try transaction.fetchOne(
                        From<PlanToLandmark>().where(\.$plan == plan && \.$landmark == landmark)
                    )
                    
                    if let planToLandmark = planToLandmark {
                        plan.planToLandmark.remove(planToLandmark)
                        landmark.planToLandmark.remove(planToLandmark)
                    }
                }
        
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
        
    }
    
    func deletePlanToLandmarkRelationship(planId : UUID, landmarkId : UUID,
                                          callback : @escaping (AsynchronousDataTransaction.Result<Void>) -> ()){
        makeAsyncTransaction(async_db_interaction_closure: {
            transaction -> () in
            do {
                let plan = try transaction.fetchOne(
                    From<Plan>().where(\.$identifier == planId)
                )
                let landmark = try transaction.fetchOne(
                    From<Landmark>().where(\.$identifier == landmarkId)
                )
                if let plan = plan, let landmark = landmark {
                    let planToLandmark = try transaction.fetchOne(
                        From<PlanToLandmark>().where(\.$plan == plan && \.$landmark == landmark)
                    )
                    
                    if let planToLandmark = planToLandmark {
                        plan.planToLandmark.remove(planToLandmark)
                        landmark.planToLandmark.remove(planToLandmark)
                    }
                }
        
            } catch {
                throw CoreStoreError(error)
            }
        }, async_callback_closure: callback)
        
    }
}
