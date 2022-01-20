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
                    let ValueofMakeVal = model
                    if ValueofMakeVal.count != 0 {
                        for i in 0...ValueofMakeVal.count - 1 {
                            if (ValueofMakeVal[i].models?.count ?? 0) != 0 {
                                for j in 0...((ValueofMakeVal[i].models?.count ?? 0) - 1 ){
                                    if ValueofMakeVal[i].models?[j].modelName?.lowercased() ==  self.addvehicle?.objData?.model?.lowercased() {
                                        self.addvehicle?.SelectedMakeIndex = i
                                    }
                                }
                            }
                            
                        }
                    }
                    
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
                if let model = response{
                    self.Vehiclecolor?.colorVal = model.data ?? []
                    self.Vehiclecolor?.yearVal = model.yearList ?? []
                    self.Vehiclecolor?.stateList = model.stateList ?? []
                }
//                else if let year = response?.yearList{
//                    self.Vehiclecolor?.yearVal = year
//                }else if let state = response?.stateList{
//                    self.Vehiclecolor?.stateList = state
//                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
    
}
class AddVehicleGetViewModel{
    weak var addvehicle : AddVehicleVC?
//    func doLogin(customerid: String, year: String, make: String, model: String, color: String,state :String, plateno: String,isothermodel:Bool,modelname:String,isothermake:Bool,makename:String) {
//        let reqModel = AddVehicleReqModel(customerid: customerid, year: year, make: make, model: model, color: color, state: state, plateno: plateno,isothermodel: isothermodel,modelname: modelname,isothermake: isothermake,makename: makename)
//        webserviceAddVehicle(reqModel)
//    }
//    func webserviceAddVehicle(_ reqModel: AddVehicleReqModel){
//        self.addvehicle?.btnSave.showLoading()
//        WebServiceSubClass.AddVehicleApi(reqModel: reqModel) { (status, apiMessage, response, error) in
//            self.addvehicle?.btnSave.hideLoading()
//            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state:status ? .success : .failure){
//                if status{
//                    self.addvehicle?.navigationController?.popViewController(animated: true)
//                    self.addvehicle?.delegateAdd.refreshVehicleScreen()
//                }
//            }
//        }
//    }
}
class EditVehicleGetViewModel{
    weak var addvehicle : AddVehicleVC?
//    func doLogin(vehicleId: String, year: String, make: String, model: String, color: String,state:String, plateno: String,isothermodel:Bool,modelname:String,isothermake:Bool,makename:String) {
//        let reqModel = EditVehicleReqModel(vehicle_id: vehicleId, year: year, make: make, model: model, color: color, state: state, plateno: plateno,isothermodel: isothermodel,modelname: modelname,isothermake: isothermake,makename: makename)
//        webserviceEditVehicle(reqModel)
//    }
//    func webserviceEditVehicle(_ reqModel: EditVehicleReqModel){
//        self.addvehicle?.btnSave.showLoading()
//        WebServiceSubClass.EditVehicleApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
//            self.addvehicle?.btnSave.hideLoading()
//            Toast.show(title:status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state:status ? .success : .failure){
//                if status{
//                    self.addvehicle?.setup()
//                    self.addvehicle?.navigationController?.popViewController(animated: true)
//                    self.addvehicle?.delegateEdit.refreshVehicleScreenEdit()
//                }
//            }
//        })
//    }
}
