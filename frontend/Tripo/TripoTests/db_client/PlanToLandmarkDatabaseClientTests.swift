//
//  PlanToLandmarkDatabaseClientTests.swift
//  TripoTests
//
//  Created by Leonid on 24.07.2023.
//

import XCTest
@testable import Tripo

final class PlanToLandmarkDatabaseClientTests : TripoTests {
    private func createPLanAndLandmark(planRemoteId : String, landmarkRemoteId : String){
        let planCreateCallbackExpectation = expectation(description: "received valid response")
        
        do {
            let client = try PlanDatabaseClient(version: V1.self)
            client.createPlanObject(
                remoteId: planRemoteId, name: generateRandomUUIDString(), description: generateRandomUUIDString(), completed: false, callback: {
                    result in
                    switch result {
                    case .success:
                        planCreateCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
        }catch {
            return
        }
        let landmarkCreateCallbackExpectation = expectation(description: "received valid response")
        
        do {
            let client = try LandmarkDatabaseClient(version: V1.self)
            client.createLandmarkObject(
                remoteId: landmarkRemoteId, name: generateRandomUUIDString(), description: generateRandomUUIDString(), type: generateRandomUUIDString(), callback: {
                    result in
                    switch result {
                    case .success:
                        landmarkCreateCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
        }catch {
            return
        }
        
        
    }
    
    func testDeletePlanToLandmarkRelationship(){
        let planRemoteId = generateRandomUUIDString()
        let landmarkRemoteId = generateRandomUUIDString()
        createPLanAndLandmark(planRemoteId: planRemoteId, landmarkRemoteId: landmarkRemoteId)
        
        let relationshipDeleteCallbackExpectation = expectation(description: "received valid response")
        
        do {
            let client = try PlanToLandmarkDatabaseClient(version: V1.self)
      
            client.deletePlanToLandmarkRelationship(planRemoteId: planRemoteId, landmarkRemoteId: landmarkRemoteId){
                    result in
                    switch result {
                    case .success:
                        relationshipDeleteCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                }
        }catch {
            return
        }
        
       waitForExpectations(timeout: 1)
    }
    func testCreatePlanToLandmarkRelationship() {
        let planRemoteId = generateRandomUUIDString()
        let landmarkRemoteId = generateRandomUUIDString()
        createPLanAndLandmark(planRemoteId: planRemoteId, landmarkRemoteId: landmarkRemoteId)
        
        let relationshipCreateCallbackExpectation = expectation(description: "received valid response")
        
        do {
            let client = try PlanToLandmarkDatabaseClient(version: V1.self)
            
            client.createPlanToLandmarkRelationship(planRemoteId: planRemoteId, landmarkRemoteId: landmarkRemoteId){
                    result in
                    switch result {
                    case .success:
                        relationshipCreateCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                }
        }catch {
            return
        }
        
       waitForExpectations(timeout: 1)
    }
   
}
