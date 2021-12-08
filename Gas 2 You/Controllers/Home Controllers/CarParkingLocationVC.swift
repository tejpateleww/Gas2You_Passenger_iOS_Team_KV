//
//  CarParkingLocationVC.swift
//  Gas 2 You
//
//  Created by MacMini on 03/08/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
protocol searchDataDelegate{
    func refreshSearchLIstScreen(text:String)
}
class CarParkingLocationVC: BaseVC {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var tblLocationList: UITableView!
    @IBOutlet weak var vwThemeview: ThemeView!
    var delegatetext : searchDataDelegate!
    var locationManager = CLLocationManager()
    var place = ""
    var PlaceName = userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String
    var latitude = userDefault.object(forKey: UserDefaultsKey.Latitude.rawValue) as? Double
    var longitude = userDefault.object(forKey: UserDefaultsKey.longitude.rawValue) as? Double
    var sublocality = ""
    var thoroughfare = ""
    var path = GMSPath()
    var polyline : GMSPolyline!
    var CurrentLocLat:String = "0.0"
    var CurrentLocLong:String = "0.0"
    var CurrentLocMarker: GMSMarker?
    var addLocationModel = AddLocationViewModel()
    var arrLocation = [AddLocationDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationModel.AddLocation = self
        addLocationModel.webserviceLocationList()
        self.mapView.mapType = .normal
        if userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String == nil{
            txtSearchBar.text = place
            location(Lat: latitude ?? 0.0, Long: longitude ?? 0.0)
            self.mapView.clear()
            self.path = GMSPath()
            self.polyline = GMSPolyline()
            
            self.CurrentLocLat = String(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)
            self.CurrentLocLong = String(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: self.latitude ?? 0.00, longitude: self.longitude ?? 0.0, zoom: 18.0)
            self.mapView.camera = camera
            
            let marker = GMSMarker()
            let markerImage = UIImage(named: "IC_pinImg")
            let markerView = UIImageView(image: markerImage)
            marker.position = CLLocationCoordinate2D(latitude:  self.latitude ?? 0.00, longitude: self.longitude ?? 0.0)
            self.getAddressFromLatLon(pdblLatitude: String(self.latitude ?? 0.00), withLongitude: String(self.longitude ?? 0.00))
            marker.iconView = markerView
            marker.map = mapView
        }else{
            txtSearchBar.text = PlaceName
            location(Lat: latitude ?? 0.0, Long: longitude ?? 0.0)
            setupMap()
        }
        tblLocationList.delegate = self
        tblLocationList.dataSource = self
        tblLocationList.reloadData()
        mapView.delegate = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        //        setUIMapPin()
        //        checkMapPermission()
    }
    @IBAction func btnSateliteClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            self.mapView.mapType = .satellite
        }else{
            self.mapView.mapType = .normal
        }
    }
    override func BackButtonWithTitle(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegatetext.refreshSearchLIstScreen(text: txtSearchBar.text ?? "")
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
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
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                            self.sublocality = pm.subLocality ?? ""
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                            self.thoroughfare = pm.thoroughfare ?? ""
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
//                        self.PlaceName = addressString
                        userDefault.setValue(addressString, forKey: UserDefaultsKey.PlaceName.rawValue)
                        self.txtSearchBar.text = addressString
                        print(addressString)
                  }
            })

        }
    func setupMap(){
        self.mapView.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
        
        self.CurrentLocLat = String(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)
        self.CurrentLocLong = String(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(self.CurrentLocLat) ?? 0.0, longitude:  Double(self.CurrentLocLong) ?? 0.0, zoom: 18.0)
        self.mapView.camera = camera
        
        let marker = GMSMarker()
        let markerImage = UIImage(named: "IC_pinImg")
        let markerView = UIImageView(image: markerImage)
        marker.position = CLLocationCoordinate2D(latitude:  Double(self.CurrentLocLat) ?? 0.0, longitude: Double(self.CurrentLocLong) ?? 0.0)
        self.getAddressFromLatLon(pdblLatitude: self.CurrentLocLat, withLongitude: self.CurrentLocLong)
        marker.iconView = markerView
        marker.map = mapView
    }
    func  location(Lat:Double,Long:Double){
        self.mapView.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
        
        self.CurrentLocLat = String(Lat)
        self.CurrentLocLong = String(Long)
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(self.CurrentLocLat) ?? 0.0, longitude:  Double(self.CurrentLocLong) ?? 0.0, zoom: 18.0)
        self.mapView.camera = camera
        
        let marker = GMSMarker()
        let markerImage = UIImage(named: "IC_pinImg")
        let markerView = UIImageView(image: markerImage)
        marker.position = CLLocationCoordinate2D(latitude:  Double(self.CurrentLocLat) ?? 0.0, longitude: Double(self.CurrentLocLong) ?? 0.0)
        marker.iconView = markerView
        //        marker.title = cartDetails?.name
        marker.map = mapView
    }
    @IBAction func btnCurrentLocation(_ sender: Any) {
        setupMap()
    }
    func locationData(){
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude:Singleton.sharedInstance.userCurrentLocation.coordinate.latitude , longitude: Singleton.sharedInstance.userCurrentLocation.coordinate.longitude, zoom: 18.0)
        mapView.camera = camera
        let marker = GMSMarker()
        let markerImage = UIImage(named: "IC_pinImg")
        let markerView = UIImageView(image: markerImage)
        marker.position = CLLocationCoordinate2D(latitude: Singleton.sharedInstance.userCurrentLocation.coordinate.latitude, longitude: Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)
        marker.iconView = markerView
        //        marker.title = cartDetails?.name
        marker.map = mapView
    }
    func setUIMapPin() {
        initializeTheLocationManager()
        let position = CLLocationCoordinate2DMake(23.033863,72.585022)
        let marker = GMSMarker(position: position)
        marker.icon = drawImageWithProfilePic(pp: nil, image: #imageLiteral(resourceName: "IC_pinImg"))
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }

    func drawImageWithProfilePic(pp: UIImage?, image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        return newImage
    }
    
    @IBAction func btnSearchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                  GMSPlaceField.addressComponents.rawValue |
                                                  GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        present(autocompleteController, animated: true, completion: nil)
    }
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
}

