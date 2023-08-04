//
//  PlanSearchPipeline.swift
//  Tripo
//
//  Created by Leonid on 04.08.2023.
//

import Foundation
import Combine


class LandmarkSearchPipeline : BasePipeline {
    internal let landmarkHTTPClient = LandmarkHTTPService()
    func getNetworkJob(pipelineSchema : LandmarkSearchPipelineSchema) -> AnyPublisher<PipelineNetworkTaskOutput, PipelineJobError> {
        return getMakeHTTPSearchPlanRequestTask(mode: pipelineSchema.mode)
            .mapError {error in PipelineJobError.WrapError(error: error)}
            .eraseToAnyPublisher()
    }
}
