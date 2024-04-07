//
//  OrderItem'.swift
//  KAI-APP
//
//  Created by Shehara Jayasooriya on 2024-03-31.
//
import Foundation
struct OrderItem: Encodable {
    let productId: Int
    let size: String
    let color: String
    let quantity: Int
}
