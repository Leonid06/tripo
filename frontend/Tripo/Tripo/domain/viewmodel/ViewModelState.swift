//
//  ViewModelState.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation


class ViewModelState {
    enum DatabaseClientInstantiationState {
        case instantiationSucceded
        case instantiationFailed
        case instantiationInProgress
    }
    
    enum RequestState {
        case requestInProgress
        case requestFailed
        case requestSucceeded
    }
}
