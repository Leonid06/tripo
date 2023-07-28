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
