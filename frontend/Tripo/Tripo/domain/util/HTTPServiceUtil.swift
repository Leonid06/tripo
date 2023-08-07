//
//  AuthenticationServiceUtil.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation
import Alamofire

struct HTTPServiceUtil {
    static func getAlamofireEncoderForFormat(format : String) throws -> ParameterEncoder? {
        switch format {
        case "application/json":
            return JSONParameterEncoder.default
        case "application/x-www-form-urlencoded" :
            return URLEncodedFormParameterEncoder.default
        default:
            throw fatalError("Invalid format provided")
        }
    }
}
