//
//  CatCell.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import UIKit
import Kingfisher

class CatCell: UITableViewCell {
    
    @IBOutlet weak var categorieImg: UIImageView!
    @IBOutlet weak var categorieLbl: UILabel!
    
    var id = ""

    func initCell(id: String, img: String, lbl: String) {
        self.id = id
        self.categorieLbl.text = lbl
        let url = img != "" ? img : "image/catalog/style/modile/acc_cat.png"
        let processor = DownsamplingImageProcessor(size: categorieImg.frame.size)
        self.categorieImg.kf.setImage(with: URL(string: "\(URLs.imagesURL)\(url)"), options: [.processor(processor)])
    }
}
