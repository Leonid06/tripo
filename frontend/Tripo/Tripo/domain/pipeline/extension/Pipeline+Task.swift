//
//  Pipeline+Task.swift
//  Tripo
//
//  Created by Leonid on 04.08.2023.
//

import Foundation
import Combine


extension PlanManualCreatePipeline {
    internal func getSaveLandmarksInDatabaseTask(landmarks: Array<PlanCreatePipelineLandmarkSchema>) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError>{
        let task = Empty<PipelineDatabaseTaskOutput, PipelineDatabaseError>()
        landmarks.forEach {
            schema in
            _ = task.merge(with:
                            self.getSaveLandmarksObjectInDatabaseSubtask(
                                landmarkName: schema.name,
                                landmarkDescription: schema.description,
                                remoteId: schema.remoteId))
        }
        
        return task.eraseToAnyPublisher()
    }

    internal func getMakeCreatePlanHTTPRequestTask(parameters : ManualPlanCreateRequestParameters) -> AnyPublisher<PipelineNetworkTaskOutput, PipelineNetworkError> {
        let task = Future<PipelineNetworkTaskOutput, PipelineNetworkError>(){
            promise in
            self.planHTTPClient.sendManualPlanCreateRequest(parameters: parameters){
                response, error in
                
                guard let error = error else {
                    guard let response = response else {
                        promise(Result.failure(PipelineNetworkError.InvalidResponse))
                        return
                    }
                    promise(Result.success(PipelineNetworkTaskOutput.PlanRemoteId(remoteId: response.id)))
                    return
                }
                promise(Result.failure(PipelineNetworkError.NetworkRequestFailed(error: error)))
            }
        }
        
        return task.eraseToAnyPublisher()
        
    }

    internal func getMapCreatePlanHTTPRequestParametersTask(planName : String?, planDescription : String?, landmarks: Array<PlanCreatePipelineLandmarkSchema>?) -> AnyPublisher<PipelineNetworkTaskOutput, PipelineNetworkError>{
        let task = Future<PipelineNetworkTaskOutput, PipelineNetworkError>(){
            promise in
            guard let planName = planName, let planDescription = planDescription, let landmarks = landmarks else {
                promise(Result.failure(PipelineNetworkError.InvalidRequestParameters(description: "invalid create http plan request parameters")))
                return
            }
            self.mapCreatePlanHTTPRequestTaskParameters(planName: planName, planDescription: planDescription, landmarkSchemas: landmarks, promise: promise)
        }
        return task.eraseToAnyPublisher()
    }
    
