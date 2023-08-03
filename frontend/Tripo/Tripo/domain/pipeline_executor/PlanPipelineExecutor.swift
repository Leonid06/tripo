//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation
import Combine

class PlanPipelineExecutor : BasePipelineExecutor {
    private var planCreatePipeline : PlanCreatePipeline?
    
    override init() throws {
        planCreatePipeline = try PlanCreatePipeline()
    }
 
    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<BasePipeline.PipelineJobOutput, PipelineExecutorError>) -> () )   throws -> AnyCancellable {
        
        guard let planCreatePipeline = planCreatePipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let defaultsJob = planCreatePipeline.getPlanCreateDefaultsJob()
        
        let pipeline = defaultsJob
            .flatMap {
                output -> AnyPublisher<BasePipeline.PipelineJobOutput, PipelineJobError> in

                let defaultsTaskOutput = output as BasePipeline.PipelineDefaultsTaskOutput
                
                switch defaultsTaskOutput {
                case .userCurrentToken(let token):
                    return planCreatePipeline.getPlanCreateDatabaseJob(userToken: token, planName: pipelineSchema.planName,
                        planDescription: pipelineSchema.planDescription,
                        landmarks: pipelineSchema.landmarks)
                    .map {output in BasePipeline.PipelineJobOutput(output: output)}
                    .eraseToAnyPublisher()
                case .Void:
                    return Fail(error: PipelineJobError.WrapError(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid defaults job output")))
                        .map {
                            output in BasePipeline.PipelineJobOutput(output: output)
                        }
                        .eraseToAnyPublisher()
                }
            }
            
            .eraseToAnyPublisher()
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
}
