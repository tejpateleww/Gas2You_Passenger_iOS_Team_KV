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
    @IBOutlet weak var selectedDate: ThemeLabel!
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
    
    
    var toolBarForService = UIToolbar()
    var toolBarForVehicle = UIToolbar()
    var toolBar = UIToolbar()
    var vehiclePicker = UIPickerView()
    var servicePicker = UIPickerView()
    var listOfVehicle = [VehicleListDatum]()
    var serviceList = [ServiceListDatum]()
    var nonmemberplanlist = [nonMemberPlanDatum]()
    var memberPlanList = [memberPlanListDatum]()
    var datePicker  = UIDatePicker()
    let dateFormatter = DateFormatter() 
    var ServiceListData = ServiceListViewModel()
    var vehicleListData = VehicalListViewModel()
    var nonmemberListData = nonMemberPlanViewMOdel()
    var addBookingData = AddBookingViewModel()
    var memberPlanModel = memberPlanViewModel()
    var arrTimeList : [String] = []
    var selectedIndex = 0
    var SelectIndex = 0
    var dateSelected = 0
    var serviceid = ""
    var subserviceid = ""
    var vehicalid = ""
    var addonid = ""
    var time = ""
    var locationManager : LocationService?
    var PlaceName = userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String
    var availableDate : [String] = []
    //MARK:- GLOBAL PROPERTIES
    
    
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) != nil , userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as! String  != ""{
            locationLabel.text = PlaceName
        }else if Singleton.sharedInstance.userCurrentLocation.coordinate.latitude == 0.0 && Singleton.sharedInstance.userCurrentLocation.coordinate.longitude == 0.0 && userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) == nil{
            locationLabel.text = "Please Select Address"
        }else{
            self.getAddressFromLatLon(pdblLatitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude), withLongitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude))
        }
        collectionViewSubService.delegate = self
        collectionViewSubService.dataSource = self
        collectionTimeList.delegate = self
        collectionTimeList.dataSource = self
        tblNonMemberPLan.delegate = self
        tblNonMemberPLan.dataSource = self
        tblNonMemberPLan.reloadData()
        tblNonMemberPLan.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        NavbarrightButton()
        NavBarTitle(isOnlyTitle: false, isMenuButton: true, title: "Schedule Service", controller: self)
        addBookingData.addbooking = self
        ServiceListData.serviceList = self
        ServiceListData.webserviceofserviceList()
        vehicleListData.homevc = self
        vehicleListData.webserviceofgetvehicalListforHome()
        if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
            memberPlanModel.homeMemberPlan = self
            memberPlanModel.webserviceofMemberAddonList()
        }else{
            nonmemberListData.homevc = self
            nonmemberListData.webserviceofNonMemberPlanList()
        }
        if arrTimeList.count != 0{
            collectionTimeList.isHidden = false
        }else{
            collectionTimeList.isHidden = true
        }
        vehiclePicker.delegate = self
        vehiclePicker.dataSource = self
        servicePicker.delegate = self
        servicePicker.dataSource = self
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMM dd, yyyy"
        txtSelectedService.inputView = servicePicker
        txtSelectedVehicle.inputView = vehiclePicker
        txtSelectedService.delegate = self
        txtSelectedVehicle.delegate = self
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
        if let date = nextDate {
            selectedDate.text = dateFormatter.string(from: date)
            ServiceListData.webserviceofDateList(bookingdate: selectedDate.text ?? "")
        }
        LblOctane.text = "93 Octane"
        dismissPickerView()
    }
    
    func setup(){
        if listOfVehicle.count != 0{
            btnAddVehicleData.isHidden = true
            txtSelectedVehicle.isHidden = false
        }else{
            txtSelectedVehicle.isHidden = true
            btnAddVehicleData.isHidden = false
        }
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDoneButtonTappedService))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtSelectedService.inputAccessoryView = toolBar
        txtSelectedVehicle.inputAccessoryView = toolBar
    }
    override func viewWillAppear(_ animated: Bool) {
        if listOfVehicle.count >= 1{
            btnAddVehicleData.isHidden = true
            txtSelectedVehicle.isHidden = false
        }else{
            txtSelectedVehicle.isHidden = true
            btnAddVehicleData.isHidden = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshVehicleList), name: notifRefreshVehicleList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshhomescreen), name: notifRefreshHomeScreen, object: nil)
    }
    @objc func refreshVehicleList(){
        vehicleListData.webserviceofgetvehicalListforHome()
    }
    func refreshVehicleScreen() {
        vehicleListData.webserviceofgetvehicalListforHome()
    }
    @objc func refreshhomescreen(){
        ServiceListData.webserviceofserviceList()
        vehicleListData.webserviceofgetvehicalListforHome()
        nonmemberListData.webserviceofNonMemberPlanList()
        dateSelected = 0
        collectionTimeList.reloadData()
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
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        if let placemarks = placemarks,placemarks.count > 0{
                                            
                                            let pm = placemarks[0]
                                            print(pm.country ?? "")
                                            print(pm.locality ?? "")
                                            print(pm.subLocality ?? "")
                                            print(pm.thoroughfare ?? "")
                                            print(pm.postalCode ?? "")
                                            print(pm.subThoroughfare ?? "")
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
    //MARK:- ACTIONS
    
    
    @IBAction func btnAddVehicle(_ sender: Any) {
        let addVehicleVC:AddVehicleVC = AddVehicleVC.instantiate(fromAppStoryboard: .Main)
        addVehicleVC.delegateAdd = self
        self.navigationController?.pushViewController(addVehicleVC, animated: true)
    }
    @IBAction func btnParkingLocationTap(_ sender: UIButton) {
        let carParkingLocationVC = storyboard?.instantiateViewController(withIdentifier: "CarParkingLocationVC") as! CarParkingLocationVC
        carParkingLocationVC.place = self.PlaceName ?? ""
        carParkingLocationVC.delegatetext = self
        navigationController?.pushViewController(carParkingLocationVC, animated: true)
    }
    @IBAction func btnSelectVehicleTap(_ sender: UIButton) {
        
        if listOfVehicle.count == 0 {
            let addVehicleVC:AddVehicleVC = AddVehicleVC.instantiate(fromAppStoryboard: .Main)
            addVehicleVC.delegateAdd = self
            self.navigationController?.pushViewController(addVehicleVC, animated: true)
            // show button for adding new vehicle
        } else {
            
            onDoneButtonDate()
            
            //            setServicePicker()
            //            setVehiclePicker()
        }
    }
    //Mark CheckLocation
    func checkLocation(){
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
                let slideToConfirmVC: SlideToConfirmVC = SlideToConfirmVC.instantiate(fromAppStoryboard: .Main)
                slideToConfirmVC.completion = {
                    self.addBookingData.doAddBooking(customerid: Singleton.sharedInstance.userId, serviceid: self.serviceid, subserviceid: self.subserviceid, parkinglocation: self.locationLabel.text ?? "", lat: "\(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)", lng: "\(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)", date: self.selectedDate.text ?? "", time: self.time, vehicleid: self.vehicalid, totalAmount: "0", addonid: self.addonid)
                    self.dismiss(animated: false, completion: nil)
                }
                slideToConfirmVC.modalPresentationStyle = .overFullScreen
                present(slideToConfirmVC, animated: false, completion: nil)
            }else{
                Toast.show(title: UrlConstant.Required, message:"Service list is empty", state: .info)
            }
        }
    }
    @IBAction func fillItUpButtonPressed(_ sender: ThemeButton) {
        if self.listOfVehicle.count == 0{
            Toast.show(title: UrlConstant.Required, message:"No vehicle has been added yet, please add vehicle to proceed further!", state: .info)
        }else {
            checkLocation()
        }
    }
    
    @IBAction func btnDatePickerTap(_ sender: UIButton) {
        
        onDoneButtonDate()
        
        setDatePicker()
    }
    
    //MARK:- OTHER METHODS
    
    @objc func onDoneButtonTappedService() {
        if txtSelectedService.isFirstResponder {
            let row = servicePicker.selectedRow(inComponent: 0);
            if self.serviceList.count != 0{
                if self.serviceList[row].subServices?.count != 0{
                    self.selectedIndex = row
                    self.ViewForShowPrice.isHidden = false
                    self.collectionViewSubService.reloadData()
                } else {
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
        }
    }
    
    func setDatePicker() {
        
        datePicker = UIDatePicker.init()
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
        datePicker.minimumDate = nextDate
        
        let nextMonth = Calendar.current.date(byAdding: .month, value: 33, to: today)
        datePicker.maximumDate = nextMonth
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
        }
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        datePicker.backgroundColor = .white
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonDate))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonDate() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            selectedDate.text = dateFormatter.string(from: date)
            ServiceListData.webserviceofDateList(bookingdate: selectedDate.text ?? "")
        }
    }
    
}

