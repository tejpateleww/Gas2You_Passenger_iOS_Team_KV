//
//  MyGarageVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class MyGarageVC: BaseVC {
    
    @IBOutlet weak var vehicleListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Garage", controller: self)
    }
    
    @IBAction func btnAddVehicleTap(_ sender: ThemeButton) {
        let addVehicleVC = storyboard?.instantiateViewController(identifier: AddVehicleVC.className) as! AddVehicleVC
        navigationController?.pushViewController(addVehicleVC, animated: true)
    }
    
}

extension MyGarageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = vehicleListTV.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            // Perform your action here
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            // Perform your action here
            completion(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "IC_bin")
        editAction.image = #imageLiteral(resourceName: "IC_pencil")
        editAction.backgroundColor = UIColor.appColor(.themeBlue)
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
