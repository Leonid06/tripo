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
        let requestDetailsDispatcher = RequestDetailsProvider.login
        
        let parameters = [
            "username" : [email],
            "password" : [password]
        ]
        let requestDetails = RequestDetails(
            method: requestDetailsDispatcher.method,
            route : requestDetailsDispatcher.route,
            format : requestDetailsDispatcher.format,
            head : requestDetailsDispatcher.head,
            parameters: parameters,
            headers: nil
        )
        
        sendRequest(requestDetails: requestDetails)
    }
    func sendRegisterUserRequest(email: String, password : String){
        let requestDetailsDispatcher = RequestDetailsProvider.register
        
        let parameters = [
            "username" : [email],
            "password" : [password]
        ]
        let requestDetails = RequestDetails(
            method: requestDetailsDispatcher.method,
            route : requestDetailsDispatcher.route,
            format : requestDetailsDispatcher.format,
            head : requestDetailsDispatcher.head,
            parameters: parameters,
            headers: nil
        )
        sendRequest(requestDetails: requestDetails)
    }
    
    func sendLogoutUserRequest(){
        let requestDetailsDispatcher = RequestDetailsProvider.register
        
        let requestDetails = RequestDetails(
            method: requestDetailsDispatcher.method,
            route : requestDetailsDispatcher.route,
            format : requestDetailsDispatcher.format,
            head : requestDetailsDispatcher.head,
            parameters: nil,
            headers: nil
        )
        sendRequest(requestDetails: requestDetails)
    }
}