//MARK:- EXTENSIONS

extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtSelectedService.isFirstResponder {
            return serviceList.count
        } else if txtSelectedVehicle.isFirstResponder {
            return listOfVehicle.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtSelectedService.isFirstResponder {
            return serviceList[row].name
        } else if txtSelectedVehicle.isFirstResponder {
            let displaydata = (listOfVehicle[row].make ?? "") + "(" + (listOfVehicle[row].plateNumber ?? "") + ")"
            return displaydata
        }
        return serviceList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
            return memberPlanList .count
        }else{
            return nonmemberplanlist.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
            let cell:MemberListHomeCell = tblNonMemberPLan.dequeueReusableCell(withIdentifier: MemberListHomeCell.className) as! MemberListHomeCell
            cell.lblPrice.text = CurrencySymbol + (memberPlanList[indexPath.row].price ?? "")
            cell.lblTitle.text = (memberPlanList[indexPath.row].planName ?? "") + arrow
            if memberPlanList[indexPath.row].isPurchased == true{
                memberPlanList[indexPath.row].isSelected = true
                cell.imgCheck.image = UIImage(named: "IC_selectedBlue")
            }else{
                memberPlanList[indexPath.row].isSelected = false
                cell.imgCheck.image = UIImage(named: "IC_unselectedBlue")
            }
            cell.imgCheck.image = (memberPlanList[indexPath.row].isSelected == true) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
            //self.addonid = (memberPlanList[indexPath.row].isSelected == true) ? self.memberPlanList[indexPath.row].id ?? "" : ""
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:nonMemberListCell = tblNonMemberPLan.dequeueReusableCell(withIdentifier: nonMemberListCell.className) as! nonMemberListCell
            cell.lblPrice.text = CurrencySymbol + (nonmemberplanlist[indexPath.row].price ?? "")
            cell.lbltitle.text = (nonmemberplanlist[indexPath.row].title ?? "") + arrow
            cell.imgCheck.image = (nonmemberplanlist[indexPath.row].isSelected == true) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
            self.addonid = (nonmemberplanlist[indexPath.row].isSelected == true) ? self.nonmemberplanlist[indexPath.row].id ?? "" : ""
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Singleton.sharedInstance.userProfilData?.is_membership_user == true{
            if memberPlanList[indexPath.row].isSelected == true{
                
            }else{
                memberPlanList[indexPath.row].isSelected = (memberPlanList[indexPath.row].isSelected == true) ? false : true
                tblNonMemberPLan.reloadData()
            }
        }else{
            nonmemberplanlist[indexPath.row].isSelected = (nonmemberplanlist[indexPath.row].isSelected == true) ? false : true
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
                self.subserviceid = serviceList[selectedIndex].subServices?[indexPath.row].id ?? ""
                self.priceTagLabel.text = CurrencySymbol + (self.serviceList[self.selectedIndex].subServices?[indexPath.row].price ?? "")
                if self.serviceList[self.selectedIndex].subServices?.count ?? 0 > 2{
                    self.imgSubserviceArrow.isHidden = false
                }else{
                    self.imgSubserviceArrow.isHidden = true
                }
            }else{
                cell.imgCheck.image = UIImage(named: "IC_unselectedBlue")
            }
            //            cell.imgCheck.image = (SelectIndex == indexPath.row) ?  :
            
            return cell
        }else{
            let cell:timeListCell = collectionTimeList.dequeueReusableCell(withReuseIdentifier: timeListCell.className, for: indexPath) as! timeListCell
            cell.lblListData.text = arrTimeList[indexPath.row]
            self.time = arrTimeList[indexPath.row]
            if dateSelected == indexPath.row{
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
            //            cell.btnSubService.setTitle(serviceList[selectedIndex].subServices?[indexPath.row].name, for: .normal)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionTimeList{
            dateSelected = indexPath.row
            collectionTimeList.reloadData()
        }else{
            SelectIndex = indexPath.row
            collectionViewSubService.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionTimeList{
            if UIDevice.current.userInterfaceIdiom == .phone{
                return CGSize(width: 90, height: 36.95)
            }else{
                return CGSize(width: 150, height: 36.95)
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
                return true
            }else{
                Toast.show(title: UrlConstant.Failed, message: "Service list is empty", state: .failure)
            }
        case txtSelectedVehicle:
            if listOfVehicle.count != 0{
                return true
            }else{
                Toast.show(title: UrlConstant.Failed, message: "Vehicle list is empty", state: .failure)
            }
        default:
            break
        }
        return false
    }
}
