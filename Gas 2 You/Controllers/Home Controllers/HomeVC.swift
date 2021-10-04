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
        locationLabel.text = text
    }
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var ViewForShowPrice: UIView!
    @IBOutlet weak var LblOctane: ThemeLabel!
    @IBOutlet weak var imgSelctService: UIImageView!
    @IBOutlet weak var gasServiceView: UIView!
    @IBOutlet var octaneButtons: [ThemeButton]!
    @IBOutlet weak var priceTagLabel: ThemeLabel!
    @IBOutlet weak var imgParkingLocation: UIImageView!
    @IBOutlet weak var locationLabel: ThemeLabel!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var imgSelectVehicle: UIImageView!
    @IBOutlet weak var lblSelectService: ThemeLabel!
    @IBOutlet weak var lblSelectedService: ThemeLabel!
    @IBOutlet weak var lblSelectGrade: ThemeLabel!
    @IBOutlet weak var lblSelectedGrade: ThemeLabel!
    @IBOutlet weak var lblPerGallon: ThemeLabel!
    @IBOutlet weak var lblParkingLocation: ThemeLabel!
    @IBOutlet weak var lblSelectDateTime: ThemeLabel!
    @IBOutlet weak var selectedDate: ThemeLabel!
    @IBOutlet weak var lblSelectVehicle: ThemeLabel!
    @IBOutlet weak var lblSelectedVehicle: ThemeLabel!
    @IBOutlet weak var lblAddOns: ThemeLabel!
    @IBOutlet weak var btnSelectService: UIButton!
    @IBOutlet weak var btnSelectParkingLocation: UIButton!
    @IBOutlet weak var btnSelectVehicle: UIButton!
    @IBOutlet weak var btnDatePicker: UIButton!
    @IBOutlet weak var collectionViewSubService: UICollectionView!
    @IBOutlet weak var tblNonMemberPLan: UITableView!
    @IBOutlet weak var tblNonMemberPlanHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionTimeList: UICollectionView!
    
    
    
    var toolBarForService = UIToolbar()
    var toolBarForVehicle = UIToolbar()
    var toolBar = UIToolbar()
    var vehiclePicker = UIPickerView()
    var servicePicker = UIPickerView()
    var listOfVehicle = [VehicleListDatum]()
    var serviceList = [ServiceListDatum]()
    var nonmemberplanlist = [nonMemberPlanDatum]()
    var datePicker  = UIDatePicker()
    let dateFormatter = DateFormatter()
    var ServiceListData = ServiceListViewModel()
    var vehicleListData = VehicalListViewModel()
    var nonmemberListData = nonMemberPlanViewMOdel()
    var addBookingData = AddBookingViewModel()
    var PlaceName = userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String
    var doneButton : (()->())?
    var arrTimeList = ["11:00","13:30","15:00","17:30"]
    var selectedIndex = 0
    var SelectIndex = 0
    var serviceid = ""
    var subserviceid = ""
    var vehicalid = ""
    var addonid = ""
    var time = ""
    //MARK:- GLOBAL PROPERTIES
    
    
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAddressFromLatLon(pdblLatitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude), withLongitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude))
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
        nonmemberListData.homevc = self
        nonmemberListData.webserviceofNonMemberPlanList()
        vehiclePicker.delegate = self
        vehiclePicker.dataSource = self
//        lblSelectedService.text = serviceList[0].name
        servicePicker.delegate = self
        servicePicker.dataSource = self
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 2, to: today)
        if let date = nextDate {
            selectedDate.text = dateFormatter.string(from: date)
        }
        LblOctane.text = "93 Octane"
//        NotificationCenter.default.removeObserver(self, name: notifRefreshVehicleList, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshVehicleList), name: notifRefreshVehicleList, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: notifRefreshVehicleList, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshVehicleList), name: notifRefreshVehicleList, object: nil)
    }
