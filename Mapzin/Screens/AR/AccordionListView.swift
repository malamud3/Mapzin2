//
//  AccordionListView.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/08/2024.
//

import SwiftUI

class SharedViewModel: ObservableObject {
    @Published var selectedItem: String?
    @Published var showAccordionList: Bool = false
}

struct AccordionItem: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}

struct FlattenedItem: Identifiable {
    let id = UUID()
    let title: String
    let parentTitle: String
}

import SwiftUI

struct AccordionListView: View {
    @EnvironmentObject private var sharedViewModel: SharedViewModel
    
    let accordionItems = [
        AccordionItem(title: "Floor 0", items: ["Room 101", "Room 102", "Room 103", "Room 104","Stairs0","Bathroom0"]),
        AccordionItem(title: "Floor 1", items: ["Elevator", "Stairs1", "Restroom"]),
        AccordionItem(title: "Floor 2", items: ["Reception", "Cafeteria", "Conference Room"])
    ]
    @State private var expandedItems: Set<UUID> = []
    @State private var searchText = ""
    
    var flattenedItems: [FlattenedItem] {
        accordionItems.flatMap { item in
            item.items.map { FlattenedItem(title: $0, parentTitle: item.title) }
        }
    }
    
    var filteredItems: [FlattenedItem] {
        if searchText.isEmpty {
            return []
        } else {
            return flattenedItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if searchText.isEmpty {
                    List {
                        ForEach(accordionItems) { item in
                            Section {
                                Button(action: {
                                    toggleExpansion(for: item.id)
                                }) {
                                    HStack {
                                        Text(item.title)
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: expandedItems.contains(item.id) ? "chevron.up" : "chevron.down")
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if expandedItems.contains(item.id) {
                                    ForEach(item.items, id: \.self) { subItem in
                                        Button(action: {
                                            itemTapped(subItem)
                                        }) {
                                            Text(subItem)
                                                .padding(.leading)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                    }
                } else {
                    List(filteredItems) { item in
                        Button(action: {
                            itemTapped(item.title)
                        }) {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.body)
                                Text(item.parentTitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search POI")
            .navigationTitle("Accordion List")
        }
    }
    
    private func toggleExpansion(for id: UUID) {
        withAnimation {
            if expandedItems.contains(id) {
                expandedItems.remove(id)
            } else {
                expandedItems.insert(id)
            }
        }
    }
    
    private func itemTapped(_ item: String) {
        sharedViewModel.selectedItem = item
        sharedViewModel.showAccordionList = false
    }
}
struct AccordionListView_Previews: PreviewProvider {
    static var previews: some View {
        AccordionListView()
    }
}
