//
//  PaymentMethodVC.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 25/11/21.
//

import UIKit
import SDWebImage

struct GetData{
    let serviceID, subserviceId, parkingLocation, date, time, vehicleId, addonId : String
}
struct memberData{
    let type, amount, Planid : String
}
class PaymentMethodVC: BaseVC, AddCardDelegate {
    
    var isLoading = true {
        didSet {
            tblPaymentMethod.isUserInteractionEnabled = !isLoading
            tblPaymentMethod.reloadData()
        }
    }
    var cardListModel = cardListViewModel()
    var arrCardList = [cardListDatum]()
    var getDataModel : GetData?
    var memberDataModel : memberData?
    var selectedIndex = NSNotFound
    var isfromMember : Bool = false
    var isfromPayment : Bool = false
    var isfromPlan : Bool = false
    let dateFormatter = DateFormatter()
    var isReload = false
    
    @IBOutlet weak var tblPaymentMethod: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMM dd, yyyy"
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Payment Method", isTitlewhite: false, controller: self)
        tblPaymentMethod.delegate = self
        tblPaymentMethod.dataSource = self
        tblPaymentMethod.reloadData()
        tblPaymentMethod.register(UINib(nibName:"NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        tblPaymentMethod.register(UINib(nibName:"cardShimmerCell", bundle: nil), forCellReuseIdentifier: "cardShimmerCell")
        cardListModel.cardList = self
        cardListModel.webserviceCardList()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnAddCardClick(_ sender: Any) {
        let vc:AddCardViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: AddCardViewController.className) as! AddCardViewController
        vc.delegateAddcard = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func refreshCardListScreen() {
        cardListModel.webserviceCardList()
    }
    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM dd, yyyy"

         return convertDateFormatter.string(from: oldDate!)
    }
}
extension PaymentMethodVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrCardList.count != 0{
            return arrCardList.count
        }else{
            return (isReload) ? 1 : 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isReload{
            let cell = tblPaymentMethod.dequeueReusableCell(withIdentifier: cardShimmerCell.className, for: indexPath) as! cardShimmerCell
            cell.lblDate.text = "Dummy Data"
            cell.lblExpirydate.text = "Dummy Data"
            cell.lblCardNumber.text = "Dummy Data"
            cell.btnPay.setTitle("Dummy Data", for: .normal)
            cell.imgCard.image = UIImage(named: "")
            return cell
        }else{
            if arrCardList.count != 0{
                let cell:PaymentMethodCell = tblPaymentMethod.dequeueReusableCell(withIdentifier: PaymentMethodCell.className) as! PaymentMethodCell
                let strUrl = "\(arrCardList[indexPath.row].cardImage ?? "")"
                cell.imgCard.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgCard.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.lblAccountNumber.text = arrCardList[indexPath.row].displayNumber
                cell.lblExpDate.text = arrCardList[indexPath.row].expiryDate
                if selectedIndex == indexPath.row{
                    cell.btnSelected.isHidden = false
                    cell.vwRadius.layer.cornerRadius = 15
                    cell.vwRadius.layer.borderWidth = 1
                    cell.vwRadius.layer.borderColor = UIColor.init(hexString: "#1C75BB").cgColor
                    if self.isfromPayment{
                        cell.btnSelected.isHidden = true
                    }
                    cell.payClick = {
                        if self.isfromMember{
                            self.cardListModel.webserviceMemberPlanPurchase(planID: self.memberDataModel?.Planid ?? "",cardId: self.arrCardList[indexPath.row].id ?? "")
                        }else if self.isfromPlan{
                            self.cardListModel.webserviceMemberPlanPurchase(planID: self.memberDataModel?.Planid ?? "",cardId: self.arrCardList[indexPath.row].id ?? "")
                        }
                        else{
                            let slideToConfirmVC: SlideToConfirmVC = SlideToConfirmVC.instantiate(fromAppStoryboard: .Main)
                            slideToConfirmVC.completion = {
                                self.cardListModel.doAddBooking(customerid: Singleton.sharedInstance.userId,
                                                                serviceid: self.getDataModel?.serviceID ?? "",
                                                                subserviceid:self.getDataModel?.subserviceId ?? "" ,
                                                                parkinglocation: self.getDataModel?.parkingLocation ?? "",
                                                                lat: "\(Singleton.sharedInstance.carParkingLocation.coordinate.latitude )", //Singleton.sharedInstance.userCurrentLocation.coordinate.latitude
                                                                lng: "\(Singleton.sharedInstance.carParkingLocation.coordinate.longitude )", //Singleton.sharedInstance.userCurrentLocation.coordinate.longitude
                                                                date: self.getDataModel?.date ?? "",
                                                                time: self.getDataModel?.time ?? "",
                                                                vehicleid: self.getDataModel?.vehicleId ?? "", totalAmount: "0",
                                                                addonid: self.getDataModel?.addonId ?? "",
                                                                card_id: self.arrCardList[indexPath.row].id ?? "")
                                self.dismiss(animated: false, completion: nil)
                            }
                            slideToConfirmVC.modalPresentationStyle = .overFullScreen
                            self.present(slideToConfirmVC, animated: false, completion: nil)
                        }
                    }
                } else {
                    cell.vwRadius.layer.borderWidth = 0
                    cell.btnSelected.isHidden = true
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let noDataCell:NoDataCell = tblPaymentMethod.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
                noDataCell.imgNodata.image = UIImage(named: "ic_card")
                noDataCell.lblData.text = "No Card found"
                if UIDevice.current.userInterfaceIdiom == .phone{
                    noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(16.0)
                }else{
                    noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(21.0)
                }
                noDataCell.selectionStyle = .none
                return noDataCell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblPaymentMethod.reloadData()
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if arrCardList.count == 0 {
            return .none
        }
        return .delete
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isReload{
            return 100
        }else{
            if arrCardList.count != 0{
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .white)
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.isLoading = false
//        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if arrCardList.count != 0{
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
                self.cardListModel.webserviceDeleteCard(cardId: self.arrCardList[indexPath.row].id ?? "")
                completion(true)
            }
            deleteAction.image = #imageLiteral(resourceName: "IC_bin")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }else{
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
}
