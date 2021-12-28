//
//  nonMemberPlanViewMOdel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 22/09/21.
//

import Foundation

class nonMemberPlanViewMOdel{
    weak var homevc : HomeVC?
    weak var nonmemberplanvc : NonMemberPlanVC?
    func webserviceofNonMemberPlanList(){
        let nonmemberList = nonMemberPlanListReqModel()
        nonmemberList.customer_id = Singleton.sharedInstance.userId
        WebServiceSubClass.nonMemberPlanList(reqModel: nonmemberList, completion: { (status, message, response, error) in
            
            if(response?.data?.count ?? 0 > 0){
                self.homevc?.lblAddOns.isHidden = false
            }else{
                self.homevc?.lblAddOns.isHidden = true
            }
            
            if status{
                if let model = response?.data{
                    self.homevc?.nonmemberplanlist = model
                    self.homevc?.tblNonMemberPLan.reloadData()
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
    func webserviceofNonMemberList(){
        let nonmemberList = nonMemberPlanListReqModel()
        nonmemberList.customer_id = Singleton.sharedInstance.userId
        WebServiceSubClass.nonMemberPlanList(reqModel: nonmemberList, completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.nonmemberplanvc?.nonmemberplanlist = model
                    self.nonmemberplanvc?.tblNonMemberPlan.reloadData()
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
}
