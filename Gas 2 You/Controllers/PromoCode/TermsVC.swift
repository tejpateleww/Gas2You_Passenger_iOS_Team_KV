//
//  TermsVC.swift
//  Gas 2 You
//
//  Created by Tej P on 27/04/22.
//

import UIKit

class TermsVC: UIViewController {
    
    
    @IBOutlet weak var vWMain: UIView!
    @IBOutlet weak var vWHeader: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbltitle: ThemeLabel!
    @IBOutlet weak var lblTCDesc: ThemeLabel!
    @IBOutlet weak var btnOk: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.clear
   
    }
  
    func prepareView() {
        self.setupUI()
        self.setupData()
    }
    
    func setupUI() {
        self.vWHeader.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWHeader.layer.masksToBounds = false
        self.vWHeader.layer.shadowRadius = 4
        self.vWHeader.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWHeader.layer.cornerRadius = 10
        self.vWHeader.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.vWHeader.layer.shadowOpacity = 0.15
        
        self.vWMain.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWMain.layer.masksToBounds = false
        self.vWMain.layer.shadowRadius = 4
        self.vWMain.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWMain.layer.cornerRadius = 10
        self.vWMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.vWMain.layer.shadowOpacity = 0.15
        
    }
    
    func setupData() {
        
    }

    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOkAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTapOutSideAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
