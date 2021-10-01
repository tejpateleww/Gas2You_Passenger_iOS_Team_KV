//
//  BookingListViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 24/09/21.
//

import Foundation
class BookingListViewModel{
    var myordervc : MyOrdersVC?
    func doBookingList(customerid: String, status: String, page: String) {
        let reqModel = bookingListReqModel(customerid: customerid, status: status, page: page)
        webserviceBookingList(reqModel)
    }
    func webserviceBookingList(_ reqModel: bookingListReqModel){
//        Utilities.showHud()
        WebServiceSubClass.BookingList(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
//            Utilities.hideHud()
            if status{
                if let userData = response?.data{
                    self.myordervc?.arrBookingList = userData
                    DispatchQueue.main.async {
                        self.myordervc?.myOrdersTV.reloadData()
                        self.myordervc?.refreshControl.endRefreshing()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.myordervc?.isLoading = false
                    }
                }else{
                    Utilities.ShowAlert(OfMessage: apiMessage)
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
class CancelOrder{
    var cancelOrder : MyOrdersVC?
    func cancelOrder(customerid: String, order_id: String,row:Int) {
        let reqModel = CancelOrderReqModel(customer_id: customerid, order_id: order_id)
        webserviceCancelOrder(reqModel, row: row)
    }
    func webserviceCancelOrder(_ reqModel: CancelOrderReqModel,row:Int){
        Utilities.showHud()
        WebServiceSubClass.cancelOrder(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
            Utilities.hideHud()
            if status{
                let indexpath = IndexPath(row: row, section: 0)
                self.cancelOrder?.arrBookingList.remove(at: indexpath.row)
                self.cancelOrder?.myOrdersTV.deleteRows(at: [indexpath], with: .fade)
                self.cancelOrder?.myOrdersTV.reloadData()
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
        Utilities.showHud()
        WebServiceSubClass.BookingDetail(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
            Utilities.hideHud()
            if status{
                if let userData = response?.data{
                    self.BookingDetails?.objBookingDetail = userData
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
