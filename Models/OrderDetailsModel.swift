//
//  OrderDetailsModel.swift
//  KAI-APP
//
//  Created by Shehara Jayasooriya on 2024-03-31.
//

import Foundation
struct OrderDetails: Encodable {
    let userId: Int
    let items: [OrderItem]
}
