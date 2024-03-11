//
//  MockAPIService.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

class MockAPIService: APIServiceProtocol {
   
    
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {

        let jsonString = """
               {
                   "title": "Sample Movie",
                   "genre": "Drama"
               }
           """
        let data = jsonString.data(using: .utf8)
        completion(data, nil)
    }

    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void) {

        let mockVehicles = [
            Vehicle(id: 1, name: "Car 13", training: "Training 1", icon: Icon(anchor: Anchor(x: 0, y: 0), size: Size(height: 0, width: 0), url: Url(left: "left_url", right: "right_url", size50x50: "size50x50_url"))),
            Vehicle(id: 2, name: "Car 42", training: "Training 2", icon: Icon(anchor: Anchor(x: 0, y: 0), size: Size(height: 0, width: 0), url: Url(left: "left_url", right: "right_url", size50x50: "size50x50_url")))
        ]
        completion(.success(mockVehicles))
    }
}
