//
//  RealmController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import UIKit
import RealmSwift

class Categorie: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var iconImage = ""
    var subs = List<Subcategorie>()
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
    var offers = [[String]]()
    var images = [String]()
}

class RealmController: NSObject {
    static let shared = RealmController()
    private let realm = try! Realm()
    
    func clear(obj: Object.Type) {
        try! realm.write{
            realm.delete(realm.objects(obj))
        }
    }
    
    func clear(catId: String, obj: Object.Type) {
        try! realm.write{
            realm.delete(realm.objects(obj).filter("catId == \(catId)"))
        }
    }
    
    func put(obj: Object) {
        try! realm.write{
            realm.add(obj)
            if let temp = obj as? Subcategorie {
                temp.parent?.subs.append(temp)
            }
        }
    }
    
    func load(obj: Object.Type, completion: @escaping ([Any]) -> Void){
        var temp = [Any]()
        for i in realm.objects(obj).sorted(byKeyPath: "id", ascending: false) {
            temp.append(i)
        }
        completion(temp)
    }
    func load(catId: String, obj: Object.Type, completion: @escaping ([Any]) -> Void){
    var temp = [Any]()
        for i in realm.objects(obj).filter("catId == \(catId)").sorted(byKeyPath: "id", ascending: false){
            temp.append(i)
    }
    completion(temp)
}
}
