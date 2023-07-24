//
//  PlanHTTPClient.swift
//  TripoTests
//
//  Created by Leonid on 19.07.2023.
//

import XCTest
import Alamofire
@testable import Tripo


final class PlanHTTPClientTests : TripoTests {
    
    func testMakeCreatePlanHTTPRequest() {
        let callbackExpectation = expectation(description: "received valid response")
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let serializedDate = dateFormatter.string(from: date)
        
        let parameterUnits = [
            ManualPlanCreateRequestParametersUnit(
                landmark_id: "1", visit_date: serializedDate)
        ]
        let parameters = ManualPlanCreateRequestParameters(
            name: "ios_test_plan",
            description: "ios_test_description",
            plan_to_landmark: parameterUnits)
        
        let service = PlanHTTPService()
        
        service.sendManualPlanCreateRequest(parameters: parameters){
            response, error in
            print(error)
            XCTAssert(error == nil)
            XCTAssert(response != nil)
            callbackExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testMakeGetPlanByIdRequest() {
        let callbackExpectation = expectation(description: "received valid response")

        let parameters = PlanGetByIdParameters(plan_id: "2")
        
        let service = PlanHTTPService()
        
        service.sendPlanGetByIdRequest(parameters: parameters){
            response, error in
            print(error)
            XCTAssert(error == nil)
            XCTAssert(response != nil)
            callbackExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
