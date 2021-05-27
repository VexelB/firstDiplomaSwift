//
//  ItemCollectionViewCell.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 26.05.2021.
//

import UIKit
import Kingfisher

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    var id = ""
    var name = "" {didSet {
        self.nameLbl.text = name
    }}
    
    func initCell(id: String, img: String, name: String, price: String, view: UIView) {
        self.id = id
        self.name = name
        self.priceLbl.text = "\(price.split(separator: ".")[0])₽"
        let url = img != "" ? img : "image/catalog/style/modile/acc_cat.png"
        let processor = DownsamplingImageProcessor(size: itemImg.frame.size)
        self.itemImg.kf.indicatorType = .activity
        self.itemImg.kf.setImage(with: URL(string: "https://blackstarshop.ru/\(url)"), options: [.processor(processor)])
    }
    @IBAction func buyPressed(_ sender: Any) {
        print("buy")
    }
}
