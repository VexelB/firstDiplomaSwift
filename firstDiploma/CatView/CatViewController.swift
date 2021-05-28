//
//  ViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 23.05.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class CatViewController: UIViewController {

    let realmcontroller = RealmController.shared

    var cats = [Categorie]()
    var subs = [Subcategorie]()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func showCart(_ sender: Any) {
        performSegue(withIdentifier: "CatToCart", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatsRS()
        loadCatsAF()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubCatViewController, segue.identifier == "CatToSub" {
            if let select = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: select) as? CatCell {
                vc.navItem.title = cell.catLbl.text
                vc.cats = subs.filter{$0.parent!.id == cell.id}
            }
        } else if let vc = segue.destination as? ItemsViewController, segue.identifier == "CatToItems" {
            if let select = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: select) as? CatCell {
                vc.navItem.title = cell.catLbl.text
                vc.cat = cell.id
            }
        }
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }
    
    func loadCatsRS() {
        realmcontroller.load(obj: Categorie.self, completion: {temp in
            self.cats = []
            for i in temp {
                if let a = i as? Categorie {
                    self.cats.append(a)
                    self.tableView.reloadData()
                }
            }
        })
        realmcontroller.load(obj: Subcategorie.self, completion: { temp in
            self.subs = []
            for i in temp {
                if let a = i as? Subcategorie {
                    self.subs.append(a)
                    self.tableView.reloadData()
                }
            }
        })
    }

    func loadCatsAF() {
        AF.request(URLs().catURL).responseJSON {
            response in if let objects = response.value {
                self.realmcontroller.clear(obj: Categorie.self)
                self.realmcontroller.clear(obj: Subcategorie.self)
                let json = JSON(objects)
                for i in json {
                    let cat = Categorie()
                    cat.id = i.0
                    cat.name = i.1["name"].stringValue
                    cat.iconImage = i.1["iconImage"].stringValue
                    if i.1["subcategories"] != [] {
                        for j in i.1["subcategories"] {
                            let cat1 = Subcategorie()
                            cat1.id = j.1["id"].stringValue
                            cat1.name = j.1["name"].stringValue
                            cat1.iconImage = j.1["iconImage"].stringValue
                            cat1.parent = cat
                            self.realmcontroller.put(obj: cat1)
                        }
                    }
                    self.realmcontroller.put(obj: cat)
                }
            }
        self.loadCatsRS()
        }
    }

}

extension CatViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell
        cell.initCell(id: cats[indexPath.row].id, img: cats[indexPath.row].iconImage, lbl: cats[indexPath.row].name)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = cats[indexPath.row]
        if subs.map({$0.parent!.name}).contains(selected.name) {
            performSegue(withIdentifier: "CatToSub", sender: nil)
        } else {
            performSegue(withIdentifier: "CatToItems", sender: nil)
        }
    }
}

