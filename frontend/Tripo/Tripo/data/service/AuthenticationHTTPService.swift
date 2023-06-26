//
//  AuthenticationHTTPService.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation


class AuthenticationHTTPService : HTTPService {
    func loginUser(email: String, password: String){
        let requestDetailsDispatcher = RequestDetailsProvider.login
        
        let parameters = [
            "email" : [email],
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
}
