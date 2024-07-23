//
//  LocationDetailsSheet.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/06/2024.
//

import SwiftUI
import MapKit

struct LocationDetailsSheet: ViewModifier {
    @Binding var showDetails: Bool
    @Binding var mapSelection: MKMapItem?
    @Binding var getDirections: Bool

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showDetails) {
                if mapSelection != nil {
                    LocationDetailsView(
                        mapSelection: $mapSelection,
                        show: $showDetails,
                        getDirections: $getDirections
                    )
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
                    .padding()
                }
            }
    }
}

extension View {
    func locationDetailsSheet(
        showDetails: Binding<Bool>,
        mapSelection: Binding<MKMapItem?>,
        getDirections: Binding<Bool>
    ) -> some View {
        self.modifier(LocationDetailsSheet(
            showDetails: showDetails,
            mapSelection: mapSelection,
            getDirections: getDirections
        ))
    }
}

