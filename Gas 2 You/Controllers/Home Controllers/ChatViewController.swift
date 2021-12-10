//
//  chatVC.swift
//  PickARide User
//
//  Created by Apple on 19/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit
import UIView_Shimmer
import SafariServices
import IQKeyboardManagerSwift

protocol chatListRefresh {
    func chatListRefreshScreen()
}
class ChatViewController: BaseVC {
    
    //MARK: -Properties
    var delegateChat : chatListRefresh?
    var isFromPush : Bool = false
    var receiverID = ""
    var bookingID = ""
    //var senderID = ""
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblChat.reloadData()
        }
    }
    var userData : ChatListDatum?
    var arrayChatHistory = [chatHistoryDatum]()
    var filterListArr : [String: [chatHistoryDatum]] = [String(): [chatHistoryDatum]()]
    var filterKeysArr : [Date] = [Date]()
    var oldChatSectionTitle = Date()
    var oldChatId = String()
    var chatUserModel = ChatUserModel()
    //MARK: -IBOutlets
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var txtviewComment: RatingTextview!
    @IBOutlet var vwNavBar: UIView!
    @IBOutlet weak var lblChatText: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    //MARK: -View Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDel.isChatScreen = true
        
        //self.ChatSocketOnMethods()
        self.setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDel.isChatScreen = false
        
        //self.ChatSocketOffMethods()
        self.setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
        if isFromPush{
            self.callChatHistoryAPI()
        }else{
            self.callChatHistoryAPI()
        }
        txtviewComment.delegate = self
        txtviewComment.textColor = txtviewComment.text == "" ? .black : .gray
        setLocalization()
        setValue()
        tblChat.register(UINib(nibName:"ChatShimmer", bundle: nil), forCellReuseIdentifier: "ChatShimmer")
        tblChat.register(UINib(nibName:"NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        if UIDevice.current.userInterfaceIdiom == .phone{
            txtviewComment.font = CustomFont.PoppinsRegular.returnFont(16)
        }else{
            txtviewComment.font = CustomFont.PoppinsRegular.returnFont(21)
        }
        tblChat.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshChatScreen), name: .refreshChatScreen, object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardNotification(notification:)),name: UIResponder.keyboardWillChangeFrameNotification,object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshChatScreen(){
        callChatHistoryAPI()
    }
    //MARK: -Bring up and down the keyboard
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 0.0
        } else {
            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
    //MARK: -other methods
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.arrayChatHistory.count > 0 {
                let list = self.filterListArr[self.filterKeysArr.last?.Date_In_DD_MM_YYYY_FORMAT ?? String ()]
                
                let rowIndex = list?.count == 0 ? 0 : ((list?.count ?? 0) - 1)
                let indexPath = IndexPath(row: rowIndex, section: self.filterKeysArr.count - 1)
                self.tblChat.reloadData()
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }else{
                self.tblChat.reloadData()
            }
        }
    }
    func prepareView(){
        
        self.txtviewComment.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone{
            self.txtviewComment.font = CustomFont.PoppinsRegular.returnFont(16)
        }else{
            self.txtviewComment.font = CustomFont.PoppinsRegular.returnFont(21)
        }
        self.txtviewComment.textColor = txtviewComment.text == "" ? .black : .gray
        if(!isFromPush){
            self.bookingID = self.userData?.bookingId ?? ""
        }
    }
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .refreshChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callHistory), name: .refreshChatScreen, object: nil)
    }
    
    @objc func callHistory(){
        self.callChatHistoryAPI()
    }
    func setLocalization() {
        
    }
    func setValue() {
        
    }
    func scrollAt(){
        if self.arrayChatHistory.count > 0 {
            let list = self.filterListArr[oldChatSectionTitle.Date_In_DD_MM_YYYY_FORMAT ?? ""]
            let row = list?.firstIndex(where: {$0.id == oldChatId}) ?? 0
            let section = self.filterKeysArr.firstIndex(where: {$0.Date_In_DD_MM_YYYY_FORMAT == oldChatSectionTitle.Date_In_DD_MM_YYYY_FORMAT}) ?? 0
            let indexPath = IndexPath(row: row, section: section)
            self.tblChat.reloadData()
            self.tblChat.scrollToRow(at: indexPath, at: .top, animated: false)
        }else{
            self.tblChat.reloadData()
        }
    }
    func scrollToFirstRow() {
        self.tblChat.layoutIfNeeded()
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tblChat.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
    func filterArrayData(isFromDidLoad: Bool){
        self.filterListArr.removeAll()
        self.filterKeysArr.removeAll()
        self.arrayChatHistory.sort(by: {$0.createdAt!.compare($1.createdAt!) == .orderedAscending})
        for each in self.arrayChatHistory{
            let dateField = each.createdAt?.serverDateStringToDateType1?.Date_In_DD_MM_YYYY_FORMAT ?? String ()
            if filterListArr.keys.contains(dateField){
                filterListArr[dateField]?.append(each)
            }else{
                filterListArr[dateField] = [each]
                self.filterKeysArr.append(each.createdAt?.serverDateStringToDateType1 ?? Date())
            }
        }
        self.filterKeysArr.sort(by: <)
        isFromDidLoad ? self.scrollToBottom() : self.scrollAt()
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    func setProfileInfo(name:String, profile:String){
        self.NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: name, controller: self)
        self.navBarChatRightImage(imgURL: profile)
    }
    
    func previewDocument(strURL : String){
        guard let url = URL(string: strURL) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    func validations() -> Bool{
        if(self.txtviewComment.text == "Start Typing..." || self.txtviewComment.text.trimmedString == ""){
            return false
        }
        return true
    }
    
    //MARK: -IBActions
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {
            return false
        }else{
            return true
        }
    }
    @IBAction func btnChatAction(_ sender: Any) {
        if(self.validations()){
            self.callSendMsgAPI()
            txtviewComment.text = ""
        }else{
            Toast.show(title: UrlConstant.Required, message: "Please enter message", state: .info)
        }
    }
    
    //MARK: -API Calls
    
}
//MARK:- Textview Delegate
extension ChatViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtviewComment.textColor == .lightGray {
            txtviewComment.text = nil
            txtviewComment.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblChatText.text = self.txtviewComment.text
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtviewComment.text.isEmpty {
            txtviewComment.text = "Start Typing..."
            txtviewComment.textColor = .lightGray
        }
    }
}
//MARK: -tableviewDelegate
extension ChatViewController : UITableViewDelegate, UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayChatHistory.count > 0 {
            let strDate = self.filterKeysArr[section].Date_In_DD_MM_YYYY_FORMAT ?? ""
            return self.filterListArr[strDate]?.count ?? 0
        } else {
            return  1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if(!self.isTblReload){
//            let cell = tblChat.dequeueReusableCell(withIdentifier: ChatShimmer.className, for: indexPath) as! ChatShimmer
//            return cell
//        }else{
            if(self.arrayChatHistory.count > 0){
                let strDateTitle = self.filterKeysArr[indexPath.section].Date_In_DD_MM_YYYY_FORMAT ?? ""
                let obj = self.filterListArr[strDateTitle]?[indexPath.row]
                
                let isDriver = obj?.senderType ?? "" == "customer"
                if(isDriver){
                    let cell = tblChat.dequeueReusableCell(withIdentifier: chatSenderCell.className, for: indexPath) as! chatSenderCell
                    cell.selectionStyle = .none
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
                    let dateObj = dateFormatter.date(from: obj?.createdAt ?? "")
                    dateFormatter.dateFormat = "hh:mm a"
                    cell.lblSenderTimer.text = (dateFormatter.string(from: dateObj!))
                    
                    if(canOpenURL(string: obj?.message ?? "")){
                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, .foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
                        let underlineAttributedString = NSAttributedString(string: obj?.message ?? "", attributes: underlineAttribute)
                        cell.lblSenderMessage.attributedText = underlineAttributedString
                    } else {
                        cell.lblSenderMessage.text = obj?.message ?? ""
                    }
                    
                    cell.btnSenderTapCousure = {
                        if(self.isValidUrl(url: obj?.message ?? "")){
                            self.previewDocument(strURL: obj?.message ?? "")
                        }
                    }
                    return cell
                }else{
                    let cell = tblChat.dequeueReusableCell(withIdentifier: chatReciverCell.className, for: indexPath) as! chatReciverCell
                    cell.selectionStyle = .none
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
                    let dateObj = dateFormatter.date(from: obj?.createdAt ?? "")
                    dateFormatter.dateFormat = "hh:mm a"
                    cell.lblTimer.text = (dateFormatter.string(from: dateObj!))
                    
                    if(canOpenURL(string: obj?.message ?? "")){
                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, .foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
                        let underlineAttributedString = NSAttributedString(string: obj?.message ?? "", attributes: underlineAttribute)
                        cell.lblReciverMessage.attributedText = underlineAttributedString
                    } else {
                        cell.lblReciverMessage.text = obj?.message ?? ""
                    }
                    cell.btnSenderTapCousure = {
                        if(self.isValidUrl(url: obj?.message ?? "")){
                            self.previewDocument(strURL: obj?.message ?? "")
                        }
                    }
                    return cell
                }
            }else{
                let NoDatacell = self.tblChat.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! NoDataCell
                NoDatacell.imgNodata.image = UIImage(named: "ic_chat")
                NoDatacell.lblData.text = "No chat available!"
                if UIDevice.current.userInterfaceIdiom == .phone{
                    NoDatacell.lblData.font = CustomFont.PoppinsRegular.returnFont(16.0)
                }else{
                    NoDatacell.lblData.font = CustomFont.PoppinsRegular.returnFont(21.0)
                }
                return NoDatacell
            }
//        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.arrayChatHistory.count > 0 {
            return self.filterKeysArr.count
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:30.0))
        if(self.arrayChatHistory.count > 0){
        
            let lblDate = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
            lblDate.backgroundColor = UIColor.lightGray
            lblDate.textColor = UIColor.white
            lblDate.layer.cornerRadius = lblDate.frame.height/2.0
            lblDate.layer.masksToBounds = true
            
            let obj = self.filterKeysArr[section]
            lblDate.text = obj.timeAgoSinceDate(isForNotification: true)
            
            lblDate.textAlignment = .center
            lblDate.font = FontBook.regular.of(size: 12.0)
            
            headerView.addSubview(lblDate)
            lblDate.center = headerView.center
        
        }
        return headerView
    }
}
class chatSenderCell : UITableViewCell {
    @IBOutlet weak var lblBottomView: UIView!
    @IBOutlet weak var lblSenderView: ChatScreenView!
    @IBOutlet weak var lblSenderMessage: ChatScreenLabel!
    @IBOutlet weak var lblSenderTimer: UILabel!
    @IBOutlet weak var btnSender: UIButton!
    
