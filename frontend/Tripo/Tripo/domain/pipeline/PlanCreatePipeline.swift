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
    
    override init() throws  {
        do {
            try super.init()
            planDatabaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
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
    
    func getPlanCreateDatabaseJob(userToken : String?, planName: String?, planDescription : String?, landmarks : Array<PlanCreatePipelineLandmarkSchema>?) -> AnyPublisher<Void, PipelineWrapperError> {
        return Future<Void, PipelineDatabaseError>(){promise in
                self.doSavePlanObjectInDatabaseTask(planName: planName,
                                                    planDescription: planDescription, promise: promise)
        }.flatMap {
            guard let landmarks = landmarks else {
                return Fail<Void, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidObjectSchema(description: "Landmark schemas are not provided"))
                    .eraseToAnyPublisher()
            }
            let task = Empty<Void, PipelineDatabaseError>()
            self.composeSaveLandmarksInDatabaseJob(job: task, landmarks: landmarks)
            return task.eraseToAnyPublisher()
        }.mapError {
            error in PipelineWrapperError.WrapError(error: error)
        }.eraseToAnyPublisher()
    }
    
    private func composeSaveLandmarksInDatabaseJob(job : Empty<Void, PipelineDatabaseError>, landmarks : Array<PlanCreatePipelineLandmarkSchema>){
        landmarks.forEach {
            schema in
            _ = job.merge(with: Future(){ promise in
                guard let landmarkName = schema.name, let landmarkDescription = schema.description, let remoteId = schema.remoteId else {
                    promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid landmark schema data")))
                    return
                }
                self.doSaveLandmarkObjectInDatabaseTask(
                    landmarkName: landmarkName,
                    landmarkDescription: landmarkDescription,
                    remoteId: remoteId,
                    promise: promise)
            })
        }
    }
    

    
    private func doSavePlanObjectInDatabaseTask(planName : String?, planDescription : String?, promise : @escaping Future<Void,  PipelineDatabaseError>.Promise){
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
                promise(Result.success(()))
            case .failure(let error):
                promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
            }
        }
    }
    
    private func doSaveLandmarkObjectInDatabaseTask(landmarkName : String, landmarkDescription : String, remoteId : String, promise : @escaping Future<Void,  PipelineDatabaseError>.Promise){
        guard let databaseClient = self.landmarkDatabaseClient else {
            promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
            return
        }
        databaseClient.createLandmarkObject(remoteId: remoteId, name: landmarkName, description: landmarkDescription, type: "poi"){
            result in
            switch result {
            case .success:
                promise(Result.success(()))
            case .failure(let error):
                promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
            }
        }
    }
}
