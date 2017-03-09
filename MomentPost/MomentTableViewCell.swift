//
//  MomentTableViewCell.swift
//  Contact
//
//  Created by Chenggang Xu on 7/2/16.
//  Copyright © 2016 Chenggang Xu. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