    var btnSenderTapCousure : (()->())?
    
    @IBAction func btnSenderTap(_ sender: UIButton) {
        if let obj = self.btnSenderTapCousure{
            obj()
        }
    }
}
class chatReciverCell : UITableViewCell {
    @IBOutlet weak var lblBottomView: UIView!
    @IBOutlet weak var lblReciverView: ChatScreenView!
    @IBOutlet weak var lblReciverMessage: ChatScreenLabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnReceiver: UIButton!
    
    var btnSenderTapCousure : (()->())?
    @IBAction func btnReceiverTap(_ sender: UIButton) {
        if let obj = self.btnSenderTapCousure{
            obj()
        }
    }
}
class chatHeaderCell : UITableViewCell {
    
    @IBOutlet weak var lblDateTime: ChatScreenLabel!
    @IBOutlet weak var vwMain: UIView!
}
class ChatConversation {
    var MessageDate : String?
    var MessageData : [MessageAllData]?
    init(date:String,Data:[MessageAllData]) {
        self.MessageDate = date
        self.MessageData = Data
    }
}
class MessageAllData {
    var isFromSender : Bool?
    var chatMessage : String?
    var isLastMessage : Bool?
    init(fromSender:Bool,message:String,lastMessage:Bool) {
        self.isLastMessage = lastMessage
        self.isFromSender = fromSender
        self.chatMessage = message
    }
}

