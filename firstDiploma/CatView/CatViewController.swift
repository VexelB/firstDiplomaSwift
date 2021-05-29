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

    let dbService: DBServiceProtocol = Services.dBRealmService

    var cats = [CategorieModel]()
    var subs = [CategorieModel]()
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func showCart(_ sender: Any) {
        if subs.count == 0 {
            performSegue(withIdentifier: "SubToCart", sender: nil)
        } else {
            performSegue(withIdentifier: "CatToCart", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cats.count == 0{
            loadCatsRS()
            loadCatsAF()
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CatViewController, segue.identifier == "CatToSub" {
            if let select = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: select) as? CatCell {
                vc.navItem.title = cell.catLbl.text
                vc.cats = subs.filter{$0.parentId == cell.id}
            }
        } else if let vc = segue.destination as? ItemsViewController {
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
        dbService.load(obj: Categorie.self, completion: { [weak self] temp in
            self?.cats = []
            for i in temp {
                if let a = i as? CategorieModel {
                    if a.parentId == "" {
                        self?.cats.append(a)
                    } else {
                        self?.subs.append(a)
                    }
                }
                self?.tableView.reloadData()
            }
            self?.tableView.reloadData()
        })
    }

    func loadCatsAF() {
        AF.request(URLs().catURL).responseJSON {
            response in if let objects = response.value {
                
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                self.dbService.clear(obj: Categorie.self) {
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    self.dbService.putCategories(json: JSON(objects)) { [weak self] in
                        self?.loadCatsRS()
                    }
                })
            }
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
        if subs.map({$0.parentId}).contains(selected.id) {
            performSegue(withIdentifier: "CatToSub", sender: nil)
        } else if subs.count == 0{
            performSegue(withIdentifier: "SubToItems", sender: nil)
        } else {
            performSegue(withIdentifier: "CatToItems", sender: nil)
        }
    }
}

