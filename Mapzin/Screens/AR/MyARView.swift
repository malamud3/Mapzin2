//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//


//import SwiftUI
//
//struct MyARView: View {
//   @StateObject private var viewModel = MapViewModel(
//            arService: ARService(),
//            poiService: POIService(),
//            floorService: FloorService(),
//            bdmService: BDMService()
//    )
//    let buildingName: String
//    var bdmFilePath: String? // Path to the sBDM file
//    
//    var body: some View {
//        ZStack{
//            ARSceneView(viewModel: viewModel, bdmFilePath: bdmFilePath)
//                .edgesIgnoringSafeArea(.all)
//                .navigationBarTitle("AR View for \(buildingName)", displayMode: .inline)
//            VStack {
//                            Text(viewModel.arStatus)
//                                .padding()
//                                .background(Color.black.opacity(0.7))
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                            
//                            Spacer()
//                            
//                            if viewModel.isPlaneDetected {
//                                Text("Plane detected!")
//                                    .padding()
//                                    .background(Color.green.opacity(0.8))
//                                    .foregroundColor(.white)
//                                    .cornerRadius(10)
//                            }
//                        }
//        }
//
//    }
//}
import SwiftUI
import ARKit

struct MyARView: UIViewRepresentable {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var arViewModel = ARViewModel()
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        
        // Setup ARView using coordinator
        arViewModel.setupARView(arView)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: arViewModel, action: #selector(arViewModel.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
