//
//  BuyCell.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 28.05.2021.
//

import UIKit

class BuyCell: UITableViewCell {

    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    func initCell(size: String, quant: String){
        self.sizeLbl.text = size
        self.quantityLbl.text = "Осталось: \(quant)"
    }

}
