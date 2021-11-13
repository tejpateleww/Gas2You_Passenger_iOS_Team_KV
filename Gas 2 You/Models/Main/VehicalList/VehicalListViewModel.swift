//
//  File.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 20/09/21.
//

import Foundation
import UIKit

class VehicalListViewModel{
    weak var mygaragevc : MyGarageVC?
    weak var homevc : HomeVC?
    func webserviceofgetvehicalList(){
        let vehicallistModel = vehicalListReqModel()
        vehicallistModel.customerid = Singleton.sharedInstance.userId
        WebServiceSubClass.vehicalList(reqModel: vehicallistModel) { (status, apiMessage, response, error)  in
            if status{
                // print(response)
                if let userdevice =  response?.data
                {
                    self.mygaragevc?.arrVehicalList =  userdevice
                    self.mygaragevc?.isLoading = false
                    self.mygaragevc?.isReload = true
                    self.mygaragevc?.vehicleListTV.reloadData()
                }
            }
            else
            {
                Utilities.ShowAlert(OfMessage: "Any Type device not found ")
                print(error)
            }
        }
    }
    func webserviceofgetvehicalListforHome(){
        let vehicallistModel = vehicalListReqModel()
        vehicallistModel.customerid = Singleton.sharedInstance.userId
        WebServiceSubClass.vehicalList(reqModel: vehicallistModel) { (status, apiMessage, response, error)  in
            if status{
                // print(response)
                if let userdevice =  response?.data
                {
                    self.homevc?.listOfVehicle = userdevice
                    self.homevc?.vehiclePicker.reloadAllComponents()
                    if userdevice.count != 0{
                        self.homevc?.txtSelectedVehicle.text = (userdevice[0].make ?? "") + "(" + (userdevice[0].plateNumber ?? "") + ")"
                        self.homevc?.vehicalid = userdevice[0].id ?? ""
                        self.homevc?.setup()
                    }else{
                        self.homevc?.txtSelectedVehicle.text = "Select Your Vehicle"
                    }
                }
            }
            else
            {
                Utilities.ShowAlert(OfMessage: "Any Type device not found ")
                print(error)
            }
        }
    }
}
class RemoveVehicleViewModel {
    weak var mygaragevc : MyGarageVC?
    func webserviceofRemovevehical(vehicleId:String,row:Int){
        let vehicallistModel = deleteVehicleReqModel()
        vehicallistModel.customerid = Singleton.sharedInstance.userId
        vehicallistModel.vehicleid = vehicleId
        WebServiceSubClass.DeleteVehicleApi(reqModel: vehicallistModel, completion: { (status, apiMessage, response, error)  in
            if status{
                NotificationCenter.default.post(name: notifRefreshVehicleList, object: nil)
//                let indexpath = IndexPath(row: row, section: 0)
//                self.mygaragevc?.arrVehicalList.remove(at: indexpath.row)
//                self.mygaragevc?.vehicleListTV.deleteRows(at: [indexpath], with: .fade)
//                self.mygaragevc?.vehicleListTV.reloadData()
                self.mygaragevc?.getvehicalList.webserviceofgetvehicalList()
            }
            else
            {
                Utilities.ShowAlert(OfMessage: apiMessage)
                print(error)
            }
        })
    }
}
