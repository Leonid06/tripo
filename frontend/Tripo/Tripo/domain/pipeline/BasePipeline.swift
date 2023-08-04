//
//  BasePipeline.swift
//  Tripo
//
//  Created by Leonid on 31.07.2023.
//

import Foundation
import Combine

protocol PipelineOutput {
    
}

class BasePipeline  {
    
    struct PipelineJobOutput {
        var output : PipelineOutput
    }
    
        enum PipelineDatabaseTaskOutput : PipelineOutput {
            case Void
            case LandmarkUUID(identifier : UUID)
            case PlanUUID(identifier : UUID)
            case PlanToLandmarkUUID(identifier: UUID)
            case PlanToUserUUID(identifier: UUID)
        }
        
        enum PipelineDefaultsTaskOutput : PipelineOutput {
            case Void
            case userCurrentToken(token : String)
        }
        
        enum PipelineNetworkTaskOutput : PipelineOutput {
            case Void
            case PlanRemoteId(remoteId: String)
            case mappedPlanCreateHTTPRequestParameters(parameters: ManualPlanCreateRequestParameters)
        }
    
    internal let defaultsService = DefaultsService()
    init() throws {
        
    }
    
    internal func getProvideUserCurrentTokenTask() -> AnyPublisher<PipelineDefaultsTaskOutput, PipelineDefaultsError>{
        let task = Future<PipelineDefaultsTaskOutput, PipelineDefaultsError>(){
            promise in
            guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
                promise(Result.failure(PipelineDefaultsError.InvalidDefaultsKey))
                return
            }
            
            guard let token = self.defaultsService.getValueForKey(key) else {
                promise(Result.failure(PipelineDefaultsError.InvalidValueByDefaultsKey(key: key)))
                return
            }
            
            guard let downcastedToken = token as? String else {
                promise(Result.failure(PipelineDefaultsError.NoValueByDefaultsKey(key: key)))
                return
            }
            
            promise(Result.success(PipelineDefaultsTaskOutput.userCurrentToken(token: downcastedToken)))
        }
        return task.eraseToAnyPublisher()
    }
}
