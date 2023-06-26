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
        let url = "\(requestDetails.head ?? "localhost")/\(requestDetails.route)/\(requestDetails.method.rawValue)"
        
        guard let parameterEncoder = try? HTTPServiceUtil.getAlamofireEncoderForFormat(format: requestDetails.format) else {
            return
        }
       
        AF.request(url, method: requestDetails.method, parameters: requestDetails.parameters, encoder: parameterEncoder, headers: nil){ response in
            debugPrint(response)
        }
    }
}


