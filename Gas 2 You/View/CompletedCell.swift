//
//  CompletedCell.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit

class CompletedCell: UITableViewCell {

    @IBOutlet weak var lblTopHalf: themeLabel!
    @IBOutlet weak var viewTopHalf: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewTopHalf?.layer.masksToBounds = true
        viewTopHalf?.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
