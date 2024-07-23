
import SwiftUI


struct LoginView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var viewModel = LoginViewModel()
    @State private var errorMessagePresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 10)
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Email", text: $viewModel.email)
                    .padding(.horizontal, 16)
                CustomTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
                    .padding(.horizontal, 16)
                
                LoginButton(action: {
                    viewModel.login()
                    if viewModel.isLoggedIn {
                        coordinator.push(.home)
                    }
                })
                .padding(.horizontal, 16)
                
                Button(action: {
                    coordinator.push(.signUp)
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
        }
        .backgroundGradient()
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
            DispatchQueue.main.async {
                if !errorMessage.isEmpty {
                    errorMessagePresented = true
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    LoginView()
}
