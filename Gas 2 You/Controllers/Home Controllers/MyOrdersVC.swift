//
//  MyOrdersVC.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit

class MyOrdersVC: BaseVC {
    
    @IBOutlet weak var myOrdersTV: UITableView!
    @IBOutlet weak var btnUpcoming: ThemeButton!
    @IBOutlet weak var vwUpcomingLine: UIView!
    @IBOutlet weak var btnInProgress: ThemeButton!
    @IBOutlet weak var vwInProgressLine: UIView!
    @IBOutlet weak var btnCompleted: ThemeButton!
    @IBOutlet weak var vwCompletedLine: UIView!
    
    var isInProcess : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavbarrightButton()
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Orders", controller: self)
        
        let upcomingCellNib = UINib(nibName: UpcomingCell.className, bundle: nil)
        myOrdersTV.register(upcomingCellNib, forCellReuseIdentifier: UpcomingCell.className)
        
        let inprogressCellNib = UINib(nibName: InProgressCell.className, bundle: nil)
        myOrdersTV.register(inprogressCellNib, forCellReuseIdentifier: InProgressCell.className)
        
        let completedCellNib = UINib(nibName: CompletedCell.className, bundle: nil)
        myOrdersTV.register(completedCellNib, forCellReuseIdentifier: CompletedCell.className)
    }
    
    @IBAction func btnUpcomingTap(_ sender: ThemeButton) {
        
        sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
        vwUpcomingLine.backgroundColor = UIColor.init(hexString: "#1F79CD")
        btnInProgress.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        vwInProgressLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        btnCompleted.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        vwCompletedLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        isInProcess = 1
        myOrdersTV.reloadData()
    }
    
    @IBAction func btnInProgressTap(_ sender: ThemeButton) {
        
        sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
        vwInProgressLine.backgroundColor = UIColor.init(hexString: "#1F79CD")
        btnUpcoming.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        vwUpcomingLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        btnCompleted.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        vwCompletedLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        isInProcess = 2
        myOrdersTV.reloadData()
    }
    
    @IBAction func btnCompletedTap(_ sender: ThemeButton) {
        sender.titleLabel?.font = CustomFont.PoppinsBold.returnFont(14)
        vwCompletedLine.backgroundColor = UIColor.init(hexString: "#1F79CD")
        btnInProgress.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        vwInProgressLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        btnUpcoming.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(14)
        vwUpcomingLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.3)
        isInProcess = 3
        myOrdersTV.reloadData()
    }
}

extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isInProcess == 1 {
            let upcomingCell = myOrdersTV.dequeueReusableCell(withIdentifier: UpcomingCell.className) as! UpcomingCell
            
            return upcomingCell
        } else if isInProcess == 2 {
            let inprogressCell = myOrdersTV.dequeueReusableCell(withIdentifier: InProgressCell.className) as! InProgressCell
            
            return inprogressCell
        } else if isInProcess == 3 {
            let completedCell = myOrdersTV.dequeueReusableCell(withIdentifier: CompletedCell.className) as! CompletedCell
            
            return completedCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isInProcess == 1 {
            print("Upcoming cell pressed")
        } else if isInProcess == 2 {
            print("InProgress cell pressed")
        } else if isInProcess == 3 {
            let completeJobVC: CompleteJobVC = CompleteJobVC.instantiate(fromAppStoryboard: .Main)
            navigationController?.pushViewController(completeJobVC, animated: true)
//            let ratingPopUp: RatingPopUpVC = RatingPopUpVC.instantiate(fromAppStoryboard: .Main)
//            ratingPopUp.modalPresentationStyle = .overFullScreen
//            present(ratingPopUp, animated: false, completion: nil)
        }
        
    }
}
