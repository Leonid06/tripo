//
//  LandmarkViewModel.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import Foundation
import CoreStore


class LandmarkViewModel : BaseViewModel {
    @Published var landmarkDetailCard : LandmarkDetailsCard?
    @Published var instantiationState : ViewModelState.DatabaseClientInstantiationState = .instantiationInProgress
    @Published var fetchLandmarkRequestState : ViewModelState.RequestState = .requestSucceeded
    var databaseClient : LandmarkDatabaseClient?
    
    override init() {
        do {
            databaseClient = try LandmarkDatabaseClient(version: MigrationUtil.currentVersion)
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
    func fetchLandmarkDetailCardByRemoteId(remoteId : String){
        guard let databaseClient = databaseClient else {
            self.fetchLandmarkRequestState = .requestFailed
            return 
        }
        databaseClient.getLandmarkObjectByRemoteId(remoteId: remoteId){
            result -> () in
            switch result {
            case .success(let landmark):
                if let landmark = landmark {
                    self.landmarkDetailCard = LandmarkDetailsCard(
                        remoteId: remoteId,
                        name: landmark.name,
                        landmarkDescription: landmark.landmarkDescription
                    )
                    self.fetchLandmarkRequestState = .requestSucceeded
                }
                self.fetchLandmarkRequestState = .requestFailed
            case .failure(let error):
                self.fetchLandmarkRequestState = .requestFailed
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