    internal func getAssignRemoteIdToPlanTask(identifier: UUID?, remoteId: String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
        let task = Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>() {
            promise in
            guard let databaseClient = self.planDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            
            guard let identifier = identifier, let remoteId = remoteId else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid Assign Remote Id To Plan Task schema")))
                return
            }
            
            databaseClient.updatePlanObjectRemoteId(id: identifier, remoteId: remoteId){
                result in 
                switch result {
                case .success:
                    promise(Result.success(PipelineDatabaseTaskOutput.Void))
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
            
        }
        return task.eraseToAnyPublisher()
    }
    
    internal func getCreateDatabaseRelationshipsTask(currentToken: String, planIdentifier: UUID, landmarkIdentifiers : Array<UUID>) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError>{
        let task = Empty<PipelineDatabaseTaskOutput, PipelineDatabaseError>()
        
        
        
        landmarkIdentifiers.forEach {
            landmarkIdentifier in
            _ = task.merge(with: Future(){
                promise in
                
                guard let databaseClient = self.planToLandmarkDatabaseClient else {
                    promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                    return
                }
                
                databaseClient.createPlanToLandmarkRelationship(
                    planId: planIdentifier, landmarkId: landmarkIdentifier){
                        result in
                        switch result {
                        case .success:
                            promise(Result.success(PipelineDatabaseTaskOutput.Void))
                        case .failure(let error):
                            promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                        }
                    }
            }.eraseToAnyPublisher())
        }
        
        return task.eraseToAnyPublisher().merge(with: Future(){
            promise in
            guard let databaseClient = self.planToUserDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            
            databaseClient.createPlanToUserRelationship(planId: planIdentifier, userCurrentToken: currentToken){
                result in
                switch result {
                case .success:
                    promise(Result.success(PipelineDatabaseTaskOutput.Void))
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
            
        }.eraseToAnyPublisher())
        .eraseToAnyPublisher()
    }
    
    internal func getSavePlanObjectInDatabaseTask(planName : String?, planDescription : String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
        Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>(){promise in
            guard let databaseClient = self.planDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            
            guard let planName = planName, let planDescription = planDescription  else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid plan schema data")))
                return
            }
            
            databaseClient.createPlanObject(name:  planName, description: planDescription, completed: false){
                result in
                switch result {
                case .success:
                    do {
                        let identifier = try result.get()
                        promise(Result.success(PipelineDatabaseTaskOutput.PlanUUID(identifier: identifier)))
                        
                    } catch {
                        promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                    }
                    
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    private func getSaveLandmarksObjectInDatabaseSubtask(landmarkName : String?, landmarkDescription : String?, remoteId : String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError>{
        let subtask = Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>(){ promise in
            guard let landmarkName = landmarkName, let landmarkDescription = landmarkDescription, let remoteId = remoteId else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid landmark schema data")))
                return
            }
            
            guard let databaseClient = self.landmarkDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            databaseClient.createLandmarkObject(remoteId: remoteId, name: landmarkName, description: landmarkDescription, type: "poi"){
                result in
                switch result {
                case .success:
                    do {
                        let identifier = try result.get()
                        promise(Result.success(PipelineDatabaseTaskOutput.LandmarkUUID(identifier: identifier)))
                        
                    } catch {
                        promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                    }
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
        }
        return subtask.eraseToAnyPublisher()
    }
}


extension LandmarkSearchPipeline {
    internal func getMakeHTTPSearchPlanRequestTask(mode: LandmarkSearchPipelineMode) -> AnyPublisher<PipelineNetworkTaskOutput, PipelineNetworkError> {
        let task = Future<PipelineNetworkTaskOutput, PipelineNetworkError>(){
            promise in
            let parameters = LandmarkSearchByRadiusParameters(
                latitude: "52.377956",
                longitude: " 4.897070",
                radius: "50000")
            self.landmarkHTTPClient.sendSearchLandmarkByRadiusRequest(
                parameters: parameters){
                    response, error in
                    guard let error = error else {
                        guard let response = response else {
                            promise(Result.failure(PipelineNetworkError.InvalidResponse))
                            return
                        }
                        promise(Result.success(PipelineNetworkTaskOutput.LandmarkSearchByRadiusHTTPRequestResponse(response: response)))
                        return
                    }
                    promise(Result.failure(PipelineNetworkError.NetworkRequestFailed(error: error)))
                }
        }
        return task.eraseToAnyPublisher()
    }
}


extension PlanFetchPipeline {
    internal func getFetchAllPlansByUserTokenTask(userToken: String?) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
        let task = Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>(){
            promise in
            guard let userToken = userToken else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid userToken")))
                return
            }
            guard let databaseClient = self.planToUserDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            
            databaseClient.getAllPlanToUserRelationshipsByUserCurrentToken(userCurrentToken: userToken){
                result in
                switch result {
                case .success:
                    do {
                        let relationships = try result.get()
                        promise(Result.success(PipelineDatabaseTaskOutput.PlanToUserRelationshipArray(relationships: relationships)))
                        
                    } catch {
                        promise(Result.failure(PipelineDatabaseError.InvalidDatabaseResponse))
                    }
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
        }
        return task.eraseToAnyPublisher()
    }
    
    internal func getPlanFetchResultMapTask(relationships : Array<PlanToUser>) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
        let task = Future<PipelineDatabaseTaskOutput, PipelineDatabaseError>(){
            promise in
            let plans = relationships.compactMap {
                $0.plan
            }
            promise(Result.success(PipelineDatabaseTaskOutput.PlanArray(plans: plans)))
            
        }
        return task.eraseToAnyPublisher()
    }
}

extension PlanEditPipeline {
    internal func getSavePlanEditInLocalDatabaseTask(schema: PlanEditPipelineSchema) -> AnyPublisher<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
        let task = Future<PipelineDatabaseTaskOutput, PipelineDatabaseError> {
            promise in
            guard let databaseClient = self.planDatabaseClient else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Database client is not initialized")))
                return
            }
            guard let identifier = schema.identifier else {
                promise(Result.failure(PipelineDatabaseError.InvalidObjectSchema(description: "Invalid task schema")))
                return 
            }
            databaseClient.updatePlan(identifier: identifier,
                                      name: schema.name,
                                      description: schema.description,
                                      remoteId: nil,
                                      completed: schema.completed){
                result in
                switch result {
                case .success:
                    promise(Result.success(PipelineDatabaseTaskOutput.Void))
                case .failure(let error):
                    promise(Result.failure(PipelineDatabaseError.DatabaseRequestFailed(error: error)))
                }
            }
            
        }
        return task
            .eraseToAnyPublisher()
    }
    
    internal func getSavePlanEditInRemoteDatabaseTask(schema: PlanEditPipelineSchema) ->
    AnyPublisher<PipelineNetworkTaskOutput, PipelineNetworkError> {
        let task = Future<PipelineNetworkTaskOutput, PipelineNetworkError> {
            promise in
            guard let identifier = schema.identifier else {
                promise(Result.failure(PipelineNetworkError.InvalidObjectSchema(description: "No plan identifier provided")))
                return
            }
            
            let parameters = PlanEditByIdParameters(
                identifier:  identifier,
                name: schema.name,
                description: schema.description,
                completed: schema.completed
            )
            self.planHTTPClient.sendPlanEditByIdRequest(parameters: parameters){
                response, error in
                guard let error = error else {
                    guard let response = response else {
                        promise(Result.failure(PipelineNetworkError.InvalidResponse))
                        return
                    }
                    promise(Result.success(PipelineNetworkTaskOutput.Void))
                    return
                }
                promise(Result.failure(PipelineNetworkError.NetworkRequestFailed(error: error)))
            }
        }
        return task.eraseToAnyPublisher()
    }
}
