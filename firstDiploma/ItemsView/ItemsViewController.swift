//
//  ItemsViewController.swift
//  firstDiploma
//
//  Created by Евгений Войтин on 26.05.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ItemsViewController: UIViewController {
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    private let itemsPerRow: CGFloat = 2
    
    var items = [Item]()
    var cat = ""
    let realmcontroller = RealmController.shared
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBAction func showCart(_ sender: Any) {
        performSegue(withIdentifier: "ItemsToCart", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemViewController, segue.identifier == "ItemsToItem" {
            if let select = collView.indexPathsForSelectedItems, let item = collView.cellForItem(at: select[0]) as? ItemCell {
                vc.item = item.item
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRS()
        loadAF()
        // Do any additional setup after loading the view.
    }
    
    func loadRS(){
        realmcontroller.load(catId: cat, obj: Item.self, completion: { temp in
            self.items = []
            for i in temp {
                if let a = i as? Item {
                    self.items.append(a)
                }
            }
            self.collView.reloadData()
            self.collView.layoutIfNeeded()
        })
    }
    func loadAF() {
        AF.request("\(URLs().itemsURL)\(self.cat)").responseJSON {
            response in if let objects = response.value {
                self.realmcontroller.clear(catId: self.cat, obj: Item.self)
                let json = JSON(objects)
                for i in json {
                    let item = Item()
                    item.id = i.0
                    item.name = i.1["name"].stringValue
                    item.article = i.1["article"].stringValue
                    item.mainImage = i.1["mainImage"].stringValue
                    item.price = i.1["price"].stringValue
                    item.desc = i.1["description"].stringValue
                    item.catId = Int(self.cat) ?? 0
                    for j in i.1["offers"] {
                        var temp = [String]()
                        item.offersSize.append(j.1["size"].stringValue)
                        item.offersQuantity.append(j.1["quantity"].stringValue)
                    }
                    for j in i.1["productImages"] {
                            item.images.append(j.1["imageURL"].stringValue)
                    }
                    self.realmcontroller.put(obj: item)
                }
            }
        self.loadRS()
        }
    }
}

extension ItemsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 4 / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.initCell(item: items[indexPath.row])
        
        let temp = cell.frame.width
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .trailing, relatedBy: .equal, toItem: cell.nameLbl, attribute: .trailing, multiplier: 1, constant: 8))
        cell.nameLbl.addConstraint(NSLayoutConstraint(item: cell.nameLbl!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: temp - 16))
        cell.itemImg.frame.size.width = cell.frame.width
        cell.itemImg.frame.size.height = cell.itemImg.frame.width * 4 / 5
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemsToItem", sender: nil)
    }
    
}
