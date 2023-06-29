//
//  AuthenticationService.swift
//  Tripo
//
//  Created by Leonid on 23.06.2023.
//

import Foundation
import Alamofire


class HTTPService {
    
    internal func sendRequest<T : HTTPRequestResponse>(requestDetails :  RequestDetails, callback : @escaping (T) -> () ) {
        let url =  "http://localhost:8000/\(requestDetails.route)"
        
        let parameterEncoder = try? HTTPServiceUtil.getAlamofireEncoderForFormat(format: requestDetails.format)
        
        AF.request(url, method: requestDetails.method, parameters: requestDetails.parameters, encoder: parameterEncoder ?? JSONParameterEncoder.default, headers: requestDetails.headers).responseDecodable(of: T.self){ response in
            debugPrint(response)
            if let value = response.value {
                callback(value)
            }else {
               print("Failed to map value")
            }
        }
    }
}


