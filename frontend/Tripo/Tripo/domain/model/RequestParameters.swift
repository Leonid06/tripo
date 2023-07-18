//
//  RequestParametersModels.swift
//  Tripo
//
//  Created by Leonid on 27.06.2023.
//

import Foundation


protocol RequestParameters : Encodable {
    
}

struct RegisterUserRequestParameters : RequestParameters {
    var email : String
    var password : String
    var is_active : Bool
    var is_superuser : Bool
    var is_verified : Bool
}

struct LogoutUserRequestParameters : RequestParameters {
    
}


struct LoginUserRequestParameters : RequestParameters {
    var username : String
    var password : String
}

struct ManualPlanCreateRequestParameters : RequestParameters {
    var name : String
    var description : String
    var plan_to_landmark : Array<ManualPlanCreateRequestParametersUnit>
}

struct ManualPlanCreateRequestParametersUnit : RequestParameters {
    var landmark_id : String
    var visit_date : String
}


