//
//  MemberListHomeCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 19/11/21.
//

import UIKit

class MemberListHomeCell: UITableViewCell {

    @IBOutlet weak var lblTitle: ThemeLabel!
    @IBOutlet weak var lblPrice: ThemeLabel!
    @IBOutlet weak var imgCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
