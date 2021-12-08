//
//  BookingListViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 24/09/21.
//

import Foundation
import UIKit
class BookingListViewModel{
    var myordervc : MyOrdersVC?
    func doBookingList(customerid: String, status: String, page: String) {
        let reqModel = bookingListReqModel(customerid: customerid, status: status, page: page)
        webserviceBookingList(reqModel)
    }
    func webserviceBookingList(_ reqModel: bookingListReqModel){
        self.myordervc?.isApiProcessing = true
        if(self.myordervc?.currentPage != 1){
            self.myordervc?.pagingSpinner.startAnimating()
        }
        WebServiceSubClass.BookingList(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
            if(self.myordervc?.currentPage != 1){
                self.myordervc?.pagingSpinner.stopAnimating()
            }
            self.myordervc?.isLoading = false
            self.myordervc?.isApiProcessing = false
            self.myordervc?.isReload = true
            if status{
                if(response?.data?.count == 0){
                    if(self.myordervc?.currentPage == 1){
                        self.myordervc?.arrBookingList = response?.data ?? []
                        self.myordervc?.isStopPaging = true
                    }else{
                        print("End of Pagination...")
                        self.myordervc?.isStopPaging = true
                    }
                }else{
                    if(self.myordervc?.currentPage == 1){
                        self.myordervc?.arrBookingList = response?.data ?? []
                    }else{
                        self.myordervc?.arrBookingList.append(contentsOf: response?.data ?? [])
                    }
                }
                self.myordervc?.myOrdersTV.reloadData()
                DispatchQueue.main.async {
                    self.myordervc?.refreshControl.endRefreshing()
                }
            }else{
                Utilities.ShowAlert(OfMessage: apiMessage)
            }
        })
    }
}


class CancelOrder{
    var cancelOrder : MyOrdersVC?
    func cancelOrder(customerid: String, order_id: String,row:Int) {
        let reqModel = CancelOrderReqModel(customer_id: customerid, order_id: order_id)
        webserviceCancelOrder(reqModel, row: row)
    }
    func webserviceCancelOrder(_ reqModel: CancelOrderReqModel,row:Int){
        WebServiceSubClass.cancelOrder(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
            if status{
                self.cancelOrder?.btnCompletedTap(self.cancelOrder?.btnCompleted ?? ThemeButton())
                self.cancelOrder?.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "2", page: "\(self.cancelOrder?.currentPage ?? 0)")
            }
            else
            {
                Utilities.ShowAlert(OfMessage: apiMessage)
                print(error)
            }
        })
    }
}
class bookingDetailsViewModel{
    var BookingDetails : CompleteJobVC?
    func webservicebookingDetails(_ reqModel: bookingDetailReqModel){
        WebServiceSubClass.BookingDetail(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
            if status{
                if let userData = response?.data{
                    self.BookingDetails?.objBookingDetail = userData
                    self.BookingDetails?.arrService = userData.services
                    self.BookingDetails?.tblDetails.reloadData()
                    self.BookingDetails?.setData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.BookingDetails?.view.setTemplateWithSubviews(false)
                    }
                }
            }
            else
            {
                Utilities.ShowAlert(OfMessage: apiMessage)
                print(error)
            }
        })
    }
}
