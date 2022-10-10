//
//  HomeVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import GrowingTextView

class HomeVC: BaseVC,searchDataDelegate,AddVehicleDelegate {
    
    func refreshSearchLIstScreen(text: String) {
        if locationLabel.text == ""{
            locationLabel.text = "Please Select Address"
        }else{
            locationLabel.text = text
        }
    }
    
    //MARK:- OUTLETS
    @IBOutlet weak var ViewForShowPrice: UIView!
    @IBOutlet weak var LblOctane: ThemeLabel!
    @IBOutlet weak var imgSelctService: UIImageView!
    @IBOutlet weak var gasServiceView: UIView!
    @IBOutlet weak var priceTagLabel: ThemeLabel!
    @IBOutlet weak var imgParkingLocation: UIImageView!
    @IBOutlet weak var locationLabel: ThemeLabel!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var imgSelectVehicle: UIImageView!
    @IBOutlet weak var lblSelectService: ThemeLabel!
    @IBOutlet weak var txtSelectedService: UITextField!
    @IBOutlet weak var lblSelectGrade: ThemeLabel!
    @IBOutlet weak var lblSelectedGrade: ThemeLabel!
    @IBOutlet weak var lblPerGallon: ThemeLabel!
    @IBOutlet weak var lblParkingLocation: ThemeLabel!
    @IBOutlet weak var lblSelectDateTime: ThemeLabel!
    @IBOutlet weak var txtDateSelected: UITextField!
    @IBOutlet weak var lblSelectVehicle: ThemeLabel!
    @IBOutlet weak var txtSelectedVehicle: UITextField!
    @IBOutlet weak var lblAddOns: ThemeLabel!
    @IBOutlet weak var btnSelectParkingLocation: UIButton!
    @IBOutlet weak var btnDatePicker: UIButton!
    @IBOutlet weak var collectionViewSubService: UICollectionView!
    @IBOutlet weak var tblNonMemberPLan: UITableView!
    @IBOutlet weak var tblNonMemberPlanHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionTimeList: UICollectionView!
    @IBOutlet weak var btnAddBooking: ThemeButton!
    @IBOutlet weak var imgSubserviceArrow: UIImageView!
    @IBOutlet weak var btnAddVehicleData: UIButton!
    @IBOutlet weak var txtViewNotes: GrowingTextView!
    @IBOutlet weak var scrollVw: UIScrollView!
    
    var toolBarForService = UIToolbar()
    var toolBarForVehicle = UIToolbar()
    var toolBar = UIToolbar()
    var vehiclePicker = UIPickerView()
    var servicePicker = UIPickerView()
    var listOfVehicle = [VehicleListDatum]()
    var serviceList = [ServiceListDatum]()
    var nonmemberplanlist = [nonMemberPlanDatum]()
    var memberPlanList = [memberPlanListDatum]()
    var datePicker  = UIPickerView()
    let dateFormatter = DateFormatter()
    var homeVM = HomeViewModel()
    var ServiceListData = ServiceListViewModel()
    var vehicleListData = VehicalListViewModel()
    var nonmemberListData = nonMemberPlanViewMOdel()
    var addBookingData = AddBookingViewModel()
    var memberPlanModel = memberPlanViewModel()
    var arrTimeList = [DateResDatum]()
    var selectedIndex = 0
    var SelectIndex = 0
    var dateSelected = 0
    var serviceid = ""
    var subserviceid = ""
    var vehicalid = ""
    var addonid = [String]()
    var time = ""
    var locationManager : LocationService?
    var PlaceName = userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String
    var availableDate : [String] = []
    var todaysDate = NSDate()
    
    
    //MARK: - VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        self.addNotificationObs()
        self.checkForNotification()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgSubserviceArrow.isUserInteractionEnabled = true
        imgSubserviceArrow.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageScreenNotification"), object: nil, userInfo: nil)
        
