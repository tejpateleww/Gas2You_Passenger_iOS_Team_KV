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
    var delegatetext : searchDataDelegate!
    var locationManager = CLLocationManager()
    var place = ""
    var PlaceName = userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String
    var latitude = userDefault.object(forKey: UserDefaultsKey.Latitude.rawValue) as? Double
    var longitude = userDefault.object(forKey: UserDefaultsKey.longitude.rawValue) as? Double
    
    var path = GMSPath()
    var polyline : GMSPolyline!
    var CurrentLocLat:String = "0.0"
    var CurrentLocLong:String = "0.0"
    var CurrentLocMarker: GMSMarker?
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String == nil{
            txtSearchBar.text = place
            setupMap()
        }else{
            txtSearchBar.text = PlaceName
            location(Lat: latitude ?? 0.0, Long: longitude ?? 0.0)
        }
        mapView.delegate = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        //        setUIMapPin()
        //        checkMapPermission()
    }
    override func BackButtonWithTitle(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegatetext.refreshSearchLIstScreen(text: txtSearchBar.text ?? "")
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
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                  GMSPlaceField.addressComponents.rawValue |
                                                  GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
      //  filter.type = .address
      //  autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
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
        // Get a reference for the custom overlay
        // let index:Int! = Int(marker.accessibilityLabel!)
        let view = MarkerInfoWindowView()
        view.sizeToFit()
        return view
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

