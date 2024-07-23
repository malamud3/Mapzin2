//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.


import SwiftUI
import ARKit

struct MyARView: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var arViewModel = ARViewModel()

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arViewModel.setupARView(arView)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

struct MyARViewContainer: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var arViewModel = ARViewModel()

    var body: some View {
        ZStack {
            MyARView()
                .environmentObject(coordinator)
                .environmentObject(arViewModel)
            MyARViewOverlay()
                .environmentObject(arViewModel)
        }
    }
}

struct MyARViewOverlay: View {
    @EnvironmentObject var arViewModel: ARViewModel

    var body: some View {
        VStack {
            if let qrPosition = arViewModel.detectedQRCodePosition {
                Text("QR Position: x: \(qrPosition.x), y: \(qrPosition.y), z: \(qrPosition.z)")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            if let camPosition = arViewModel.cameraPosition {
                Text("Camera Position: x: \(camPosition.x), y: \(camPosition.y), z: \(camPosition.z)")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            Text(arViewModel.navigationInstructions)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)

            Text(arViewModel.doorNavigationInstructions)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)

            Text("Detected Windows: \(arViewModel.detectedWindows.count)")
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
