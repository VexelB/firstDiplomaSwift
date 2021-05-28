//
//  ItemViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 27.05.2021.
//

import UIKit
import Kingfisher

class ItemViewController: UIViewController {

    var images = [String]()
    var frame = CGRect.zero
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = item.name
        descLbl.text = item.name
        priceLbl.text = "\(item.price.split(separator: ".")[0])₽"
        
        images = Array(item.images) == [] ? [item.mainImage] : Array(item.images)
        imagesPageControl.numberOfPages = images.count
        setupScreen()
        
        imagesScrollView.delegate = self
    }

    func setupScreen() {
        for i in 0..<images.count {
            frame.origin.x = imagesScrollView.frame.size.width * CGFloat(i)
            frame.size = imagesScrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.contentMode = .scaleAspectFill
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: URL(string:"\(URLs().images)\(images[i])"))
            
            self.imagesScrollView.addSubview(imgView)
        }
        
        imagesScrollView.contentSize = CGSize(width: (imagesScrollView.frame.size.width * CGFloat(images.count)), height: imagesScrollView.frame.size.height)
        imagesScrollView.delegate = self
    }
}

extension ItemViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        imagesPageControl.currentPage = Int(pageNumber)
    }
}
