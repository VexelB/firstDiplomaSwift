//
//  CartDelViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

class CartDelViewController: UIViewController {

    let dbService = Services.dBRealmService
    
    var catId = ""
    var delegate: DeleteCartItemProtocol?
    
    @IBAction func noPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        dbService.clearByCategorie(catId: catId, obj: CartItem.self, completion: {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.loadCart()
        })
    }

}
