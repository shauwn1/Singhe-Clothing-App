import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var shouldNavigateToHome = false
    @State private var shouldNavigateToSignup = false
    @StateObject private var cart = Cart()

    private var homeViewModel: HomeViewModel {
        HomeViewModel(cart: cart)
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // App logo or title
                Text("KAI")
                    .font(.custom("Helvetica Neue", size: 40))
                    .fontWeight(.bold)
                    .padding(.bottom, 50)

                // Email field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)

                // Password field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 10)

                // Login button
                Button(action: {
                    authenticationViewModel.login(email: email, password: password)
                }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Error message
                if let errorMessage = authenticationViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Sign up navigation
                Button(action: {
                    shouldNavigateToSignup = true
                }) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
            .navigationTitle("Login")
            .sheet(isPresented: $shouldNavigateToSignup) {
                SignupView()
            }
            .onAppear {
                authenticationViewModel.onLoginSuccess = {
                    self.shouldNavigateToHome = true
                }
            }
            .fullScreenCover(isPresented: $shouldNavigateToHome) {
                HomeView(viewModel: homeViewModel)
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
