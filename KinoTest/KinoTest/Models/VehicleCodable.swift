//
//  VehicleCodable.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import Foundation

struct Vehicle: Codable, Identifiable, Equatable {
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.training == rhs.training
    }
    
    let id: Int
    let name: String
    let training: String?
    let icon: Icon
}

struct Icon: Codable, Equatable {
    static func == (lhs: Icon, rhs: Icon) -> Bool {
        return lhs.anchor == rhs.anchor && lhs.size == rhs.size && lhs.url == rhs.url
    }
    
    let anchor: Anchor
    let size: Size
    let url: Url
}

struct Anchor: Codable , Equatable {
    let x: Int
    let y: Int
}

struct Size: Codable, Equatable {
    let height: Int
    let width: Int
}

struct Url: Codable, Equatable {
    let left: String
    let right: String
    let size50x50: String
}

struct Response: Codable {
    let vehicleList: VehicleList
    
    private enum CodingKeys: String, CodingKey {
            case vehicleList
        }
}

struct VehicleList: Codable {
    let status: String
    let response: [Vehicle]
    
    private enum CodingKeys: String, CodingKey {
          case status
          case response
      }
}
