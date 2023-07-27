//
//  PlanViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation
import CoreStore



struct PlanViewModelState {
    enum DatabaseClientState {
        case instantiationSucceded
        case instantiationFailed
        case instantiationInProgress
    }
}

class PlanViewModel : ObservableObject {
    @Published var plan : Plan?
    @Published var databaseClientState : PlanViewModelState.DatabaseClientState = .instantiationInProgress
    private let id : String
    private var databaseClient : PlanDatabaseClient?
    
    
    init(id : String) {
        self.id = id
        do {
            databaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
        }catch DatabaseClientError.differentStorageExistsAtUrl(let url) {
            print("Different storage exists at URL : \(url)")
            databaseClientState = .instantiationFailed
        }catch DatabaseClientError.internalError(let error) {
            print("Internal database client error happened : \(error)")
            databaseClientState = .instantiationFailed
        }catch DatabaseClientError.unknownError {
            print("unknown database client error happened")
            databaseClientState = .instantiationFailed
        }catch {
            print("unknown error happened")
            databaseClientState = .instantiationFailed
        }
    }
    
    func fetchPlanById(id: String){
        if let databaseClient = databaseClient {
            databaseClient.getPlanObjectByRemoteId(remoteId: id){
                result -> () in
                switch result {
                case .success(let plan):
                    if let plan = plan {
                        self.plan = plan
                    }
                case .failure(let error):
                    switch error {
                    case CoreStoreError.unknown:
                        print("unknown database client error happened")
                    case CoreStoreError.persistentStoreNotFound(let entity):
                        print("Persistent store featuring entity : \(entity) was not found")
                    case CoreStoreError.internalError(let error):
                        print("internal database client error happened : \(error)")
                    default:
                        print("unknown error happened")
                    }
                }
            }
        }
    }
}
