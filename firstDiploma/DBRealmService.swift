//
//  RealmController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import UIKit
import RealmSwift
import SwiftyJSON

class Categorie: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var iconImage = ""
    @objc dynamic var parentId = ""
    convenience init(parentId: String, data: (String, JSON)) {
        self.init(value: [
            "id": data.0,
            "name": data.1["name"].stringValue,
            "iconImage": data.1["iconImage"].stringValue,
            "parentId": parentId
        ])
    }
}

class Item: Object {
    @objc dynamic var catId = 0
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var article = ""
    @objc dynamic var mainImage = ""
    @objc dynamic var price = ""
    @objc dynamic var desc = ""
    var offerSizes = List<String>()
    var offerQuantities = List<String>()
    var images = List<String>()
    
    convenience init(catId: String, data: (String, JSON)) {
        self.init(value: [
            "id": data.0,
            "name": data.1["name"].stringValue,
            "mainImage": data.1["mainImage"].stringValue,
            "price": data.1["price"].stringValue,
            "desc": data.1["description"].stringValue,
            "catId": Int(catId) ?? 0,
            "offerSizes": data.1["offers"].map { $0.1["size"].stringValue },
            "offerQuantities": data.1["offers"].map { $0.1["quantity"].stringValue },
            "images": data.1["productImages"].map { $0.1["imageURL"].stringValue }
        ])
    }
}

class CartItem: Object {
    @objc dynamic var catId = 0
    @objc dynamic var id = ""
    @objc dynamic var article = ""
    @objc dynamic var name = ""
    @objc dynamic var mainImage = ""
    @objc dynamic var price = ""
    @objc dynamic var size = ""
}

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

protocol DBServiceProtocol {
    func clear(obj: Object.Type, completion: @escaping () -> Void)
    
    func clearByCategorie(catId: String, obj: Object.Type, completion: @escaping () -> Void)
    
    func putCategories(json: JSON, completion: @escaping () -> Void)
    
    func putItems(catId:String, json: JSON, completion: @escaping () -> Void)
    
    func putInCart(item: ItemModel, size: String)

    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void)
    
    func loadByCategorie(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void)
}

class DBRealmService: DBServiceProtocol {
    
    func clear(obj: Object.Type, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool{
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(obj))
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func clearByCategorie(catId: String, obj: Object.Type, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool{
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(obj).filter("catId == \(catId)"))
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func putInCart(item: ItemModel, size: String) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool {
                let realm = try! Realm()
                let cartItem = CartItem()
                cartItem.catId = (realm.objects(CartItem.self).last?.catId ?? 0) + 1
                cartItem.name = item.name
                cartItem.mainImage = item.mainImage
                cartItem.size = size
                cartItem.price = item.price
                cartItem.article = item.id
                try! realm.write {
                    realm.add(cartItem)
                }
            }
        }
    }
    
    func putCategories(json: JSON, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool {
                let realm = try! Realm()
                let cats = json.map { cat -> Categorie in
                    let categorieR = Categorie(parentId: "", data: cat)
                    let subcategories = cat.1["subcategories"].map {
                        Categorie(parentId: cat.0, data: $0)
                    }
                    try! realm.write{
                        realm.add(subcategories)
                    }
                    return categorieR
                }
                try! realm.write{
                    realm.add(cats)
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func putItems(catId: String, json: JSON, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool {
                let realm = try! Realm()
                let items = json.map { item -> Item in
                    let itemR = Item(catId: catId, data: item)
                    return itemR
                }
                try! realm.write{
                    realm.add(items)
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool {
                let realm = try! Realm()
                let result = realm.objects(obj).sorted(byKeyPath: "id", ascending: false)
                var models = [Any]()
                switch result.first {
                case is CartItem:
                    models = result.map {
                        return CartItemModel(cartItem: $0 as! CartItem)
                    }
                case is Categorie:
                    models = result.map {
                        return CategorieModel(categorie: $0 as! Categorie)
                    }
                default:
                    break
                }
                DispatchQueue.main.async {
                    completion(models)
                }
            }
        }
    }
    func loadByCategorie(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void) {
        DispatchQueue.init(label: "dbThread").async {
            autoreleasepool {
                let realm = try! Realm()
                let result = realm.objects(obj).sorted(byKeyPath: "id", ascending: false)
                var models = [Any]()
                switch result.first {
                case is Item:
                    models = result.map {
                        return ItemModel(item: $0 as! Item)
                    }
                default:
                    break
                }
                DispatchQueue.main.async {
                    completion(models)
                }
            }
        }
    }
}
