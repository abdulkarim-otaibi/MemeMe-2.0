//
//  ViewControllerOpen.swift
//  MemeMe 2.0
//
//  Created by Abdulkrum Alatubu on 25/10/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit

class ViewControllerOpen: UIViewController {

    var memeImage :UIImage?
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = memeImage
    }
    
    func setImage(img:UIImage) {
        self.memeImage = img
    }
    
    
  
    
    
}