        if Singleton.sharedInstance.userCurrentLocation.coordinate.latitude == 0.0 && Singleton.sharedInstance.userCurrentLocation.coordinate.longitude == 0.0{
            locationLabel.text = "Please Select Address"
        }else{
            Singleton.sharedInstance.userCurrentLocation = CLLocation(latitude: Singleton.sharedInstance.userCurrentLocation.coordinate.latitude, longitude: Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)
            self.getAddressFromLatLon(pdblLatitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude), withLongitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude))
        }
        
        collectionViewSubService.delegate = self
        collectionViewSubService.dataSource = self
        collectionTimeList.delegate = self
        collectionTimeList.dataSource = self
        tblNonMemberPLan.delegate = self
        tblNonMemberPLan.dataSource = self
        tblNonMemberPLan.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        addBookingData.addbooking = self
        ServiceListData.serviceList = self
        ServiceListData.webserviceofserviceList()
        vehicleListData.homevc = self
        vehicleListData.webserviceofgetvehicalListforHome()
        nonmemberListData.homevc = self
        nonmemberListData.webserviceofNonMemberPlanList()
        
        vehiclePicker.delegate = self
        vehiclePicker.dataSource = self
        servicePicker.delegate = self
        servicePicker.dataSource = self
        datePicker.delegate = self
        datePicker.dataSource = self
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMM dd, yyyy"
        txtSelectedService.inputView = servicePicker
        txtSelectedVehicle.inputView = vehiclePicker
        txtDateSelected.inputView = datePicker
        txtSelectedService.delegate = self
        txtSelectedVehicle.delegate = self
        txtDateSelected.delegate = self
        
        let DateToShare = convertDateFormat(inputDate: Singleton.sharedInstance.appInitModel?.currentDate ?? "")
        ServiceListData.webserviceofDateList(booking_date:DateToShare, isFromToday: true)
        
        LblOctane.text = "93 Octane"
        dismissPickerView()
        self.scrollVw.showsHorizontalScrollIndicator = false
        self.scrollVw.showsVerticalScrollIndicator = false

        
        //Notes section
        self.txtViewNotes.trimWhiteSpaceWhenEndEditing = false
        self.txtViewNotes.placeholder = "Please provide note.. (Optional)"
        self.txtViewNotes.placeholderColor = UIColor.lightGray
        self.txtViewNotes.minHeight = 100
        self.txtViewNotes.maxHeight = 150
        self.txtViewNotes.layer.cornerRadius = 5
        self.txtViewNotes.layer.borderColor = hexStringToUIColor(hex: "1C75BB").cgColor
        self.txtViewNotes.layer.borderWidth = 2
        
        callInitAPI()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NavbarrightButton()
        NavBarTitle(isOnlyTitle: false, isMenuButton: true, title: "Schedule Service", controller: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            self.tblNonMemberPlanHeight.constant = tblNonMemberPLan.contentSize.height
        }
    }
    
    //MARK: - Custom methods
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.moveToNextCell()
    }
    
    func addNotificationObs(){
        
        NotificationCenter.default.removeObserver(self, name: .reCallInitAPI, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reCallInitAPI), name: .reCallInitAPI, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .openCarDoorScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openCarDoor), name: .openCarDoorScreen, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .clearAddonArray, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearAddonArray), name: .clearAddonArray, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .goToCompOrderScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToCompOrderScreen), name: .goToCompOrderScreen, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .goToNotiScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToNotiScreen), name: .goToNotiScreen, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .goToUpcomingOrderScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToUpcomingOrderScreen), name: .goToUpcomingOrderScreen, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .goToProfileScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToProfileScreen), name: .goToProfileScreen, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshVehicleList), name: notifRefreshVehicleList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshhomescreen), name: notifRefreshHomeScreen, object: nil)
    }
    
    func checkForNotification(){
        if(AppDelegate.pushNotificationObj != nil){
            if(AppDelegate.pushNotificationType == NotificationTypes.InvoiceGenerated.rawValue){
                self.goToCompOrderScreen()
            }else if(AppDelegate.pushNotificationType == "SendBulkPushNotification"){
                self.goToNotiScreen()
            }else if(AppDelegate.pushNotificationType == "membershipUpdate"){
                self.goToProfileScreen()
            }
        }
    }
    
    @objc func goToProfileScreen() {
        
        let MyProfileVC : MyProfileVC = MyProfileVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(MyProfileVC, animated: true)
        
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func goToCompOrderScreen() {
        
        let MyOrdersVC:MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
        MyOrdersVC.isFromComplete = true
        MyOrdersVC.isFromPushInvoice = true
        MyOrdersVC.bookingid = AppDelegate.pushNotificationObj?.booking_id ?? ""
        self.navigationController?.pushViewController(MyOrdersVC, animated: true)
        
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func goToNotiScreen() {
        
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil

        let MyOrdersVC:NotificationListVC = NotificationListVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(MyOrdersVC, animated: true)
    }
    
    @objc func goToUpcomingOrderScreen() {
        let MyOrdersVC:MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(MyOrdersVC, animated: true)
    }
    
    @objc func openCarDoor() {
        AppDel.showCarDoorOpenVC()
    }
    
    @objc func clearAddonArray() {
        self.addonid = []
    }
    
    @objc func refreshVehicleList(){
        vehicleListData.webserviceofgetvehicalListforHome()
    }
    
    @objc func refreshhomescreen(){
        ServiceListData.webserviceofserviceList()
        vehicleListData.webserviceofgetvehicalListforHome()
        nonmemberListData.webserviceofNonMemberPlanList()
        
        dateSelected = 0
        collectionTimeList.reloadData()
    }
    
    @objc func reCallInitAPI() {
        self.callInitAPI()
    }
    
    func ReloadAddonsAfterInitResponse(){
        nonmemberListData.webserviceofNonMemberPlanList()
    }
    
//    func setup(){
//        if listOfVehicle.count != 0{
//            btnAddVehicleData.isHidden = true
//            txtSelectedVehicle.isHidden = false
//        }else{
//            txtSelectedVehicle.isHidden = true
//            btnAddVehicleData.isHidden = false
//        }
//    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDoneButtonTappedService))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtSelectedService.inputAccessoryView = toolBar
        txtSelectedVehicle.inputAccessoryView = toolBar
        txtDateSelected.inputAccessoryView = toolBar
    }
    
    func refreshVehicleScreen() {
        vehicleListData.webserviceofgetvehicalListforHome()
    }
    
    func convertDateFormat(inputDate: String) -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let oldDate = olDateFormatter.date(from: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd, yyyy"
        
        return convertDateFormatter.string(from: oldDate ?? Date())
    }
    
    func moveToNextCell(){
        let visibleItems: NSArray = self.collectionViewSubService.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < serviceList.count {
            self.collectionViewSubService.scrollToItem(at: nextItem, at: .left, animated: true)
            
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            if (error != nil){
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            if let placemarks = placemarks,placemarks.count > 0{
                
                let pm = placemarks[0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + (pm.subLocality ?? "") + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + (pm.thoroughfare ?? "") + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + (pm.locality ?? "") + ", "
                }
                if pm.country != nil {
                    addressString = addressString + (pm.country ?? "" ) + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + (pm.postalCode ?? "") + " "
                }
                self.PlaceName = addressString
                self.locationLabel.text = addressString
                print(addressString)
            }
            else{
                Utilities.ShowAlert(OfMessage: "Location Not Found")
            }
        })
        
    }
    
    //MARK: - ACTIONS
    @IBAction func btnAddVehicle(_ sender: Any) {
        let addVehicleVC:AddNewVehicleVC = AddNewVehicleVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(addVehicleVC, animated: true)
    }
    
    @IBAction func btnParkingLocationTap(_ sender: UIButton) {
//        let LocationStatus = CLLocationManager.authorizationStatus()
//        if LocationStatus == .notDetermined {
//            AppDelegate.shared.locationService.locationManager?.requestWhenInUseAuthorization()
//        }else if LocationStatus == .restricted || LocationStatus == .denied {
//            Utilities.showAlertWithTitleFromWindow(title: AppInfo.appName, andMessage: "Please turn on permission from settings, to track location in app.", buttons: ["Cancel","Settings"]) { (index) in
//                if index == 1 {
//                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
//                        return
//                    }
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:])
//                    }
//                    if let settingsAppURL = URL(string: UIApplication.openSettingsURLString){
//                        UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
//                    }
//                }
//            }
//        }else{
//            let carParkingLocationVC = storyboard?.instantiateViewController(withIdentifier: "CarParkingLocationVC") as! CarParkingLocationVC
//            carParkingLocationVC.place = self.PlaceName ?? ""
//            carParkingLocationVC.delegatetext = self
//            navigationController?.pushViewController(carParkingLocationVC, animated: true)
//        }
        let carParkingLocationVC = storyboard?.instantiateViewController(withIdentifier: "CarParkingLocationVC") as! CarParkingLocationVC
        carParkingLocationVC.delegatetext = self
        carParkingLocationVC.searchText = ((self.locationLabel.text == "" || self.locationLabel.text == "Please Select Address") ? "" : self.locationLabel.text) ?? ""
        navigationController?.pushViewController(carParkingLocationVC, animated: true)
    }
    
    @IBAction func btnSelectVehicleTap(_ sender: UIButton) {
        if listOfVehicle.count == 0 {
            let addVehicleVC:AddNewVehicleVC = AddNewVehicleVC.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(addVehicleVC, animated: true)
        }
    }
    
    func checkService() -> Bool{
        let selectedService = self.serviceList.first(where: { $0.id == self.serviceid })
        if(selectedService?.subServices?.count ?? 0 > 0){
            if(self.subserviceid == ""){
                return false
            }else{
                return true
            }
        }else{
            return true
        }
        
    }
    
    @IBAction func fillItUpButtonPressed(_ sender: ThemeButton) {
        if self.listOfVehicle.count == 0{
            Toast.show(title: UrlConstant.Required, message:"No vehicle has been added yet, please add vehicle to proceed further!", state: .info)
        }else if(self.locationLabel.text == "" || self.locationLabel.text == "Please Select Address"){
            Toast.show(title: UrlConstant.Required, message:"Please select parking location", state: .info)
        }else if(self.txtSelectedVehicle.text == "" || self.txtSelectedVehicle.text == "Select Your Vehicle"){
            Toast.show(title: UrlConstant.Required, message:"Please select Your Vehicle", state: .info)
        }else if(!self.checkService()){
            Toast.show(title: UrlConstant.Required, message:"Please select sub service type", state: .info)
        }else {
            let LocationStatus = CLLocationManager.authorizationStatus()
            if LocationStatus == .notDetermined {
                AppDelegate.shared.locationService.locationManager?.requestWhenInUseAuthorization()
            }else if LocationStatus == .restricted || LocationStatus == .denied {
                Utilities.showAlertWithTitleFromWindow(title: AppInfo.appName, andMessage: "Please turn on permission from settings, to track location in app.", buttons: ["Cancel","Settings"]) { (index) in
                    if index == 1 {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:])
                        }
                        if let settingsAppURL = URL(string: UIApplication.openSettingsURLString){
                            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
                        }
                    }
                }
            }else{
                if self.serviceList.count != 0{
                    self.addBookingData.webserviceCheckTime(bookingDate: self.txtDateSelected.text ?? "", bookingTime: self.time, vehicleId: self.vehicalid)
                }else{
                    Toast.show(title: UrlConstant.Required, message:"Service list is empty", state: .info)
                }
            }
        }
    }
    
    @IBAction func btnDatePickerTap(_ sender: UIButton) {
        
    }
    
    @objc func onDoneButtonTappedService() {
        if txtSelectedService.isFirstResponder {
            let row = servicePicker.selectedRow(inComponent: 0);
            if self.serviceList.count != 0{
                if self.serviceList[row].subServices?.count != 0{
                    self.serviceid = self.serviceList[row].id ?? "0"
                    self.selectedIndex = row
                    self.ViewForShowPrice.isHidden = false
                    if self.serviceList[self.selectedIndex].subServices?.count ?? 0 > 2{
                        self.imgSubserviceArrow.isHidden = false
                    }else{
                        self.imgSubserviceArrow.isHidden = true
                    }
                    self.collectionViewSubService.reloadData()
                } else {
                    self.subserviceid = ""
                    self.LblOctane.text = self.serviceList[row].name
                    self.ViewForShowPrice.isHidden = true
                    self.serviceid = self.serviceList[row].id ?? ""
                    self.priceTagLabel.text = CurrencySymbol + (self.serviceList[row].price ?? "")
                }
                self.txtSelectedService.text = self.serviceList[row].name
                self.txtSelectedService.endEditing(true)
            }else{
                self.txtSelectedService.endEditing(true)
            }
            
        } else if txtSelectedVehicle.isFirstResponder{
            let row = vehiclePicker.selectedRow(inComponent: 0)
            if listOfVehicle.count != 0{
                self.vehicalid = self.listOfVehicle[row].id ?? ""
                self.txtSelectedVehicle.text = (self.listOfVehicle[row].make ?? "") + "(" + (self.listOfVehicle[row].plateNumber ?? "") + ")"
                self.txtSelectedVehicle.endEditing(true)
            }else{
                self.txtSelectedVehicle.endEditing(true)
            }
        } else if txtDateSelected.isFirstResponder{
            let row = datePicker.selectedRow(inComponent: 0)
            if availableDate.count != 0{
                txtDateSelected.text = convertDateFormat(inputDate: availableDate[row])
                ServiceListData.webserviceofDateList(booking_date: txtDateSelected.text ?? "", isFromToday: false)
                
                txtDateSelected.endEditing(true)
            }else{
                txtDateSelected.endEditing(true)
            }
        }
    }
}

