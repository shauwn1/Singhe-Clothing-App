import SwiftUI
struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        List {
            ForEach(viewModel.orders) { order in
                VStack(alignment: .leading) {
                    Text("Order ID: \(order.id)")
                    Text("Date: \(order.date)")
                    Text("Quantity: \(order.quantity)")
                    Text("Size: \(order.size)")
                    Text("Color: \(order.color)")
                    Text("Title: \(order.title)")
                    Text("Price: $\(order.price, specifier: "%.2f")")
                    AsyncImage(url: URL(string: order.image)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                }
                .padding()
            }
        }
        .navigationTitle("Orders")
        .onAppear {
            viewModel.loadOrders()
        }
    }
}
