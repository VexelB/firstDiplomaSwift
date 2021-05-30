//
//  BuyViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

class BuyViewController: UIViewController {
    
    var item = ItemModel()
    var sizes = [String]()
    var quant = [String]()
    let dbServies = Services.dBRealmService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizes = item.offerSizes
        quant = item.offerQuantities
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
        dbServies.putInCart(item: item, size: sizes[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
