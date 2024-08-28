//
//  AccordionItem.swift
//  Mapzin
//
//  Created by Amir Malamud on 28/08/2024.
//

import Foundation
struct AccordionItem: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}
