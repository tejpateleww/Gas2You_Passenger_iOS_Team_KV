//
//  SelectPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit
protocol memberdelegate {
    func myprofilerefresh()
}
class MemberPlanVC: BaseVC {

    var delegateMember : memberdelegate?
    var memberPlanList = [memberPlanListDatum]()
    var memberPlanModel = memberPlanViewModel()
    var selectedIndex = 0
    @IBOutlet weak var currentPlanIV: UIImageView!
    @IBOutlet weak var memberPlanDescriptionView: UIView!
    @IBOutlet var membershipPlanButtons: [ThemeButton]!
    @IBOutlet weak var tblMembershipPlan: UITableView!
    @IBOutlet weak var btnPayNow: ThemeButton!
    
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
        self.navigationController?.popViewController(animated: true)
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
        cell.icCheck.image = selectedIndex == indexPath.row ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
        cell.selectionStyle = .none
        //(memberPlanList[indexPath.row].isSelected == true)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        //memberPlanList[indexPath.row].isSelected = (memberPlanList[indexPath.row].isSelected == true) ? false : true
        tblMembershipPlan.reloadData()
    }
}


