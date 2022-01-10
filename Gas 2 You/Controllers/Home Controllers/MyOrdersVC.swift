//
//  MyOrdersVC.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit
import UIView_Shimmer

class MyOrdersVC: BaseVC {
    var isLoading = true {
        didSet {
            myOrdersTV.isUserInteractionEnabled = !isLoading
            myOrdersTV.reloadData()
        }
    }
    var isInProcess : Int = 0
    var arrBookingList = [BookingListDatum]()
    var BookingList = BookingListViewModel()
    var cancelOrderData = CancelOrder()
    let refreshControl = UIRefreshControl()
    var isReload = false
    var isApiProcessing = false
    var currentPage = 1
    var isStopPaging = false
    var pagingSpinner = UIActivityIndicatorView()
    var isFromPayment : Bool = false
    var isFromComplete : Bool = false
    var bookingid = ""
    
    @IBOutlet weak var myOrdersTV: UITableView!
    @IBOutlet weak var btnUpcoming: ThemeButton!
    @IBOutlet weak var vwUpcomingLine: UIView!
    @IBOutlet weak var btnInProgress: ThemeButton!
    @IBOutlet weak var vwInProgressLine: UIView!
    @IBOutlet weak var btnCompleted: ThemeButton!
    @IBOutlet weak var vwCompletedLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myOrdersTV.delegate = self
        myOrdersTV.dataSource = self
        BookingList.myordervc = self
        addTableFooter()
        if isFromPayment{
            btnInProgressTap(btnInProgress)
        }else if isFromComplete{
            btnCompletedTap(btnCompleted)
        }else{
            btnUpcomingTap(btnUpcoming)
        }
        NotificationCenter.default.post(name: notifRefreshHomeScreen, object: nil)
        myOrdersTV.register(UINib(nibName:"ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Orders", controller: self)
        
        let upcomingCellNib = UINib(nibName: UpcomingCell.className, bundle: nil)
        myOrdersTV.register(upcomingCellNib, forCellReuseIdentifier: UpcomingCell.className)
        let inprogressCellNib = UINib(nibName: InProgressCell.className, bundle: nil)
        myOrdersTV.register(inprogressCellNib, forCellReuseIdentifier: InProgressCell.className)
        let completedCellNib = UINib(nibName: CompletedCell.className, bundle: nil)
        myOrdersTV.register(completedCellNib, forCellReuseIdentifier: CompletedCell.className)
        myOrdersTV.register(UINib(nibName:"NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        
        myOrdersTV.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        isLoading = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNotificationObs()
    }
    
    override func BackButtonWithTitle(button: UIButton) {
        guard let navVC = self.navigationController,
              let profileVC = navVC.viewControllers.first(where: {$0.isKind(of: HomeVC.self)}) as? HomeVC else {
            return
        }
        profileVC.refreshhomescreen()
        profileVC.ServiceListData.webserviceofDateList(booking_date: profileVC.convertDateFormat(inputDate: Singleton.sharedInstance.appInitModel?.currentDate ?? ""), isFromToday: true)
        navVC.popToViewController(profileVC, animated: true)
        
    }
    
    //MARK: - Custom methods
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .refreshCompOrderScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCompOrderScreen), name: .refreshCompOrderScreen, object: nil)
    }
    
    @objc func refreshCompOrderScreen(){
        self.btnCompletedTap(btnCompleted)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        arrBookingList.removeAll()
        self.currentPage = 1
        self.isStopPaging = false
        self.isReload = false
        self.isLoading = true
        BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
    }
    func addTableFooter(){
        if #available(iOS 13.0, *) {
            self.pagingSpinner = UIActivityIndicatorView(style: .medium)
        } else {
            self.pagingSpinner = UIActivityIndicatorView(style: .gray)
        }
        self.pagingSpinner.stopAnimating()
        self.pagingSpinner.color = UIColor.init(hexString: "#1F79CD")
        self.pagingSpinner.hidesWhenStopped = true
        self.myOrdersTV.tableFooterView = self.pagingSpinner
        self.myOrdersTV.tableFooterView?.isHidden = true
    }
    @IBAction func btnUpcomingTap(_ sender: ThemeButton) {
        
        NavbarrightButton()
        
        vwUpcomingLine.backgroundColor = UIColor.init(hexString: "#1F79CD")
        vwInProgressLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        if UIDevice.current.userInterfaceIdiom == .phone{
            sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
            btnInProgress.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
            btnCompleted.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        }else{
            sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(19)
            btnInProgress.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(19)
            btnCompleted.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(19)
        }
        vwCompletedLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        self.currentPage = 1
        isStopPaging = false
        isInProcess = 0
        isLoading = true
        isReload = false
        cancelOrderData.cancelOrder = self
        if arrBookingList.filter({$0.status == "0"}).count == 0{
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }else{
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }
        myOrdersTV.reloadData()
    }
    
    @IBAction func btnInProgressTap(_ sender: ThemeButton) {
        NavbarrightButton()
        sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
        vwInProgressLine.backgroundColor = UIColor.init(hexString: "#1F79CD")
        vwUpcomingLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        if UIDevice.current.userInterfaceIdiom == .phone{
            sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
            btnUpcoming.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
            btnCompleted.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        }else{
            sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(19)
            btnUpcoming.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(19)
            btnCompleted.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(19)
        }
        vwCompletedLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        self.currentPage = 1
        isStopPaging = false
        isInProcess = 1
        isLoading = true
        isReload = false
        if arrBookingList.filter({$0.status == "1"}).count == 0{
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }else{
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }
        myOrdersTV.reloadData()
    }
    
    @IBAction func btnCompletedTap(_ sender: ThemeButton) {
        sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
        vwCompletedLine.backgroundColor = UIColor.init(hexString: "#1F79CD")
        vwInProgressLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        if UIDevice.current.userInterfaceIdiom == .phone{
            sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
            btnInProgress.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
            btnUpcoming.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        }else{
            sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(19)
            btnInProgress.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(19)
            btnUpcoming.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(19)
        }
        vwUpcomingLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        self.currentPage = 1
        isStopPaging = false
        isInProcess = 2
        isLoading = true
        isReload = false
        if arrBookingList.filter({$0.status == "2"}).count == 0{
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }else{
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }
        myOrdersTV.reloadData()
    }
}

extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrBookingList.count != 0{
            return arrBookingList.count
        }else{
            return (isReload) ? 1 : 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isInProcess == 0 {
            if !isReload{
                let shimmerCell:ShimmerCell = myOrdersTV.dequeueReusableCell(withIdentifier: ShimmerCell.className) as! ShimmerCell
                shimmerCell.lblVehicle.text = "dummy data"
                shimmerCell.lblAddress.text = "dummy data"
                shimmerCell.lblFuelType.text = "dummy data"
                shimmerCell.lblDateAndTime.text = "dummy data"
                return shimmerCell
            }else{
                if arrBookingList.count != 0{
                    let upcomingCell = myOrdersTV.dequeueReusableCell(withIdentifier: UpcomingCell.className) as! UpcomingCell
                    upcomingCell.lblService.text = arrBookingList[indexPath.row].mainServiceName
                    upcomingCell.lblLocation.text = arrBookingList[indexPath.row].parkingLocation
                    upcomingCell.lblDateandTime.text = (arrBookingList[indexPath.row].time ?? "") + ", " + (arrBookingList[indexPath.row].date ?? "")
//                    upcomingCell.lblVehicleDetail.text = (arrBookingList[indexPath.row].makeName ?? "") + " " + (arrBookingList[indexPath.row].plateNumber ?? "")
                    
                    let mainString = (arrBookingList[indexPath.row].makeName ?? "") + " " + (arrBookingList[indexPath.row].plateNumber ?? "")
                            let searchString = arrBookingList[indexPath.row].plateNumber ?? ""
                            let range = (mainString as NSString).range(of: searchString)
                            let fullRange = NSRange(location: 0, length: mainString.count)
                            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
                    mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
                    mutableAttributedString.addAttribute(.foregroundColor, value: colors.themeBlue.value, range: range)
                            mutableAttributedString.addAttribute(.font, value: FontBook.semibold.of(size: 14), range: fullRange)
                    upcomingCell.lblVehicleDetail.attributedText = mutableAttributedString
                    
                    
                    upcomingCell.lblBookingid.text = arrBookingList[indexPath.row].id ?? ""
                    upcomingCell.buttonCancel = {
                        self.showAlertWithTitleFromVC( title: "Cancel Order", message: "Are you sure want to cancel order?", buttons: ["No", "Yes"]) { index in
                            if index == 1 {
                                self.cancelOrderData.cancelOrder(customerid: Singleton.sharedInstance.userId, order_id: self.arrBookingList[indexPath.row].id ?? "", row: indexPath.row)
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                    }
                    return upcomingCell
                }else{
                    let noDataCell:NoDataCell = myOrdersTV.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
                    noDataCell.imgNodata.image = UIImage(named: "ic_Order")
                    noDataCell.lblData.text = "No upcoming order found"
                    if UIDevice.current.userInterfaceIdiom == .phone{
                        noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(16.0)
                    }else{
                        noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(21.0)
                    }
                    noDataCell.selectionStyle = .none
                    return noDataCell
                }
            }
        } else if isInProcess == 1 {
            if !isReload{
                let shimmerCell:ShimmerCell = myOrdersTV.dequeueReusableCell(withIdentifier: ShimmerCell.className) as! ShimmerCell
                shimmerCell.lblVehicle.text = "dummy data"
                shimmerCell.lblAddress.text = "dummy data"
                shimmerCell.lblFuelType.text = "dummy data"
                shimmerCell.lblDateAndTime.text = "dummy data"
                return shimmerCell
            }else{
                if arrBookingList.count != 0{
                    let inprogressCell = myOrdersTV.dequeueReusableCell(withIdentifier: InProgressCell.className) as! InProgressCell
                    inprogressCell.lblServices.text = arrBookingList[indexPath.row].mainServiceName
                    inprogressCell.lblLocation.text = arrBookingList[indexPath.row].parkingLocation
                    inprogressCell.lblTimeandDate.text = (arrBookingList[indexPath.row].time ?? "") + ", " + (arrBookingList[indexPath.row].date ?? "")
//                    inprogressCell.lblVehicleDetails.text = (arrBookingList[indexPath.row].makeName ?? "") + " " + (arrBookingList[indexPath.row].plateNumber ?? "")
                    
                    let mainString = (arrBookingList[indexPath.row].makeName ?? "") + " " + (arrBookingList[indexPath.row].plateNumber ?? "")
                    let searchString = (arrBookingList[indexPath.row].plateNumber ?? "")
                    let range = (mainString as NSString).range(of: searchString)
                    let fullRange = NSRange(location: 0, length: mainString.count)
                    let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
                    mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
                    mutableAttributedString.addAttribute(.foregroundColor, value: colors.themeBlue.value, range: range)
                    mutableAttributedString.addAttribute(.font, value: FontBook.semibold.of(size: 14), range: fullRange)
                    inprogressCell.lblVehicleDetails.attributedText = mutableAttributedString
                    
                    if self.arrBookingList[indexPath.row].driverContactNumber?.toInt() != 0{
                        inprogressCell.vwCallandChat.isHidden = false
                        inprogressCell.lblOnTheWay.isHidden = false
                    }else{
                        inprogressCell.vwCallandChat.isHidden = true
                        inprogressCell.lblOnTheWay.isHidden = true
                    }
                    inprogressCell.lblBookingID.text = arrBookingList[indexPath.row].id
                    inprogressCell.chatClick = {
                        let chatVC: ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
                        chatVC.bookingID = self.arrBookingList[indexPath.row].id ?? ""// self.bookingid//
                        chatVC.isFromPush = true
                        self.navigationController?.pushViewController(chatVC, animated: true)
                    }
                    inprogressCell.callClick = {
                        
                            if let phoneCallURL = URL(string: "tel://\(self.arrBookingList[indexPath.row].driverContactNumber ?? "")") {
                                
                                let application:UIApplication = UIApplication.shared
                                if (application.canOpenURL(phoneCallURL)) {
                                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                                }
                            }
                    }
                    return inprogressCell
                }else{
                    let noDataCell:NoDataCell = myOrdersTV.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
                    noDataCell.imgNodata.image = UIImage(named: "ic_Order")
                    noDataCell.lblData.text = "No in-progress order found"
                    if UIDevice.current.userInterfaceIdiom == .phone{
                        noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(16.0)
                    }else{
                        noDataCell.lblData.font = CustomFont.PoppinsRegular.returnFont(21.0)
                    }
                    noDataCell.selectionStyle = .none
                    return noDataCell
                }
            }
        } else if isInProcess == 2 {
            if !isReload{
                let shimmerCell:ShimmerCell = myOrdersTV.dequeueReusableCell(withIdentifier: ShimmerCell.className) as! ShimmerCell
                shimmerCell.lblVehicle.text = "dummy data"
                shimmerCell.lblAddress.text = "dummy data"
                shimmerCell.lblFuelType.text = "dummy data"
                shimmerCell.lblDateAndTime.text = "dummy data"
                return shimmerCell
            }else{
                if arrBookingList.count != 0{
                    let completedCell = myOrdersTV.dequeueReusableCell(withIdentifier: CompletedCell.className) as! CompletedCell
                    completedCell.lblServices.text = arrBookingList[indexPath.row].mainServiceName
                    completedCell.lblLocation.text = arrBookingList[indexPath.row].parkingLocation
                    completedCell.lblTimeandDate.text = (arrBookingList[indexPath.row].time ?? "") + ", " + (arrBookingList[indexPath.row].date ?? "")
                    //                    completedCell.lblVehicleDetails.text = (arrBookingList[indexPath.row].makeName ?? "") + " " + (arrBookingList[indexPath.row].plateNumber ?? "")
                    
                    
                    let mainString = (arrBookingList[indexPath.row].makeName ?? "") + " " + (arrBookingList[indexPath.row].plateNumber ?? "")
                    let searchString = (arrBookingList[indexPath.row].plateNumber ?? "")
                    let range = (mainString as NSString).range(of: searchString)
                    let fullRange = NSRange(location: 0, length: mainString.count)
                    let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
                    mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
                    mutableAttributedString.addAttribute(.foregroundColor, value: colors.themeBlue.value, range: range)
                    mutableAttributedString.addAttribute(.font, value: FontBook.semibold.of(size: 14), range: fullRange)
                    completedCell.lblVehicleDetails.attributedText = mutableAttributedString
                    
                    completedCell.lblBookingid.text = arrBookingList[indexPath.row].id ?? ""
                    if arrBookingList[indexPath.row].statuslabel == "Cancelled" {
                        completedCell.lblTopHalf.text = "Cancelled"
                        completedCell.viewTopHalf?.backgroundColor = #colorLiteral(red: 0.9433980584, green: 0.3328252435, blue: 0.4380534887, alpha: 1)
                    } else {
                        completedCell.lblTopHalf.text = "Completed"
                        completedCell.viewTopHalf?.backgroundColor = #colorLiteral(red: 0.4391005337, green: 0.8347155452, blue: 0.5683938265, alpha: 1)
                    }
                    return completedCell
                }else{
                    let noDataCell:NoDataCell = myOrdersTV.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
                    noDataCell.imgNodata.image = UIImage(named: "ic_Order")
                    noDataCell.lblData.text = "No completed order found"
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isReload{
            return UITableView.automaticDimension
        }else{
            if arrBookingList.count != 0{
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isInProcess == 0 {
            print("Upcoming cell pressed")
        } else if isInProcess == 1 {
            print("InProgress cell pressed")
        } else if isInProcess == 2 {
            if arrBookingList[indexPath.row].statuslabel != "Cancelled" {
                let completeJobVC: CompleteJobVC = CompleteJobVC.instantiate(fromAppStoryboard: .Main)
                completeJobVC.orderId = arrBookingList[indexPath.row].id ?? ""
                navigationController?.pushViewController(completeJobVC, animated: true)
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.myOrdersTV.contentOffset.y >= (self.myOrdersTV.contentSize.height - self.myOrdersTV.frame.size.height)) && self.isStopPaging == false && self.isApiProcessing == false {
            print("call from scroll..")
            self.currentPage += 1
            BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "\(isInProcess)", page: "\(currentPage)")
        }
    }
}
