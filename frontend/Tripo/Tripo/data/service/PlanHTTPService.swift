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
}
