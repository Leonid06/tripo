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
    
    func sendGetLandmarkByIdRequest(parameters: LandmarkGetByIdParameters, callback : @escaping (LandmarkGetByIdRequestResponse?, AFError?) -> ()){
        let requestDetailsProvider = RequestDetailsProvider.landmarkGetById
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
}
