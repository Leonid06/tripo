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
    
    func getPlanCreateDefaultsJob() -> AnyPublisher<PipelineDefaultsTaskOutput, PipelineJobError> {
        return getProvideUserCurrentTokenTask().mapError {
            error in PipelineJobError.WrapError(error: error)
        }.eraseToAnyPublisher()
    }
    
    func getPlanCreateDatabaseJob(userToken : String?, planName: String?, planDescription : String?, landmarks : Array<PlanCreatePipelineLandmarkSchema>?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineJobError> {
        return getSavePlanObjectInDatabaseTask(planName: planName, planDescription: planDescription)
            .flatMap { output in
                guard let landmarks = landmarks else {
                    return Fail<PipelineDatabaseTaskOutput, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidObjectSchema(description: "Landmark schemas are not provided"))
                        .eraseToAnyPublisher()
                }
                return self.getSaveLandmarksInDatabaseTask(landmarks: landmarks)
            }
            .collect().flatMap {
                outputs in
                guard let userToken = userToken else {
                    return Fail<PipelineDatabaseTaskOutput, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidObjectSchema(description: "Access token is not provided"))
                        .eraseToAnyPublisher()
                }
                
                let outputArray = outputs as Array<PipelineDatabaseTaskOutput>
                
                
                var planIdentifier : UUID?
                var landmarkIdentifiers = Array<UUID>()
                
                outputArray.forEach { output in
                    switch output {
                    case .PlanUUID(let identifier):
                        planIdentifier = identifier
                    case .LandmarkUUID(let identifier):
                        landmarkIdentifiers.append(identifier)
                    default:
                        return
                    }
                    
                }

                guard let planIdentifier = planIdentifier, !landmarkIdentifiers.isEmpty else {
                    return Fail<PipelineDatabaseTaskOutput, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidUpstreamTaskOutput(description: "invalid landmark and plan  upstream db task outputs"))
                        .eraseToAnyPublisher()
                }
                return self.getCreateDatabaseRelationshipsTask(currentToken: userToken, planIdentifier: planIdentifier, landmarkIdentifiers: landmarkIdentifiers)
            }.mapError {error in PipelineJobError.WrapError(error: error)}
            .eraseToAnyPublisher()
        }
        private func getSaveLandmarksInDatabaseTask(landmarks: Array<PlanCreatePipelineLandmarkSchema>) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError>{
            let task = Empty<PipelineDatabaseTaskOutput, PipelineDatabaseError>()
            landmarks.forEach {
                schema in
                _ = task.merge(with:
                                self.getSaveLandmarksObjectInDatabaseSubtask(
                                    landmarkName: schema.name,
                                    landmarkDescription: schema.description,
                                    remoteId: schema.remoteId))
            }
            
            return task.eraseToAnyPublisher()
        }
        
        private func getCreateDatabaseRelationshipsTask(currentToken: String, planIdentifier: UUID, landmarkIdentifiers : Array<UUID>) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError>{
            let task = Empty<PipelineDatabaseTaskOutput, PipelineDatabaseError>()
            
            
            
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
                                promise(Result.success(PipelineDatabaseTaskOutput.Void))
                            case .failure(let error):
                                promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                            }
                        }
                }.eraseToAnyPublisher())
            }
            
            return task.eraseToAnyPublisher().merge(with: Future(){
                promise in
                guard let databaseClient = self.planToUserDatabaseClient else {
                    promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                    return
                }
                
                databaseClient.createPlanToUserRelationship(planId: planIdentifier, userCurrentToken: currentToken){
                    result in
                    switch result {
                    case .success:
                        promise(Result.success(PipelineDatabaseTaskOutput.Void))
                    case .failure(let error):
                        promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                    }
                }
                
            }.eraseToAnyPublisher())
            .eraseToAnyPublisher()
        }
        
        private func getSavePlanObjectInDatabaseTask(planName : String?, planDescription : String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
            Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>(){promise in
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
                            promise(Result.success(PipelineDatabaseTaskOutput.PlanUUID(identifier: identifier)))
                            
                        } catch {
                            promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                        }
                        
                    case .failure(let error):
                        promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        
        private func getSaveLandmarksObjectInDatabaseSubtask(landmarkName : String?, landmarkDescription : String?, remoteId : String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError>{
            let subtask = Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>(){ promise in
                guard let landmarkName = landmarkName, let landmarkDescription = landmarkDescription, let remoteId = remoteId else {
                    promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid landmark schema data")))
                    return
                }
                
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
                            promise(Result.success(PipelineDatabaseTaskOutput.LandmarkUUID(identifier: identifier)))
                            
                        } catch {
                            promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                        }
                    case .failure(let error):
                        promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                    }
                }
            }
            return subtask.eraseToAnyPublisher()
        }
    }

