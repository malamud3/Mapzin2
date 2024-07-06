import SwiftUI

/// A view modifier that applies a full-screen gradient background to the content.
struct MainFullScreenGradient: ViewModifier {
    
    /// Applies the gradient background to the given content.
    /// - Parameter content: The content view to be modified.
    /// - Returns: The modified view with a gradient background.
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.4),
                    Color.blue.opacity(0.3),
                    Color.green.opacity(0.2),
                    Color.green.opacity(0.1),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            content
        }
    }
}

extension View {
    /// Applies a full-screen gradient background to the view.
    /// - Returns: The view with a gradient background.
    func backgroundGradient() -> some View {
        self.modifier(MainFullScreenGradient())
    }
}
