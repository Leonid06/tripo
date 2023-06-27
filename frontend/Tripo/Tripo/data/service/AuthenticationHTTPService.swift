//
//  AuthenticationHTTPService.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation


class AuthenticationHTTPService : HTTPService {
    static let shared = AuthenticationHTTPService()
    func sendloginUserRequest(email: String, password: String){
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
        
        sendRequest(requestDetails: requestDetails)
    }
    func sendRegisterUserRequest(email: String, password : String){
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
        sendRequest(requestDetails: requestDetails)
    }
    
    func sendLogoutUserRequest(){
        let requestDetailsProvider = RequestDetailsProvider.register
        let parameters = LogoutUserRequestParameters()
        
        let requestDetails = RequestDetails(
            method: requestDetailsProvider.method,
            route : requestDetailsProvider.route,
            format : requestDetailsProvider.format,
            head : requestDetailsProvider.head,
            parameters: parameters,
            headers: nil
        )
        sendRequest(requestDetails: requestDetails)
    }
}
