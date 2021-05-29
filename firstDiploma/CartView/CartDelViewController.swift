//
//  CartDelViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

class CartDelViewController: UIViewController {

//    let realmcontroller = RealmController.shared
    
    var catId = ""
    var par = CartViewController()
    
    @IBAction func noPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesPressed(_ sender: Any) {
//        realmcontroller.clear(catId: catId, obj: CartItem.self) { [weak self] in
//            self?.par.tableView.reloadData()
//        }
        dismiss(animated: true, completion: nil)
    }

}
