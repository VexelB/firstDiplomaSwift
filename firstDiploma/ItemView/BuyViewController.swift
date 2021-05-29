//
//  BuyViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

class BuyViewController: UIViewController {
    
    var item = Item()
    var sizes = [String]()
    var quant = [String]()
//    let realmcontroller = RealmController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizes = Array(item.offersSize)
        quant = Array(item.offersQuantity)
        // Do any additional setup after loading the view.
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dismiss(animated: true, completion: nil)
    }

}

extension BuyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyCell", for: indexPath) as! BuyCell
        cell.initCell(size: sizes[indexPath.row], quant: quant[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cartItem = CartItem()
        cartItem.name = item.name
        cartItem.mainImage = item.mainImage
        cartItem.size = sizes[indexPath.row]
        cartItem.price = item.price
        cartItem.article = item.id
//        realmcontroller.put(obj: cartItem)
        dismiss(animated: true, completion: nil)
    }
}
