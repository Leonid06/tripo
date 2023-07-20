//
//  HomeViewModel.swift
//  Tripo
//
//  Created by Leonid on 30.06.2023.
//

import Foundation
import Alamofire


class HomeViewModel : ObservableObject {
    
    
    func sendLogoutUserRequest(){
        Task {
            AuthenticationHTTPService.shared.sendLogoutUserRequest(callback: onLogOutUserRequestResponse)
        }
       
    }
    
    private func onLogOutUserRequestResponse(response : LogOutUserRequestResponse?, error: AFError?){
        if let error = error {
            print(error)
            return
        }
        if response != nil {
            guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
                return
            }
            DefaultsService.shared.resetValueForKey(key)
        }
  
    }
}