//MARK: KEYBOARD SETUP FOR CHATBOX
extension ChatViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboards))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboards()
    {
        view.endEditing(true)
    }
    
    func setupKeyboard(_ enable: Bool) {
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.enableAutoToolbar = enable
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !enable
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        keyboardHeightLayoutConstraint?.constant = 0
        self.animateConstraintWithDuration()
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if #available(iOS 11.0, *) {
            
            DispatchQueue.main.async {
                if self.arrayChatHistory.count != 0 {
                    self.scrollToBottom()
                }
            }
            keyboardHeightLayoutConstraint?.constant = keyboardSize!.height - view.safeAreaInsets.bottom
            
        } else {
            
            DispatchQueue.main.async {
                if self.arrayChatHistory.count != 0 {
                    self.scrollToBottom()
                }
            }
            keyboardHeightLayoutConstraint?.constant = keyboardSize!.height - 10
            
        }
        self.animateConstraintWithDuration()
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.loadViewIfNeeded() ?? ()
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
//MARK:- Api Calls
extension ChatViewController{
    
    func callChatHistoryAPI(){
        self.chatUserModel.chatViewController = self
        self.chatUserModel.webservicegetChatHistoryAPI(BookingId: self.bookingID)
    }
    
    func callSendMsgAPI(){
        self.chatUserModel.chatViewController = self
        let SendMsgReqModel = SendMsgReqModel()
        SendMsgReqModel.bookingId = self.bookingID
        SendMsgReqModel.receiverId = receiverID// Singleton.sharedInstance.userId
        SendMsgReqModel.message = self.txtviewComment.text ?? ""

        self.chatUserModel.webserviceSendMsgAPI(reqModel: SendMsgReqModel)
    }
}
