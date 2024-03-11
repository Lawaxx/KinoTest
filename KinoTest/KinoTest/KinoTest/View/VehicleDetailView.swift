//
//  VehicleDetailView.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import SwiftUI
import URLImage

struct VehicleDetail: View {
    
    let vehicle: Vehicle

    var body: some View {
        ScrollView {
            VStack {
                Text("\(vehicle.name)")
                    .bold()
                    .font(.system(size: 55, weight: .semibold, design: .default))
                    .italic()
                    .padding()
                
                if let imageUrl = URL(string: vehicle.icon.url.size50x50) {
                    URLImage(imageUrl) { proxy in
                        proxy
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .topLeading)
                    }
                } else {
                    Image(systemName: "Car.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .topLeading)
                }
                
                Text("ID : \(vehicle.id)")
                    .bold()
                    .font(.subheadline)
                    .italic()
                
            }.padding()
        }
    }
}


struct VehicleDetail_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetail(vehicle: Vehicle(id: 1, name: "Test Vehicle", training: "Test Training", icon: Icon(anchor: Anchor(x: 0, y: 0), size: Size(height: 100, width: 100), url: Url(left: "", right: "", size50x50: "https://example.com/image.png"))))
    }
}
