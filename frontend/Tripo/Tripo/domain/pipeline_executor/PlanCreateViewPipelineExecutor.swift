//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation
import Combine

class PlanCreateViewPipelineExecutor : BasePipelineExecutor {
    private var planCreatePipeline : PlanCreatePipeline?
    private var landmarkSearchPipeline : LandmarkSearchPipeline?
    
    override init() throws {
        planCreatePipeline = try PlanCreatePipeline()
        landmarkSearchPipeline = try LandmarkSearchPipeline()
    }
    
    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<BasePipeline.PipelineNetworkTaskOutput, PipelineExecutorError>) -> () ) throws -> AnyCancellable {
        
        guard let planCreatePipeline = planCreatePipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let defaultsJob = planCreatePipeline.getDefaultsJob()

        
        let pipeline = defaultsJob
            .flatMap {
                output in
                
                let defaultsTaskOutput = output as BasePipeline.PipelineDefaultsTaskOutput
                
                switch defaultsTaskOutput {
                case .userCurrentToken(let token):
                    return planCreatePipeline.getDatabaseJob(userToken: token, planName: pipelineSchema.planName,
                        planDescription: pipelineSchema.planDescription,
                        landmarks: pipelineSchema.landmarks)
                    .eraseToAnyPublisher()
                case .Void:
                    return Fail(error: PipelineJobError.WrapError(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid defaults job output")))
                        .eraseToAnyPublisher()
                }
            }
            .flatMap {
                output in
                return planCreatePipeline.getNetworkJob(planName: pipelineSchema.planName, planDescription: pipelineSchema.planDescription, landmarks: pipelineSchema.landmarks)
                    .eraseToAnyPublisher()
            }

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
