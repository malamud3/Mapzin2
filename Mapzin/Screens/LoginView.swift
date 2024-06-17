import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var errorMessagePresented = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            // Main content container
            VStack {
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 10)

                VStack(spacing: 20) {
                    
                    CustomTextField(placeholder: "Email", text: $viewModel.email)
                    CustomTextField(placeholder: "Password", text: $viewModel.password)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                        LoginButton {
                            viewModel.login()
                        }
                        
                        SignUpButton {
                            viewModel.signUp()
                        }
                 
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .background(Color.clear) // Ensures the background is transparent for gradient

                Spacer() // Ensures the VStack can expand properly
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .background(Color.clear) // Ensures the background is transparent for gradient
        }
        .alert(isPresented: $errorMessagePresented) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = ""
                }
            )
        }
        .onReceive(viewModel.$errorMessage) { errorMessage in
            if !errorMessage.isEmpty {
                errorMessagePresented = true
            }
        }
    }
}
