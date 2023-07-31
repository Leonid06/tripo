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
 
    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<UUID, PipelineExecutorError>) -> ()) throws {
        
        guard let planCreatePipeline = planCreatePipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let defaultsJob = planCreatePipeline.getPlanCreateDefaultsJob()
        
        let pipeline = defaultsJob
            .flatMap {
                token in
                planCreatePipeline.getPlanCreateDatabaseJob(userToken: token,planName: pipelineSchema.planName,
                                                            planDescription: pipelineSchema.planDescription,
                                                            landmarks: pipelineSchema.landmarks)
            }.eraseToAnyPublisher()
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
