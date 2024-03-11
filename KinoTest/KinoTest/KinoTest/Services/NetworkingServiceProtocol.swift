//
//  NetworkingServiceProtocol.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

protocol NetworkingServiceProtocol {
    func fetchData(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void)
    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void)
}
