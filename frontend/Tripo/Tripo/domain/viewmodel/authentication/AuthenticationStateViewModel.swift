//
//  LoginViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.06.2023.
//

import Foundation
import Combine


class AuthenticationStateViewModel : BaseViewModel {
    @Published var state : AuthenticationState = .loggedOut
    private var currentSubscriptions = Set<AnyCancellable>()
    private let defaultsService = DefaultsService.shared
    
    override init() {
        super.init()
        guard let jwtKeychainKey = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
            return
        }
        let keyState = defaultsService.getKeyState(key: jwtKeychainKey)
        mapKeyStateToAuthenticationState(keyState: keyState)
        
        defaultsService.subscribeToKeyStateUpdateNotifications(key: jwtKeychainKey, in: &currentSubscriptions, callback: onJWTKeyStateUpdate)
    }
    
    deinit {
        currentSubscriptions.forEach {
            subscription in subscription.cancel()
        }
    }
    
  
    
    private func onJWTKeyStateUpdate(keyState: KeyState){
        mapKeyStateToAuthenticationState(keyState: keyState)
    }
    
   
}

fileprivate extension AuthenticationStateViewModel {
    func mapKeyStateToAuthenticationState(keyState : KeyState){
        guard keyState == .hasValue else {
            self.state = .loggedOut
            return
        }
        self.state = .authenticated
    }
}
