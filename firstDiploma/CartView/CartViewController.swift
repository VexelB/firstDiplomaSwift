//
//  CartViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

protocol DeleteCartItemProtocol: AnyObject {
    func loadCart()
}

class CartViewController: UIViewController {
    
    let dbService = Services.dBRealmService
    var cart = [(item: CartItemModel, amount: Int)]()
    var fullprice = 0 { didSet{
        fullpriceLbl.text = "\(fullprice)₽"
    }}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullpriceLbl: UILabel!
    @IBAction func order(_ sender: Any) {
        dbService.clear(obj: CartItem.self, completion: { [weak self] in
            self?.loadCart()
        })
    }
    
    override func viewDidLoad() {
        loadCart()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CartDelViewController {
            if let index = tableView.indexPathForSelectedRow {
                vc.cartItem = cart[index.row].item
                vc.delegate = self
            }
        }
    }
    
    func distinctCart(cart: [CartItemModel]) -> [(item: CartItemModel, amount: Int)]{
        var unique = [(item: CartItemModel, amount: Int)]()
        for i in cart {
            var isunique = true
            for (x, j) in unique.enumerated() {
                if i.name == j.item.name, i.size == j.item.size {
                    isunique = false
                    unique[x].amount += 1
                }
            }
            if isunique {
                unique.append((i, 1))
            }
        }
        return(unique)
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

extension CartViewController: DeleteCartItemProtocol {
    func loadCart() {
        dbService.load(obj: CartItem.self, completion: { [weak self] result in
            self?.fullprice = 0
            self?.cart = self?.distinctCart(cart: result.map {
                if let item = $0 as? CartItemModel, let price = Int(item.price.split(separator: ".")[0]) {
                    self?.fullprice += price
                }
                return $0 as! CartItemModel
            }) ?? [(item: CartItemModel, amount: Int)]()
            self?.tableView.reloadData()
        })
    }
}
