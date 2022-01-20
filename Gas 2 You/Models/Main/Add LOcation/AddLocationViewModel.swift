//
//  AddLocationViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 03/12/21.
//

import Foundation
class AddLocationViewModel{
    var AddLocation : CarParkingLocationVC?
    func webserviceAddLocation(location:String,lat:Double,lng:Double){
        let addlocationData = AddLocationReqModel()
        addlocationData.customer_id = Singleton.sharedInstance.userId
        addlocationData.location = location
        addlocationData.latitude = String(lat)
        addlocationData.longitude = String(lng)
        Utilities.showHud()
        WebServiceSubClass.addLocation(reqModel: addlocationData, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            DispatchQueue.main.async {
                if status{
                    self.AddLocation?.addLocationModel.webserviceLocationList()
                }else{
                    Toast.show(title: UrlConstant.Error, message: apiMessage, state: .failure)
                }
            }
        })
    }
    func webserviceLocationList(){
        let locationList = LocationListReqModel()
        locationList.customer_id = Singleton.sharedInstance.userId
        WebServiceSubClass.LocationList(reqModel: locationList, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            DispatchQueue.main.async {
                if status{
                    if let model = response?.data{
                        self.AddLocation?.arrLocation = model
                        if model.count != 0{
                            self.AddLocation?.vwThemeview.isHidden = false
                        }else{
                            self.AddLocation?.vwThemeview.isHidden = true
                        }
                        self.AddLocation?.vwThemeview.isHidden = false
                        self.AddLocation?.tblLocationList.reloadData()
                    }
                }else{
                    Toast.show(title: UrlConstant.Error, message: apiMessage, state: .failure)
                }
            }
        })
    }
    
}
