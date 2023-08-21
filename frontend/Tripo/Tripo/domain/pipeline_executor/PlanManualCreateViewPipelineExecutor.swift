//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation
import Combine

class PlanManualCreateViewPipelineExecutor : BasePipelineExecutor {
    internal var planCreatePipeline : PlanManualCreatePipeline?
    internal var landmarkSearchPipeline : LandmarkSearchPipeline?
    
    override init() throws {
        planCreatePipeline = try PlanManualCreatePipeline()
        landmarkSearchPipeline = try LandmarkSearchPipeline()
    }
    
    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<BasePipeline.PipelineDatabaseTaskOutput, PipelineExecutorError>) -> () ) throws -> AnyCancellable {
        
        guard let planCreatePipeline = planCreatePipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let savePlanInLocalDatabaseGroup = getSaveEntitiesGroup(
            pipeline: planCreatePipeline,
            planName: pipelineSchema.planName,
            planDescription: pipelineSchema.planDescription,
            landmarks: pipelineSchema.landmarks)
        
        let pipeline = savePlanInLocalDatabaseGroup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    completionClosure(PipelineExecutionProduct.Failure(failure: PipelineExecutorError.PipelineExecutionFailed(error: error)))
                default:
                    return
                }
            }, receiveValue: { output in
                completionClosure(PipelineExecutionProduct.Success(output: output))
            })
        
        return pipeline
    }
    
    
    func executeSearchLandmarkPipeline(pipelineSchema: LandmarkSearchPipelineSchema, completionClosure : @escaping (PipelineExecutionProduct<BasePipeline.PipelineNetworkTaskOutput, PipelineExecutorError>) -> ()) throws -> AnyCancellable {
        guard let landmarkSearchPipeline = landmarkSearchPipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let networkJob = landmarkSearchPipeline.getNetworkJob(pipelineSchema: pipelineSchema)
        
        let pipeline = networkJob.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                completionClosure(PipelineExecutionProduct.Failure(failure: PipelineExecutorError.PipelineExecutionFailed(error: error)))
            default:
                return
            }
        }, receiveValue: { output in
            completionClosure(PipelineExecutionProduct.Success(output: output))
        })
        
        return pipeline
    }
}
