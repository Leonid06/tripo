//
//  ResponseModels.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation



protocol HTTPRequestResponse : Decodable {
}

struct LogInUserRequestResponse : HTTPRequestResponse {
    
    var access_token : String
}

struct RegisterUserRequestResponse : HTTPRequestResponse {

}

struct LogOutUserRequestResponse : HTTPRequestResponse {
    var statusCode: String
    
    
}
