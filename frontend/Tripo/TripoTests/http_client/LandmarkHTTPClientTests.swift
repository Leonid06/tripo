//
//  LandmarkHTTPClientTests.swift
//  TripoTests
//
//  Created by Leonid on 20.07.2023.
//

import XCTest
import Alamofire
@testable import Tripo

final class LandmarkHTTPClientTests : TripoTests {
//    func testGetlandmarkByIdHTTPRequest(){
//        let callbackExpectation = expectation(description: "received valid response")
//        let parameters = LandmarkGetByIdParameters(id: "1")
//
//        let service = LandmarkHTTPService()
//
//        service.sendGetLandmarkByIdRequest(parameters: parameters){
//            response, error in
//            print(error)
//            XCTAssert(error == nil)
//            XCTAssert(response != nil)
//            callbackExpectation.fulfill()
//        }
//        waitForExpectations(timeout: 1)
//    }
    func testSearchLandmarkByRadiusHTTPRequest(){
        let callbackExpectation = expectation(description: "received valid response")
        let parameters = LandmarkSearchByRadiusParameters(
            latitude: "48.864716",
            longitude: "2.349014",
            radius: "100000")
        
        let service = LandmarkHTTPService()
        
        service.sendSearchLandmarkByRadiusRequest(parameters: parameters){
            response, error in
            XCTAssert(error == nil)
            XCTAssert(response != nil)
            callbackExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
