//
//  APIError.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

enum APIError: String, Error {
    
    case URLError = "there is a problem with the URL"
    case serverResponseError = "error server reponse"
    case decodeError = "Data can't be decoded !"
    case dataError = "The service is momentarily unavailable"
    
}
