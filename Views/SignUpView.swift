import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var mobileNumber = ""
    @State private var showRegistrationSuccess = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Logo or App name
                Text("Singhe Clothing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                Group {
                    InputField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
                    InputField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    InputField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    InputField(icon: "phone.fill", placeholder: "Mobile Number", text: $mobileNumber)
                }
                
                Button("Register") {
                    authenticationViewModel.register(fullname: fullName, mobilenumber: mobileNumber, email: email, password: password)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                if let errorMessage = authenticationViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                if showRegistrationSuccess {
                    Text("Registered successfully!")
                        .foregroundColor(.green)
                }
                
                Spacer()

                // Already have an account? Go to Login
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.secondary)
                    
                    Button("Login") {
                        navigateToLogin = true
                    }
                    .foregroundColor(.blue)
                }
                .padding()

                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
            }
            .padding()
            .navigationTitle("Sign Up")
            .onAppear {
                authenticationViewModel.onRegistrationSuccess = {
                    self.showRegistrationSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigateToLogin = true
                    }
                }
            }
        }
    }
}

struct InputField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.vertical, 12)
            } else {
                TextField(placeholder, text: $text)
                    .padding(.vertical, 12)
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
        .padding(.horizontal)
    }
}
