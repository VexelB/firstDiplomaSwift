//
//  RealmController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import UIKit
import RealmSwift
import SwiftyJSON

class CartItem: Object {
    @objc dynamic var catId = 0
    @objc dynamic var id = ""
    @objc dynamic var article = ""
    @objc dynamic var name = ""
    @objc dynamic var mainImage = ""
    @objc dynamic var price = ""
    @objc dynamic var size = ""
}

class Categorie: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var iconImage = ""
    convenience init(data: (String, JSON)) {
        self.init(value: [
            "id": data.0,
            "name": data.1["name"].stringValue,
            "iconImage": data.1["iconImage"].stringValue
        ])
    }
}

class Subcategorie: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var iconImage = ""
    @objc dynamic var parent = ""
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
    var offersSize = List<String>()
    var offersQuantity = List<String>()
    var images = List<String>()
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

struct CategorieModel {
    let id: String
    let name: String
    let iconImage: String
    
    init(categorie: Categorie) {
        self.id = categorie.id
        self.name = categorie.name
        self.iconImage = categorie.iconImage
    }
}

struct SubcategorieModel {
    let id: String
    let name: String
    let iconImage: String
    let parent: String
    
    init(subcategorie: Subcategorie) {
        self.id = subcategorie.id
        self.name = subcategorie.name
        self.iconImage = subcategorie.iconImage
        self.parent = subcategorie.parent
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
    let offersSize: [String]
    let offersQuantity: [String]
    let images: [String]
}

protocol DBServiceProtocol {
    func clear(obj: Object.Type, completion: @escaping () -> Void)
    
    func clear(catId: String, obj: Object.Type, completion: @escaping () -> Void)
    
    func put(json: JSON, completion: @escaping () -> Void)

    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void)
    
    func load(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void)
}

class DBRealmService: DBServiceProtocol {
    
    func clear(obj: Object.Type, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "aaa").async {
            autoreleasepool{
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(obj))
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }
    
    func clear(catId: String, obj: Object.Type, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "aaa").async {
            autoreleasepool{
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(obj).filter("catId == \(catId)"))
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }
    
    func put(json: JSON, completion: @escaping () -> Void) {
        DispatchQueue.init(label: "aaa").async {
            autoreleasepool {
                let realm = try! Realm()
                let cats = json.map { cat -> Categorie in
                    let categorieR = Categorie(data: cat)
                    let subcategories = cat.1["subcategories"].map {
                        Subcategorie(parentId: cat.0, data: $0)
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
    
    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void){
        DispatchQueue.init(label: "aaa").async {
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
                case is Subcategorie:
                    models = result.map {
                        return SubcategorieModel(subcategorie: $0 as! Subcategorie)
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
    func load(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void) {
        DispatchQueue.init(label: "aaa").async {
            autoreleasepool {
                let realm = try! Realm()
                let result = Array(realm.objects(obj).filter("catId == \(catId)").sorted(byKeyPath: "id", ascending: false))
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
