//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 31.07.2023.
//

import Foundation
import Combine


class PlanCreatePipeline : BasePipeline {
    
    private let landmarkHTTPService = LandmarkHTTPService()
    private var planDatabaseClient : PlanDatabaseClient?
    private var landmarkDatabaseClient : LandmarkDatabaseClient?
    private var planToLandmarkDatabaseClient : PlanToLandmarkDatabaseClient?
    private var planToUserDatabaseClient : PlanToUserDatabaseClient?
    
    override init() throws  {
        do {
            try super.init()
            planDatabaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
            landmarkDatabaseClient = try LandmarkDatabaseClient(version: MigrationUtil.currentVersion)
            planToLandmarkDatabaseClient = try PlanToLandmarkDatabaseClient(version: MigrationUtil.currentVersion)
            planToUserDatabaseClient = try PlanToUserDatabaseClient(version: MigrationUtil.currentVersion)
        }catch DatabaseClientError.differentStorageExistsAtUrl(let url) {
            print("Different storage exists at URL : \(url)")
            throw PipelineDatabaseError.PipelineDatabaseInstantiationError.InvalidDatabaseStorageProvided(url: url)
            
        }catch DatabaseClientError.internalError(let error) {
            throw PipelineDatabaseError.PipelineDatabaseInstantiationError.InternalDatabaseErrorHappened(error: error)
        }catch DatabaseClientError.unknownError {
            print("unknown database client error happened")
            throw PipelineDatabaseError.PipelineDatabaseInstantiationError.UnknownDatabaseErrorHappened
            
        }catch {
            print("unknown error happened")
            throw PipelineDatabaseError.PipelineDatabaseInstantiationError.UnknownDatabaseErrorHappened
        }
    }
    
    func getPlanCreateDefaultsJob() -> AnyPublisher<String, PipelineWrapperError> {
        return Future<String, PipelineDefaultsError>(){
            promise in
            self.doGetUserCurrentTokenTask(promise: promise)
        }.mapError {
            error in PipelineWrapperError.WrapError(error: error)
        }.eraseToAnyPublisher()
    }
    
    func getPlanCreateDatabaseJob(userToken : String?, planName: String?, planDescription : String?, landmarks : Array<PlanCreatePipelineLandmarkSchema>?) -> AnyPublisher<UUID, PipelineWrapperError> {
        return Future<UUID, PipelineDatabaseError>(){promise in
                self.doSavePlanObjectInDatabaseTask(planName: planName,
                                                    planDescription: planDescription, promise: promise)
        }
        .flatMap { planId in
            guard let landmarks = landmarks else {
                return Fail<UUID, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidObjectSchema(description: "Landmark schemas are not provided"))
                    .eraseToAnyPublisher()
            }
            let task = Empty<UUID, PipelineDatabaseError>()
            self.composeSaveLandmarksInDatabaseJob(job: task, landmarks: landmarks)
            return task.eraseToAnyPublisher()
        }
        .collect()
        .flatMap {
            output in
            
            let planId = output[0]
            let landmarkIds = Array(output[1...])
            
            guard let userToken = userToken else {
                return Fail<UUID, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidObjectSchema(description: "Access token is not provided"))
                    .eraseToAnyPublisher()
            }
            
            return self.getCreateDatabaseRelationshipsTask(currentToken: userToken, planIdentifier: planId, landmarkIdentifiers: landmarkIds)
        }
        .mapError {
            error in PipelineWrapperError.WrapError(error: error)
        }.eraseToAnyPublisher()
      
    }
    
    private func composeSaveLandmarksInDatabaseJob(job : Empty<UUID, PipelineDatabaseError>, landmarks : Array<PlanCreatePipelineLandmarkSchema>){
        landmarks.forEach {
            schema in
            _ = job.merge(with: Future(){ promise in
                guard let landmarkName = schema.name, let landmarkDescription = schema.description, let remoteId = schema.remoteId else {
                    promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid landmark schema data")))
                    return
                }
                self.doSaveLandmarkObjectInDatabaseSubtask(
                    landmarkName: landmarkName,
                    landmarkDescription: landmarkDescription,
                    remoteId: remoteId,
                    promise: promise)
            })
        }
    }
    
    private func getCreateDatabaseRelationshipsTask(currentToken: String, planIdentifier: UUID, landmarkIdentifiers : Array<UUID>) -> AnyPublisher<UUID, PipelineDatabaseError>{
        let task = Empty<UUID, PipelineDatabaseError>()
        
      
        
        landmarkIdentifiers.forEach {
            landmarkIdentifier in
            _ = task.merge(with: Future(){
                promise in
                
                guard let databaseClient = self.planToLandmarkDatabaseClient else {
                    promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                    return
                }
                
                databaseClient.createPlanToLandmarkRelationship(
                    planId: planIdentifier, landmarkId: landmarkIdentifier){
                    result in
                    switch result {
                    case .success:
                        do {
                            if let identifier = try result.get(){
                                promise(Result.success(identifier))
                            }
                           
                        } catch {
                            promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                        }
                    case .failure(let error):
                        promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                    }
                }
            })
        }
        
        return task.merge(with: Future(){
            promise in
            guard let databaseClient = self.planToUserDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            
            databaseClient.createPlanToUserRelationship(planId: planIdentifier, userCurrentToken: currentToken){
                result in
                switch result {
                case .success:
                    do {
                        if let identifier = try result.get(){
                            promise(Result.success(identifier))
                        }
                       
                    } catch {
                        promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                    }
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
            
        }).eraseToAnyPublisher()
    }
    

    
    private func doSavePlanObjectInDatabaseTask(planName : String?, planDescription : String?, promise : @escaping Future<UUID,  PipelineDatabaseError>.Promise){
        guard let databaseClient = self.planDatabaseClient else {
            promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
            return
        }
        
        guard let planName = planName, let planDescription = planDescription  else {
            promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid plan schema data")))
            return
        }
        
        databaseClient.createPlanObject(name:  planName, description: planDescription, completed: false){
            result in
            switch result {
            case .success:
                do {
                    let identifier = try result.get()
                    promise(Result.success(identifier))
                   
                } catch {
                    promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                }
                
            case .failure(let error):
                promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
            }
        }
    }
    
    private func doSaveLandmarkObjectInDatabaseSubtask(landmarkName : String, landmarkDescription : String, remoteId : String, promise : @escaping Future<UUID,  PipelineDatabaseError>.Promise){
        guard let databaseClient = self.landmarkDatabaseClient else {
            promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
            return
        }
        databaseClient.createLandmarkObject(remoteId: remoteId, name: landmarkName, description: landmarkDescription, type: "poi"){
            result in
            switch result {
            case .success:
                do {
                    let identifier = try result.get()
                    promise(Result.success(identifier))
                   
                } catch {
                    promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                }
            case .failure(let error):
                promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
            }
        }
    }
}
