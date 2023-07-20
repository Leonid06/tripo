//
//  LandmarkHTTPService.swift
//  Tripo
//
//  Created by Leonid on 19.07.2023.
//

import Foundation
import Alamofire

class LandmarkHTTPService : HTTPService {
    func sendSearchLandmarkByRadiusRequest(parameters: LandmarkSearchByRadiusParameters, callback : @escaping (LandmarkSearchByRadiusRequestResponse?, AFError?) -> ()){
        let requestDetailsProvider = RequestDetailsProvider.landmarkSearchByRadius
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
    
    func sendGetCachedLandmarkByIdRequest(parameters: CachedLandmarkGetByIdParameters, callback : @escaping (CachedLandmarkGetByIdRequestResponse?, AFError?) -> ()){
        let requestDetailsProvider = RequestDetailsProvider.cachedLandmarkGetById
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
}
