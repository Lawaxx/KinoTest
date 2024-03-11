//
//  KinoTestApp.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import SwiftUI

@main
struct KinoTestApp: App {
    
     let apiService: APIService = APIService(networkingService: RealNetworkingService())

    var body: some Scene {
        WindowGroup {
            ContentView(vehicleService: apiService)
        }
    }
}
