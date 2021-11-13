//
//  memberPlanViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 28/09/21.
//

import Foundation
class memberPlanViewModel{
weak var memberplanvc : MemberPlanVC?
func webserviceofMemberPlanList(){
    let memberModel = memberListReqModel()
    memberModel.customer_id = Singleton.sharedInstance.userId
    WebServiceSubClass.MemberPlanList(reqModel: memberModel , completion: { (status, message, response, error) in
        if status{
            if let model = response?.data{
                self.memberplanvc?.memberPlanList = model
                self.memberplanvc?.tblMembershipPlan.reloadData()
            }
        }else{
            Utilities.ShowAlert(OfMessage: "No Data Found")
            print(error)
        }
    })
}
}
