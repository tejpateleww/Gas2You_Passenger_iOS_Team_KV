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
    @IBOutlet weak var imgGas: UIImageView!
    @IBOutlet weak var lblGas: themeLabel!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblCarName: themeLabel!
    @IBOutlet weak var imgLocationPin: UIImageView!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblDateTime: themeLabel!
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    @IBOutlet weak var btnGiveRateReview: UIButton!
    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var lblRating: themeLabel!
    @IBOutlet weak var vwReviewFeedBack: UIView!
    @IBOutlet weak var lblReview: themeLabel!
    @IBOutlet weak var lblUserReview: themeLabel!
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
                borderedViews[i].layer.borderWidth = 1.3
                borderedViews[i].layer.borderColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.12)
            }
        }
    }
    
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Completed", controller: self)
        
        setUIMapPin()
        setUI()
    }
    
    @IBAction func btnDownloadInvoiceTap(_ sender: UIButton) {
    }
    
    @IBAction func btnGiveRateTap(_ sender: UIButton) {
        let ratingPopUpVC: RatingPopUpVC = RatingPopUpVC.instantiate(fromAppStoryboard: .Main)
        ratingPopUpVC.modalPresentationStyle = .overFullScreen
        present(ratingPopUpVC, animated: false, completion: nil)
    }
    
    
    func setUI() {
        completeLabel.layer.masksToBounds = true
        completeLabel.layer.cornerRadius = 5
        
        vwRating.addShadow(view: vwRating, shadowColor: nil)
        vwReviewFeedBack.addShadow(view: vwReviewFeedBack, shadowColor: nil)
    }
    
    func setUIMapPin() {
        initializeTheLocationManager()
        var position = CLLocationCoordinate2DMake(23.033863,72.585022)
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
