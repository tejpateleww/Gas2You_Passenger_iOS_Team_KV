//
//  RatingPopUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 12/08/21.
//

import UIKit
import Cosmos

protocol rateandreviewDelegate{
    func refreshCompleteJobScreen(rate:Double,review:String)
}

class RatingPopUpVC: UIViewController {
    var rateDelegate : rateandreviewDelegate?
    var rateModel = rateandreviewmodel()
    var orderid = ""
    @IBOutlet weak var vwBlur: UIVisualEffectView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblWelcomeTo: ThemeLabel!
    @IBOutlet weak var lblG2U: ThemeLabel!
    @IBOutlet weak var lblRateExperience: ThemeLabel!
    @IBOutlet weak var lblGiveFeedback: ThemeLabel!
    @IBOutlet weak var txtReview: UITextView!
    @IBOutlet weak var btnSubmit: ThemeButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwCosmos: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rateModel.reviewmodel = self
        vwBlur.layer.cornerRadius = 20
        btnCancel.layer.cornerRadius = 9
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = #colorLiteral(red: 0.1235632375, green: 0.5093602538, blue: 0.7753000855, alpha: 1)
        btnCancel.titleLabel?.textColor = #colorLiteral(red: 0.1235632375, green: 0.5093602538, blue: 0.7753000855, alpha: 1)
        btnCancel.tintColor = #colorLiteral(red: 0.1235632375, green: 0.5093602538, blue: 0.7753000855, alpha: 1)
        if UIDevice.current.userInterfaceIdiom == .phone{
            btnCancel.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(16)
            txtReview.font = CustomFont.PoppinsRegular.returnFont(13)
        }else{
            btnCancel.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(21)
            txtReview.font = CustomFont.PoppinsRegular.returnFont(18)
        }
        txtReview.text = "Write down your review"
        txtReview.textColor = UIColor.lightGray
        txtReview.delegate = self
        
        vwCosmos.settings.fillMode = .half
    }
    
    @IBAction func btnSubmitTap(_ sender: ThemeButton) {
        rateModel.doAddBooking(order_id: orderid, rate: "\(vwCosmos.rating)", review: txtReview.text)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCancelTap(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func adjustUITextViewHeight(arg : UITextView) {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}

extension RatingPopUpVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write down your review"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
