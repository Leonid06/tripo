//
//  PlanViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation
import CoreStore



class PlanViewModel : BaseViewModel {
    @Published var plan : Plan?
    @Published var databaseClientInstantiationState : ViewModelState.DatabaseClientInstantiationState = .instantiationInProgress
    @Published var fetchPlanByIdRequestState :
    ViewModelState.fetchRequestState = .fetchInProgress
    private let id : String
    private var databaseClient : PlanDatabaseClient?
    
    
    init(id : String) {
        self.id = id
        do {
            databaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
            databaseClientInstantiationState = .instantiationSucceded
        }catch DatabaseClientError.differentStorageExistsAtUrl(let url) {
            print("Different storage exists at URL : \(url)")
            databaseClientInstantiationState = .instantiationFailed
        }catch DatabaseClientError.internalError(let error) {
            print("Internal database client error happened : \(error)")
            databaseClientInstantiationState = .instantiationFailed
        }catch DatabaseClientError.unknownError {
            print("unknown database client error happened")
            databaseClientInstantiationState = .instantiationFailed
        }catch {
            print("unknown error happened")
            databaseClientInstantiationState = .instantiationFailed
        }
    }
    
    func fetchPlanById(id: String){
        fetchPlanByIdRequestState = .fetchInProgress
        
        if let databaseClient = databaseClient {
            databaseClient.getPlanObjectByRemoteId(remoteId: id){
                result -> () in
                switch result {
                case .success(let plan):
                    if let plan = plan {
                        self.plan = plan
                        self.fetchPlanByIdRequestState = .fetchNotRequested
                    }
                    self.fetchPlanByIdRequestState = .fetchFailed
                case .failure(let error):
                    self.fetchPlanByIdRequestState = .fetchFailed
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
