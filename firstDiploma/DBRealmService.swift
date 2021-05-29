//
//  RealmController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import UIKit
import RealmSwift

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
}

class Subcategorie: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var iconImage = ""
    @objc dynamic var parent: Categorie?
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
    let parent: CategorieModel?
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
    
    func put(obj: Object)

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
    
    func put(obj: Object) {
        DispatchQueue.init(label: "aaa").async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    if let temp = obj as? CartItem {
                        temp.catId = (realm.objects(CartItem.self).last?.catId ?? 0) + 1
                        temp.id = "\(temp.catId)"
                    }
                    realm.add(obj)
                }
            }
        }
        
        
//        print(realm.objects(CartItem.self))
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
