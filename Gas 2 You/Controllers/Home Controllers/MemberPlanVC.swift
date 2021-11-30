//
//  SelectPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit
class MemberPlanVC: BaseVC {

    var memberPlanList = [memberPlanListDatum]()
    var memberPlanModel = memberPlanViewModel()
    var selectedIndex = 0
    var plan_Id = ""
    var type = ""
    var amount = ""
    var isFromMyprofile : Bool = false
    @IBOutlet weak var currentPlanIV: UIImageView!
    @IBOutlet weak var memberPlanDescriptionView: UIView!
    @IBOutlet var membershipPlanButtons: [ThemeButton]!
    @IBOutlet weak var tblMembershipPlan: UITableView!
    @IBOutlet weak var btnPayNow: ThemeButton!
    @IBOutlet weak var lblDescription: ThemeLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberPlanModel.memberplanvc = self
        memberPlanModel.webserviceofMemberPlanList()
        tblMembershipPlan.delegate = self
        tblMembershipPlan.dataSource = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Select Plan", controller: self)
        
        setUI()
    }
    
    @IBAction func membershipPlans(_ sender: ThemeButton) {
            
            for i in 0..<membershipPlanButtons.count {
                if sender.tag == i {
                    membershipPlanButtons[i].setImage(#imageLiteral(resourceName: "IC_selected"), for: .normal)
                } else {
                    membershipPlanButtons[i].setImage(#imageLiteral(resourceName: "IC_boxUnselected"), for: .normal)
                }
            }
    }
    
    
    @IBAction func btnPayNowTap(_ sender: ThemeButton) {
        if isFromMyprofile{
            let vc: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            let objdatamodel = memberData(type: type, amount: amount, Planid: plan_Id)
            vc.isfromMember = true
            vc.memberDataModel = objdatamodel
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
                let alert = UIAlertController(title: AppInfo.appName, message: "You are already a member of Gas 2 you, Are you sure you want to change membership ?", preferredStyle: UIAlertController.Style.alert)

                        // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: { Date in
                    let vc: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
                    vc.isfromPlan = true
                    let objdatamodel = memberData(type: self.type, amount: self.amount, Planid: self.plan_Id)
                    vc.memberDataModel = objdatamodel
                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    func setUI() {
        
        memberPlanDescriptionView.layer.cornerRadius = 5
        memberPlanDescriptionView.layer.borderWidth = 1
        memberPlanDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    

}
extension MemberPlanVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberPlanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:membershipPlanCell = tblMembershipPlan.dequeueReusableCell(withIdentifier: membershipPlanCell.className) as! membershipPlanCell
        cell.lblDetails.text = memberPlanList[indexPath.row].planName ?? "" + arrow
        cell.lblPrice.text = CurrencySymbol + (memberPlanList[indexPath.row].price ?? "")
        self.lblDescription.text = memberPlanList[indexPath.row].descriptionField ?? ""
        if isFromMyprofile{
            cell.icCheck.image = (selectedIndex == indexPath.row) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
        }else{
            cell.icCheck.image = memberPlanList[indexPath.row].isPurchased == true ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromMyprofile{
            selectedIndex = indexPath.row
            self.plan_Id = memberPlanList[selectedIndex].id ?? ""
            self.amount = memberPlanList[selectedIndex].price ?? ""
            self.type = memberPlanList[selectedIndex].type ?? ""
            self.lblDescription.text = memberPlanList[selectedIndex].descriptionField ?? ""
            tblMembershipPlan.reloadData()
        }else{
            let _ = memberPlanList.map({$0.isPurchased = false})
            memberPlanList[indexPath.row].isPurchased = true
            self.plan_Id = memberPlanList[indexPath.row].id ?? ""
            self.amount = memberPlanList[indexPath.row].price ?? ""
            self.type = memberPlanList[indexPath.row].type ?? ""
            self.lblDescription.text = memberPlanList[indexPath.row].descriptionField ?? ""
            tblMembershipPlan.reloadData()
        }
    }
}


