//
//  ViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 26.05.2021.
//

import UIKit

class SubCatViewController: UIViewController {

    let realmcontroller = RealmController.shared

    var cats = [Subcategorie]()
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showCart(_ sender: Any) {
        performSegue(withIdentifier: "SubToCart", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadCatsRS()
//        loadCatsAF()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemsViewController, segue.identifier == "SubToItems" {
            if let select = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: select) as? CatCell {
                vc.navItem.title = cell.catLbl.text
                vc.cat = cell.id
            }
        }
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }

}

extension SubCatViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell
        cell.initCell(id: cats[indexPath.row]["id"] as! String,img: cats[indexPath.row]["iconImage"] as! String, lbl: cats[indexPath.row]["name"] as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SubToItems", sender: nil)
    }
}

