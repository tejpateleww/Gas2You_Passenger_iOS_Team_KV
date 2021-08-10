//
//  NotificationListVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class NotificationListVC: BaseVC {

    @IBOutlet weak var notificationTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Notifications", controller: self)
    }
}


extension NotificationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTV.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
}
