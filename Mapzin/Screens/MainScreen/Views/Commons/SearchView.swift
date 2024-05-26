//
//  SearchView.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
            SearchResultsList(results: $viewModel.results, mapSelection: $viewModel.mapSelection)
        }
        .padding()
    }
}

