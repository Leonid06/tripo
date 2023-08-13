//
//  PlanCreateViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation
import Combine



class PlanManualCreateViewModel : BaseViewModel {
    @Published var landmarkSearchDetailCards  =  Array<LandmarkSearchDetailCard>()
    @Published var landmarkChosenSearchDetailCards = Array<LandmarkSearchDetailCard>()
    @Published var databaseClientInstantiationState : ViewModelState.DatabaseClientInstantiationState = .instantiationInProgress
    @Published var fetchLandmarksRequestState : ViewModelState.RequestState = .requestSucceeded
    @Published var createPlanRequestState : ViewModelState.RequestState =
        .requestSucceeded
    @Published var creationAllowed : Bool?
    
    private var planCreatePipelineExecutor : PlanManualCreateViewPipelineExecutor?
    
    override init() {
        super.init()
        do {
            planCreatePipelineExecutor = try PlanManualCreateViewPipelineExecutor()
            databaseClientInstantiationState = .instantiationSucceded
        } catch PipelineDatabaseError.PipelineDatabaseInstantiationError.InternalDatabaseErrorHappened(let error) {
            print("Internal database client error happened : \(error)")
            databaseClientInstantiationState = .instantiationFailed
        } catch PipelineDatabaseError.PipelineDatabaseInstantiationError.InvalidDatabaseStorageProvided(let url){
            print("Different storage exists at URL : \(url)")
        } catch PipelineDatabaseError.PipelineDatabaseInstantiationError.UnknownDatabaseErrorHappened {
            print("unknown database client error happened")
        }
        catch {
            print("plan create pipeline executor instantiation failed due to unknown error")
        }
        
    }
    
    func chooseLandmarkForPlan(card: LandmarkSearchDetailCard){
        landmarkSearchDetailCards.append(card)
        creationAllowed = true 
    }
    
    func searchLandmarksByCurrentLocation(){
        guard let planCreatePipelineExecutor = planCreatePipelineExecutor else {
            print("plan create view pipeline executor is not initialized")
            createPlanRequestState = .requestFailed
            return
        }
        
        do {
            let pipelineSchema = LandmarkSearchPipelineSchema(mode: .ByCurrentLocation)
            
            let pipeline = try planCreatePipelineExecutor.executeSearchLandmarkPipeline(pipelineSchema: pipelineSchema){
                product in
                switch product {
                case .Failure(let error):
                    print("Error happened during search landmark pipeline execution : \(error)")
                case .Success(let output):
                    switch output{
                    case .LandmarkSearchByRadiusHTTPRequestResponse(let response):
                        self.landmarkSearchDetailCards = self.mapLandmarkSearchByRadiusRequestResponseToLandmarkSearchDetailCards(response: response)
                    default:
                        print("Invalid search landmark pipeline product")
                    }
                }
            }
            pipeline.cancel()
        }  catch {
            createPlanRequestState = .requestFailed
        }
    }
    
    
    func createPlanWith(_ planDetailCard : PlanManualCreateDetailCard, and landmarkDetailCards : Array<LandmarkSearchDetailCard>){
        createPlanRequestState = .requestInProgress
        
        
        guard let planCreatePipelineExecutor = planCreatePipelineExecutor else {
            print("plan create view pipeline executor is not initialized")
            createPlanRequestState = .requestFailed
            return
        }
        do {
            let pipelineSchema = PlanManualCreateViewPipelineExecutor.mapManualPlanCreatePresentationDataToPipelineSchema(planDetailCard: planDetailCard, landmarkDetailCards: landmarkDetailCards)
            let pipeline = try planCreatePipelineExecutor.executeCreatePlanPipeline(pipelineSchema: pipelineSchema){
                product in
                
                switch product {
                case .Failure(let error):
                    print("Error happened during create plan pipeline execution : \(error)")
                case .Success:
                    self.createPlanRequestState = .requestSucceeded
                }
            }
            pipeline.cancel()
            
        } catch {
            createPlanRequestState = .requestFailed
        }
        
    }
}
