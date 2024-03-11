//
//  RealNetworkingService.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 07/03/2024.
//

import Foundation

class RealNetworkingService: NetworkingServiceProtocol {
    
    func fetchData(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.URLError))
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
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
            }
        }.resume()
    }

    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void) {
    
        let urlString = "http://api.kinomap.com/vehicle/list?icon=1&lang=en-gb&forceStandard=1&outputFormat=json&appToken=\(appToken)"
        
        fetchData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let vehicles = try JSONDecoder().decode([Vehicle].self, from: data)
                    completion(.success(vehicles))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
