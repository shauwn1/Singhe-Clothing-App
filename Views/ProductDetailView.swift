import SwiftUI

struct ProductDetailView: View {
    @ObservedObject var viewModel: ProductDetailViewModel

    init(product: ClothingItem, cart: Cart) {
        viewModel = ProductDetailViewModel(product: product, cart: cart)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: viewModel.product.image)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.4)
                }
                .frame(height: 300)
                .cornerRadius(12)
                .shadow(radius: 5)

                Text(viewModel.product.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.product.description)
                    .padding(.top, 2)
                    .padding(.bottom, 2)

                Text("Price: $\(viewModel.product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.bottom, 5)

                if !viewModel.productVariants.isEmpty {
                    SizeColorPickerView(sizes: viewModel.productVariants.map(\.size).removingDuplicates(),
                                        selectedSize: $viewModel.selectedSize,
                                        colors: viewModel.productVariants.map(\.color).removingDuplicates(),
                                        selectedColor: $viewModel.selectedColor)
                }

                Button("Add to Cart") {
                    viewModel.addProductToCart()
                }
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SizeColorPickerView: View {
    var sizes: [String]
    @Binding var selectedSize: String?
    var colors: [String]
    @Binding var selectedColor: String?

    var body: some View {
        VStack {
            Text("Size")
                .font(.headline)
                .padding(.bottom, 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sizes, id: \.self) { size in
                        Button(size) {
                            selectedSize = size
                        }
                        .padding()
                        .background(selectedSize == size ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(selectedSize == size ? .white : .black)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.bottom, 10)

            Text("Color")
                .font(.headline)
                .padding(.bottom, 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Button(color) {
                            selectedColor = color
                        }
                        .padding()
                        .background(selectedColor == color ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(selectedColor == color ? .white : .black)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

// Helper extension to remove duplicates from an array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
