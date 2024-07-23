//
//  LocationDetailsView.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//


import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirections: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        VStack(spacing: 16) {
            HeaderView(mapSelection: $mapSelection, show: $show)
            LookAroundPreviewView(lookAroundScene: $lookAroundScene)
            ActionButtons(openInMaps: openInMaps, startDirections: startDirections)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { _, _ in
            fetchLookAroundPreview()
        }
    }
    
    private func openInMaps() {
        if let mapSelection = mapSelection {
            mapSelection.openInMaps()
        }
    }
    
    private func startDirections() {
        withAnimation {
            getDirections = true
            show = false
        }
    }
    
    private func fetchLookAroundPreview() {
        guard let mapSelection = mapSelection else { return }
        lookAroundScene = nil
        
        Task {
            let request = MKLookAroundSceneRequest(mapItem: mapSelection)
            do {
                lookAroundScene = try await request.scene
            } catch {
                print("Failed to fetch Look Around scene: \(error)")
            }
        }
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), 
                        show: .constant(false), getDirections: .constant(true))
}
