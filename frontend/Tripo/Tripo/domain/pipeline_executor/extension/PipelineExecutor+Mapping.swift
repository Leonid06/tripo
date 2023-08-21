//
//  BasePipelineExecutor+Mapping.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation


extension PlanManualCreateViewPipelineExecutor {
    static func mapManualPlanCreateDetailCardToPipelineSchema(
        planDetailCard : PlanManualCreateDetailCard, landmarkDetailCards : Array<LandmarkSearchDetailCard>
    ) -> PlanCreatePipelineSchema {
        var landmarkSchemas = Array<PlanCreatePipelineLandmarkSchema>()
        let pipelineSchema = PlanCreatePipelineSchema(
            planName: planDetailCard.name,
            planDescription: planDetailCard.description,
            landmarks: landmarkSchemas
        )
        
        landmarkDetailCards.forEach {
            card in
            let landmarkSchema = PlanCreatePipelineLandmarkSchema(
                name: card.name,
                remoteId: card.remoteId
            )
            
            landmarkSchemas.append(landmarkSchema)
        }
        
        return pipelineSchema
    }
}

extension PlanViewPipelineExecutor {
    static func mapPlanDetailCardToPlanEditPipelineSchema(planDetailCard: PlanDetailsCard) -> PlanEditPipelineSchema {
        return PlanEditPipelineSchema(
            name: planDetailCard.name,
            description: "",
            completed: planDetailCard.completed,
            identifier: planDetailCard.id
        )
    }
    
    static func mapPlanDetailCardToPlanDeletePipelineSchema(planDetailCard: PlanDetailsCard) -> PlanDeletePipelineSchema {
        return PlanDeletePipelineSchema(
            identifier: UUID(),
            remoteId: ""
        )
    }
}
