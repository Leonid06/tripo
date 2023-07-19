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

protocol HTTPRequestResponseUnit : Decodable {
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

struct LandmarkSearchByRadiusRequestResponse  : HTTPRequestResponse {
    var landmark : Array<LandmarkSearchByRadiusRequestResponseUnit>
}

struct LandmarkSearchByRadiusRequestResponseUnit : HTTPRequestResponseUnit {
    var id : String
    var name : String
}

struct LandmarkGetByIdRequestResponse : HTTPRequestResponse {
    var id : String
    var name : String 
}
