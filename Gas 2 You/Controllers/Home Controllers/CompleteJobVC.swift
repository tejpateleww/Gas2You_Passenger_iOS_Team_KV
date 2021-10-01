//
//  CompleteJobVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit
import GoogleMaps
import Cosmos
import UIView_Shimmer


extension UILabel: ShimmeringViewProtocol { }
extension UISwitch: ShimmeringViewProtocol { }
extension UIProgressView: ShimmeringViewProtocol { }
extension UITextView: ShimmeringViewProtocol { }
extension UIStepper: ShimmeringViewProtocol { }
extension UISlider: ShimmeringViewProtocol { }
extension UIImageView: ShimmeringViewProtocol {}

class CompleteJobVC: BaseVC,rateandreviewDelegate {
    
    
    
    @IBOutlet weak var StackDownloadinvoiceBottom: NSLayoutConstraint!
    @IBOutlet weak var stackDownloadInvoiceTop: NSLayoutConstraint!
    @IBOutlet weak var btnDownloadInvoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblStatus: ThemeLabel!
    @IBOutlet weak var viewStatus: UIView?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgGas: UIImageView!
    @IBOutlet weak var lblGas: ThemeLabel!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblCarName: ThemeLabel!
    @IBOutlet weak var imgLocationPin: UIImageView!
    @IBOutlet weak var lblAddress: ThemeLabel!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblDateTime: ThemeLabel!
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    @IBOutlet weak var btnGiveRateReview: UIButton!
    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var lblRating: ThemeLabel!
    @IBOutlet weak var vwReviewFeedBack: UIView!
    @IBOutlet weak var lblReview: ThemeLabel!
    @IBOutlet weak var lblUserReview: ThemeLabel!
    @IBOutlet weak var lblTimeandDate: ThemeLabel!
    @IBOutlet weak var lblPlatNumber: ThemeLabel!
    @IBOutlet weak var lblItemName: ThemeLabel!
    @IBOutlet weak var lblTotalAmount: ThemeLabel!
    @IBOutlet weak var lbltotalGallon: ThemeLabel!
    @IBOutlet weak var lblPricePerGallon: ThemeLabel!
    @IBOutlet weak var vwCosmos: CosmosView!
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
    var shimmeringAnimatedItems: [UIView] {
        [
            lblGas,
            imgGas,
            imgCar,
            lblCarName,
            imgLocationPin,
            lblAddress,
            imgCalender,
            lblDateTime,
            lblPlatNumber,
            lblTimeandDate,
            lblItemName,
            lbltotalGallon,
            lblPricePerGallon,
            lblTotalAmount,
            btnDownloadInvoice,
            btnGiveRateReview,
            lblRating,
            vwCosmos,
            lblReview,
            lblUserReview
        ]
    }
    var locationManager = CLLocationManager()
    var isfromCancelled = false
    var strTitle = ""
    var objBookingDetail : bookingDetailDatum?
    var bookingDetailViewModel = bookingDetailsViewModel()
    var orderId = ""
    var isCancel : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingDetailViewModel.BookingDetails = self
        bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: orderId))
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: strTitle == "" ? "Completed" : "Cancelled", controller: self)
        view.backgroundColor = .systemBackground
        setUIMapPin()
        if isfromCancelled{
            btnDownloadInvoiceHeight.constant = 0
            stackDownloadInvoiceTop.constant = 0
            StackDownloadinvoiceBottom.constant = 0
        }
        if isCancel{
            vwRating.isHidden = true
            vwReviewFeedBack.isHidden = true
            btnGiveRateReview.isHidden = true
        }
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func setData(){
        let makename = objBookingDetail?.makeName ?? ""
        let modelName = objBookingDetail?.modelName ?? ""
        lblGas.text = objBookingDetail?.mainServiceName
        lblCarName.text = makename + "(" + modelName + ")"
        lblAddress.text = objBookingDetail?.parkingLocation
        lblTimeandDate.text = (objBookingDetail?.time ?? "") + " ," + (objBookingDetail?.date ?? "")
        lblPlatNumber.text = objBookingDetail?.plateNumber
        lblItemName.text = objBookingDetail?.mainServiceName
        lbltotalGallon.text = (objBookingDetail?.totalGallon ?? "" ) + " Gallon"
        lblPricePerGallon.text = CurrencySymbol +  (objBookingDetail?.pricePerGallon ?? "") + " Per Gallon"
        lblTotalAmount.text = CurrencySymbol + (objBookingDetail?.finalAmount ?? "")
        if objBookingDetail?.rate == ""{
            vwRating.isHidden = true
            vwReviewFeedBack.isHidden = true
        }else{
            vwRating.isHidden = false
            vwReviewFeedBack.isHidden = false
            btnGiveRateReview.isHidden = true
        }
        vwCosmos.rating = Double(objBookingDetail?.rate ?? "") ?? 0.0
        lblUserReview.text = objBookingDetail?.review
    }
    @IBAction func btnDownloadInvoiceTap(_ sender: UIButton) {
    }
    
    @IBAction func btnGiveRateTap(_ sender: UIButton) {
            let ratingPopUpVC: RatingPopUpVC = RatingPopUpVC.instantiate(fromAppStoryboard: .Main)
            ratingPopUpVC.rateDelegate = self
            ratingPopUpVC.orderid = self.orderId
            ratingPopUpVC.modalPresentationStyle = .overFullScreen
            present(ratingPopUpVC, animated: false, completion: nil)
    }
    
    
    func setUI() {
        viewStatus?.layer.masksToBounds = true
        viewStatus?.layer.cornerRadius = 5
        viewStatus?.backgroundColor = #colorLiteral(red: 0.4391005337, green: 0.8347155452, blue: 0.5683938265, alpha: 1)
        vwRating.addShadow(view: vwRating, shadowColor: nil)
        vwReviewFeedBack.addShadow(view: vwReviewFeedBack, shadowColor: nil)
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
    func refreshCompleteJobScreen(rate: Double, review: String) {
        vwCosmos.rating = rate
        lblUserReview.text = review
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: self.orderId))
            self.view.setTemplateWithSubviews(false)
        }
    }
    
}

extension CompleteJobVC: CLLocationManagerDelegate {
    
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
