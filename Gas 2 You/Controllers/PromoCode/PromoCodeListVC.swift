//
//  PromoCodeListVC.swift
//  Gas 2 You
//
//  Created by Tej P on 27/04/22.
//

import UIKit

class PromoCodeListVC: BaseVC {
    
    //MARK: - Variables
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var vWMain: UIView!
    @IBOutlet weak var vWEnterPromo: UIView!
    @IBOutlet weak var btnApply: ThemeButton!
    @IBOutlet weak var txtEnterpromo: ThemeTextfield!
    @IBOutlet weak var lblOfferForYou: ThemeLabel!
    @IBOutlet weak var tblPromoList: UITableView!
    @IBOutlet weak var tblpromoListHeight: NSLayoutConstraint!
    
    private var finishedLoadingInitialTableCells = false
    private var selectedIndex :Int = -1
    
    //MARK: - Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tblPromoList.layer.removeAllAnimations()
        self.tblpromoListHeight.constant = self.tblPromoList.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Offers", controller: self)
        self.txtEnterpromo.placeholder = "Enter promo code here"
        self.txtEnterpromo.placeHolderColor = (UIColor.lightGray).withAlphaComponent(0.3)
        self.scrollVw.showsVerticalScrollIndicator = false
        
        self.vWEnterPromo.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWEnterPromo.layer.masksToBounds = false
        self.vWEnterPromo.layer.shadowRadius = 4
        self.vWEnterPromo.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWEnterPromo.layer.cornerRadius = 10
        self.vWEnterPromo.layer.shadowOpacity = 0.15
        
        self.setupTable()
    }
    
    func setupData(){
        self.tblPromoList.reloadData()
    }
    
    func setupTable(){
        self.tblPromoList.delegate = self
        self.tblPromoList.dataSource = self
        self.tblPromoList.separatorStyle = .none
        self.tblPromoList.showsVerticalScrollIndicator = false
        self.tblPromoList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.registerNib()
    }
    
    func registerNib(){
        let nib = UINib(nibName: promoCell.className, bundle: nil)
        self.tblPromoList.register(nib, forCellReuseIdentifier: promoCell.className)
    }
    
    func reloadRowWithError(){
        let indexPath = IndexPath(item: self.selectedIndex, section: 0)
        self.tblPromoList.reloadRows(at: [indexPath], with: .right)
    }
}

//MARK: - UITableview Methods
extension PromoCodeListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblPromoList.dequeueReusableCell(withIdentifier: promoCell.className) as! promoCell
        cell.selectionStyle = .none
        
        
        cell.lblErrorMessage.isHidden = (self.selectedIndex != indexPath.row)
        cell.vWContainer.layer.borderColor = (self.selectedIndex != indexPath.row) ? UIColor.white.cgColor : UIColor.red.cgColor
        cell.vWContainer.layer.borderWidth = 1
        
        cell.btnTCClosure = {
            let vc : TermsVC = TermsVC.instantiate(fromAppStoryboard: .PromoCode)
            vc.modalPresentationStyle = .overCurrentContext
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
            vc.modalTransitionStyle = modalStyle
            self.present(vc, animated: true, completion: nil)
        }
        
        cell.btnApplyClosure = {
            self.selectedIndex = indexPath.row
            self.reloadRowWithError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if 5 > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
               let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: UITableView.automaticDimension / 2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
}
