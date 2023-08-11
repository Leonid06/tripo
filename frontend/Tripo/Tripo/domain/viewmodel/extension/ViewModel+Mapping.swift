//
//  ViewModel+Mapping.swift
//  Tripo
//
//  Created by Leonid on 28.07.2023.
//

import Foundation


extension PlanManualCreateViewModel {
    internal func mapLandmarkSearchByRadiusRequestResponseToLandmarkSearchDetailCards
    (response : LandmarkSearchByRadiusRequestResponse) -> [LandmarkSearchDetailCard] {
        var cards = Array<LandmarkSearchDetailCard>()
        let landmarks =  response.landmark
        
        landmarks.forEach {
            landmark in
            let card = LandmarkSearchDetailCard(name: landmark.name, landmarkDescription: "", remoteId: landmark.id)
            cards.append(card)
        }
        
        return cards
    }
}

extension PlanViewModel {
    internal func mapPlanToPlanDetailsCard(plan : Plan) -> PlanDetailsCard {
        return PlanDetailsCard(
            name: plan.name,
            completed: plan.completed)
    }
    
    internal func mapLandmarkToLandmarkDetailsCard(landmark: Landmark) -> LandmarkDetailsCard {
        return LandmarkDetailsCard(
            remoteId: landmark.remoteId,
            name : landmark.name,
            landmarkDescription: landmark.landmarkDescription
        )
    }
}

extension HomeViewModel {
    internal func mapFetchAllPlansByCurrentUserResultToHomePlanDetailCards(
        result: Array<Plan>) -> [HomePlanDetailCard] {
            return result.map {
                HomePlanDetailCard(
                    name: $0.name,
                    remoteId: $0.remoteId
                )
            }
        }
}
