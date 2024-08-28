//
//  AccordionListView.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/08/2024.
//

import SwiftUI

struct AccordionListView: View {
    @EnvironmentObject private var sharedViewModel: SharedViewModel
    @State private var expandedSections: Set<String> = []
    @State private var searchText = ""
    
    let accordionItems = [
        AccordionItem(title: "Floor 0", items: ["Room 101", "Room 102", "Room 103", "Room 104", "Stairs0", "Bathroom0"]),
        AccordionItem(title: "Floor 1", items: ["Elevator", "Stairs1", "Restroom"]),
        AccordionItem(title: "Floor 2", items: ["Reception", "Cafeteria", "Conference Room"])
    ]
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return accordionItems.flatMap { $0.items }.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
            NavigationView {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.black, .gray]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        SearchBar(searchText: $searchText)
                            .padding(.top)
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 2)
                        
                        if searchText.isEmpty {
                            accordionList
                        } else {
                            searchResultsList
                        }
                    }
                }
                .navigationTitle("Search POI")
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(.white)
            }
            .colorScheme(.dark)
            .accentColor(.white)
        }
    
    private var accordionList: some View {
        List {
            ForEach(accordionItems) { section in
                Section(header: sectionHeader(for: section)) {
                    if expandedSections.contains(section.title) {
                        ForEach(section.items, id: \.self) { item in
                            Button(action: {
                                itemTapped(item)
                            }) {
                                Text(item)
                                    .padding(.leading)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var searchResultsList: some View {
        List(filteredItems, id: \.self) { item in
            Button(action: {
                itemTapped(item)
            }) {
                Text(item)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func sectionHeader(for section: AccordionItem) -> some View {
        Button(action: {
            toggleExpansion(for: section.title)
        }) {
            HStack {
                Text(section.title)
                    .font(.headline)
                Spacer()
                Image(systemName: expandedSections.contains(section.title) ? "chevron.up" : "chevron.down")
            }
        }
    }
    
    private func toggleExpansion(for title: String) {
        withAnimation {
            if expandedSections.contains(title) {
                expandedSections.remove(title)
            } else {
                expandedSections.insert(title)
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
