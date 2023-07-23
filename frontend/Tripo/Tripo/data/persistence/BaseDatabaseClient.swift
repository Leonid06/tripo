//
//  DatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 21.07.2023.
//

import CoreData

class BaseDatabaseClient {
    guard let modelURL = Bundle.main.url(forResource: "DataModel",
                                         withExtension: "momd") else {
        fatalError("Failed to find data model")
    }
    
    
    
}