//MARK: - EXTENSIONS
extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if txtSelectedService.isFirstResponder{
            return 1
        }else if txtSelectedVehicle.isFirstResponder{
            return 1
        }else if txtDateSelected.isFirstResponder{
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtSelectedService.isFirstResponder {
            return serviceList.count
        } else if txtSelectedVehicle.isFirstResponder {
            return listOfVehicle.count
        } else if txtDateSelected.isFirstResponder{
            return availableDate.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtSelectedService.isFirstResponder {
            return serviceList[row].name
        } else if txtSelectedVehicle.isFirstResponder {
            let displaydata = (listOfVehicle[row].make ?? "") + "(" + (listOfVehicle[row].plateNumber ?? "") + ")"
            return displaydata
        } else if txtDateSelected.isFirstResponder{
            return convertDateFormat(inputDate: availableDate[row])
        }
        return serviceList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonmemberplanlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:nonMemberListCell = tblNonMemberPLan.dequeueReusableCell(withIdentifier: nonMemberListCell.className) as! nonMemberListCell
        if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
            if nonmemberplanlist[indexPath.row].title == "Service Charge" || nonmemberplanlist[indexPath.row].title == "Windshield Washer Fluid Refill"{
                cell.lblPrice.text = CurrencySymbol + (nonmemberplanlist[indexPath.row].price ?? "")
                if(nonmemberplanlist[indexPath.row].isChecked ?? false){
                    if(!self.addonid.contains(nonmemberplanlist[indexPath.row].id ?? "-1")){
                        self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
                    }
                }
            }else{
                cell.lblPrice.text = "Free"
                if nonmemberplanlist[indexPath.row].isChecked ?? false{
                    if(!self.addonid.contains(nonmemberplanlist[indexPath.row].id ?? "-1")){
                        self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
                    }
                }
            }
            cell.imgCheck.image = (nonmemberplanlist[indexPath.row].isChecked == true) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
            
        }else{
            if nonmemberplanlist[indexPath.row].title == "Service Charge"{ // || nonmemberplanlist[indexPath.row].title == "Windshield Washer Fluid Refill"
                cell.lblPrice.text = CurrencySymbol + (nonmemberplanlist[indexPath.row].price ?? "")
                cell.imgCheck.image = UIImage(named: "IC_selectedBlue")
                //Tej's Code
                if(nonmemberplanlist[indexPath.row].isChecked ?? false){
                    if(!self.addonid.contains(nonmemberplanlist[indexPath.row].id ?? "-1")){
                        self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
                    }
                }
                //Tej's Code Complete
                
                
//                if let index = self.addonid.firstIndex(where: {$0 == self.nonmemberplanlist[indexPath.row].id ?? ""}){
//                    self.addonid.remove(at: index)
//                }
//                if nonmemberplanlist[indexPath.row].isChecked ?? false{
//                    self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
//                }
            }else{
                cell.lblPrice.text = CurrencySymbol + (nonmemberplanlist[indexPath.row].price ?? "")
                if let index = self.addonid.firstIndex(where: {$0 == self.nonmemberplanlist[indexPath.row].id ?? ""}){
                    self.addonid.remove(at: index)
                }
                if nonmemberplanlist[indexPath.row].isChecked ?? false{
                    self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
                }
                cell.imgCheck.image = (nonmemberplanlist[indexPath.row].isChecked == true) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
            }
        }
        cell.lbltitle.text = (nonmemberplanlist[indexPath.row].title ?? "") + arrow
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
            if(nonmemberplanlist[indexPath.row].isChecked == true && nonmemberplanlist[indexPath.row].title != "Windshield Washer Fluid Refill"){
                return
            }else{
          
                if(self.addonid.contains(nonmemberplanlist[indexPath.row].id ?? "-1")){
                    if let index = self.addonid.firstIndex(where: {$0 == self.nonmemberplanlist[indexPath.row].id ?? ""}){
                        self.addonid.remove(at: index)
                        nonmemberplanlist[indexPath.row].isChecked = false
                    }
                }else{
                    self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
                    nonmemberplanlist[indexPath.row].isChecked = true
                }
                print(self.addonid)
                    
                tblNonMemberPLan.reloadData()
            }
              
        }else{
           
            if(nonmemberplanlist[indexPath.row].isChecked == true && nonmemberplanlist[indexPath.row].title == "Service Charge"){
                return
            }
            
            if(self.addonid.contains(nonmemberplanlist[indexPath.row].id ?? "-1")){
                if let index = self.addonid.firstIndex(where: {$0 == self.nonmemberplanlist[indexPath.row].id ?? ""}){
                    self.addonid.remove(at: index)
                    nonmemberplanlist[indexPath.row].isChecked = false
                }
            }else{
                self.addonid.append(self.nonmemberplanlist[indexPath.row].id ?? "")
                nonmemberplanlist[indexPath.row].isChecked = true
            }
            
            print(self.addonid)
            tblNonMemberPLan.reloadData()
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSubService{
            if serviceList.count != 0{
                return serviceList[selectedIndex].SubCount
            }
            return 0
        }else{
            return arrTimeList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewSubService{
            let cell:SubServiceCell = collectionViewSubService.dequeueReusableCell(withReuseIdentifier: SubServiceCell.className, for: indexPath) as! SubServiceCell
            cell.lblData.text = serviceList[selectedIndex].subServices?[indexPath.row].name
            if SelectIndex == indexPath.row{
                cell.imgCheck.image = UIImage(named: "IC_selectedBlue")
                self.LblOctane.text = self.serviceList[self.selectedIndex].subServices?[indexPath.row].name
                self.priceTagLabel.text = CurrencySymbol + (self.serviceList[self.selectedIndex].subServices?[indexPath.row].price ?? "")
                self.subserviceid = serviceList[selectedIndex].subServices?[SelectIndex].id ?? ""
                if self.serviceList[self.selectedIndex].subServices?.count ?? 0 > 2{
                    self.imgSubserviceArrow.isHidden = false
                }else{
                    self.imgSubserviceArrow.isHidden = true
                }
            }else{
                cell.imgCheck.image = UIImage(named: "IC_unselectedBlue")
            }
            
            return cell
        }else{
            let cell:timeListCell = collectionTimeList.dequeueReusableCell(withReuseIdentifier: timeListCell.className, for: indexPath) as! timeListCell
            cell.lblListData.text = arrTimeList[indexPath.row].displayTime
            if dateSelected == indexPath.row{
                self.time = arrTimeList[dateSelected].time ?? ""
                cell.layoutSubviews()
                cell.layoutIfNeeded()
                cell.vwMain.layer.cornerRadius = 10
                cell.lblListData.layer.cornerRadius = 10
                cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#1C75BB")
                cell.lblListData.textColor = colors.white.value
            }else{
                cell.vwMain.layer.cornerRadius = 10
                cell.vwMain.backgroundColor = UIColor.white
                cell.lblListData.textColor = hexStringToUIColor(hex: "#0C233C")
            }
            //cell.btnSubService.setTitle(serviceList[selectedIndex].subServices?[indexPath.row].name, for: .normal)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionTimeList{
            dateSelected = indexPath.row
            self.time = arrTimeList[dateSelected].time ?? ""
            collectionTimeList.reloadData()
        }else{
            SelectIndex = indexPath.row
            self.subserviceid = serviceList[selectedIndex].subServices?[SelectIndex].id ?? ""
            collectionViewSubService.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionTimeList{
            if UIDevice.current.userInterfaceIdiom == .phone{
                return CGSize(width: collectionView.frame.width/1.5, height: 36.95)
            }else{
                return CGSize(width: collectionView.frame.width/2, height: 36.95)
            }
        }else{
            return CGSize(width: collectionViewSubService.frame.width / 2, height: collectionViewSubService.frame.width)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionTimeList{
            return 10
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionTimeList{
            return 10
        }else{
            return 0
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtSelectedService:
            if serviceList.count != 0{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.servicePicker.selectRow(0, inComponent: 0, animated: true)
                }
                return true
            }else{
                Toast.show(title: UrlConstant.Error, message: "Service list is empty", state: .failure)
            }
        case txtSelectedVehicle:
            if listOfVehicle.count != 0{
                return true
            }else{
                Toast.show(title: UrlConstant.Error, message: "Vehicle list is empty", state: .failure)
            }
        case txtDateSelected:
            if availableDate.count != 0{
                return true
            }else{
                Toast.show(title: UrlConstant.Error, message: "Date list is empty", state: .failure)
            }
        default:
            break
        }
        return false
    }
}

extension HomeVC {
    func callInitAPI(){
        self.homeVM.homeVC = self
        self.homeVM.callInitAPI()
    }
}


extension HomeVC: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            DispatchQueue.main.async {
                self.scrollVw.scrollToBottom()
            }
            self.view.layoutIfNeeded()
        }
    }
}


