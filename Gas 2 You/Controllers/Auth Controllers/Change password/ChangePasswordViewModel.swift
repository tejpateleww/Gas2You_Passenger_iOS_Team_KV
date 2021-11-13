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
        self.changePasswordVC?.btnSave.showLoading()
        self.changePasswordVC?.isApiCalling = true
        WebServiceSubClass.ChangePasswordApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.changePasswordVC?.btnSave.hideLoading()
            self.changePasswordVC?.isApiCalling = false
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state:status ? .success : .failure){
                if status{
                    self.clearAllFields()
                    Utilities.showAlertAction(AppInfo.appName, message: apiMessage, vc: self.changePasswordVC!) {
                        self.changePasswordVC?.popBack()
                    }
                }
            }
        }
    }

    func clearAllFields(){
        changePasswordVC?.txtCurrentPassword.text = ""
        changePasswordVC?.txtNewPassword.text = ""
        changePasswordVC?.txtReEnterPassword.text = ""
        
    }
}
