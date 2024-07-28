//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.


import SwiftUI
import ARKit

struct ARViewContainer: View {
    @StateObject private var viewModel = ARViewModel()
    @State private var showInstructions = false
    @State private var showSettings = false


    var body: some View {
        ZStack {
            ARViewRepresentable(viewModel: viewModel)
            
            VStack {
                topBar
                Spacer()
                if showInstructions {
                    instructionsPanel
                }
                bottomBar
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            Spacer()
            Text("AR Navigation")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
            Spacer()
            Button(action: { showInstructions.toggle() }) {
                Image(systemName: showInstructions ? "info.circle.fill" : "info.circle")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
    }

    private var instructionsPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Navigation Instructions")
                .font(.headline)
            Text(viewModel.navigationInstructions)
                .font(.subheadline)
            if !viewModel.doorNavigationInstructions.isEmpty {
                Text("Door: \(viewModel.doorNavigationInstructions)")
                    .font(.subheadline)
            }
            Text("Detected Windows: \(viewModel.detectedWindows.count)")
                .font(.subheadline)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .transition(.move(edge: .top))
    }

    private var bottomBar: some View {
        HStack {
            statusIndicator
            Spacer()
            scanButton
        }

    }

    private var statusIndicator: some View {
        HStack {
            Circle()
                .fill(viewModel.detectedQRCodePosition != nil ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            Text(viewModel.detectedQRCodePosition != nil ? "QR Detected" : "Scanning...")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(20)
    }

    private var scanButton: some View {
        Button(action: { /* Trigger QR scan */ }) {
            Text("Scan QR")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Navigation Settings")) {
                    Toggle("Show Path", isOn: .constant(true))
                    Toggle("Audio Instructions", isOn: .constant(false))
                }
                Section(header: Text("Display Settings")) {
                    Picker("Map Style", selection: .constant(0)) {
                        Text("Standard").tag(0)
                        Text("Satellite").tag(1)
                        Text("Hybrid").tag(2)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Placeholder for ARViewRepresentable
struct ARViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        viewModel.setupARView(arView)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
