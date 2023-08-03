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
 
    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<BasePipeline.PipelineJobOutput, PipelineExecutorError>) -> ()) throws {
        
        guard let planCreatePipeline = planCreatePipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let defaultsJob = planCreatePipeline.getPlanCreateDefaultsJob()
        
        let pipeline = defaultsJob
            .flatMap {
                output in

//                guard let token = (output as? BasePipeline.PipelineDefaultsTaskOutput).userCurrentToken else {
//                    return Fail<BasePipeline.PipelineJobOutput, PipelineOutputError>(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid defaults job output"))
//                        .mapError {error in PipelineJobError.WrapError(error: error)}
//                        .eraseToAnyPublisher()
//                }
                
//                return Fail<BasePipeline.PipelineJobOutput, PipelineJobError>(error: PipelineJobError.WrapError(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid defaults job output")) )
//                    .eraseToAnyPublisher()

                return planCreatePipeline.getPlanCreateDatabaseJob(userToken: "", planName: pipelineSchema.planName,
                    planDescription: pipelineSchema.planDescription,
                    landmarks: pipelineSchema.landmarks)
            }
            .map {
                output in BasePipeline.PipelineJobOutput(output: output)
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
    }
}
