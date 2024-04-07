//
//  ProductVariantModel.swift
//  KAI-APP
//
//  Created by Shehara Jayasooriya on 2024-03-31.
//

import Foundation

struct ProductVariant: Identifiable, Decodable {
    let id: Int
    let productId: Int
    let size: String
    let color: String
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
            case id
            case productId = "product_id"  // Map the JSON field name to your property name
            case size
            case color
            case quantity
        }
    
    
}



