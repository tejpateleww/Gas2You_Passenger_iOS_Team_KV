//
//  VehicleListCell.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class VehicleListCell: UITableViewCell {

    @IBOutlet weak var lblCarName: ThemeLabel!
    @IBOutlet weak var lblModel: ThemeLabel!
    @IBOutlet weak var lblYear: ThemeLabel!
    @IBOutlet weak var lblColor: ThemeLabel!
    @IBOutlet weak var lblPlatNo: ThemeLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
