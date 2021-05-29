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
    var cart = [CartItemModel]()
    var fullprice = 0 { didSet{
        fullpriceLbl.text = "\(fullprice)₽"
    }}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullpriceLbl: UILabel!
    @IBAction func order(_ sender: Any) {
        dbService.clear(obj: CartItem.self, completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        loadCart()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CartDelViewController {
            vc.catId = "\((tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! CartCell).id)"
            vc.delegate = self
        }
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
            self?.cart = result.map { $0 as! CartItemModel }
            self?.tableView.reloadData()
        })
    }
}
