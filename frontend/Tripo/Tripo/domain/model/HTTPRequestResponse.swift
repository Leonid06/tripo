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

struct CachedLandmarkGetByIdRequestResponse : HTTPRequestResponse {
    var id : String
    var name : String 
}

struct PlanGetByIdRequestResponse : HTTPRequestResponse {
    var plan_id : String
    var name : String
    var description : String
    var locations : Array<PlanGetByIdRequestResponseUnit>
}

struct PlanGetByIdRequestResponseUnit : HTTPRequestResponseUnit {
    var landmark_id : String
    var visit_data : String?
}
