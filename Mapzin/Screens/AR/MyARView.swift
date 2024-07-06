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

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat(arc4random()) / CGFloat(UInt32.max),
            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
            blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
            alpha: 1.0
        )
    }
}
