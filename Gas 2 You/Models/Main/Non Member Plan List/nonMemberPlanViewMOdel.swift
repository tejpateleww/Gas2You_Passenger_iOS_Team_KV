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
        WebServiceSubClass.nonMemberPlanList(completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.homevc?.nonmemberplanlist = model
                    if Singleton.sharedInstance.userProfilData?.is_membership_user == false{
                        self.homevc?.nonmemberplanlist[0].isSelected = true
                    }
                    self.homevc?.tblNonMemberPLan.reloadData()
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
    func webserviceofNonMemberList(){
        WebServiceSubClass.nonMemberPlanList(completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.nonmemberplanvc?.nonmemberplanlist = model
                    if Singleton.sharedInstance.userProfilData?.is_membership_user == false{
                        self.nonmemberplanvc?.nonmemberplanlist[0].isSelected = true
                    }
                    self.nonmemberplanvc?.tblNonMemberPlan.reloadData()
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
        })
    }
}
