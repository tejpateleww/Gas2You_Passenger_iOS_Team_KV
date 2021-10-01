//
//  MyGarageVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class MyGarageVC: BaseVC,AddVehicleDelegate,editVehicleDelegate {
    
    
    var getvehicalList =  VehicalListViewModel()
    var removeVehicle = RemoveVehicleViewModel()
    @IBOutlet weak var vehicleListTV: UITableView!
    var arrVehicalList = [VehicleListDatum]()
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicleListTV.delegate = self
        vehicleListTV.dataSource = self
        self.getvehicalList.webserviceofgetvehicalList()
        self.getvehicalList.mygaragevc = self
        self.removeVehicle.mygaragevc = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Garage", controller: self)
    }
    
    @IBAction func btnAddVehicleTap(_ sender: ThemeButton) {
        let addVehicleVC = storyboard?.instantiateViewController(identifier: AddVehicleVC.className) as! AddVehicleVC
        addVehicleVC.delegateAdd = self
        navigationController?.pushViewController(addVehicleVC, animated: true)
    }
    func refreshVehicleScreenEdit() {
        getvehicalList.webserviceofgetvehicalList()
    }
    func refreshVehicleScreen() {
        getvehicalList.webserviceofgetvehicalList()
    }
}

extension MyGarageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVehicalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = vehicleListTV.dequeueReusableCell(withIdentifier: VehicleListCell.className, for: indexPath) as! VehicleListCell
        cell.lblCarName.text = arrVehicalList[indexPath.row].make ?? ""
        cell.lblModel.text = arrVehicalList[indexPath.row].model ?? ""
        cell.lblYear.text = arrVehicalList[indexPath.row].year ?? ""
        cell.lblColor.text = arrVehicalList[indexPath.row].color ?? ""
        cell.lblPlatNo.text = arrVehicalList[indexPath.row].plateNumber ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            self.removeVehicle.webserviceofRemovevehical(vehicleId: self.arrVehicalList[indexPath.row].id ?? "", row: indexPath.row)
            // Perform your action here
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            let addVehicleVC = self.storyboard?.instantiateViewController(identifier: AddVehicleVC.className) as! AddVehicleVC
            addVehicleVC.isfromEdit = true
            addVehicleVC.delegateEdit = self
            addVehicleVC.objData = self.arrVehicalList[indexPath.row]
            self.navigationController?.pushViewController(addVehicleVC, animated: true)
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
