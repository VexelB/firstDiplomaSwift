//
//  Structs.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 02.06.2021.
//

import Foundation

struct CategorieModel {
    let id: String
    let name: String
    let iconImage: String
    let parentId: String
    
    init(categorie: Categorie) {
        self.id = categorie.id
        self.name = categorie.name
        self.iconImage = categorie.iconImage
        self.parentId = categorie.parentId
    }
}

struct ItemModel {
    let catId: Int
    let id: String
    let name: String
    let article: String
    let mainImage: String
    let price: String
    let desc: String
    let offerSizes: [String]
    let offerQuantities: [String]
    let images: [String]
    
    init() {
        self.catId = -1
        self.id = "item.id"
        self.name = "item.name"
        self.article = "item.article"
        self.mainImage = "item.mainImage"
        self.price = "item.price"
        self.desc = "item.desc"
        self.offerSizes = [""]
        self.offerQuantities = [""]
        self.images = [""]
    }
    
    init(item: Item) {
        self.catId = item.catId
        self.id = item.id
        self.name = item.name
        self.article = item.article
        self.mainImage = item.mainImage
        self.price = item.price
        self.desc = item.desc
        self.offerSizes = Array(item.offerSizes)
        self.offerQuantities = Array(item.offerQuantities)
        self.images = Array(item.images)
    }
}

struct CartItemModel {
    let catId: Int
    let id: String
    let article: String
    let name: String
    let mainImage: String
    let price: String
    let size: String
    
    init(cartItem: CartItem) {
        self.catId = cartItem.catId
        self.id = cartItem.id
        self.article = cartItem.article
        self.name = cartItem.name
        self.mainImage = cartItem.mainImage
        self.price = cartItem.price
        self.size = cartItem.size
    }
}
