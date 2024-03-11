//
//  MockNetworkingService.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

class MockNetworkingService: NetworkingServiceProtocol {
    
    var mockData: Data?
    var mockError: APIError?
    var mockVehicles: [Vehicle]?
    var mockResponse: String?

    // Simule la récupération de données brutes à partir d'une URL donnée.
    func fetchData(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let data = mockData {
            completion(.success(data))
        }
    }

    // Simule la récupération des véhicules.
    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let vehicles = mockVehicles {
            completion(.success(vehicles))
        }
    }
    
    // Méthode utilitaire pour configurer le mock pour réussir avec des données spécifiques.
    func configureForSuccess(withVehicles vehicles: [Vehicle]) {
        self.mockVehicles = vehicles
        self.mockData = mockJSON.data(using: .utf8)
        self.mockError = nil
    }
    // Méthode utilitaire pour configurer le mock pour réussir avec d'autres données spécifiques.
    func configureForSuccessToo() {
        if let jsonData = mockJSON.data(using: .utf8) {
            self.mockData = jsonData
            self.mockError = nil
        }
    }
    // Méthode utilitaire pour configurer le mock pour echouer avec des données spécifiques.
    func configureForFailure(withError error: APIError) {
        self.mockVehicles = nil
        self.mockError = error
    }
}
