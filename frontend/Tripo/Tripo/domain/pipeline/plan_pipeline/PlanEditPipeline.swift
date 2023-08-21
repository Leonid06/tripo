//
//  PlanEditPipeline.swift
//  Tripo
//
//  Created by Leonid on 18.08.2023.
//

import Foundation
import Combine

class PlanEditPipeline : BasePipeline {
    internal var planDatabaseClient : PlanDatabaseClient?
    internal var planHTTPClient = PlanHTTPService()
    
    override init() throws  {
        do {
            try super.init()
            self.planDatabaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
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
    
    func getDatabaseJob(schema: PlanEditPipelineSchema) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineJobError> {
        return getSavePlanEditInLocalDatabaseTask(schema: schema)
            .mapError {error in PipelineJobError.WrapError(error: error)}
            .eraseToAnyPublisher()
    }
    
    func getNetworkJob(schema: PlanEditPipelineSchema) ->
    AnyPublisher<PipelineNetworkTaskOutput, PipelineJobError> {
        return getSavePlanEditInRemoteDatabaseTask(schema: schema)
            .mapError {error in PipelineJobError.WrapError(error: error)}
            .eraseToAnyPublisher()
    }
    
    
}
