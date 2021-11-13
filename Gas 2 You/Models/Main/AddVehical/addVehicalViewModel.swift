//
//  addVehicalViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 20/09/21.
//

import Foundation
import UIKit

class addVehicalViewModel{
    weak var addvehicle : AddVehicleVC?
    
    func webserviceofmakeandmodel(){
        WebServiceSubClass.makeandmodelList(completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.addvehicle?.makeVal = model
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
}
class VehicleColorListViewModel{
    weak var Vehiclecolor : AddVehicleVC?
    func webserviceofcolorList(){
        WebServiceSubClass.vehicleColorList(completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.Vehiclecolor?.colorVal = model
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
    
}
class AddVehicleGetViewModel{
    weak var addvehicle : AddVehicleVC?
    func doLogin(customerid: String, year: String, make: String, model: String, color: String, plateno: String) {
        let reqModel = AddVehicleReqModel(customerid: customerid, year: year, make: make, model: model, color: color, plateno: plateno)
        webserviceAddVehicle(reqModel)
    }
    func webserviceAddVehicle(_ reqModel: AddVehicleReqModel){
        self.addvehicle?.btnSave.showLoading()
        WebServiceSubClass.AddVehicleApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.addvehicle?.btnSave.hideLoading()
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state:status ? .success : .failure){
                if status{
                    self.addvehicle?.navigationController?.popViewController(animated: true)
                    self.addvehicle?.delegateAdd.refreshVehicleScreen()
                }
            }
        }
    }
}
class EditVehicleGetViewModel{
    weak var addvehicle : AddVehicleVC?
    func doLogin(vehicleId: String, year: String, make: String, model: String, color: String, plateno: String) {
        let reqModel = EditVehicleReqModel(vehicle_id: vehicleId, year: year, make: make, model: model, color: color, plateno: plateno)
        webserviceEditVehicle(reqModel)
    }
    func webserviceEditVehicle(_ reqModel: EditVehicleReqModel){
        self.addvehicle?.btnSave.showLoading()
        WebServiceSubClass.EditVehicleApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            self.addvehicle?.btnSave.hideLoading()
            Toast.show(title:status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state:status ? .success : .failure){
                if status{
                    self.addvehicle?.setup()
                    self.addvehicle?.navigationController?.popViewController(animated: true)
                    self.addvehicle?.delegateEdit.refreshVehicleScreenEdit()
                }
            }
        })
    }
}
