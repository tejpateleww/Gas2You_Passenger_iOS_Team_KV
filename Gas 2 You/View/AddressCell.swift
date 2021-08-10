//
//  AddressCell.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class AddressCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
