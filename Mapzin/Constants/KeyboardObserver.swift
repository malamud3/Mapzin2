//
//  KeyboardObserver.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import Combine
import SwiftUI

import Combine
import SwiftUI

class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                notification.name == UIResponder.keyboardWillShowNotification ?
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect :
                CGRect.zero
            }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)
    }
}


