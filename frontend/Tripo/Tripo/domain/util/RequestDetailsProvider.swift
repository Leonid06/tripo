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
    case landmarkSearchByRadius
    case cachedLandmarkGetById
    case planGetById
    
    var head : String? {
        switch self {
        case
                .login,
                .register,
                .logout,
                .planManualCreate,
                .landmarkSearchByRadius,
                .cachedLandmarkGetById,
                .planGetById
                
            :
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
            return "plan/create/manual"
        case .landmarkSearchByRadius:
            return "landmark/search/by-radius"
        case .cachedLandmarkGetById:
            return "landmark/get/by-id"
        case .planGetById:
            return "plan/get/by-id"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case    .login,
                .register,
                .logout,
                .planManualCreate,
                .landmarkSearchByRadius,
                .cachedLandmarkGetById,
                .planGetById
            :
            return .post
        }
    }
    
    var format : String {
        switch self {
        case    .register,
                .logout,
                .planManualCreate,
                .landmarkSearchByRadius,
                .cachedLandmarkGetById,
                .planGetById
            :
            return "application/json"
        case .login:
            return "application/x-www-form-urlencoded"
        }
    }
}


