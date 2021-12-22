//
//  MyGarageVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class MyGarageVC: BaseVC,AddVehicleDelegate,editVehicleDelegate {
    var isLoading = true {
        didSet {
            vehicleListTV.isUserInteractionEnabled = !isLoading
            vehicleListTV.reloadData()
        }
    }
    
    var getvehicalList =  VehicalListViewModel()
    var removeVehicle = RemoveVehicleViewModel()
    var arrVehicalList = [VehicleListDatum]()
    var isReload = false
    
    @IBOutlet weak var vehicleListTV: UITableView!
    @IBOutlet weak var btnAddVehicle: ThemeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        vehicleListTV.delegate = self
        vehicleListTV.dataSource = self
        self.getvehicalList.webserviceofgetvehicalList()
        self.getvehicalList.mygaragevc = self
        self.removeVehicle.mygaragevc = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Garage", controller: self)
        vehicleListTV.register(UINib(nibName:"NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
    }
    
    @IBAction func btnAddVehicleTap(_ sender: ThemeButton) {
        
        if(Singleton.sharedInstance.userProfilData?.is_membership_user == false && self.arrVehicalList.count > 0){
            Toast.show(title: UrlConstant.Failed, message: "Please upgrade your plan to add multiple vehicle", state: .info)
        }else{
            if #available(iOS 13.0, *) {
                let addVehicleVC = storyboard?.instantiateViewController(identifier: AddVehicleVC.className) as! AddVehicleVC
                addVehicleVC.delegateAdd = self
                navigationController?.pushViewController(addVehicleVC, animated: true)
            }else {
                let addVehicleVC = storyboard?.instantiateViewController(withIdentifier: AddVehicleVC.className) as! AddVehicleVC
                addVehicleVC.delegateAdd = self
                navigationController?.pushViewController(addVehicleVC, animated: true)
            }
        }
    }
        
    func refreshVehicleScreenEdit() {
        getvehicalList.webserviceofgetvehicalList()
        NotificationCenter.default.post(name: notifRefreshVehicleList, object: nil)
    }
    func refreshVehicleScreen() {
        getvehicalList.webserviceofgetvehicalList()
        NotificationCenter.default.post(name: notifRefreshVehicleList, object: nil)
    }
}

extension MyGarageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrVehicalList.count != 0{
            return arrVehicalList.count
        }else{
            return (isReload) ? 1 : 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isReload{
            let cell = vehicleListTV.dequeueReusableCell(withIdentifier: VehicleListCell.className, for: indexPath) as! VehicleListCell
            cell.lblCarName.text = "Dummy Data"
            cell.lblModel.text = "Dummy Data"
            cell.lblYear.text = "Dummy Data"
            cell.lblColor.text = "Dummy Data"
            cell.lblPlatNo.text = "Dummy Data"
            return cell
        }else{
            if arrVehicalList.count != 0{
                let cell = vehicleListTV.dequeueReusableCell(withIdentifier: VehicleListCell.className, for: indexPath) as! VehicleListCell
                cell.lblCarName.text = arrVehicalList[indexPath.row].make ?? ""
                cell.lblModel.text = arrVehicalList[indexPath.row].model ?? ""
                cell.lblYear.text = arrVehicalList[indexPath.row].year ?? ""
                cell.lblColor.text = arrVehicalList[indexPath.row].color ?? ""
                cell.lblPlatNo.text = arrVehicalList[indexPath.row].plateNumber ?? ""
                cell.lblState.text = arrVehicalList[indexPath.row].state_name ?? ""
                return cell
            }else{
                let noDataCell:NoDataCell = vehicleListTV.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
                noDataCell.imgNodata.image = UIImage(named: "ic_car")
                noDataCell.lblData.text = "No vehicle found"
                if UIDevice.current.userInterfaceIdiom == .phone{
                    noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(16.0)
                }else{
                    noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(21.0)
                }
                noDataCell.selectionStyle = .none
                return noDataCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isReload{
            return UITableView.automaticDimension
        }else{
            if arrVehicalList.count != 0{
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }

    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if arrVehicalList.count == 0 {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .white)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if arrVehicalList.count != 0{
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            self.removeVehicle.webserviceofRemovevehical(vehicleId: self.arrVehicalList[indexPath.row].id ?? "", row: indexPath.row)
            //Perform your action here
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            if #available(iOS 13.0, *) {
                let addVehicleVC = self.storyboard?.instantiateViewController(identifier: AddVehicleVC.className) as! AddVehicleVC
                addVehicleVC.isfromEdit = true
                addVehicleVC.delegateEdit = self
                addVehicleVC.objData = self.arrVehicalList[indexPath.row]
                self.navigationController?.pushViewController(addVehicleVC, animated: true)
                // Perform your action here
                completion(true)
            } else {
                let addVehicleVC = self.storyboard?.instantiateViewController(withIdentifier: AddVehicleVC.className) as! AddVehicleVC
                addVehicleVC.isfromEdit = true
                addVehicleVC.delegateEdit = self
                addVehicleVC.objData = self.arrVehicalList[indexPath.row]
                self.navigationController?.pushViewController(addVehicleVC, animated: true)
                // Perform your action here
                completion(true)
            }
            
        }

        deleteAction.image = #imageLiteral(resourceName: "IC_bin")
        editAction.image = #imageLiteral(resourceName: "IC_pencil")
        editAction.backgroundColor = UIColor.appColor(.themeBlue)
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }else{
            return UISwipeActionsConfiguration(actions: [])
        }
    }
}
