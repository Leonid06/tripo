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
    @Published var instantiationState : ViewModelState.DatabaseClientInstantiationState = .instantiationInProgress
    @Published var fetchPlanRequestState :
    ViewModelState.RequestState = .requestSucceeded
    private var databaseClient : PlanDatabaseClient?
    
    
    init(id : String) {
        do {
            databaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
            instantiationState = .instantiationSucceded
        }catch DatabaseClientError.differentStorageExistsAtUrl(let url) {
            print("Different storage exists at URL : \(url)")
            instantiationState = .instantiationFailed
        }catch DatabaseClientError.internalError(let error) {
            print("Internal database client error happened : \(error)")
            instantiationState = .instantiationFailed
        }catch DatabaseClientError.unknownError {
            print("unknown database client error happened")
            instantiationState = .instantiationFailed
        }catch {
            print("unknown error happened")
            instantiationState = .instantiationFailed
        }
    }
    
    func fetchPlanByRemoteId(remoteId: String){
        fetchPlanRequestState = .requestInProgress
        
        guard let databaseClient = databaseClient else {
            fetchPlanRequestState = .requestFailed
            return 
        }
        
        databaseClient.getPlanObjectByRemoteId(remoteId: remoteId){
            result -> () in
            switch result {
            case .success(let plan):
                if let plan = plan {
                    self.plan = plan
                    self.fetchPlanRequestState = .requestSucceeded
                }
                self.fetchPlanRequestState = .requestFailed
            case .failure(let error):
                self.fetchPlanRequestState = .requestFailed
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
