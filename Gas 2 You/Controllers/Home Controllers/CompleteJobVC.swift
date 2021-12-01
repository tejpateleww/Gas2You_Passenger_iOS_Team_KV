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
                if UIDevice.current.userInterfaceIdiom == .phone{
                    borderedButtons[i].titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(13)
                }else{
                    borderedButtons[i].titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(18)
                }
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
    var orderId = String()
    var isCancel : Bool = false
    var url = ""
    var number = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingDetailViewModel.BookingDetails = self
        bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: orderId))
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: strTitle == "" ? "Completed" : "Cancelled", controller: self)
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
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
        if #available(iOS 13.0, *) {
            view.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
        } else {
            view.setTemplateWithSubviews(true, viewBackgroundColor: .white)
        }
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
        lblTimeandDate.text = (objBookingDetail?.time ?? "") + ", " + (objBookingDetail?.date ?? "")
        lblPlatNumber.text = objBookingDetail?.plateNumber
        lblItemName.text = objBookingDetail?.mainServiceName
        lbltotalGallon.text = (objBookingDetail?.totalGallon ?? "" ) + " Gallon"
        lblPricePerGallon.text = CurrencySymbol +  (objBookingDetail?.pricePerGallon ?? "") + " Per Gallon"
        lblTotalAmount.text = CurrencySymbol + (objBookingDetail?.finalAmount ?? "")
        self.url = objBookingDetail?.invoiceurl ?? ""
        self.number = objBookingDetail?.invoiceNumber ?? ""
        if(self.pdfFileAlreadySaved(url: url, fileName: number) == true){
            self.btnDownloadInvoice.setTitle(" VIEW INVOICE", for: .normal)
        }else{
            self.btnDownloadInvoice.setTitle("DOWNLOAD INVOICE", for: .normal)
        }
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
        savePdf(urlString: url, fileName: number)
    }
    func savePdf(urlString:String, fileName:String) {
        if(urlString == ""){
            Utilities.hideHud()
            return
        }
        if(self.pdfFileAlreadySaved(url: urlString, fileName: fileName) == true){
            Utilities.hideHud()
            let vc : WebViewVC  = WebViewVC.instantiate(fromAppStoryboard: .Main)
            vc.isLoadFromURL = true
            vc.strUrl = urlString
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }else{
            DispatchQueue.main.async {
                let url = URL(string: urlString)
                let pdfData = try? Data.init(contentsOf: url!)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(AppInfo.appName)_\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
//                    self.delegate?.onSaveInvoice()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        Toast.show(title: UrlConstant.Success, message: "Invoice successfully downloaded!", state: .success)
                    }
                } catch {
                    Utilities.showAlertAction(message: "Invoice could not be saved!", vc: self)
                }
                Utilities.hideHud()
            }
        }
    }
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                let fileName = "\(AppInfo.appName)_\(fileName).pdf".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                for url in contents {
                    if url.description.contains(fileName) {
                        status = true
                    }
                }
            } catch {
                print("could not locate Invoice file !!!!!!!")
            }
        }
        return status
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
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
