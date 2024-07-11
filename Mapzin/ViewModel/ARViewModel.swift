//
//  ARViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 08/07/2024.
//

import Foundation
import ARKit

class ARViewModel: ObservableObject {
    var arModel: ARModel

    init(model: ARModel) {
        self.arModel = model
    }

    func createARConfiguration() -> ARWorldTrackingConfiguration {
        return ARWorldTrackingConfiguration()
    }
}
