//
//  TableViewCell.swift
//  MemeMe 2.0
//
//  Created by Abdulkrum Alatubu on 24/10/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    var Info: Meme? {
        didSet{
            theImage.image = Info?.memedImage
            title.text = (Info?.topText)! + "..." + (Info?.bottomText)!
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }

}
