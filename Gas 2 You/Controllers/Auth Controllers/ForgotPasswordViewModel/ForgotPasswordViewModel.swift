//
//  ForgotPasswordViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation
import UIKit

class ForgotPasswordViewModel {
    weak var forgotPasswordVC : ForgotPasswordVC? = nil
    
    func webserviceForgotPassword(reqModel:ForgotPasswordReqModel){
        Utilities.showHud()
        self.forgotPasswordVC?.btnSubmit.showLoading()
        WebServiceSubClass.ForgotPasswordApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            self.forgotPasswordVC?.btnSubmit.hideLoading()
            if status{
                Utilities.ShowAlertOfSuccess(OfMessage: "Reset password link sent to your email address")
                //self.emit(.showToast(title: UrlConstant.Success, message: "Reset password link sent to your email address", state: .success))
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
                //self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
            }
        })
    }
}
