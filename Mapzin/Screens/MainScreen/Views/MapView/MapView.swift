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
                Annotation("", coordinate: .userLocation) {
                    UserLocationAnnotationView()
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
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(Color.blue, lineWidth: 6)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            CenterButton(action: centerOnUserLocation)
        }
    }

    private func centerOnUserLocation() {
        cameraPosition = .region(.userRegion)
    }
}
