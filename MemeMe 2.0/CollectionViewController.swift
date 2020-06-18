//
//  CollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Abdulkrum Alatubu on 25/10/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
 
    @IBOutlet weak var collectionView: UICollectionView!
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)

    }

    
    // this funs for refresh the CollectionView when we add new item
    @objc func refresh(notification: NSNotification) {
        //must be used from main thread only , becouse we need update UI  
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.memes = appDelegate.memes
            self.collectionView.reloadData()
            
        }
        
    }
    
}

extension CollectionViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (view.frame.width - 10) / 3, height: (view.frame.height - 10) / 3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewList:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! CollectionViewCell
        viewList.Info = memes[indexPath.row]
        return viewList
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ViewControllerOpen") as! ViewControllerOpen
        VC.setImage(img: memes[indexPath.row].memedImage!)
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
}
