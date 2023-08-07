//
//  RegisterViewModel.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation


class RegisterViewModel : BaseViewModel {
    func sendRegisterUserRequest(email: String, password: String){
        Task {
            AuthenticationHTTPService.shared.sendRegisterUserRequest(email: email, password: password, callback: {_, _ in })
        }
    }
}
