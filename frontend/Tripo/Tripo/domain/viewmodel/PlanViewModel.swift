//
//  PlanViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation
import CoreStore



class PlanViewModel : BaseViewModel {
    @Published var planDetailCard : PlanDetailsCard?
    @Published var landmarkDetailCards : Array<LandmarkDetailsCard> = Array<LandmarkDetailsCard>()
    @Published var instantiationState : ViewModelState.DatabaseClientInstantiationState = .instantiationInProgress
    @Published var fetchPlanRequestState :
    ViewModelState.RequestState = .requestSucceeded
    @Published var editPlanRequestState :
    ViewModelState.RequestState = .requestSucceeded
    private var databaseClient : PlanDatabaseClient?
    
    private var planViewPipelineExecutor : PlanViewPipelineExecutor?
    
    
    override init() {
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
    
    func editPlanDetailCard(card: PlanDetailsCard){
        editPlanRequestState = .requestInProgress
        
        guard let planViewPipelineExecutor = planViewPipelineExecutor else {
            print("plan view pipeline executor is not initialized")
            editPlanRequestState = .requestFailed
            return
        }
        
        let schema = PlanViewPipelineExecutor.mapPlanDetailCardToPlanEditPipelineSchema(planDetailCard: card)
        
        do {
            let pipelineCancellable = try planViewPipelineExecutor.executePlanEditPipeline(schema: schema){
                product in
                switch product {
                case .Failure(let error):
                    self.editPlanRequestState = .requestFailed
                    print("Error happened during plan edit pipeline execution : \(error)")
                  
                case .Success(let output):
                    switch output {
                    case .Void:
                        self.editPlanRequestState = .requestSucceeded
                        return
                    default:
                        self.editPlanRequestState = .requestSucceeded
                        print("Invalid plan edit pipeline product")
                    }
                }
            }
        } catch {
            editPlanRequestState = .requestFailed
        }
        
        
    }
    
    func fetchPlanDetailCardByRemoteId(remoteId: String){
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
                    self.planDetailCard = self.mapPlanToPlanDetailsCard(plan: plan)
                    self.landmarkDetailCards = plan.planToLandmark.compactMap { relationship in
                        guard let landmark = relationship.landmark else {
                            return nil
                        }
                        return self.mapLandmarkToLandmarkDetailsCard(landmark: landmark)
                    }
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
