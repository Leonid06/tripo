//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 31.07.2023.
//

import Foundation
import Combine


class PlanCreatePipeline : BasePipeline {
    
    internal let landmarkHTTPService = LandmarkHTTPService()
    internal var planDatabaseClient : PlanDatabaseClient?
    internal var landmarkDatabaseClient : LandmarkDatabaseClient?
    internal var planToLandmarkDatabaseClient : PlanToLandmarkDatabaseClient?
    internal var planToUserDatabaseClient : PlanToUserDatabaseClient?
    
    internal var planHTTPClient = PlanHTTPService()
    
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
    
    func getPlanCreateNetworkJob(planName: String?, planDescription: String?, landmarks : Array<PlanCreatePipelineLandmarkSchema>?) -> AnyPublisher<PipelineNetworkTaskOutput, PipelineJobError> {
        return getMapCreatePlanHTTPRequestParametersTask(planName: planName, planDescription: planDescription, landmarks: landmarks)
            .flatMap {
                output in
                switch output {
                case .mappedPlanCreateHTTPRequestParameters(let parameters):
                    return self.getMakeCreatePlanHTTPRequestTask(parameters: parameters)
                default:
                    return Fail<PipelineNetworkTaskOutput, PipelineNetworkError>(error: PipelineNetworkError.InvalidUpstreamTaskOutput(description: "Invalid map create plan http request parameters task output"))
                        .eraseToAnyPublisher()
                }
            }.mapError {
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
        
    }

