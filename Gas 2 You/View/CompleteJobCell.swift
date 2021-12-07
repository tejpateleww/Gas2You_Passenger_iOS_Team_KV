//
//  CompleteJobCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 07/12/21.
//

import UIKit

class CompleteJobCell: UITableViewCell {

    @IBOutlet weak var lblItemName: ThemeLabel!
    @IBOutlet weak var lblQty: ThemeLabel!
    @IBOutlet weak var lblprice: ThemeLabel!
    @IBOutlet weak var lblTotal: ThemeLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
