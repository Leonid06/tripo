//
//  DefaultsService .swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import Foundation
import Combine




class DefaultsService {
    static let shared = DefaultsService()
    
    private let notificationStream = PassthroughSubject<KeyState, Never>()
    private let userDefaults =  UserDefaults.standard
    
    private func getDefaultsValueByKey(key : String) -> String? {
        return userDefaults.value(forKey: key) as? String
    }
    
    func setValueForKey(_ key : String, value: Any){
        userDefaults.set(value, forKey: key)
        notificationStream.send(.hasValue)
    }
    
    func resetValueForKey(_ key : String){
        userDefaults.removeObject(forKey: key)
        notificationStream.send(.empty)
    }
    
    func getValueForKey(_ key : String) -> Any? {
        return userDefaults.value(forKey: key)
    }
    
    func getKeyState(key: String) -> KeyState {
        guard let value = getDefaultsValueByKey(key: key) else {
            return .empty
        }
        return .hasValue
    }
    
    func subscribeToKeyStateUpdateNotifications(key : String, in storage : inout Set<AnyCancellable>, callback : @escaping (KeyState)-> ()) {
        let subscription = notificationStream.sink(receiveValue: callback)
        subscription.store(in: &storage)
    }
}
