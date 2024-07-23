import SwiftUI
import MapKit

struct MapView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var results: [MKMapItem]
    @Binding var route: MKRoute?
    @Binding var routeDisplaying: Bool
    @Binding var routeDestination: MKMapItem?
    @EnvironmentObject var locationManager: LocationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

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
                    } else {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                }

                // Route polyline
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(Color.blue, lineWidth: 6)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                updateCameraPosition()
            }
        }
    }

    func updateCameraPosition() {
        if locationManager.isAuthorized, let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}
