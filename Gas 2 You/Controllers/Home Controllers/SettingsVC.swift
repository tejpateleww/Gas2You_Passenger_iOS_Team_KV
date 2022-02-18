//
//  SettingsVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit
import SafariServices

class SettingsVC: BaseVC {

    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var btnAboutus: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    var notiChangeViewModel = NotiChangeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    func prepareView(){
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Settings", controller: self)
        
        self.switchNotification.layer.cornerRadius = self.switchNotification.bounds.height/2
        self.switchNotification.layer.borderWidth = 1
        self.switchNotification.layer.borderColor = #colorLiteral(red: 0.1801939905, green: 0.8354453444, blue: 0.6615549922, alpha: 1)
        self.switchNotification.tintColor = UIColor(hexString: "#EBFBF6")
        self.switchNotification.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        if(Singleton.sharedInstance.userProfilData?.notification == "1"){
            self.switchNotification.setOn(true, animated: true)
        }else{
            self.switchNotification.setOn(false, animated: true)
        }
    }
    @objc func switchValueDidChange(_ sender: UISwitch) {
        self.callNotiChangeApi()
    }
    func previewDocument(strURL : String){
        guard let url = URL(string: strURL) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    @IBAction func btnAboutClick(_ sender: Any) {
        var AS = ""
        if let ASLink = Singleton.sharedInstance.appInitModel?.appLinks?.filter({ $0.name == "about_us"}) {
            if ASLink.count > 0 {
                AS = ASLink[0].url ?? ""
                self.previewDocument(strURL: AS)
            }
        }
    }
    @IBAction func btnTermsClick(_ sender: Any) {
        var TC = ""
        if let TCLink = Singleton.sharedInstance.appInitModel?.appLinks?.filter({ $0.name == "terms_and_condition"}) {
            if TCLink.count > 0 {
                TC = TCLink[0].url ?? ""
                self.previewDocument(strURL: TC)
            }
        }
    }
    @IBAction func btnPrivacyClick(_ sender: Any) {
        var PP = ""
        if let PPLink = Singleton.sharedInstance.appInitModel?.appLinks?.filter({ $0.name == "privacy_policy"}) {
            if PPLink.count > 0 {
                PP = PPLink[0].url ?? ""
                self.previewDocument(strURL: PP)
            }
        }
    }
    @IBAction func btnLogoutTap(_ sender: UIButton) {
        self.showAlertWithTitleFromVC( title: "Logout", message: "Are you sure want to Logout?", buttons: ["Cancel", "Logout"]) { index in
            if index == 1 {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                AppDel.navigateToLogin()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
//MARK: - API call
extension SettingsVC {
    func callNotiChangeApi(){
        self.notiChangeViewModel.settingsVC = self
        
        let reqModel = NotificationStatusReqModel()
        reqModel.notification = (Singleton.sharedInstance.userProfilData?.notification == "1") ? "0" : "1"
        self.notiChangeViewModel.webserviceNotiStatusChangeAPI(reqModel: reqModel)
    }
}
