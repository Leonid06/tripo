//
//  PlanCreateViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation
import Combine



class PlanCreateViewModel : BaseViewModel {
    @Published var fetchedLandmarks : Array<LandmarkSearchShortPresentationUnit>?
    @Published var databaseClientInstantiationState : ViewModelState.DatabaseClientInstantiationState = .instantiationInProgress
    @Published var fetchLandmarksRequestState : ViewModelState.RequestState = .requestSucceeded
    @Published var createPlanRequestState : ViewModelState.RequestState =
        .requestSucceeded
    
    private var planCreatePipelineExecutor : PlanPipelineExecutor?
    
    override init() {
        super.init()
        do {
            planCreatePipelineExecutor = try PlanPipelineExecutor()
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
        
        //    func fetchLandmarksByCurrentLocation(radius: Int){
        //        fetchLandmarksRequestState = .requestInProgress
        //        landmarkHTTPService
        //            .sendSearchLandmarkByRadiusRequest(parameters: LandmarkSearchByRadiusParameters(latitude: "52.377956", longitude: "4.897070", radius: String(radius))){
        //                response, error in
        //
        //                if let error = error {
        //                    self.fetchLandmarksRequestState = .requestFailed
        //                    switch error {
        //                    case .createURLRequestFailed(let error):
        //                        print("Failed to create url request due to the following error raised : \(error)")
        //                    case .responseSerializationFailed(let reason):
        //                        print("Response serialization failed due to the following reason: \(reason)")
        //                    case .responseValidationFailed(let reason):
        //                        print("Response validation failed due to the following reason: \(reason)")
        //                    default:
        //                        print("fetch failed due to unknown  error : \(error)")
        //                    }
        //                }
        //
        //                if let response = response {
        //                    self.fetchedLandmarks = self.mapLandmarkSearchByRadiusRequestResponseToLandmarkSearchShortPresentationUnits(response: response)
        //                    self.fetchLandmarksRequestState = .requestNotRequested
        //                }
        //            }
        //    }
    }
    
    
    func createPlanWith(_ planPresentationUnit : PlanCreatePresentationUnit, and landmarkSearchShortPresentationUnits : Array<LandmarkSearchShortPresentationUnit>){
        createPlanRequestState = .requestInProgress
        
        
        guard let planCreatePipelineExecutor = planCreatePipelineExecutor else {
            print("plan create pipeline executor is not initialized")
            return
        }
        do {
            let pipelineSchema = PlanPipelineExecutor.mapPlanCreatePresentationDataToPipelineSchema(planPresentationUnit: planPresentationUnit, landmarkUnits: landmarkSearchShortPresentationUnits)
            try planCreatePipelineExecutor.executeCreatePlanPipeline(pipelineSchema: pipelineSchema){
                product in
            }
            createPlanRequestState = .requestSucceeded
        } catch {
            createPlanRequestState = .requestFailed
        }
        
    }
}
