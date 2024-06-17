//
//  BaseCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    func start() {
        fatalError("Start method should be implemented.")
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
