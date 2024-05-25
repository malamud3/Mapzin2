//
//  ContentView.swift
//  Mapzin
//
//  Created by Amir Malamud on 17/03/2024.
//

import SwiftUI
import MapKit

struct HomeView: View {
//    @ObservedObject var viewModel: LocationViewModel
//    @State private var position: MapCameraPosition = .userLocation( fallback: .automatic)
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var  results = [MKMapItem]()
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition){
                Annotation("", coordinate: .userLocation){
                    ZStack{
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.blue.opacity(0.25))
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.blue)
                    }
                }
                ForEach(results, id: \.self){ item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate:  placemark.coordinate  )
                                    
                }
            }
            
            .overlay(alignment:.top){
                TextField("Search for locations", text:$searchText)
                    .font(.subheadline)
                    .padding(12)
                    .background(.white)
                    .padding()
                    .shadow(radius: 10)
            }
            .onSubmit(of: .text) {
                Task {
                    await searchPlaces()
                }
            }
            .mapControls{
                MapUserLocationButton()
                MapPitchToggle()
                MapCompass()

            }
        }
  
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

extension HomeView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
}

extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        return .init(latitude: 32.1226, longitude: 34.8065)
    }
}
extension MKCoordinateRegion{
    static var userRegion: MKCoordinateRegion{
        return .init(center: .userLocation, 
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}
//#Preview {
//    HomeView(viewModel: LocationViewModel())
//}

