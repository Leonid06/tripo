//
//  HomeViewPipelineExecutor.swift
//  Tripo
//
//  Created by Leonid on 10.08.2023.
//

import Foundation
import Combine



class HomeViewPipelineExecutor : BasePipelineExecutor {
    private var planFetchPipeline : PlanFetchPipeline?
    
    override init() throws {
        planFetchPipeline = try PlanFetchPipeline()
    }
    func executeFetchAllLandmarksByCurrentUserPipeline(completionClosure: @escaping (PipelineExecutionProduct<BasePipeline.PipelineDatabaseTaskOutput, PipelineExecutorError>) -> ()) throws -> AnyCancellable {
        guard let pipeline = planFetchPipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let defaultsJob = pipeline.getDefaultsJob()
        
        let pipelineCancellable = defaultsJob
            .flatMap {
                output in
                let defaultsTaskOutput = output as BasePipeline.PipelineDefaultsTaskOutput
                
                switch defaultsTaskOutput {
                case .userCurrentToken(let token):
                    return pipeline.getDatabaseJob(userToken: token)
                        .eraseToAnyPublisher()
                case .Void:
                    return Fail(error: PipelineJobError.WrapError(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid defaults job output")))
                        .eraseToAnyPublisher()
                }
            }.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    completionClosure(PipelineExecutionProduct.Failure(failure: PipelineExecutorError.PipelineExecutionFailed(error: error)))
                default:
                    return
                }
            }, receiveValue: { output in
                completionClosure(PipelineExecutionProduct.Success(output: output))
            })
        return pipelineCancellable
    }
}
