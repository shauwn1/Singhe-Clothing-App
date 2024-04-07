import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showingProfile = false
    @State private var showOrders = false
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        NavigationView {
            List {
                dashboardSection
                
                categoriesSection
                
                productsSection
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CartButtonView(cart: viewModel.cart)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }

    private var dashboardSection: some View {
        Section(header: Text("Dashboard")) {
            NavigationLink(destination: UserProfileView(viewModel: UserProfileViewModel(apiService: ApiService(), userId: authenticationViewModel.user?.id ?? 0))) {
                Text("User Profile")
            }
            
            NavigationLink(destination: OrdersView(viewModel: OrdersViewModel(userId: authenticationViewModel.user?.id ?? 0))) {
                Text("View Orders")
            }
        }
    }

    private var categoriesSection: some View {
        Section(header: Text("Categories").font(.headline).foregroundColor(.blue)) {
            ForEach(viewModel.categories, id: \.self) { category in
                DisclosureGroup(category) {
                    if let subcategories = viewModel.subCategories[category], !subcategories.isEmpty {
                        ForEach(subcategories, id: \.self) { subCategory in
                            Button(action: {
                                viewModel.loadProductsForSubCategory(subCategory, forCategory: category)
                            }) {
                                Text(subCategory)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(.blue)
                            }
                        }
                    } else {
                        Text("Loading subcategories...")
                            .onAppear {
                                viewModel.loadSubCategories(forCategory: category)
                            }
                    }
                }
            }
        }
    }

    private var productsSection: some View {
        Section(header: Text("Products")) {
            ForEach(viewModel.clothingItems) { product in
                NavigationLink(destination: ProductDetailView(product: product, cart: viewModel.cart)) {
                    ProductRow(product: product)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(cart: Cart())
        HomeView(viewModel: viewModel)
            .environmentObject(AuthenticationViewModel())
    }
}

struct ProductRow: View {
    let product: ClothingItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 100, height: 100)
                case .failure:
                    Color.red // Indicates an error.
                default:
                    ProgressView() // Shows a loading indicator.
                }
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                Text("\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
