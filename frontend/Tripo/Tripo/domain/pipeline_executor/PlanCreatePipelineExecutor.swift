//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation
import Combine

class PlanCreatePipelineExecutor : BasePipelineExecutor {
    private let landmarkHTTPService = LandmarkHTTPService()
    private let defaultsService = DefaultsService()
    private var planDatabaseClient : PlanDatabaseClient?
    private var landmarkDatabaseClient : LandmarkDatabaseClient?
    
    
    override init() throws  {
        do {
            try super.init()
            planDatabaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
        }catch DatabaseClientError.differentStorageExistsAtUrl(let url) {
            print("Different storage exists at URL : \(url)")
            throw PipelineExecutorError.DatabaseClientInitializationFailed
            
        }catch DatabaseClientError.internalError(let error) {
            print("Internal database client error happened : \(error)")
            throw PipelineExecutorError.DatabaseClientInitializationFailed
        }catch DatabaseClientError.unknownError {
            print("unknown database client error happened")
            throw PipelineExecutorError.DatabaseClientInitializationFailed
            
        }catch {
            print("unknown error happened")
            throw PipelineExecutorError.DatabaseClientInitializationFailed
        }
    }
    
    private func doSavePlanObjectInDatabaseTask(planName : String?, planDescription : String?, promise : @escaping Future<Void,  PipelineExecutorError>.Promise){
        guard let databaseClient = self.planDatabaseClient else {
            promise(Result.failure(PipelineExecutorError.PipelineExecutionError(description: "Database client is not initialized")))
            return
        }
        
        guard let planName = planName, let planDescription = planDescription  else {
            promise(Result.failure(PipelineExecutorError.PipelineExecutionError(description: "Invalid plan schema data")))
            return 
        }
        
        databaseClient.createPlanObject(name:  planName, description: planDescription, completed: false){
            result in
            switch result {
            case .success:
                promise(Result.success(()))
            case .failure(let error):
                promise(Result.failure(PipelineExecutorError.DatabaseRequestFailed(error: error)))
            }
        }
    }
    
    private func doSaveLandmarkObjectInDatabaseTask(landmarkName : String, landmarkDescription : String, remoteId : String, promise : @escaping Future<Void,  PipelineExecutorError>.Promise){
        guard let databaseClient = self.landmarkDatabaseClient else {
            promise(Result.failure(PipelineExecutorError.PipelineExecutionError(description: "Database client is not initialized")))
            return
        }
        databaseClient.createLandmarkObject(remoteId: remoteId, name: landmarkName, description: landmarkDescription, type: "poi"){
            result in
            switch result {
            case .success:
                promise(Result.success(()))
            case .failure(let error):
                promise(Result.failure(PipelineExecutorError.DatabaseRequestFailed(error: error)))
            }
        }
    }
    
    
    private func doGetUserCurrentTokenTask(promise: @escaping Future<String, PipelineExecutorError>.Promise){
        guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
            promise(Result.failure(PipelineExecutorError.InvalidDefaultsKey))
            return
        }
        
        guard let token = defaultsService.getValueForKey(key) else {
            promise(Result.failure(PipelineExecutorError.InvalidValueByDefaultsKey(key: key)))
            return
        }
        
        guard let downcastedToken = token as? String else {
            promise(Result.failure(PipelineExecutorError.NoValueByDefaultsKey(key: key)))
            return
        }
        
        promise(Result.success(downcastedToken))
     
    }
    
    private func composeSaveLandmarksInDatabaseJob(job : Empty<Void, PipelineExecutorError>, landmarks : Array<PlanCreatePipelineLandmarkSchema>){
        landmarks.forEach {
            schema in
            _ = job.merge(with: Future<Void, PipelineExecutorError>(){ promise in
                guard let landmarkName = schema.name, let landmarkDescription = schema.description, let remoteId = schema.remoteId else {
                    promise(Result.failure(PipelineExecutorError.PipelineExecutionError(description: "Invalid landmark schema data")))
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
    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<Void, PipelineExecutorError>) -> ()) throws {

        let pipeline = Future<String, PipelineExecutorError>(){
            promise in self.doGetUserCurrentTokenTask(promise: promise)
        }.flatMap { token in
            let job = Future<Void, PipelineExecutorError>(){ promise in
                self.doSavePlanObjectInDatabaseTask(planName: pipelineSchema.planName,
                                                    planDescription: pipelineSchema.planDescription, promise: promise)
            }
            return job.eraseToAnyPublisher()
        }.flatMap {
            guard let landmarks = pipelineSchema.landmarks else {
                return Fail<Void, PipelineExecutorError>(error: PipelineExecutorError.PipelineExecutionError(description: "Landmark schemas are not provided"))
                    .eraseToAnyPublisher()
            }
            let job = Empty<Void, PipelineExecutorError>()
            self.composeSaveLandmarksInDatabaseJob(job: job, landmarks: landmarks)
            return job.eraseToAnyPublisher()
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let failure):
                completionClosure(PipelineExecutionProduct.Failure(failure: failure))
            default:
                return
            }
        }, receiveValue: { output in
            completionClosure(PipelineExecutionProduct.Success(output: output))
        })
        pipeline.cancel()
    }
}
