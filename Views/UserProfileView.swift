import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            if let user = authenticationViewModel.user {
                VStack(alignment: .center, spacing: 20) {
                    Image("defaultProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding(.top, 50)
                    
                    Text(user.fullname)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    
                    Text(user.email)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.orange)
                        Text(user.mobilenumber)
                            .font(.body)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
            } else {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .onAppear {
            viewModel.fetchUserProfile()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(viewModel: UserProfileViewModel(apiService: ApiService(), userId: 1))
            .environmentObject(AuthenticationViewModel())
    }
}
