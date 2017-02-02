//
//  PhotoCell.swift
//  myApp
//
//  Created by Enzo Ames on 2/1/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {


    @IBOutlet weak var posterView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
