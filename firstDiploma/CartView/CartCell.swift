//
//  CartCell.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit
import Kingfisher

class CartCell: UITableViewCell {

    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBAction func delPressed(_ sender: Any) {
        delBtnPressed?()
    }
    
    var amount = 1 {
        didSet{
            amountLbl.text = "x \(amount)"
        }
    }
    var id = 0
    var delBtnPressed: (()->())?
    
    func initCell(item: (CartItemModel, Int)) {
        nameLbl.text = item.0.name
        sizeLbl.text = item.0.size
        priceLbl.text = "\(item.0.price.split(separator: ".")[0])₽"
        id = item.0.catId
        self.amount = item.1
        let processor = DownsamplingImageProcessor(size: itemImg.frame.size)
        itemImg.kf.setImage(with: URL(string: "\(URLs().images)\(item.0.mainImage)"), options: [.processor(processor)])
    }

}
