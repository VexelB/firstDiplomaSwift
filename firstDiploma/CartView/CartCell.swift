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
    @IBAction func delPressed(_ sender: Any) {
        delBtnPressed?()
    }
    
    var id = 0
    var delBtnPressed: (()->())?
    
    func initCell(item: CartItemModel) {
        nameLbl.text = item.name
        sizeLbl.text = item.size
        priceLbl.text = "\(item.price.split(separator: ".")[0])₽"
        id = item.catId
        let processor = DownsamplingImageProcessor(size: itemImg.frame.size)
        itemImg.kf.setImage(with: URL(string: "\(URLs().images)\(item.mainImage)"), options: [.processor(processor)])
    }

}
