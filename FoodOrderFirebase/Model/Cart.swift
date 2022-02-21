//
//  Cart.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}

