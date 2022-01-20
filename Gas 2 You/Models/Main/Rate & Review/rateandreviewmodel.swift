//
//  rateandreviewmodel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 28/09/21.
//

import Foundation
class rateandreviewmodel {
    var reviewmodel:RatingPopUpVC?
    func doAddBooking(order_id: String, rate: String, review: String) {
        let reqModel = rateReqModel(order_id: order_id, rate: rate, review: review)
        webserviceRateAndReview(reqModel)
    }
    func webserviceRateAndReview(_ reqModel: rateReqModel){
        self.reviewmodel?.btnSubmit.showLoading()
        WebServiceSubClass.rateandreview(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            self.reviewmodel?.btnSubmit.hideLoading()
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state: status ? .success : .failure){
                if status{
                    self.reviewmodel?.rateDelegate?.refreshCompleteJobScreen(rate: self.reviewmodel?.vwCosmos.rating ?? 0.0, review: self.reviewmodel?.txtReview.text ?? "")
                }
            }
        })
    }
}
