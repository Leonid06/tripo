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
    case planManualCreate
    
    var head : String? {
        switch self {
        case .login, .register, .logout, .planManualCreate:
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
        case .planManualCreate:
            return "plan/create"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .login, .register, .logout, .planManualCreate:
            return .post
        }
    }
    
    var format : String {
        switch self {
        case  .register, .logout, .planManualCreate:
            return "application/json"
        case .login:
            return "application/x-www-form-urlencoded"
        }
    }
}


