//
//  Coordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//

import Foundation

@MainActor
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
