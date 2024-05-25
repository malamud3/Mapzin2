//
//  MapView.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var mapSelection: MKMapItem?
    @Binding var results: [MKMapItem]
    @Binding var route: MKRoute?
    @Binding var routeDisplaying: Bool
    @Binding var routeDestination: MKMapItem?

    var body: some View {
        ZStack {
            Map(position: $cameraPosition, selection: $mapSelection) {
                // User location annotation
                Annotation("", coordinate: .userLocation) {
                    ZStack {
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

                // Results annotations
                ForEach(results, id: \.self) { item in
                                    if routeDisplaying {
                                        if item == routeDestination {
                                            let placemark = item.placemark
                                            Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                                        }
                                    } else{
                                        let placemark = item.placemark
                                        Marker(placemark.name ?? "", coordinate:  placemark.coordinate  )
                                    }
                                }

                // Route polyline
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(Color.blue, lineWidth: 6)
                }
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        centerOnUserLocation()
                    }) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
            }
        }
    }

    private func centerOnUserLocation() {
        cameraPosition = .region(.userRegion)
    }
}

