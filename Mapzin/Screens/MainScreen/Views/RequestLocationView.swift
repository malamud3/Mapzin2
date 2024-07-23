//
//  RequestLocationView.swift
//  Mapzin
//
//  Created by Amir Malamud on 22/06/2024.
//
import SwiftUI

struct RequestLocationView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            Text("This app requires access to your location.")
                .padding()
            Button(action: {
                locationManager.requestLocationAuthorization()
            }) {
                Text("Grant Location Access")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
