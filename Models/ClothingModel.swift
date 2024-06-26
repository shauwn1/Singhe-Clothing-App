//
//  ClothingModel.swift
//  KAI-APP
//
//  Created by Shehara Jayasooriya on 2024-03-31.
//

import Foundation
struct ClothingItem: Identifiable, Codable {
    var id: Int
    var title: String
    var price: Double
    var description: String
    var category: String
    var sub_category: String
    var image: String
  //  var rate: Double
//    var count: Int
}
