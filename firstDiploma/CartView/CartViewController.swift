//
//  CartViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

class CartViewController: UIViewController {
    
//    let realmcontroller = RealmController.shared
    var cart = [CartItem]()
    var fullprice = 0 { didSet{
        fullpriceLbl.text = "\(fullprice)₽"
    }}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullpriceLbl: UILabel!
    @IBAction func order(_ sender: Any) {
//        realmcontroller.clear(obj: CartItem.self)
        tableView.reloadData()
    }
    
    func loadCart() {
//        realmcontroller.load(obj: CartItem.self, completion: { temp in
//                    self.cart = []
//                    self.fullprice = 0
//                    for i in temp {
//                        if let a = i as? CartItem {
//                            self.cart.append(a)
//                            self.fullprice += Int(a.price.split(separator: ".")[0]) ?? 0
//                        }
//                    }
//        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CartDelViewController {
            vc.catId = "\((tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! CartCell).id)"
            vc.par = self
        }
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        loadCart()
        return cart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.initCell(item: cart[indexPath.row])
        cell.delBtnPressed = {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }


}
