//
//  AddVehicleViewModel.swift
//  Gas 2 You
//
//  Created by Tej P on 11/01/22.
//

import Foundation

class AddVehicleViewModel{
    
    weak var addNewVehicleVC : AddNewVehicleVC? = nil
    
    func webserviceGetColorListAPI(){
        self.addNewVehicleVC?.btnSave.showLoading()
        WebServiceSubClass.vehicleColorList(completion: { (status, apiMessage, response, error) in
            self.addNewVehicleVC?.btnSave.hideLoading()
            if status{
                self.addNewVehicleVC?.arrYearList = response?.yearList ?? []
                self.addNewVehicleVC?.arrStateList = response?.stateList ?? []
                self.addNewVehicleVC?.arrColorList = response?.data ?? []
                self.addNewVehicleVC?.enableData()
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state:.failure)
            }
        })
    }
    
    func webserviceGetMakeAndModelList(){
        self.addNewVehicleVC?.btnSave.showLoading()
        WebServiceSubClass.makeandmodelList(completion: { (status, apiMessage, response, error) in
            self.addNewVehicleVC?.btnSave.hideLoading()
            if status{
                self.addNewVehicleVC?.arrMakeList = response?.data ?? []
                self.addNewVehicleVC?.enableData()
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state:.failure)
            }
        })
    }
    
    func webserviceAddVehicle(_ reqModel: AddNewVehicleReqModel){
        self.addNewVehicleVC?.btnSave.showLoading()
        WebServiceSubClass.AddVehicleApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.addNewVehicleVC?.btnSave.hideLoading()
            if status{
                Toast.show(title: UrlConstant.Success, message: apiMessage, state: .success)
                self.addNewVehicleVC?.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .refreshVehicleScreen, object: nil)
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state:.failure)
            }
        }
    }
    
    func webserviceEditVehicle(_ reqModel: EditNewVehicleReqModel){
        self.addNewVehicleVC?.btnSave.showLoading()
        WebServiceSubClass.EditVehicleApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.addNewVehicleVC?.btnSave.hideLoading()
            if status{
                Toast.show(title: UrlConstant.Success, message: apiMessage, state: .success)
                self.addNewVehicleVC?.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .refreshVehicleScreen, object: nil)
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state:.failure)
            }
        }
    }
    
}

