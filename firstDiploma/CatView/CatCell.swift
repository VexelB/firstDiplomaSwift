//
//  CatCell.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 25.05.2021.
//

import UIKit
import Kingfisher

class CatCell: UITableViewCell {
    
    @IBOutlet weak var catImg: UIImageView!
    
    @IBOutlet weak var catLbl: UILabel!
    
    var id = ""

    func initCell(id: String, img: String, lbl: String) {
        self.id = id
        self.catLbl.text = lbl
        let url = img != "" ? img : "image/catalog/style/modile/acc_cat.png"
        self.catImg.kf.setImage(with: URL(string: "https://blackstarshop.ru/\(url)"), options: [.transition(.fade(0.2))])
    }
    
    
}
