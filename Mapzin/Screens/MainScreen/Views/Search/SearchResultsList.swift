import SwiftUI
import MapKit

struct SearchResultsList: View {
    @Binding var results: [MKMapItem]
    @Binding var mapSelection: MKMapItem?
    
    var onSelect: () -> Void

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(results, id: \.self) { item in
                        Button(action: {
                            mapSelection = item
                            onSelect()
                        }) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name ?? "")
                                        .font(.system(.subheadline, design: .default))
                                        .foregroundColor(mapSelection == item ? .blue : .primary)
                                    Text(item.placemark.title ?? "")
                                        .font(.system(.footnote, design: .default))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.leading, 5)
                                Spacer()
                            }
                            .padding(5)
                            .background(mapSelection == item ? Color.blue.opacity(0.1) : Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(5)
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.8))
                    .shadow(radius: 5)
            )
            .padding(5)
        }
    }
}
