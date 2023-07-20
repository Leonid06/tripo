//
//  AuthenticationService.swift
//  Tripo
//
//  Created by Leonid on 23.06.2023.
//

import Foundation
import Alamofire


class HTTPService {
    
    internal func sendRequest<T : HTTPRequestResponse>(requestDetails :  RequestDetails, callback : @escaping (T?, AFError?) -> () ) {
        let url =  "http://localhost:8000/\(requestDetails.route)"
        
        let parameterEncoder = try? HTTPServiceUtil.getAlamofireEncoderForFormat(format: requestDetails.format)
        
        AF.request(url, method: requestDetails.method, parameters: requestDetails.parameters, encoder: parameterEncoder ?? JSONParameterEncoder.default, headers: requestDetails.headers).responseDecodable(of: T.self){ response in
            
            switch response.result {
            case .success:
                callback(response.value, nil)
            case .failure(let error):
                switch error {
                case .createURLRequestFailed, .responseSerializationFailed, .requestAdaptationFailed:
                    print(response.debugDescription)
                    callback(nil, error)
                default:
                    callback(nil, error)
                }
            }
        }
    }
}



