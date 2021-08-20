//
//  InProgressCell.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit

class InProgressCell: UITableViewCell {

    
    var chatClick : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnActionchat(_ sender: UIButton) {
        if let btnclicked = chatClick {
            btnclicked()
        }
    }
}
