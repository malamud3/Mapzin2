import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirections: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        VStack(spacing: 16) {
            headerView
            lookAroundPreview
            actionButtons
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding()
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { _, _ in
            fetchLookAroundPreview()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mapSelection?.placemark.name ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(mapSelection?.placemark.title ?? "")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: closeView) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                    .background(Circle().fill(Color(.systemGray6)))
            }
            .accessibilityLabel("Close")
        }
        .padding([.top, .horizontal])
    }
    
    private var lookAroundPreview: some View {
        Group {
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
                    .padding()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
        .animation(.easeInOut, value: lookAroundScene)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 24) {
            Button(action: openInMaps) {
                Text("Open in Maps")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 170, height: 48)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
            }
            .accessibilityLabel("Open in Maps")
            
            Button(action: startDirections) {
                Text("Get Directions")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 170, height: 48)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
            }
            .accessibilityLabel("Get Directions")
            .padding(.trailing)
        }
        .padding([.horizontal, .bottom])
    }
    
    private func closeView() {
        withAnimation {
            show.toggle()
        }
        mapSelection = nil
    }
    
    private func openInMaps() {
        if let mapSelection {
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
    LocationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(true))
}
