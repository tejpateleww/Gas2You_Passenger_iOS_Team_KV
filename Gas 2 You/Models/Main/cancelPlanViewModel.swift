//
//  cancelPlanViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 22/11/21.
//

import Foundation
class cancelPlanViewModel{
    weak var cancelplanvc : MyProfileVC?
    func webservicecancelPlan(){
        let memberPlan = cancelMemberPlanReqModel()
        memberPlan.customer_id = Singleton.sharedInstance.userId
        WebServiceSubClass.CancelMemberPlan(reqModel: memberPlan, completion: { (status, apiMessage, response, error) in
            if status{
                userDefault.removeObject(forKey: UserDefaultsKey.MemberPlan.rawValue)
                Singleton.sharedInstance.userProfilData?.is_membership_user = false
                self.cancelplanvc?.vwMember.isHidden = true
                self.cancelplanvc?.vwNonmember.isHidden = false
                userDefault.setUserData()
                NotificationCenter.default.post(name: notifRefreshHomeScreen, object: nil)
            }
    })
    }
}

