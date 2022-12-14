//
//  LeftViewController.swift
//  Gas 2 You
//
//  Created by MacMini on 13/08/21.
//

import UIKit
import MediaPlayer

//import InteractiveSideMenu

class LeftViewController: MenuViewController {
    
    
    @IBOutlet weak var MenuTblView : UITableView!
    @IBOutlet weak var ConstantMenuTblViewHeight : NSLayoutConstraint!
    @IBOutlet weak var lblUserName: ThemeLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblVersion: ThemeLabel!
    
    var indexPathCustom = IndexPath(row: 0, section: 1)
    var logoutUserModel = LogoutUserModel()
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    //MARK:- Properties
    ///0 for menu name 1 for icon name
    private let titlesArray : [(String,String)] = [("Home","IC_home"),
                                                   ("My Orders","IC_gas"),
                                                   ("My Profile","IC_user"),
                                                   ("Membership","IC_membership"),
                                                   ("Payment Method","IC_membership"),
                                                   ("Settings","IC_settings"),
                                                   ("Notifications","IC_bell")]
//                                                   ("PromoCode","IC_gas"),
//                                                   ("GiftCard","icon_TitleGiftCard")
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let Version = "Version : \(Bundle.main.releaseVersionNumber ?? "")(\(Bundle.main.buildVersionNumber ?? ""))"
        lblVersion.text = Version
        self.MenuTblView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareView()
    }
    
    //MARK: -  Observer method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        MenuTblView.layer.removeAllAnimations()
        ConstantMenuTblViewHeight.constant = MenuTblView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }

    
    func DoLogoutFinal(){
        AppDel.dologout()
    }
    func callLogoutAPI(){
        self.logoutUserModel.menuViewController = self
        self.logoutUserModel.webserviceForLogout()
    }
    func prepareView(){
        let obj = Singleton.sharedInstance.userProfilData
        lblUserName.text = ( obj?.firstName ?? "") + " " + (obj?.lastName ?? "")
    }
    @IBAction func btnMyprofileClick(_ sender: Any) {
        let vc : MyProfileVC = MyProfileVC.instantiate(fromAppStoryboard: .Main)
        (menuContainerViewController?.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
        
        menuContainerViewController?.hideSideMenu()
    }
    @IBAction func btnLogoutTap(_ sender: UIButton) {

        Utilities.showAlertWithTitleFromVC(vc: self, title: UrlConstant.Logout, message: UrlConstant.LogoutMessage, buttons: [UrlConstant.Ok,UrlConstant.Cancel], isOkRed: false) { (ind) in
//            menuContainerViewController.hideSideMenu()
            if ind == 0{
                self.callLogoutAPI()
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
}
extension LeftViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTblView.dequeueReusableCell(withIdentifier: "LeftViewMenuItemCell", for: indexPath) as! LeftViewMenuItemCell
        cell.LblMenuItem.text = titlesArray[indexPath.row].0
        cell.ImageViewMenuIcon.image = UIImage(named: titlesArray[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        switch indexPath.row {
        case 0 :
            menuContainerViewController.hideSideMenu()
        case 1 :
            let vc : MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 2 :
            let vc : MyProfileVC = MyProfileVC.instantiate(fromAppStoryboard: .Main)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 3 :
//            if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
                let vc : MemberPlanVC = MemberPlanVC.instantiate(fromAppStoryboard: .Main)
                (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
                menuContainerViewController.hideSideMenu()
//            }else{
//                let vc : NonMemberPlanVC = NonMemberPlanVC.instantiate(fromAppStoryboard: .Main)
//                (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
//                menuContainerViewController.hideSideMenu()
//            }
        case 4:
            let vc : PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            vc.isfromPayment = true
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            menuContainerViewController.hideSideMenu()
        case 5 :
            let vc : SettingsVC = SettingsVC.instantiate(fromAppStoryboard: .Main)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 6:
            let vc : NotificationListVC = NotificationListVC.instantiate(fromAppStoryboard: .Main)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 7:
            let vc : MyGiftCardListVC = MyGiftCardListVC.instantiate(fromAppStoryboard: .PromoCode)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 8:
            let vc : GiftCardVC = GiftCardVC.instantiate(fromAppStoryboard: .PromoCode)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        default:
            menuContainerViewController.hideSideMenu()
        }
    }
    
    
    
}

extension LeftViewController : MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Get the system music player.
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        musicPlayer.setQueue(with: mediaItemCollection)
        mediaPicker.dismiss(animated: true)
        // Begin playback.
        musicPlayer.play()
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
}
class LeftViewMenuItemCell : UITableViewCell {
    @IBOutlet weak var LblMenuItem : ThemeLabel!
    @IBOutlet weak var ImageViewMenuIcon : UIImageView!
}
