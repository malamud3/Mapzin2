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
    var body: some View {
        VStack {
            Map(position: $cameraPosition){
                UserAnnotation()
                
                
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
                
            }
       
            .mapControls{
                MapCompass()
                MapUserLocationButton()
                MapPitchToggle()
            }
        }
  
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
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
                     latitudinalMeters: 20000,
                     longitudinalMeters: 20000)
    }
}
//#Preview {
//    HomeView(viewModel: LocationViewModel())
//}

