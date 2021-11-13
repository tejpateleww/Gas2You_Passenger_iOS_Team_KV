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
    func doAddBooking(customerid: String, serviceid: String, subserviceid: String, parkinglocation: String, lat: String, lng: String, date: String, time: String, vehicleid: String, totalAmount: String, addonid: String) {
        let reqModel = AddBookingReqModel(customerid: customerid, serviceid: serviceid, subserviceid: subserviceid, parkinglocation: parkinglocation, lat: lat, lng: lng, date: date, time: time, vehicleid: vehicleid, totalAmount: totalAmount, addonid: addonid)
        webserviceAddBooking(reqModel)
    }
    func webserviceAddBooking(_ reqModel: AddBookingReqModel){
        self.addbooking?.btnAddBooking.showLoading()
        WebServiceSubClass.addBooking(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            self.addbooking?.btnAddBooking.hideLoading()
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state: status ? .success : .failure){
            if status{
                let myOrdersVC: MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
                self.addbooking?.navigationController?.pushViewController(myOrdersVC, animated: true)
            }
            }
        })
    }
}
