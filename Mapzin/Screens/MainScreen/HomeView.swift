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
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?

    var body: some View {
        VStack {
            Map(position: $cameraPosition, selection: $mapSelection){
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
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth:6)
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
            .onChange(of: getDirections, { oldValue, newValue in
                if newValue {
                    fetchRoute()
                }
            })
            .onChange(of: mapSelection, {oldValue, newValue in
                showDetails = newValue != nil
            })
            .sheet(isPresented: $showDetails, content: {
                LocationDetailsView(
                                    mapSelection: $mapSelection,
                                    show: $showDetails, 
                                    getDirections: $getDirections
                )
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
                    .padding()
            })
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
    
    func fetchRoute(){
        if let mapSelection{
            let req = MKDirections.Request()
            req.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            req.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: req).calculate()
                route = result?.routes.first
                routeDestination = mapSelection
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
            
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
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}
//#Preview {
//    HomeView(viewModel: LocationViewModel())
//}
