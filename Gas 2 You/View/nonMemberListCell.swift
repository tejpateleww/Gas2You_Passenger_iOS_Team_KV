//
//  nonMemberListCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 22/09/21.
//

import UIKit

class nonMemberListCell: UITableViewCell {

    @IBOutlet weak var lbltitle: ThemeLabel!
    @IBOutlet weak var lblPrice: ThemeLabel!
    @IBOutlet weak var btnCheck: UIButton!
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
