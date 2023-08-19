//
//  PlanViewPipelineExecutor.swift
//  Tripo
//
//  Created by Leonid on 18.08.2023.
//

import Foundation
import Combine

class PlanViewPipelineExecutor : BasePipelineExecutor {
    private var planEditPipeline : PlanEditPipeline?
    
    override init() throws {
        planEditPipeline = try PlanEditPipeline()
    }
    func executePlanEditPipeline(schema: PlanEditPipelineSchema, completionClosure: @escaping (PipelineExecutionProduct<BasePipeline.PipelineNetworkTaskOutput, PipelineExecutorError>) -> ()) throws -> AnyCancellable {
        guard let planEditPipeline = planEditPipeline else {
            throw PipelineExecutorError.PipelineNotInitialized
        }
        
        let databaseJob = planEditPipeline.getDatabaseJob(schema: schema)
        let networkJob = planEditPipeline.getNetworkJob(schema: schema)
        let pipelineCancellable = databaseJob.flatMap {
            _ in networkJob
        }.sink(receiveCompletion: {
            completion in 
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



