//
//  SharedViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 28/08/2024.
//

import Foundation
class SharedViewModel: ObservableObject {
    @Published var selectedItem: String?
    @Published var showAccordionList: Bool = false
}
