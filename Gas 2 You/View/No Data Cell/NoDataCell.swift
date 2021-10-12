//
//  NoDataCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 01/10/21.
//

import UIKit

class NoDataCell: UITableViewCell {

    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var imgNodata: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
