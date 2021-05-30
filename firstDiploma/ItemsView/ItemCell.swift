//
//  ItemCollectionViewCell.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 26.05.2021.
//

import UIKit
import Kingfisher

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBAction func buyPressed(_ sender: Any) {
        buyBtnPressed?()
    }
    var buyBtnPressed : (()->())?
    
    var id = ""
    var item = ItemModel()
    private var name = "" {didSet {
        self.nameLbl.text = name
    }}
    
    func initCell(item: ItemModel) {
        self.item = item
        self.id = item.id
        self.name = item.name
        self.priceLbl.text = "\(item.price.split(separator: ".")[0])₽"
        let url = item.mainImage != "" ? item.mainImage : "image/catalog/style/modile/acc_cat.png"
        let processor = DownsamplingImageProcessor(size: itemImg.frame.size)
        self.itemImg.kf.indicatorType = .activity
        self.itemImg.kf.setImage(with: URL(string: "\(URLs.images.rawValue)\(url)"), options: [.processor(processor)])
    }
}
