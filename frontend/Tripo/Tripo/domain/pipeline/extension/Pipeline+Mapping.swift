//
//  Pipeline+Mapping.swift
//  Tripo
//
//  Created by Leonid on 04.08.2023.
//

import Foundation
import Combine

extension PlanManualCreatePipeline {
    internal func mapCreatePlanHTTPRequestTaskParameters(planName: String, planDescription: String, landmarkSchemas : Array<PlanCreatePipelineLandmarkSchema>, promise: Future<PipelineNetworkTaskOutput, PipelineNetworkError>.Promise) {
        
        var parameters = ManualPlanCreateRequestParameters(
            name: planName,
            description: planDescription,
            plan_to_landmark: Array<ManualPlanCreateRequestParametersUnit>())
        
        landmarkSchemas.forEach {
            schema in
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let serializedDate = dateFormatter.string(from: date)
            
            guard let remoteId = schema.remoteId else {
                promise(Result.failure(PipelineNetworkError.InvalidRequestParameters(description: "invalid plan create http request parameters")))
                return 
            }
            
            let unit = ManualPlanCreateRequestParametersUnit(landmark_id: remoteId, visit_date: serializedDate)
            parameters.plan_to_landmark.append(unit)
        }
        
        promise(Result.success(PipelineNetworkTaskOutput.mappedPlanCreateHTTPRequestParameters(parameters: parameters)))
            
    }
}

