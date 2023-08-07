//
//  LoginViewModel.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation
import Alamofire



class LoginViewModel : BaseViewModel {
    
    func sendlogInUserRequest(email : String, password: String){
        Task {
            AuthenticationHTTPService.shared.sendLoginUserRequest(email: email, password: password, callback: onLogInUserRequestResponse)
        }
    }
    
    private func onLogInUserRequestResponse(response : LogInUserRequestResponse?, error : AFError?){
        
        if let error = error {
            print(error)
            return
        }
        
        if let response = response {
            guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
                return
            }
            DefaultsService.shared.setValueForKey(key, value: response.access_token)
        }
        
    }
}
