//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.

import SwiftUI
import ARKit

struct ARViewContainer: View {
    @StateObject private var viewModel = ARViewModel()
    @StateObject private var sharedViewModel = SharedViewModel()
    @State private var showInstructions = false
    @State private var showSettings = false
//    @State private var currentObjectIndex = 0

     
    var body: some View {
        ZStack {
            ARViewRepresentable(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: 20)
                topBar
                Spacer()
                if showInstructions {
                    instructionsPanel
                }
                bottomBar
            }
            .padding()
            .safeAreaInset(edge: .top, content: { Color.clear.frame(height: 0) })
            .safeAreaInset(edge: .bottom, content: { Color.clear.frame(height: 0) })
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $sharedViewModel.showAccordionList) {
            AccordionListView()
                .environmentObject(sharedViewModel)
        }
        .onChange(of: sharedViewModel.selectedItem) { _, newItem in
//            if let item = newItem {
//                viewModel.selectedItemObject = ARObject(name: item, position: SCNVector3(-0.568, -0.478, -1.851), color: .green)
//            }
//            viewModel.selectedItemObject = ARObject(name: item, position: SCNVector3(-6.134, 0.067, 0.622), color: .green)
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { sharedViewModel.showAccordionList = true }) {
                Image(systemName: "list.bullet")
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
            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
    }

    private var instructionsPanel: some View {
            VStack(alignment: .leading, spacing: 10) {
                if let instruction = viewModel.currentInstruction {
                    HStack {
                        Image(systemName: getDirectionIcon(instruction.direction ?? ""))
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(instruction.roomName)
                                .font(.headline)
                            Text("\(String(describing: instruction.direction?.capitalized)) for \(String(format: "%.2f", instruction.distance ?? "")) m")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                } else {
                    Text("No current instructions")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }

        private func getDirectionIcon(_ direction: String) -> String {
            switch direction {
            case "to your left":
                return "arrow.turn.up.left"
            case "to your right":
                return "arrow.turn.up.right"
            case "in front of you":
                return "arrow.up"
            case "behind you":
                return "arrow.down"
            default:
                return "questionmark"
            }
        }
    private var bottomBar: some View {
        HStack {
            statusIndicator
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
