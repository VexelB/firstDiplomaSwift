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
    convenience init(data: (String, JSON)) {
        self.init(value: [
            "id": data.0,
            "name": data.1["name"].stringValue,
            "iconImage": data.1["iconImage"].stringValue,
            "parentId": ""
        ])
    }
    convenience init(parentId: String, data: (String, JSON)) {
        self.init(value: [
            "id": data.1["id"].stringValue,
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

protocol DBServiceProtocol {
    func clear(obj: Object.Type, completion: @escaping () -> Void)
    
    func clearByCategorie(catId: String, obj: Object.Type, completion: @escaping () -> Void)
    
    func delFromCart(item: CartItemModel, completion: @escaping () -> Void)
    
    func putCategories(json: JSON, completion: @escaping () -> Void)
    
    func putItems(catId:String, json: JSON, completion: @escaping () -> Void)
    
    func putInCart(item: ItemModel, size: String)

    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void)
    
    func loadByCategorie(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void)
}

class DBRealmService: DBServiceProtocol {
    
    func clear(obj: Object.Type, completion: @escaping () -> Void) {
        DispatchQueue.dbThread.async {
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
        DispatchQueue.dbThread.async {
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
    
    func delFromCart(item: CartItemModel, completion: @escaping () -> Void) {
        DispatchQueue.dbThread.async {
            autoreleasepool{
                let realm = try! Realm()
                try! realm.write {
                    if let deleted = realm.objects(CartItem.self).filter({$0.name == item.name}).filter({$0.size == item.size}).first {
                        realm.delete(deleted)
                    }
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func putInCart(item: ItemModel, size: String) {
        DispatchQueue.dbThread.async {
            autoreleasepool {
                let realm = try! Realm()
                let cartItem = CartItem()
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
        DispatchQueue.dbThread.async {
            autoreleasepool {
                let realm = try! Realm()
                let cats = json.map { cat -> Categorie in
                    let categorieR = Categorie(data: cat)
                    let subcategories = cat.1["subcategories"].map {
                        Categorie(parentId: categorieR.id, data: $0)
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
        DispatchQueue.dbThread.async {
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
        DispatchQueue.dbThread.async {
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
        DispatchQueue.dbThread.async {
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

extension DispatchQueue {
    static let dbThread = DispatchQueue.init(label: "dbThread")
}
