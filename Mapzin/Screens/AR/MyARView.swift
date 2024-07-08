//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//


import SwiftUI

struct MyARView: View {
    let buildingName: String
    var bdmFilePath: String? // Path to the BDM file
    
    var body: some View {
        ARSceneView(bdmFilePath: bdmFilePath)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("AR View for \(buildingName)", displayMode: .inline)
            .environmentObject(Coordinator())
    }
}
