import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 10)
                
                DataFields(email: $viewModel.email, password: $viewModel.password)
                
                ErrorMessage(message: viewModel.errorMessage)
                
                LoginButton {
                    viewModel.login()
                }
                
                SignUpButton {
                    viewModel.signUp()
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
        }
    }
}