extension CarParkingLocationVC: CLLocationManagerDelegate {
    
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 4)
        }
    }
    
}

extension CarParkingLocationVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = MarkerInfoWindowView()
        view.titleLabel.numberOfLines = 1
        
        if(marker == self.CurrentLocMarker){
            view.titleLabel.text = "You"
            view.titleLabel.textAlignment = .center
            view.imgArrow.isHidden = true
            view.imgArrowHeigh.constant = 0
            view.frame.size.width = 60
            view.frame.size.height = view.titleLabel.bounds.size.height - 15
            view.sizeToFit()
        }else{
            view.titleLabel.text = PlaceName
            view.titleLabel.textAlignment = .left
            view.imgArrow.isHidden = false
            view.imgArrowHeigh.constant = 20
            let width = view.titleLabel.text?.stringWidth // 74.6
            view.frame = CGRect(x: 0, y: 0, width: width ?? 0, height: 50)
            view.sizeToFit()
        }
        return view
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if(marker != self.CurrentLocMarker){
            Utilities.showAlert("Parking Location", message: "Parking Location", vc: self)
        }
    }
}
extension CarParkingLocationVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        userDefault.setValue(place.name, forKey: UserDefaultsKey.PlaceName.rawValue)
        userDefault.setValue(place.coordinate.longitude, forKey: UserDefaultsKey.longitude.rawValue)
        userDefault.setValue(place.coordinate.latitude, forKey: UserDefaultsKey.Latitude.rawValue)
        
        userDefault.synchronize()
        
        txtSearchBar.text =  place.name
        
        Singleton.sharedInstance.userCurrentLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        location(Lat: place.coordinate.latitude, Long: place.coordinate.longitude)
        addLocationModel.webserviceAddLocation(location: place.name ?? "", lat: place.coordinate.latitude, lng: place.coordinate.longitude)
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

extension CarParkingLocationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocation.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:locationListCell = tblLocationList.dequeueReusableCell(withIdentifier: locationListCell.className) as! locationListCell
        cell.lblLocation.text = arrLocation[indexPath.row].location
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        userDefault.setValue(arrLocation[indexPath.row].location, forKey: UserDefaultsKey.PlaceName.rawValue)
        userDefault.setValue(arrLocation[indexPath.row].longitude, forKey: UserDefaultsKey.longitude.rawValue)
        userDefault.setValue(arrLocation[indexPath.row].latitude, forKey: UserDefaultsKey.Latitude.rawValue)
        
        userDefault.synchronize()
        self.txtSearchBar.text = arrLocation[indexPath.row].location
        location(Lat: Double(arrLocation[indexPath.row].latitude) ?? 0.00, Long: Double(arrLocation[indexPath.row].longitude) ?? 0.00)
        Singleton.sharedInstance.userCurrentLocation = CLLocation(latitude: Double(arrLocation[indexPath.row].latitude) ?? 0.00, longitude: Double(arrLocation[indexPath.row].longitude) ?? 0.00)
        self.navigationController?.popViewController(animated: true)
    }
}
