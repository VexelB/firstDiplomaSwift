//
//  URLs.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import Foundation

enum URLs{
    static let categorieURL = "https://blackstarshop.ru/index.php?route=api/v1/categories"
    static let itemsURL = "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id="
    static let imagesURL = "https://blackstarshop.ru/"
}

enum Services {
    static let dBRealmService = DBRealmService()
}

enum Segues {
    static let showSubcategorie = "CatToSub"
    static let showItemsFromSubcategories = "SubToItems"
    static let showItemsFromCategories = "CatToItems"
    static let showCartFromItems = "ItemsToCart"
    static let showBuyFromItems = "ItemsToBuy"
    static let showItem = "ItemsToItem"
    static let showCartFromItem = "ItemToCart"
    
}
