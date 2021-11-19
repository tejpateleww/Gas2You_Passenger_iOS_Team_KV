//
//  ChatListVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit
import SDWebImage

class ChatListVC: BaseVC,chatListRefresh {
    
    
    //MARK: Properties
    var arrUserList = [ChatListDatum]()
    var chatUserModel = ChatUserModel()
    var isReload = false
    let refreshControl = UIRefreshControl()
    var isLoading = true {
        didSet {
            self.chatListTV.isUserInteractionEnabled = !isLoading
            self.chatListTV.reloadData()
        }
    }
    @IBOutlet weak var chatListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        self.chatListTV.delegate = self
        self.chatListTV.dataSource = self
        self.chatListTV.reloadData()
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Chat", controller: self)
        self.addRefreshControl()
        self.callUserListAPI()
        chatListTV.register(UINib(nibName:"NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        chatListTV.register(UINib(nibName:"ChatListShimmerCell", bundle: nil), forCellReuseIdentifier: "ChatListShimmerCell")
    }
    //MARK: - Custom Methods
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = UIColor.init(hexString: "#1F79CD")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.chatListTV.addSubview(self.refreshControl)
    }
    func chatListRefreshScreen() {
        self.chatUserModel.webservicegetChatUserListAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
        self.isLoading = true
        self.isReload = false
        self.callUserListAPI()
    }
}

extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrUserList.count != 0 {
            return self.arrUserList.count
        } else {
            return (isReload) ? 5 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if !isReload{
            let ChatListShimmerCell = chatListTV.dequeueReusableCell(withIdentifier: ChatListShimmerCell.className) as! ChatListShimmerCell
            ChatListShimmerCell.lblName.text = "dummy datadummy data"
            ChatListShimmerCell.lblMessage.text = "dummy datadummy datadummy"
            return ChatListShimmerCell
        }else{
            if self.arrUserList.count != 0{
                let cell = chatListTV.dequeueReusableCell(withIdentifier: ChatListCell.className, for: indexPath) as! ChatListCell
                let dict = self.arrUserList[indexPath.row]
                cell.lblName.text = dict.fullName ?? ""
                cell.lblMessage.text = dict.message ?? ""
                cell.lblTime.text = dict.createdAt ?? ""
                
                let strUrl = dict.image ?? ""
                let strURl = URL(string: strUrl)
                cell.profileIV.sd_imageIndicator = SDWebImageActivityIndicator.white
                cell.profileIV.sd_setImage(with: strURl, placeholderImage: UIImage(named: "AppIcon"), options: .refreshCached, completed: nil)
                
                return cell
            }else{
                let noDataCell:NoDataCell = chatListTV.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
                noDataCell.imgNodata.image = UIImage(named: "IC_chat")
                noDataCell.lblData.text = "No chat available!"
                noDataCell.selectionStyle = .none
                return noDataCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController: ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
        chatViewController.userData = self.arrUserList[indexPath.row]
        chatViewController.delegateChat = self
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isReload{
            return UITableView.automaticDimension
        }else{
            if self.arrUserList.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .white)
        }
    }
}
extension ChatListVC{
    
    func callUserListAPI(){
        self.chatUserModel.chatListVC = self
        self.chatUserModel.webservicegetChatUserListAPI()
    }
}
