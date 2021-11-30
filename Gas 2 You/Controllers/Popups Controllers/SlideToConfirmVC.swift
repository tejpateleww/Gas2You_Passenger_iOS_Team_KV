//
//  SlideToConfirmVC.swift
//  Gas 2 You
//
//  Created by MacMini on 12/08/21.
//

import UIKit
import MTSlideToOpen

class SlideToConfirmVC: UIViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgGasdoor: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTheyWillClose: ThemeLabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var slideToConfirmView: MTSlideToOpenView!
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwBlur.layer.cornerRadius = 20
        
        setUpSwipeView(vwSwipe: slideToConfirmView)
    }
    
    @IBAction func btnCancleTap(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
    }
    
    func setUpSwipeView(vwSwipe : MTSlideToOpenView) {
        vwSwipe.sliderViewTopDistance = 0
        vwSwipe.thumbnailViewTopDistance = 8
        vwSwipe.thumbnailViewStartingDistance = 16
        vwSwipe.textLabel.text = "Confirm"
        vwSwipe.sliderCornerRadius = 0
        vwSwipe.thumnailImageView.frame = CGRect(x: 10, y: 0, width: 10, height: 10)
        vwSwipe.thumnailImageView.backgroundColor = .clear // ThemeColor.gradientColor2
        vwSwipe.thumnailImageView.image = #imageLiteral(resourceName: "IC_slideImg")
        vwSwipe.draggedView.backgroundColor = .clear
        vwSwipe.textColor = .white
        if UIDevice.current.userInterfaceIdiom == .phone{
            vwSwipe.textFont = CustomFont.PoppinsSemiBold.returnFont(16)
        }else{
            vwSwipe.textFont = CustomFont.PoppinsSemiBold.returnFont(21)
        }
        vwSwipe.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1) //ThemeColor.blueBorder
        vwSwipe.layer.cornerRadius = 9
        vwSwipe.delegate = self
        //playAnimation()
        
    }
}

extension SlideToConfirmVC: MTSlideToOpenDelegate {
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
//        dismiss(animated: false, completion: {
            if let completion = self.completion{
                completion()
            }
//        })
    }
}
