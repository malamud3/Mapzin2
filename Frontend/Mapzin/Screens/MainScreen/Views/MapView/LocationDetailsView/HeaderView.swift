//
//  HeaderView.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import SwiftUI
import MapKit

struct HeaderView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mapSelection?.placemark.name ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(mapSelection?.placemark.title ?? "")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: closeView) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                    .background(Circle().fill(Color(.systemGray6)))
            }
            .accessibilityLabel("Close")
        }
        .padding([.top, .horizontal])
    }
    
    private func closeView() {
        withAnimation {
            show.toggle()
        }
        mapSelection = nil
    }
}

