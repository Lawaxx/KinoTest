//
//  APIService.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

class APIService: APIServiceProtocol {
    
    let networkingService: NetworkingServiceProtocol
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
    }
    
    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void) {
        guard let url = URL(string: "http://api.kinomap.com/vehicle/list?icon=1&lang=en-gb&forceStandard=1&outputFormat=json&appToken=\(appToken)") else {
            completion(.failure(.URLError))
            return
        }

        networkingService.fetchData(urlString: url.absoluteString) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(Response.self, from: data)
                    let vehicles = decodedResponse.vehicleList.response
                    completion(.success(vehicles))
                } catch {
                    print("Decoding error:", error)
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
