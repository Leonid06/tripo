//
//  PlanService.swift
//  Tripo
//
//  Created by Leonid on 18.07.2023.
//

import Foundation
import Alamofire

class PlanHTTPService : HTTPService {
    func sendManualPlanCreateRequest(parameters: ManualPlanCreateRequestParameters, callback : @escaping (PlanManualCreateRequestResponse?, AFError?)-> () ){
        let requestDetailsProvider = RequestDetailsProvider.planManualCreate
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
    
    func sendPlanGetByIdRequest(parameters : PlanGetByIdParameters, callback :
        @escaping (PlanGetByIdRequestResponse?, AFError?) -> ()){
        let requestDetailsProvider = RequestDetailsProvider.planGetById
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
    
    func sendPlanEditByIdRequest(parameters : PlanEditByIdParameters, callback :
        @escaping (PlanEditByIdRequestResponse?, AFError?) -> ()){
        let requestDetailsProvider = RequestDetailsProvider.planEditById
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
    
    func sendPlanDeleteByIdRequest(parameters : PlanDeleteByIdParameters, callback :
        @escaping (PlanDeleteByIdRequestResponse?, AFError?) -> ()){
        let requestDetailsProvider = RequestDetailsProvider.planDeleteById
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route: requestDetailsProvider.route,
            format: requestDetailsProvider.format,
            parameters: parameters)
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
}
