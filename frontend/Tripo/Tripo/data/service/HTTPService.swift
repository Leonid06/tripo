//
//  AuthenticationService.swift
//  Tripo
//
//  Created by Leonid on 23.06.2023.
//

import Foundation
import Alamofire


class HTTPService {
    
    internal func sendRequest(requestDetails :  RequestDetails) {
        let url =  "http://localhost:8000/\(requestDetails.route)"
        
        let parameterEncoder = try? HTTPServiceUtil.getAlamofireEncoderForFormat(format: requestDetails.format)
            
       
        
        AF.request(url, method: requestDetails.method, parameters: requestDetails.parameters, encoder: parameterEncoder ?? JSONParameterEncoder.default, headers: requestDetails.headers).response{ response in
            debugPrint(response)
        }
    }
}


