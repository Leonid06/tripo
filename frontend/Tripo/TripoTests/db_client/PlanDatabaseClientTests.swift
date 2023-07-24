//
//  PlanDatabaseClientTests.swift
//  TripoTests
//
//  Created by Leonid on 24.07.2023.
//

import XCTest
import Cuckoo
@testable import Tripo


final class PlanDatabaseClientTests : TripoTests {
    
    func testCreatePlanObject() {
        let callbackExpectation = expectation(description: "received valid response")
        
        do {
            let client = try PlanDatabaseClient(version: V1.self)
            client.createPlanObject(
                remoteId: generateRandomUUIDString(), name: generateRandomUUIDString(), description: generateRandomUUIDString(), completed: false, callback: {
                    result in
                    switch result {
                    case .success:
                        callbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
        }catch {
            return
        }
       waitForExpectations(timeout: 1)
    }
    
    func testGetPlanObjectByRemoteId() {
        let createCallbackExpectation = expectation(description: "received valid response")
        let getCallbackExpectation = expectation(description: "received valid response")
        do {
            let client = try PlanDatabaseClient(version: V1.self)
            let remoteId = generateRandomUUIDString()
            client.createPlanObject(
                remoteId: remoteId, name: generateRandomUUIDString(), description: generateRandomUUIDString(), completed: false, callback: {
                    result in
                    switch result {
                    case .success:
                        createCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
            client.getPlanObjectByRemoteId(remoteId: remoteId, callback: {
                result in
                switch result {
                case .success:
                    getCallbackExpectation.fulfill()
                case .failure(let error):
                    print(error)
                }
            })
                
            
        
        }catch {
            return
        }
       waitForExpectations(timeout: 1)
    }
    
    func testUpdatePlanObjectByRemoteId(){
        let createCallbackExpectation = expectation(description: "received valid response")
        let updateCallbackExpectation = expectation(description: "received valid response")
        do {
            let client = try PlanDatabaseClient(version: V1.self)
            let remoteId = generateRandomUUIDString()
            client.createPlanObject(
                remoteId: remoteId, name: generateRandomUUIDString(), description: generateRandomUUIDString(), completed: false, callback: {
                    result in
                    switch result {
                    case .success:
                        createCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
            let newRemoteId = generateRandomUUIDString()
            client.updatePlanObjectRemoteId(oldRemoteId: remoteId, newRemoteId: newRemoteId , callback: {
                result in
                switch result {
                case .success:
                    updateCallbackExpectation.fulfill()
                case .failure(let error):
                    print(error)
                }
            })
        }catch {
            return
        }
       waitForExpectations(timeout: 1)
    }
    
    func testDeletePlanObjectByRemoteId(){
        let createCallbackExpectation = expectation(description: "received valid response")
        let deleteCallbackExpectation = expectation(description: "received valid response")
        do {
            let client = try PlanDatabaseClient(version: V1.self)
            let remoteId = generateRandomUUIDString()
            client.createPlanObject(
                remoteId: remoteId, name: generateRandomUUIDString(), description: generateRandomUUIDString(), completed: false, callback: {
                    result in
                    switch result {
                    case .success:
                        createCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
            client.deletePlanObjectByRemoteId(remoteId: remoteId, callback: {
                result in
                switch result {
                case .success:
                    deleteCallbackExpectation.fulfill()
                case .failure(let error):
                    print(error)
                }
            })
                
            
        
        }catch {
            return
        }
       waitForExpectations(timeout: 1)
    }
}

