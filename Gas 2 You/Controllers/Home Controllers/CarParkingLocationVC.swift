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
    var PlaceName = userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefault.object(forKey: UserDefaultsKey.PlaceName.rawValue) as? String == nil{
            self.getAddressFromLatLon(pdblLatitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude), withLongitude: String(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude))
        }else{
            txtSearchBar.text = PlaceName
        }
        mapView.delegate = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        setUIMapPin()
    }
    override func BackButtonWithTitle(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegatetext.refreshSearchLIstScreen(text: txtSearchBar.text ?? "")
    }
    func setUIMapPin() {
        initializeTheLocationManager()
        let position = CLLocationCoordinate2DMake(23.033863,72.585022)
        let marker = GMSMarker(position: position)
        marker.icon = drawImageWithProfilePic(pp: nil, image: #imageLiteral(resourceName: "IC_pinImg"))
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
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
                                                                    self.txtSearchBar.text = addressString
                                            print(addressString)
                                        }
                                        else{
                                            Utilities.ShowAlert(OfMessage: "Location Not Found")
                                        }
                                    })
        
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
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

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
    userDefault.synchronize()
    
    txtSearchBar.text =  place.name
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

