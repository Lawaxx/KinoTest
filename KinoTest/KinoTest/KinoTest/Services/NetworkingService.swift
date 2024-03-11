//
//  NetworkingService.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

class NetworkingService: NetworkingServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func fetchData(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.URLError))
            return
        }
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Networking error: \(error.localizedDescription)")
                completion(.failure(.URLError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.serverResponseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void) {
        
        let urlString = "http://api.kinomap.com/vehicle/list?icon=1&lang=en-gb&forceStandard=1&outputFormat=json&appToken=\(appToken)"
        
        fetchData(urlString: urlString) { result in
            switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                        let vehicles = decodedResponse.vehicleList.response
                        completion(.success(vehicles))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(.decodeError))
                    }
                case .failure(_):
                    completion(.failure(.serverResponseError))
            }
        }
    }
}
