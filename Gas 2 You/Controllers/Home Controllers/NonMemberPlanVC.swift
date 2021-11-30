//
//  NonMemberPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 17/08/21.
//

import UIKit

class NonMemberPlanVC: BaseVC {
    
    @IBOutlet weak var planIV: UIImageView!
    @IBOutlet weak var btnPayNow: ThemeButton!
    @IBOutlet weak var tblNonMemberPlan: UITableView!
    var nonmemberplanlist = [nonMemberPlanDatum]()
    var nonmemberViewModel = nonMemberPlanViewMOdel()
    override func viewDidLoad() {
        super.viewDidLoad()
        nonmemberViewModel.nonmemberplanvc = self
        nonmemberViewModel.webserviceofNonMemberList()
        tblNonMemberPlan.delegate = self
        tblNonMemberPlan.dataSource = self
        tblNonMemberPlan.tableFooterView = UIView()
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Select Plan", isTitlewhite: false, controller: self)
    }
    
    @IBAction func btnPayNowTap(_ sender: ThemeButton) {
//        let memberPlanVC: MemberPlanVC = MemberPlanVC.instantiate(fromAppStoryboard: .Main)
//        navigationController?.pushViewController(memberPlanVC, animated: true)
    }
}
extension NonMemberPlanVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonmemberplanlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:nonMemberPlanListCell = tblNonMemberPlan.dequeueReusableCell(withIdentifier: nonMemberPlanListCell.className) as! nonMemberPlanListCell
        cell.lblId.text = (nonmemberplanlist[indexPath.row].id ?? "") + "."
        cell.lblTitle.text = (nonmemberplanlist[indexPath.row].title ?? "") + arrow
        cell.lblPrice.text = CurrencySymbol + (nonmemberplanlist[indexPath.row].price ?? "")
        cell.imgCheck.image = (nonmemberplanlist[indexPath.row].isChecked == true) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nonmemberplanlist[indexPath.row].isChecked = (nonmemberplanlist[indexPath.row].isChecked == true) ? false : true
        tblNonMemberPlan.reloadData()
    }
}
