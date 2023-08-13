//
//  HomeViewModel.swift
//  Tripo
//
//  Created by Leonid on 30.06.2023.
//

import Foundation
import Alamofire


class HomeViewModel : BaseViewModel {
    
    private let authenticationService = AuthenticationHTTPService()
    
    private var homeViewPipelineExecutor : HomeViewPipelineExecutor?
    
    @Published var homePlanDetailCards : Array<HomePlanDetailCard> = Array<HomePlanDetailCard>()
    

    override init() {
        super.init()
        do {
            homeViewPipelineExecutor = try HomeViewPipelineExecutor()
        } catch PipelineDatabaseError.PipelineDatabaseInstantiationError.InternalDatabaseErrorHappened(let error) {
            print("Internal database client error happened : \(error)")
        } catch PipelineDatabaseError.PipelineDatabaseInstantiationError.InvalidDatabaseStorageProvided(let url){
            print("Different storage exists at URL : \(url)")
        } catch PipelineDatabaseError.PipelineDatabaseInstantiationError.UnknownDatabaseErrorHappened {
            print("unknown database client error happened")
        }
        catch {
            print("plan create pipeline executor instantiation failed due to unknown error")
        }
        
    }
    
    func sendLogoutUserRequest(){
        authenticationService.sendLogoutUserRequest(callback: onLogOutUserRequestResponse)
    }
    
    func fetchAllPlansByCurrentUser(){
        guard let homeViewPipelineExecutor = homeViewPipelineExecutor else {
            print("home view pipeline executor is not initialized")
            return
        }
        
        do {
            let pipelineCancellable = try homeViewPipelineExecutor.executeFetchAllLandmarksByCurrentUserPipeline {
                product in
                switch product {
                case .Failure(let error):
                    print("Error happened during fetch landmark by current user pipeline pipeline execution : \(error)")
                case .Success(let output):
                    switch output{
                    case .PlanArray(let plans):
                        self.homePlanDetailCards = self.mapFetchAllPlansByCurrentUserResultToHomePlanDetailCards(result: plans)
                    default:
                        print("Invalid search landmark pipeline product")
                    }
                }
            }
        }
        catch {
        }
            
        }
    }
    
    private func onLogOutUserRequestResponse(response : LogOutUserRequestResponse?, error: AFError?){
        if let error = error {
            print(error)
            return
        }
        if response != nil {
            guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
                return
            }
            DefaultsService.shared.resetValueForKey(key)
        }
  
    }
