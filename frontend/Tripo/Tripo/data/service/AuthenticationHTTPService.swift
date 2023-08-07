//
//  AuthenticationHTTPService.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation
import Alamofire


class AuthenticationHTTPService : HTTPService {
    static let shared = AuthenticationHTTPService()
    
    func sendLoginUserRequest(email: String, password: String, callback : @escaping (LogInUserRequestResponse?, AFError?) -> () ){
        let requestDetailsProvider = RequestDetailsProvider.login
        
        let parameters = LoginUserRequestParameters(
            username: email.lowercased(),
            password: password)
        
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route : requestDetailsProvider.route,
            format : requestDetailsProvider.format,
            head : requestDetailsProvider.head,
            parameters: parameters,
            headers: nil
        )
        
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
    func sendRegisterUserRequest(email: String, password : String, callback : @escaping (RegisterUserRequestResponse?, AFError?) -> () ){
        let requestDetailsProvider = RequestDetailsProvider.register
        
        let parameters = RegisterUserRequestParameters(
            email: email.lowercased(),
            password: password,
            is_active: true,
            is_superuser: false,
            is_verified: false)
        
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route : requestDetailsProvider.route,
            format : requestDetailsProvider.format,
            head : requestDetailsProvider.head,
            parameters: parameters,
            headers: nil
        )
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
    
    func sendLogoutUserRequest(callback: @escaping (LogOutUserRequestResponse?, AFError?) -> () ){
        let requestDetailsProvider = RequestDetailsProvider.logout
        let parameters = LogoutUserRequestParameters()
        
        guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
            return
        }
        guard let jwtToken = DefaultsService.shared.getValueForKey(key) as? String else {
            return
        }
        
        let headers : HTTPHeaders = [
            .authorization(bearerToken: jwtToken)
        ]
        
        
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route : requestDetailsProvider.route,
            format : requestDetailsProvider.format,
            head : requestDetailsProvider.head,
            parameters: parameters,
            headers: headers
        )
        sendRequest(requestDetails: requestDetails, callback: callback)
    }
}
