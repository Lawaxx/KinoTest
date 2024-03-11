//
//  NetworkingServiceTest.swift
//  KinoTestTests
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import XCTest
@testable import KinoTest

final class NetworkingServiceTest: XCTestCase {

    func testNetworkingServiceSuccessResponse() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "{\"key\": \"value\"}".data(using: .utf8)
            return (response, data)
        }
        
        let networkingService = NetworkingService(session: session)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        let url =  "https://kino.com"
        
        networkingService.fetchData(urlString: url) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTFail("Expected success, but got \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNetworkingServiceFailureResponse() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        let networkingService = NetworkingService(session: session) // Utilisez la session configurée
        
        let expectation = self.expectation(description: "Completion handler invoked on failure")
        
        let url =  "https://example.com/nonexistent"
        
        networkingService.fetchData(urlString: url) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, APIError.serverResponseError, "Expected serverResponseError, but got \(error)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchVehiclesSuccess() {
    
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        
        let vehiclesJSON = """
          {
              "vehicleList": {
                  "status": "success",
                  "response": [
                      {
                          "id": 1,
                          "name": "Vehicle Name",
                          "training": "Some Training",
                          "icon": {
                              "anchor": {"x": 0, "y": 0},
                              "size": {"height": 100, "width": 100},
                              "url": {
                                  "left": "https://example.com/left.png",
                                  "right": "https://example.com/right.png",
                                  "size50x50": "https://example.com/50x50.png"
                              }
                          }
                      }
                  ]
              }
          }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, vehiclesJSON)
        }
        
        let networkingService = NetworkingService(session: session)
        

        let expectation = self.expectation(description: "fetchVehicles succeeds")
        networkingService.fetchVehicles { result in
            switch result {
            case .success(let vehicles):
                XCTAssert(!vehicles.isEmpty, "Should have received some vehicles")
                    if let firstVehicle = vehicles.first {
                        XCTAssertEqual(firstVehicle.id, 3)
                        XCTAssertEqual(firstVehicle.name, "4x4")
                    }
            case .failure(let error):
                XCTFail("Expected successful fetchVehicles, but failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

}
