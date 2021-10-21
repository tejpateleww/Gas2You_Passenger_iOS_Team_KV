//
//  ChangePasswordViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 07/09/21.
//

import Foundation

class ChangePasswordViewModel {


    weak var changePasswordVC : ChangePasswordVC? = nil
    func webserviceChangePassword(reqModel: ChangePasswordReqModel){
        Utilities.showHud()
        self.changePasswordVC?.isApiCalling = true
        WebServiceSubClass.ChangePasswordApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            self.changePasswordVC?.isApiCalling = false
            if status{
                self.clearAllFields()
                Utilities.showAlertAction(AppInfo.appName, message: apiMessage, vc: self.changePasswordVC!) {
                    self.changePasswordVC?.popBack()
                }
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
                //Toast.show(title:UrlConstant.Failed, message: apiMessage, state: .failure)
            }
    
        }
    }

    func clearAllFields(){
        changePasswordVC?.txtCurrentPassword.text = ""
        changePasswordVC?.txtNewPassword.text = ""
        changePasswordVC?.txtReEnterPassword.text = ""
        
    }
}
