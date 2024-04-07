//
//  EncodableCartItemsModel.swift
//  KAI-APP
//
//  Created by Shehara Jayasooriya on 2024-03-31.
//

import Foundation
struct EncodableCartItem: Encodable {
    let productId: Int
    let size: String
    let color: String
    let quantity: Int
    
    init(cartItem: CartItem) {
        // Initialize properties using cartItem
        productId = cartItem.product.id
        size = cartItem.size
        color = cartItem.color
        quantity = cartItem.quantity
    }
}
