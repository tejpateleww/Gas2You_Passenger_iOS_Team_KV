//
//  ChatUserModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 15/11/21.
//

import Foundation
class ChatUserModel{
    
    weak var chatListVC : ChatListVC? = nil
    weak var chatViewController : ChatViewController? = nil
    
    func webservicegetChatUserListAPI(){
        WebServiceSubClass.ChatList(completion: { (status, apiMessage, response, error) in
            self.chatListVC?.isLoading = false
            self.chatListVC?.isReload = true
            if status{
                self.chatListVC?.arrUserList = response?.data ?? []
                self.chatListVC?.chatListTV.reloadData()
                DispatchQueue.main.async {
                    self.chatListVC?.refreshControl.endRefreshing()
                }
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        })
    }
    
    func webserviceSendMsgAPI(reqModel: SendMsgReqModel){
        WebServiceSubClass.sendMsgAPI(reqModel: reqModel) { (status, apiMessage, response, error) in
            if status{
                self.chatViewController?.arrayChatHistory.append((response?.data)!)
                self.chatViewController?.filterArrayData(isFromDidLoad: true)
                self.chatViewController?.delegateChat?.chatListRefreshScreen()
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        }
    }

    func webservicegetChatHistoryAPI(BookingId:String){
       WebServiceSubClass.getChatHistoryApi(BookingId: BookingId, completion:{ (status, apiMessage, response, error) in
           self.chatViewController?.isTblReload = true
            if status{
                self.chatViewController?.bookingID = response?.bookingId ?? ""
             //   self.chatViewController?.senderID = response?.driverId ?? ""
                self.chatViewController?.setProfileInfo(name: response?.driverName ?? "", profile: response?.driverProfilePicture ?? "")
                self.chatViewController?.arrayChatHistory = response?.data ?? []
                self.chatViewController?.receiverID = response?.driverId ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.chatViewController?.filterArrayData(isFromDidLoad: true)
                }
 
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        })
    }
    
}
