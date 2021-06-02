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

    private let dbService: DBServiceProtocol = Services.dBRealmService

    var categories = [CategorieModel]()
    var subcategories = [CategorieModel]()
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showCart(_ sender: Any) {
        if subcategories.count == 0 {
            performSegue(withIdentifier: "SubToCart", sender: nil)
        } else {
            performSegue(withIdentifier: "CatToCart", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if categories.count == 0{
            loadCatsRS()
            loadCatsAF()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? CatViewController {
            if let select = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: select) as? CatCell {
                vc.navItem.title = cell.categorieLbl.text
                vc.categories = subcategories.filter{$0.parentId == cell.id}
            }
        } else if let vc = segue.destination as? ItemsViewController {
            if let select = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: select) as? CatCell {
                vc.navItem.title = cell.categorieLbl.text
                vc.categorie = cell.id
            }
        }
    }
    
    func loadCatsRS() {
        dbService.load(obj: Categorie.self, completion: { [weak self] temp in
            self?.categories = []
            for i in temp {
                if let a = i as? CategorieModel {
                    if a.parentId == "" {
                        self?.categories.append(a)
                    } else {
                        self?.subcategories.append(a)
                    }
                }
                self?.tableView.reloadData()
            }
            self?.tableView.reloadData()
        })
    }

    func loadCatsAF() {
        AF.request("\(URLs.categorieURL)").responseJSON { [weak self]
            response in if let objects = response.value {
                
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                self?.dbService.clear(obj: Categorie.self) {
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    self?.dbService.putCategories(json: JSON(objects)) {
                        self?.loadCatsRS()
                    }
                })
            }
        self?.tableView.reloadData()
        }
    }

}

extension CatViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell
        cell.initCell(id: categories[indexPath.row].id, img: categories[indexPath.row].iconImage, lbl: categories[indexPath.row].name)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = categories[indexPath.row]
        if subcategories.map({$0.parentId}).contains(selected.id) {
            performSegue(withIdentifier: Segues.showSubcategorie, sender: nil)
        } else if subcategories.count == 0{
            performSegue(withIdentifier: Segues.showItemsFromSubcategories, sender: nil)
        } else {
            performSegue(withIdentifier: Segues.showItemsFromCategories, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

