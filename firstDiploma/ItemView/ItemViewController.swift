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
    var item: ItemModel?
    
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    
    @IBAction func showCart(_ sender: Any) {
        performSegue(withIdentifier: Segues.showCartFromItem, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let itemImages = item?.images else { return }
        images = Array(itemImages) == [] ? [item!.mainImage] : Array(itemImages)
        imagesPageControl.numberOfPages = images.count
        
        nameLbl.text = item?.name
        descriptionLbl.text = item?.desc
        priceLbl.text = "\(item!.price.split(separator: ".")[0])₽"
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? BuyViewController {
            vc.item = item
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScreen()
    }

    func setupScreen() {
        view.layoutIfNeeded()
        for i in 0..<images.count {
            frame.origin.x = imagesScrollView.frame.size.width * CGFloat(i)
            frame.size = imagesScrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.kf.indicatorType = .activity
            let processor = DownsamplingImageProcessor(size: imagesView.frame.size)
            imgView.kf.setImage(with: URL(string:"\(URLs.imagesURL)\(images[i])"), options: [.processor(processor)])
            imgView.contentMode = .scaleAspectFill
            
            imagesScrollView.addSubview(imgView)
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
