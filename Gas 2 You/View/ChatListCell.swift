//
//  ChatListCell.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var lblTime: themeLabel!
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblMessage: themeLabel!
    @IBOutlet weak var profileIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileIV.layer.cornerRadius = profileIV.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
