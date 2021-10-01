//
//  MyProfileViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 21/09/21.
//

import Foundation
class MyProfileViewModel{
    var myprofilevc : MyProfileVC?
    struct EditProfileValues {
        let firstName, lastName, email, mobile : String
        let firstNamePlaceholder, lastNamePlaceholder,mobileNoPlaceholder: String
    }
    private func handleSingleValidaton(array: inout [String], values: (Bool,String)) {
        if !values.0 {
            array.append(values.1)
        }
    }
    func doLogin(customerid:String,firstname:String,lastname:String,mobileno:String) {
        let reqModel = UpdateProfileRequestModel(customer_id: customerid, first_name: firstname, last_name: lastname, mobile_no: mobileno)
            webserviceEditProfile(reqModel)
        }
    
    func webserviceEditProfile(_ reqModel: UpdateProfileRequestModel){
        Utilities.showHud()
        WebServiceSubClass.UpdateProfileInfo(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Toast.show(title: UrlConstant.Success, message: apiMessage, state: .success)
                Singleton.sharedInstance.userProfilData = response?.data
                Constants.userDefaults.setUserData()
                let _ = Constants.userDefaults.getUserData()
                self.myprofilevc?.setData()
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        })
    }
}
