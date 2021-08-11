//
//  CompleteJobVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit
import GoogleMaps

class CompleteJobVC: BaseVC {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var completeLabel: themeLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var borderedButtons: [UIButton]! {
        didSet {
            for i in 0..<borderedButtons.count {
                borderedButtons[i].titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(13)
                borderedButtons[i].layer.borderWidth = 1
                borderedButtons[i].layer.borderColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.12)
            }
        }
    }
    @IBOutlet var borderedViews: [UIView]! {
        didSet {
            for i in 0..<borderedViews.count {
                borderedViews[i].layer.cornerRadius = 5
                borderedViews[i].layer.borderWidth = 1
                borderedViews[i].layer.borderColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.12)
            }
        }
    }
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Completed", controller: self)
        
        initializeTheLocationManager()
//        mapView.isMyLocationEnabled = true
        
        var position = CLLocationCoordinate2DMake(23.033863,72.585022)
//            var marker = GMSMarker(position: position)

        let marker = GMSMarker(position: position)
        marker.icon = drawImageWithProfilePic(pp: nil, image: #imageLiteral(resourceName: "IC_pinImg"))
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        setUI()
    }
    
    func setUI() {
        completeLabel.layer.masksToBounds = true
        completeLabel.layer.cornerRadius = 5
        
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

extension CompleteJobVC: CLLocationManagerDelegate {
    
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location = locationManager.location?.coordinate
        
        cameraMoveToLocation(toLocation: location)
        
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 4)
        }
    }
    
    
    
}
