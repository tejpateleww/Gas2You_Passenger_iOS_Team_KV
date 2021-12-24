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
        self.addbooking?.btnAddBooking.showLoading()
        WebServiceSubClass.checkTime(reqModel: checkTime, completion: { (status, apiMessage, response, error) in
            self.addbooking?.btnAddBooking.hideLoading()
//            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: status ? apiMessage : apiMessage, state: status ? .success : .failure){
                if status{
                    let myOrdersVC: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
                    print(self.addbooking?.addonid.joined(separator: ",") ?? "")
                    let objdatamodel = GetData(serviceID: self.addbooking?.serviceid ?? "", subserviceId: self.addbooking?.subserviceid ?? "", parkingLocation: self.addbooking?.locationLabel.text ?? "", date: self.addbooking?.txtDateSelected.text ?? "", time: self.addbooking?.time ?? "", vehicleId: self.addbooking?.vehicalid ?? "", addonId: self.addbooking?.addonid.joined(separator: ",") ?? "")
                    myOrdersVC.getDataModel = objdatamodel
                    self.addbooking?.navigationController?.pushViewController(myOrdersVC, animated: true)
                }else{
                    Toast.show(title:UrlConstant.Failed, message: apiMessage, state: .failure)
                    self.addbooking?.ServiceListData.webserviceofDateList(booking_date: (self.addbooking?.dateFormatter.string(from: (self.addbooking?.todaysDate) as Date? ?? Date())) ?? "", isFromToday: true)
                }
        })
    }
}
