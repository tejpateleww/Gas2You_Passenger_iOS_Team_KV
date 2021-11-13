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
        self.forgotPasswordVC?.btnSubmit.showLoading()
        WebServiceSubClass.ForgotPasswordApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            self.forgotPasswordVC?.btnSubmit.hideLoading()
            Toast.show(title: status ? UrlConstant.Success :  UrlConstant.Failed, message: status ?  "Reset password link sent to your email address" : apiMessage, state: status ? .success :  .failure){
                if status{
                    
                }
            }
        })
    }
}
