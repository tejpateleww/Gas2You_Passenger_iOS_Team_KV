//
//  cancelMembershipConfirmViewModel.swift
//  Gas 2 You
//
//  Created by Tej P on 11/02/22.
//

import Foundation

class cancelMembershipConfirmViewModel {
    weak var myProfileVC : MyProfileVC?
    func webserviceofRemovevehical(reqModel : cancelMembershipConfirmReqModel){
        Utilities.showHud()
        WebServiceSubClass.ConfirmCancemMemberShip(reqModel: reqModel, completion: { (status, apiMessage, response, error)  in
            Utilities.hideHud()
            if status{
                if(response?.isOpenModal ?? false){
                    self.myProfileVC?.CancelMembershipStatus(strMsg: response?.message ?? "")
                }else{
                    self.myProfileVC?.CancelMembership()
                }
            }
            else{
                Utilities.ShowAlert(OfMessage: apiMessage)
                print(error)
            }
        })
    }
}
