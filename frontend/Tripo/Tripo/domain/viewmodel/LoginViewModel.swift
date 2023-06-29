//
//  LoginViewModel.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation



class LoginViewModel : ObservableObject {
    
    func sendlogInUserRequest(email : String, password: String){
        Task {
            AuthenticationHTTPService.shared.sendLoginUserRequest(email: email, password: password, callback: onSuccessfullLogInUserRequestResponse)
        }
    }
    
    private func onSuccessfullLogInUserRequestResponse(response : LogInUserRequestResponse){
        guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
            return
        }
        DefaultsService.shared.setValueForKey(key, value: response.jwtToken)
    }
}
