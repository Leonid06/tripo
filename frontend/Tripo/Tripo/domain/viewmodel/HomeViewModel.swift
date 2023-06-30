//
//  HomeViewModel.swift
//  Tripo
//
//  Created by Leonid on 30.06.2023.
//

import Foundation


class HomeViewModel : ObservableObject {
    
    
    func sendLogoutUserRequest(){
        Task {
            AuthenticationHTTPService.shared.sendLogoutUserRequest(callback: onSuccessfullLogOutUserRequestResponse)
        }
       
    }
    
    private func onSuccessfullLogOutUserRequestResponse(response : LogOutUserRequestResponse){
        guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
            return
        }
        DefaultsService.shared.resetValueForKey(key)
    }
}
