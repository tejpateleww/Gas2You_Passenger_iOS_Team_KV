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
    var selectedIndex = -1
    var plan_Id = ""
    var type = ""
    var planType = ""
    var amount = ""
    var isFromMyprofile : Bool = false
    @IBOutlet weak var currentPlanIV: UIImageView!
    @IBOutlet weak var tblMembershipPlan: UITableView!
    @IBOutlet weak var btnPayNow: ThemeButton!
    @IBOutlet weak var lblPlanNotAvailable: ThemeLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        lblPlanNotAvailable.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberPlanModel.memberplanvc = self
        memberPlanModel.webserviceofMemberPlanList()
        tblMembershipPlan.delegate = self
        tblMembershipPlan.dataSource = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Select Plan", controller: self)
        self.btnPayNow.isHidden = true
    }
    
    @IBAction func btnPayNowTap(_ sender: ThemeButton) {
            if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
                if self.planType == "Yearly"{
                    let alert = UIAlertController(title: AppInfo.appName, message: "You already have a \(Singleton.sharedInstance.userProfilData?.type ?? "") membership plan. are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: { Date in
                        let vc: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
                        vc.isfromPlan = true
                        let objdatamodel = memberData(type: self.planType, amount: self.amount, Planid: self.plan_Id)
                        vc.memberDataModel = objdatamodel
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: AppInfo.appName, message: "you already have a \(Singleton.sharedInstance.userProfilData?.type ?? "") membership plan. are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: { Date in
                        let vc: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
                        vc.isfromPlan = true
                        let objdatamodel = memberData(type: self.planType, amount: self.amount, Planid: self.plan_Id)
                        vc.memberDataModel = objdatamodel
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                if self.plan_Id != ""{
                    let vc: PaymentMethodVC = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
                    let objdatamodel = memberData(type: type, amount: amount, Planid: plan_Id)
                    vc.isfromPlan = true
                    vc.memberDataModel = objdatamodel
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    Toast.show(title: UrlConstant.Required, message: "Please select plan", state: .info)
                }
            }
        }
//    }
}
extension MemberPlanVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberPlanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:membershipPlanCell = tblMembershipPlan.dequeueReusableCell(withIdentifier: membershipPlanCell.className) as! membershipPlanCell
        cell.lblDetails.text = (memberPlanList[indexPath.row].planName ?? "") + arrow
        cell.lblPrice.text = CurrencySymbol + (memberPlanList[indexPath.row].price ?? "")
        cell.lblDescription.text = memberPlanList[indexPath.row].descriptionField ?? ""
        cell.memberPlanDescriptionView.layer.cornerRadius = 5
        cell.memberPlanDescriptionView.layer.borderWidth = 1
        
        if(memberPlanList[indexPath.row].isPurchased ?? false){
            self.planType = memberPlanList[indexPath.row].type ?? ""
        }
        
        if memberPlanList[indexPath.row].planName == "Monthly Plan"{
            cell.lblDescription.fontColor = UIColor.init(hexString: "#1C75BB")
            cell.memberPlanDescriptionView.layer.borderColor = UIColor.init(hexString: "#1C75BB").cgColor
        }else{
            cell.lblDescription.fontColor = UIColor.init(hexString: "#1C75BB")
            cell.memberPlanDescriptionView.layer.borderColor = UIColor.init(hexString: "#1C75BB").cgColor
        }
        if isFromMyprofile{
            cell.icCheck.image = (selectedIndex == indexPath.row) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
            self.plan_Id = memberPlanList[selectedIndex].id ?? ""
            self.amount = memberPlanList[selectedIndex].price ?? ""
            self.type = memberPlanList[selectedIndex].type ?? ""
        }else{
            cell.icCheck.image = memberPlanList[indexPath.row].isPurchased == true ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.btnPayNow.isHidden = false
        if isFromMyprofile{
            selectedIndex = indexPath.row
            self.plan_Id = memberPlanList[selectedIndex].id ?? ""
            self.amount = memberPlanList[selectedIndex].price ?? ""
            self.type = memberPlanList[selectedIndex].type ?? ""
            tblMembershipPlan.reloadData()
        }else{
            let _ = memberPlanList.map({$0.isPurchased = false})
            memberPlanList[indexPath.row].isPurchased = true
            self.plan_Id = memberPlanList[indexPath.row].id ?? ""
            self.amount = memberPlanList[indexPath.row].price ?? ""
            self.type = memberPlanList[indexPath.row].type ?? ""
            tblMembershipPlan.reloadData()
        }
    }
}
