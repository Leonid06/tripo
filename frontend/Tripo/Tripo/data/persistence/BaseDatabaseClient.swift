//
//  DatabaseClient.swift
//  Tripo
//
//  Created by Leonid on 21.07.2023.
//

import CoreStore

class BaseDatabaseClient {
    
    let databaseInterface = CoreStoreDefaults.dataStack
    
    init() throws {
        do {
            try databaseInterface.addStorageAndWait()
        } catch {
            
        }
    }
    
    func makeAsyncTransaction<T>(async_db_interaction_closure: @escaping  (AsynchronousDataTransaction)-> (T), async_callback_closure : @escaping (AsynchronousDataTransaction.Result<T>) -> ()){
        databaseInterface.perform(asynchronous: async_db_interaction_closure, completion: async_callback_closure)
    }
}
