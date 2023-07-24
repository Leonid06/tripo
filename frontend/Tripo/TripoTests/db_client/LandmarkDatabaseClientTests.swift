//
//  LandmarkDatabaseClientTests.swift
//  TripoTests
//
//  Created by Leonid on 24.07.2023.
//

import XCTest
@testable import Tripo


final class LandmarkDatabaseClientTests : TripoTests {
    
    func testCreateLandmarkObject() {
        let callbackExpectation = expectation(description: "received valid response")
        
        do {
            let client = try LandmarkDatabaseClient(version: V1.self)
            client.createLandmarkObject(
                remoteId: generateRandomUUIDString(), name: generateRandomUUIDString(), description: generateRandomUUIDString(), type: generateRandomUUIDString(), callback: {
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
    
    func testGetLandmarkObjectByRemoteId() {
        let createCallbackExpectation = expectation(description: "received valid response")
        let getCallbackExpectation = expectation(description: "received valid response")
        do {
            let client = try LandmarkDatabaseClient(version: V1.self)
            let remoteId = generateRandomUUIDString()
            client.createLandmarkObject(
                remoteId: generateRandomUUIDString(), name: generateRandomUUIDString(), description: generateRandomUUIDString(), type: generateRandomUUIDString(), callback: {
                    result in
                    switch result {
                    case .success:
                        createCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
            client.getLandmarkObjectByRemoteId(remoteId: remoteId, callback: {
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
    
    func testUpdateLandmarkObjectByRemoteId(){
        let createCallbackExpectation = expectation(description: "received valid response")
        let updateCallbackExpectation = expectation(description: "received valid response")
        do {
            let client = try LandmarkDatabaseClient(version: V1.self)
            let remoteId = generateRandomUUIDString()
            client.createLandmarkObject(
                remoteId: generateRandomUUIDString(), name: generateRandomUUIDString(), description: generateRandomUUIDString(), type: generateRandomUUIDString(), callback: {
                    result in
                    switch result {
                    case .success:
                        createCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
            let newRemoteId = generateRandomUUIDString()
            client.updateLandmarkObjectRemoteId(oldRemoteId: remoteId, newRemoteId: newRemoteId , callback: {
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
    
    func testDeleteLandmarkObjectByRemoteId(){
        let createCallbackExpectation = expectation(description: "received valid response")
        let deleteCallbackExpectation = expectation(description: "received valid response")
        do {
            let client = try LandmarkDatabaseClient(version: V1.self)
            let remoteId = generateRandomUUIDString()
            client.createLandmarkObject(
                remoteId: generateRandomUUIDString(), name: generateRandomUUIDString(), description: generateRandomUUIDString(), type: generateRandomUUIDString(), callback: {
                    result in
                    switch result {
                    case .success:
                        createCallbackExpectation.fulfill()
                    case .failure(let error):
                        print(error)
                    }
                })
            client.deleteLandmarkObjectByRemoteId(remoteId: remoteId, callback: {
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
