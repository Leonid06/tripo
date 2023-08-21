//
//  PlanFetchPipeline.swift
//  Tripo
//
//  Created by Leonid on 10.08.2023.
//

import Foundation
import Combine

class PlanFetchPipeline : BasePipeline {
    internal var planToUserDatabaseClient : PlanToUserDatabaseClient?
    
    override init() throws  {
        do {
            try super.init()
            self.planToUserDatabaseClient = try PlanToUserDatabaseClient(version: MigrationUtil.currentVersion)
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
    
    func getDefaultsJob() -> AnyPublisher<PipelineDefaultsTaskOutput, PipelineJobError> {
        return getProvideUserCurrentTokenTask().mapError {
            error in PipelineJobError.WrapError(error: error)
        }.eraseToAnyPublisher()
    }
    
    func getDatabaseJob(userToken : String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineJobError> {
        return getFetchAllPlansByUserTokenTask(userToken: userToken)
            .flatMap {
                output in
                
                let downcastedOutput = output as PipelineDatabaseTaskOutput
                
                switch downcastedOutput {
                case .PlanToUserRelationshipArray(let relationships):
                    return self.getPlanFetchResultMapTask(relationships: relationships)
                default:
                    return Fail<PipelineDatabaseTaskOutput, PipelineDatabaseError>(error: PipelineDatabaseError.InvalidUpstreamTaskOutput(description: "invalid FetchAllPlansByUserTokenTask output"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
            .mapError {error in PipelineJobError.WrapError(error: error)}
            .eraseToAnyPublisher()
        }
}
