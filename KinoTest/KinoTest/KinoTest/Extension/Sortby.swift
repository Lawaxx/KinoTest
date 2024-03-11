//
//  Sortby.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 09/03/2024.
//

import Foundation

enum SortCriterion: String {
    case name = "name"
    case id = "id"
}

func sortVehicles(_ vehicles: [Vehicle], by criterion: SortCriterion) -> [Vehicle] {
    switch criterion {
    case .name:
        return vehicles.sorted(by: { $0.name < $1.name })
    case .id:
        return vehicles.sorted(by: { $0.id < $1.id })
    }
}
