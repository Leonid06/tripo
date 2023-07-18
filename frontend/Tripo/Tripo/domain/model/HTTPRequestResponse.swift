//
//  ResponseModels.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation
import Alamofire



protocol HTTPRequestResponse : Decodable {
}

struct LogInUserRequestResponse : HTTPRequestResponse {
    var access_token : String
}

struct RegisterUserRequestResponse : HTTPRequestResponse {
}

struct LogOutUserRequestResponse : HTTPRequestResponse, EmptyResponse {
    static func emptyValue() -> LogOutUserRequestResponse {
        return LogOutUserRequestResponse.init()
    }
}

struct PlanManualCreateRequestResponse : HTTPRequestResponse {
    var message : String 
}
