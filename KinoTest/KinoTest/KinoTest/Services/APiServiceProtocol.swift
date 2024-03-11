//
//  APiServiceProtocol.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

protocol APIServiceProtocol {
    func fetchVehicles(completion: @escaping (Result<[Vehicle], APIError>) -> Void)
}
