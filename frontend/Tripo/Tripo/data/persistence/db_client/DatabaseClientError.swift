//
//  databaseClientError.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore


enum DatabaseClientError : Error {
    case internalError
    case differentStorageExistsAtUrl
    case unknownError
    
    init(_ error: Error?){
        guard let error = error else {
            self = .unknownError
            return
        }
        switch error {
        case let error as NSError:
            self = .internalError
        case CoreStoreError.differentStorageExistsAtURL(let existingStorage):
            self = .differentStorageExistsAtUrl
        default:
            self = .unknownError
        }
        
    
    }
}
