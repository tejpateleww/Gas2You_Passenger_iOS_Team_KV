//
//  MyGiftCardListVC.swift
//  Gas 2 You
//
//  Created by Tej P on 03/05/22.
//

import UIKit

class MyGiftCardListVC: BaseVC {
    
    //MARK: - Variables
    @IBOutlet weak var tblGiftCards: UITableView!
    
    private var selectedIndex = -1
    private var currentNormal = true
    private var arrData: [String] = ["1","2"]
    
    //MARK: - Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }

    //MARK: - Custom methods
    private func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    private func setupUI(){
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My GiftCards", controller: self)
        self.setupTable()
    }
    
    private func setupData(){
        self.tblGiftCards.reloadData()
    }
    
    
    private func setupTable(){
        self.tblGiftCards.delegate = self
        self.tblGiftCards.dataSource = self
        self.tblGiftCards.separatorStyle = .none
        self.tblGiftCards.showsVerticalScrollIndicator = false
        
        self.registerNib()
    }
    
    private func registerNib(){
        let nib = UINib(nibName: GiftCardCellTableViewCell.className, bundle: nil)
        self.tblGiftCards.register(nib, forCellReuseIdentifier: GiftCardCellTableViewCell.className)
        
        let nib1 = UINib(nibName: NoDataCell.className, bundle: nil)
        self.tblGiftCards.register(nib1, forCellReuseIdentifier: NoDataCell.className)
    }
}


//MARK: - UITableview Methods
extension MyGiftCardListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrData.count == 0) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(arrData.count > 0){
            let cell = tblGiftCards.dequeueReusableCell(withIdentifier: GiftCardCellTableViewCell.className) as! GiftCardCellTableViewCell
            cell.selectionStyle = .none
            
            if(self.selectedIndex != -1){
                
                if(!self.currentNormal){
                    cell.vWBack.isHidden = false
                    cell.vWFront.isHidden = true
                }else{
                    cell.vWBack.isHidden = true
                    cell.vWFront.isHidden = false
                }
                
                self.currentNormal = true
                self.selectedIndex = -1
            }
            
            cell.btnDetailClosure = {
                UIView.transition(with: cell.stackMain, duration: 0.6, options: .transitionFlipFromRight, animations: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        cell.vWBack.isHidden = false
                        cell.vWFront.isHidden = true
                    }
                }){ finished in
                    self.selectedIndex = indexPath.row
                    self.currentNormal = false
                    
                    let indexPath = IndexPath(item: self.selectedIndex, section: 0)
                    self.tblGiftCards.reloadRows(at: [indexPath], with: .none)
                }
            }
            
            cell.btnBackClosure = {
                UIView.transition(with: cell.stackMain, duration: 0.6, options: .transitionFlipFromLeft, animations: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        cell.vWBack.isHidden = true
                        cell.vWFront.isHidden = false
                    }
                }){ finished in
                    self.selectedIndex = indexPath.row
                    self.currentNormal = true
                    let indexPath = IndexPath(item: self.selectedIndex, section: 0)
                    self.tblGiftCards.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            
            cell.btnCopyClosure = {
                UIPasteboard.general.string = cell.lblCode.text ?? ""
                Toast.show(title: UrlConstant.Success, message:"Code copy to clipboard", state: .success)
            }
            
            return cell
        }else{
            let Cell: NoDataCell = tblGiftCards.dequeueReusableCell(withIdentifier: NoDataCell.className) as! NoDataCell
            Cell.imgNodata.image = UIImage(named: "icon_TitleGiftCard")
            Cell.lblData.text = "Gift card not found!"
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (arrData.count > 0) ? UITableView.automaticDimension : tableView.frame.height
    }
 
}
