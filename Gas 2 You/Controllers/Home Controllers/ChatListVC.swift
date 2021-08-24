//
//  ChatListVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class ChatListVC: BaseVC {

    @IBOutlet weak var chatListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Chat", controller: self)
        DispatchQueue.main.async {
            self.chatListTV.reloadData()
        }
        
    }
    

}

extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = chatListTV.dequeueReusableCell(withIdentifier: ChatListCell.className) as! ChatListCell
            cell.lblMessage.textColor = indexPath.row == 0 ? .black : #colorLiteral(red: 0.6745098039, green: 0.6941176471, blue: 0.7529411765, alpha: 1)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatViewController: ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