//    @objc func refreshVehicleList(){
//        vehicleListData.webserviceofgetvehicalListforHome()
//    }
    func refreshVehicleScreen() {
        vehicleListData.webserviceofgetvehicalListforHome()
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
    
    @IBAction func btnSelectServiceTap(_ sender: UIButton) {
        
        onDoneButtonTappedService()
        onDoneButtonTappedVehicle()
        onDoneButtonDate()
        
        setServicePicker()
    }
    
    @IBAction func octaneButtonPressed(_ sender: ThemeButton) {
        
        switch sender.tag {
        case 0:
            deselectOtherOctaneButtons(tag: sender.tag)
            break
        case 1:
            deselectOtherOctaneButtons(tag: sender.tag)
            break
        default:
            break
        }
    }
    
    @IBAction func btnParkingLocationTap(_ sender: UIButton) {
        let carParkingLocationVC = storyboard?.instantiateViewController(withIdentifier: "CarParkingLocationVC") as! CarParkingLocationVC
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
            
            onDoneButtonTappedService()
            onDoneButtonTappedVehicle()
            onDoneButtonDate()
            
            setVehiclePicker()
        }
    }
 
    @IBAction func fillItUpButtonPressed(_ sender: ThemeButton) {
        if self.listOfVehicle.count == 0{
            Toast.show(message: "Please add some vehicle", state: .failure)
        }else{
            let slideToConfirmVC: SlideToConfirmVC = SlideToConfirmVC.instantiate(fromAppStoryboard: .Main)
            slideToConfirmVC.completion = {
                self.addBookingData.doAddBooking(customerid: Singleton.sharedInstance.userId, serviceid: self.serviceid, subserviceid: self.subserviceid, parkinglocation: self.locationLabel.text ?? "", lat: "\(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)", lng: "\(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)", date: self.selectedDate.text ?? "", time: self.time, vehicleid: self.vehicalid, totalAmount: "0", addonid: self.addonid)
            }
            slideToConfirmVC.modalPresentationStyle = .overFullScreen
            present(slideToConfirmVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnDatePickerTap(_ sender: UIButton) {
        
        onDoneButtonTappedService()
        onDoneButtonTappedVehicle()
        onDoneButtonDate()
        
        setDatePicker()
        
    }
    
    //MARK:- OTHER METHODS
    
    
    func deselectOtherOctaneButtons(tag: Int) {
        
        for i in 0..<octaneButtons.count {
            if tag == i {
                octaneButtons[i].setImage(#imageLiteral(resourceName: "IC_selectedCheckGray"), for: .normal)
            } else {
                octaneButtons[i].setImage(#imageLiteral(resourceName: "IC_unselectedGray"), for: .normal)
            }
        }
    }
    
    func setServicePicker() {
        
        servicePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.width, height: 250)
        servicePicker.backgroundColor = .white
        self.view.addSubview(servicePicker)
        
        toolBarForService = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBarForService.barStyle = .default
        toolBarForService.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTappedService))]
        self.view.addSubview(toolBarForService)
        
    }
    
    @objc func onDoneButtonTappedService() {
        if let click = self.doneButton{
            click()
        }
    }
    
    func setVehiclePicker() {
        
        vehiclePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.width, height: 250)
        vehiclePicker.backgroundColor = .white
        self.view.addSubview(vehiclePicker)
        
        toolBarForVehicle = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBarForVehicle.barStyle = .default
        toolBarForVehicle.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTappedVehicle))]
        self.view.addSubview(toolBarForVehicle)
        
    }
    
    @objc func onDoneButtonTappedVehicle() {
        if let click = self.doneButton{
            click()
        }
    }
    
    func setDatePicker() {
        
        datePicker = UIDatePicker.init()
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 2, to: today)
        datePicker.minimumDate = nextDate

        let nextMonth = Calendar.current.date(byAdding: .day, value: 33, to: today)
        datePicker.maximumDate = nextMonth
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
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
        }
    }
    
}

//MARK:- EXTENSIONS

extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == servicePicker {
            return serviceList.count
        } else {
            return listOfVehicle.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == servicePicker {
            return serviceList[row].name
        } else {
            let displaydata = (listOfVehicle[row].make ?? "") + "(" + (listOfVehicle[row].plateNumber ?? "") + ")"
            return displaydata
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.doneButton = {
            if pickerView == self.servicePicker {
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
                self.toolBarForService.removeFromSuperview()
                self.servicePicker.removeFromSuperview()
                self.lblSelectedService.text = self.serviceList[row].name
                self.lblSelectedService.endEditing(true)
            } else {
                self.vehicalid = self.listOfVehicle[row].id ?? ""
                self.toolBarForVehicle.removeFromSuperview()
                self.vehiclePicker.removeFromSuperview()
                self.lblSelectedVehicle.text = (self.listOfVehicle[row].make ?? "") + "(" + (self.listOfVehicle[row].plateNumber ?? "") + ")"
                self.lblSelectedVehicle.endEditing(true)
            }
        }
    }
}
extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonmemberplanlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:nonMemberListCell = tblNonMemberPLan.dequeueReusableCell(withIdentifier: nonMemberListCell.className) as! nonMemberListCell
        cell.lblPrice.text = CurrencySymbol + (nonmemberplanlist[indexPath.row].price ?? "")
        cell.lbltitle.text = (nonmemberplanlist[indexPath.row].title ?? "") + arrow
        cell.imgCheck.image = (nonmemberplanlist[indexPath.row].isSelected == true) ? UIImage(named: "IC_selectedBlue") : UIImage(named: "IC_unselectedBlue")
        self.addonid = (nonmemberplanlist[indexPath.row].isSelected == true) ? self.nonmemberplanlist[indexPath.row].id ?? "" : ""
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nonmemberplanlist[indexPath.row].isSelected = (nonmemberplanlist[indexPath.row].isSelected == true) ? false : true
        tblNonMemberPLan.reloadData()
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
            }else{
                cell.imgCheck.image = UIImage(named: "IC_unselectedBlue")
            }
//            cell.imgCheck.image = (SelectIndex == indexPath.row) ?  :
            self.subserviceid = serviceList[selectedIndex].subServices?[indexPath.row].id ?? ""
            return cell
        }else{
            let cell:timeListCell = collectionTimeList.dequeueReusableCell(withReuseIdentifier: timeListCell.className, for: indexPath) as! timeListCell
            cell.lblListData.text = arrTimeList[indexPath.row]
            self.time = arrTimeList[indexPath.row]
            if SelectIndex == indexPath.row{
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
            SelectIndex = indexPath.row
            collectionTimeList.reloadData()
        }else{
//            serviceList[indexPath.row].isSelected = (serviceList[indexPath.row].isSelected == true) ? false : true
            SelectIndex = indexPath.row
            collectionViewSubService.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionTimeList{
            return CGSize(width: 65.82, height: 36.95)
        }else{
            return CGSize(width: collectionViewSubService.frame.width / 2, height: collectionViewSubService.frame.width)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
extension HomeVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        print("Place ID: \(place.placeID!)")
        userDefault.setValue(place.name, forKey: UserDefaultsKey.PlaceName.rawValue)
        
        userDefault.synchronize()
        
        locationLabel.text =  place.name
        Singleton.sharedInstance.userCurrentLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
