import SwiftUI

struct CartView: View {
    @ObservedObject var cart: Cart
    @State private var orderPlaced = false
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            List {
                ForEach(cart.items) { item in
                    HStack {
                        AsyncImage(url: URL(string: item.product.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                        
                        VStack(alignment: .leading) {
                            Text(item.product.title)
                                .font(.headline)
                            Text("Size: \(item.size), Color: \(item.color)")
                                .font(.subheadline)
                            Text("$\(item.product.price, specifier: "%.2f") x \(item.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .onAppear {
                                    print("Displaying item with size: \(item.size), color: \(item.color)")
                                }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                cart.decreaseQuantity(of: item)
                            }) {
                                Image(systemName: "minus.circle")
                            }
                            Text("\(item.quantity)")
                            Button(action: {
                                cart.increaseQuantity(of: item)
                            }) {
                                Image(systemName: "plus.circle")
                            }
                        }
                        .foregroundColor(.blue)
                    }
                }
                .onDelete(perform: removeItems)
                
                Section {
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text("$\(cart.totalAmount, specifier: "%.2f")")
                            .font(.headline)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Cart")

            Spacer()

            Button("Place Order") {
                guard let userId = authenticationViewModel.user?.id else { return }
                ApiService().placeOrder(userID: userId, items: cart.items) { success in
                    DispatchQueue.main.async {
                        if success {
                            self.orderPlaced = true
                            self.cart.clearCart() // Clear the cart after placing the order
                        } else {
                            self.orderPlaced = true
                            self.cart.clearCart()
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .alert(isPresented: $orderPlaced) {
            Alert(title: Text("Order Placed"), message: Text("Your order has been placed successfully."), dismissButton: .default(Text("OK")))
        }
    }

    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = cart.items[index]
            cart.removeFromCart(itemId: item.id)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(cart: Cart())
            .environmentObject(AuthenticationViewModel())
    }
}
