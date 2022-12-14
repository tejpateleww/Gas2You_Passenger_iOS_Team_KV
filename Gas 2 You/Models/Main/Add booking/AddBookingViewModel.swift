//
//  AddBookingViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 24/09/21.
//

import Foundation
import UIKit

class AddBookingViewModel{
    var addbooking : HomeVC?
    func webserviceCheckTime(bookingDate:String,bookingTime:String,vehicleId:String){
        let checkTime = CheckTimeReqModel()
        checkTime.booking_date = bookingDate
        checkTime.booking_time = bookingTime
        checkTime.vehicle_id = vehicleId
        checkTime.longitude = (Singleton.sharedInstance.carParkingLocation.coordinate.longitude == 0.0) ? "\(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude )" :"\(Singleton.sharedInstance.carParkingLocation.coordinate.longitude )"
        checkTime.latitude = (Singleton.sharedInstance.carParkingLocation.coordinate.latitude == 0.0) ? "\(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude )" :"\(Singleton.sharedInstance.carParkingLocation.coordinate.latitude )"
        
        self.addbooking?.btnAddBooking.showLoading()
        WebServiceSubClass.checkTime(reqModel: checkTime, completion: { (status, apiMessage, response, error) in
            self.addbooking?.btnAddBooking.hideLoading()
            if status{
                let myOrdersVC: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
                let objdatamodel = GetData(serviceID: self.addbooking?.serviceid ?? "", subserviceId: self.addbooking?.subserviceid ?? "", parkingLocation: self.addbooking?.locationLabel.text ?? "", date: self.addbooking?.txtDateSelected.text ?? "", time: self.addbooking?.time ?? "", vehicleId: self.addbooking?.vehicalid ?? "", addonId: self.addbooking?.addonid.joined(separator: ",") ?? "", notes: self.addbooking?.txtViewNotes.text.trimmedString ?? "")
                myOrdersVC.getDataModel = objdatamodel
                self.addbooking?.navigationController?.pushViewController(myOrdersVC, animated: true)
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Toast.show(title:UrlConstant.Error, message: apiMessage, state: .failure)
                }
            }
        })
    }
}
