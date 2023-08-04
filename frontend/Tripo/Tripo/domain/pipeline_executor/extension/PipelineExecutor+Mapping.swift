//
//  BasePipelineExecutor+Mapping.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation


extension PlanCreateViewPipelineExecutor {
    static func mapPlanCreatePresentationDataToPipelineSchema(
        planPresentationUnit : PlanCreatePresentationUnit, landmarkUnits : Array<LandmarkSearchShortPresentationUnit>
    ) -> PlanCreatePipelineSchema {
        var landmarkSchemas = Array<PlanCreatePipelineLandmarkSchema>()
        let pipelineSchema = PlanCreatePipelineSchema(
            planName: planPresentationUnit.name,
            planDescription: planPresentationUnit.description,
            landmarks: landmarkSchemas
        )
        
        landmarkUnits.forEach {
            unit in
            let landmarkSchema = PlanCreatePipelineLandmarkSchema(
                name: unit.name,
                remoteId: unit.remoteId
            )
            
            landmarkSchemas.append(landmarkSchema)
        }
        
        return pipelineSchema
    }
}
