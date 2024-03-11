//
//  APIServiceTest.swift
//  KinoTestTests
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import XCTest
@testable import KinoTest


final class APIServiceTest: XCTestCase {
    
    var apiService: APIService!
    var mockNetworkingService: MockNetworkingService!
    
    override func setUpWithError() throws {
        super.setUp()
        mockNetworkingService = MockNetworkingService()
        apiService = APIService(networkingService: mockNetworkingService)
    }
    
    override func tearDownWithError() throws {
        apiService = nil
        mockNetworkingService.mockVehicles = nil
        mockNetworkingService.mockData = nil
        mockNetworkingService.mockError = nil
        super.tearDown()
    }
    
    func testFetchVehiclesSuccess() {
        
        mockNetworkingService.configureForSuccessToo()

        let expectation = self.expectation(description: "Fetching vehicles succeeds")

        apiService.fetchVehicles { result in
            switch result {
                case .success(let vehicles):
                    
                    XCTAssertNotNil(vehicles)
                    XCTAssertEqual(vehicles.count, 1)
                    
                    let vehicle = vehicles.first!
                                XCTAssertEqual(vehicle.id, 3)
                                XCTAssertEqual(vehicle.name, "4x4")
                                XCTAssertEqual(vehicle.training, nil)
                                XCTAssertEqual(vehicle.icon.url.left, "https://static.kinomap.com/img/icons/km_4x4l.png")
                                XCTAssertEqual(vehicle.icon.url.right, "https://static.kinomap.com/img/icons/km_4x4r.png")
                                XCTAssertEqual(vehicle.icon.url.size50x50, "https://static.kinomap.com/img/icons/50x50/km_4x4.png")

                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    
    func testFetchVehiclesFailure() {
        
        mockNetworkingService.configureForFailure(withError: .dataError)
        
        XCTAssertEqual(mockNetworkingService.mockError, .dataError, "MockNetworkingService should be configured to fail with .dataError")

        let expectation = self.expectation(description: "Expecting fetch to fail")

        apiService.fetchVehicles { result in
            switch result {
                case .success(_):
                    XCTFail("Was expecting failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error, .dataError)
                    expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchVehiclesNetworkError() {
        mockNetworkingService.mockError = .URLError
        let expectation = self.expectation(description: "Expecting network error")

        apiService.fetchVehicles { result in
            if case .failure(let error) = result, error == .URLError {
                expectation.fulfill()
            } else {
                XCTFail("Expected URLError, got \(result)")
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchVehiclesFailureDueToDecodingError() {
       
        let invalidJSONData = "{\"invalid\": \"data\"}".data(using: .utf8)!
        mockNetworkingService.mockData = invalidJSONData
        mockNetworkingService.mockError = nil

        let expectation = self.expectation(description: "Fetching vehicles fails due to decoding error")

        apiService.fetchVehicles { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure due to decoding error, got success")
            case .failure(let error):
                XCTAssertEqual(error, .decodeError)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testFetchDataWithInvalidURL() {
        let invalidURLString = "This is not a valid URL"
        mockNetworkingService.fetchData(urlString: invalidURLString) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure due to invalid URL, got success")
            case .failure(let error):
                XCTAssertEqual(error, .URLError)
            }
        }
    }

    func testFetchVehiclesWithEmptyResponse() {
        let emptyVehiclesJSON = "{\"vehicleList\": {\"status\": \"OK\", \"response\": []}}"
        mockNetworkingService.mockData = emptyVehiclesJSON.data(using: .utf8)
        mockNetworkingService.mockError = nil

        let expectation = self.expectation(description: "Fetching vehicles with empty response")

        apiService.fetchVehicles { result in
            switch result {
            case .success(let vehicles):
                XCTAssertTrue(vehicles.isEmpty)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success with empty vehicles list, got failure")
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testFetchDataSuccess() {
        
        mockNetworkingService.mockData = mockJSON.data(using: .utf8)
        
        let expectation = self.expectation(description: "fetchData success")

        guard let url = URL(string: "https://valid.url") else {
            XCTFail("URL invalide")
            return
        }
        let decoder = JSONDecoder()
        mockNetworkingService.fetchData(urlString: url.absoluteString) { result in
                switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try decoder.decode(Response.self, from: data)
                        let vehicles = decodedResponse.vehicleList.response
                        XCTAssertEqual(vehicles.first?.id , 3)
                        XCTAssertEqual(vehicles.first?.name, "4x4")
                        
                        expectation.fulfill()
                    } catch {
                        XCTFail("Decoding failed with error: \(error)")
                    }
                    
                case .failure(_):
                    XCTFail("Expected success, got failure")
                }
            }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

        func testFetchDataFailure() {
            
            mockNetworkingService.mockError = .URLError

            let expectation = self.expectation(description: "fetchData failure")

            guard let url = URL(string: "https://valid.url") else {
                XCTFail("URL invalide")
                return
            }
            apiService.fetchData(url: url) { result in
                if case .failure(let error) = result {
                    XCTAssertEqual(error, .URLError)
                    expectation.fulfill()
                }
            }

            waitForExpectations(timeout: 1.0, handler: nil)
        }
}
