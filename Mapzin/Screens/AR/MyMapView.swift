//
//  MapView.swift
//  Mapzin
//
//  Created by Amir Malamud on 10/07/2024.
//

import SwiftUI

struct MyMapView: View {
    @StateObject private var viewModel = MapViewModel(
        arService: ARService(),
        bdmService: BDMService(),
        floorDetectionService: FloorDetectionService()
    )
    
    var body: some View {
        MyARView(buildingName: "Building Name", bdmFilePath: "path/to/your/bdmfile.bdm")
            .environmentObject(viewModel)
            .edgesIgnoringSafeArea(.all)
    }
}
