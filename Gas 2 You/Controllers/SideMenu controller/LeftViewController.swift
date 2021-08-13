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
    
    var indexPathCustom = IndexPath(row: 0, section: 1)
    
    //MARK:- Properties
    ///0 for menu name 1 for icon name
    private let titlesArray : [(String,String)] = [("Home","IC_home"),
                                                   ("My Orders","IC_gasCan"),
                                                   ("My Profile","IC_user"),
                                                   ("Membership","IC_membership"),
                                                   ("Settings","IC_settings"),
                                                   ("Notifications","IC_bell")]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MenuTblView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    //MARK: -  Observer method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        MenuTblView.layer.removeAllAnimations()
        ConstantMenuTblViewHeight.constant = MenuTblView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
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
            let vc : SelectPlanVC = SelectPlanVC.instantiate(fromAppStoryboard: .Main)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 4 :
            let vc : SettingsVC = SettingsVC.instantiate(fromAppStoryboard: .Main)
            (menuContainerViewController.contentViewControllers[0] as? NavigationController)?.pushViewController(vc, animated: false)
            
            menuContainerViewController.hideSideMenu()
        case 5:
            let vc : NotificationListVC = NotificationListVC.instantiate(fromAppStoryboard: .Main)
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
    @IBOutlet weak var LblMenuItem : themeLabel!
    @IBOutlet weak var ImageViewMenuIcon : UIImageView!
}
