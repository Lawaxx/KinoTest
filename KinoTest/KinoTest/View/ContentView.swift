//
//  ContentView.swift
//  KinoTest
//
//  Created by Aurelien Waxin on 06/03/2024.
//

import SwiftUI
import URLImage

struct ContentView: View {
    
    let vehicleService: APIServiceProtocol

    @State private var vehicles: [Vehicle] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = true
    @AppStorage("selectedSortCriterion") private var selectedSortCriterion: SortCriterion = .name


    var body: some View {
        NavigationView {
            List(vehicles) { vehicle in
                NavigationLink(destination: VehicleDetail(vehicle: vehicle)) {
                    HStack {
                        if let imageUrl = URL(string: vehicle.icon.url.size50x50) {
                            URLImage(imageUrl) { proxy in
                                proxy
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            }
                        } else {
                            Image(systemName: "car.fill") 
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        }
                        
                        Text(vehicle.name)
                            .badge("ID : \(vehicle.id)")
                            .padding(.leading, 10)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                        title: Text("Erreur"),
                        message: Text(alertMessage),
                        primaryButton: .default(Text("OK")),
                        secondaryButton: .default(Text("Réessayer")) {
                            self.fetchData()
                        }
                    )
            }
            .onAppear(perform: fetchData)
            .navigationBarTitle("Vehicles")
            .navigationBarItems(trailing: Group {
                            if isLoading {
                                ProgressView()
                            } else {
                                menuForSorting()
                            }
                        })
            .onChange(of: selectedSortCriterion) { _, _ in
                applySort()
            }
        }
    }

    init(vehicleService: APIServiceProtocol) {
        self.vehicleService = vehicleService
    }

    func fetchData() {
        vehicleService.fetchVehicles { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedVehicles):
                        self.vehicles = fetchedVehicles
                        self.applySort()
                case .failure(let error):
                    print("Erreur lors de la récupération des véhicules : \(error.localizedDescription)")
                    self.showAlert = true
                    self.alertMessage = "Erreur lors de la récupération des véhicules : \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }
    
    func menuForSorting() -> some View {
        Menu {
            Picker("Critère de tri", selection: $selectedSortCriterion) {
                Text("Nom").tag(SortCriterion.name)
                Text("ID").tag(SortCriterion.id)
            }
            .pickerStyle(InlinePickerStyle())
        } label: {
            Label("Trier", systemImage: "arrow.up.arrow.down")
        }
    }
    
    private func applySort() {
            vehicles.sort(by: {
                switch selectedSortCriterion {
                case .name: return $0.name < $1.name
                case .id: return $0.id < $1.id
                }
            })
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        let realNetworkingService = RealNetworkingService()

        let realService = APIService(networkingService: realNetworkingService)

        return ContentView(vehicleService: realService)
    }
}
