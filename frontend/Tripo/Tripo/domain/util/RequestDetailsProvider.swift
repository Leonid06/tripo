//
//  RequestDetailsDispatcher.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation
import Alamofire

enum RequestDetailsProvider {
    case login
    case register
    case logout
    
    var head : String? {
        switch self {
        case .login, .register, .logout:
            print(EnvironmentVariables.REST_HEAD)
            return EnvironmentVariables.REST_HEAD as? String
        }
    }
    
    var route : String {
        switch self {
        case .login:
            return "auth/login"
        case .register:
            return "auth/register"
        case .logout:
            return "auth/logout"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .login, .register, .logout:
            return .post
        }
    }
    
    var format : String {
        switch self {
        case  .register, .logout:
            return "application/json"
        case .login:
            return "application/x-www-form-urlencoded"
        }
    }
}


