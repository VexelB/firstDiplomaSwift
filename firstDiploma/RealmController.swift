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

class RealmController: NSObject {
    static let shared = RealmController()
    private let realm = try! Realm()
    
    func clear(obj: Object.Type) {
        try! realm.write {
            realm.delete(realm.objects(obj))
        }
    }
    
    func clear(catId: String, obj: Object.Type) {
        try! realm.write {
            realm.delete(realm.objects(obj).filter("catId == \(catId)"))
        }
    }
    
    func put(obj: Object) {
        try! realm.write {
            if let temp = obj as? CartItem {
                temp.catId = (realm.objects(CartItem.self).last?.catId ?? 0) + 1
                temp.id = "\(temp.catId)"
            }
            realm.add(obj)
        }
//        print(realm.objects(CartItem.self))
    }
    
    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void){
        completion(Array(realm.objects(obj).sorted(byKeyPath: "id", ascending: false)))
    }
    func load(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void){
        completion(Array(realm.objects(obj).filter("catId == \(catId)").sorted(byKeyPath: "id", ascending: false)))
    }
}
