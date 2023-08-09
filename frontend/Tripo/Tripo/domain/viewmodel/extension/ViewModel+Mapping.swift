//
//  ViewModel+Mapping.swift
//  Tripo
//
//  Created by Leonid on 28.07.2023.
//

import Foundation


extension PlanCreateViewModel {
    internal func mapLandmarkSearchByRadiusRequestResponseToLandmarkSearchShortPresentationUnits
    (response : LandmarkSearchByRadiusRequestResponse) -> [LandmarkSearchShortPresentationUnit] {
        var units = Array<LandmarkSearchShortPresentationUnit>()
        let landmarks =  response.landmark
        
        landmarks.forEach {
            landmark in
            let unit = LandmarkSearchShortPresentationUnit(name: landmark.name, remoteId: landmark.id)
            units.append(unit)
        }
        
        return units
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
