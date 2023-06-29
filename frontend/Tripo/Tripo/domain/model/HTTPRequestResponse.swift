//
//  ResponseModels.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation



protocol HTTPRequestResponse : Decodable {
    var statusCode : String { get set }
}

struct LogInUserRequestResponse : HTTPRequestResponse {
    var statusCode: String
    
    var jwtToken : String
}

struct RegisterUserRequestResponse : HTTPRequestResponse {
    var statusCode: String
    
    
}

struct LogOutUserRequestResponse : HTTPRequestResponse {
    var statusCode: String
    
    
}
