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
    
    private let dbService = Services.dBRealmService
    
    private let sectionInsets = UIEdgeInsets(
      top: 10.0,
      left: 10.0,
      bottom: 10.0,
      right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    private var items = [ItemModel]()
    var categorie = ""
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBAction func showCart(_ sender: Any) {
        performSegue(withIdentifier: Segues.showCartFromItems, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItemsRS()
        loadAF()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? ItemViewController {
            if let select = collView.indexPathsForSelectedItems, let item = collView.cellForItem(at: select[0]) as? ItemCell {
                vc.item = item.item
            }
        } else if let vc = segue.destination as? BuyViewController {
            if let select = collView.indexPathsForSelectedItems, let item = collView.cellForItem(at: select[0]) as? ItemCell {
                vc.item = item.item
            }
        }
    }
    
    func loadItemsRS(){
        dbService.loadByCategorie(catId: categorie, obj: Item.self, completion: { [weak self] results in
            self?.items = results.map { $0 as! ItemModel }
            self?.collView.reloadData()
        })
    }
    
    func loadAF() {
        AF.request("\(URLs.itemsURL)\(self.categorie)").responseJSON { [weak self]
            response in if let objects = response.value {
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                self?.dbService.clear(obj: Item.self) {
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    self?.dbService.putItems(catId: self?.categorie ?? "-1", json: JSON(objects), completion: {
                        self?.loadItemsRS()
                    })
                })
            }
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
        
        cell.itemImg.frame.size.width = cell.frame.width
        cell.itemImg.frame.size.height = cell.itemImg.frame.width * 4 / 5
        NSLayoutConstraint(item: cell.nameLbl!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cell.frame.width).isActive = true
        
        cell.buyBtnPressed = {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            self.performSegue(withIdentifier: Segues.showBuyFromItems, sender: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.showItem, sender: nil)
        collView.deselectItem(at: indexPath, animated: true)
    }
    
}
