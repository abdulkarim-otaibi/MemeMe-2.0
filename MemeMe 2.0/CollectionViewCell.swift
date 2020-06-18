//
//  CollectionViewCell.swift
//  MemeMe 2.0
//
//  Created by Abdulkrum Alatubu on 25/10/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImage: UIImageView!
    
    var Info: Meme? {
           didSet{
               collectionImage.image = Info?.memedImage
           }
       }
}
