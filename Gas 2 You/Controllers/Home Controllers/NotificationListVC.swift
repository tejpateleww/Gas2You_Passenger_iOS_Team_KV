//
//  NotificationListVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

struct notification{
    var img : UIImage?
    var msg : String?
}

class NotificationListVC: BaseVC {

    @IBOutlet weak var notificationTV: UITableView!
    
    var arrNotification = [notificationListDatum]()
    var notificationModelClass = NotificationModelClass()
    
    //Pagination
    var CurrentPage = 1
    var isApiProcessing = false
    var isStopPaging = false
    
    //Shimmer
    var isTblReload = false
    
    var isLoading = true {
        didSet {
            self.notificationTV.isUserInteractionEnabled = !isLoading
            self.notificationTV.reloadData()
        }
    }
    
    //Pull to refresh
    let refreshControl = UIRefreshControl()
//    var dragInitialIndexPath: IndexPath?
//    var dragCellSnapshot: UIView?
//    var arrNotification = [notification]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Notifications", controller: self)
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
//        longPress.minimumPressDuration = 0.2 // optional
//        notificationTV.addGestureRecognizer(longPress)
//        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_checkRightGreen"), msg: "Your Order #1234 has been completed"))
//        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_checkRightGreen"), msg: "Your Order #1234 has been completed"))
//        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_wrongRed"), msg: "Your booking #1205 has been cancelled"))
//        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_rightCheck"), msg: "Your Order #1234 has been placed"))
//        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_rightCheck"), msg: "Your Order #1234 has been placed"))
        self.prepareView()
    }
    func prepareView(){
        self.registerNib()
        self.setupUI()
        self.setupData()
        self.addRefreshControl()
    }
    
    func setupUI(){
        self.notificationTV.delegate = self
        self.notificationTV.dataSource = self
    }
    
    func setupData(){
        self.callNotificationListAPI()
    }
    
    func registerNib(){
        let nib1 = UINib(nibName: NotiShimmerCell.className, bundle: nil)
        self.notificationTV.register(nib1, forCellReuseIdentifier: NotiShimmerCell.className)
        let nib2 = UINib(nibName: NoDataCell.className, bundle: nil)
        self.notificationTV.register(nib2, forCellReuseIdentifier: NoDataCell.className)
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = UIColor.init(hexString: "#1F79CD")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.notificationTV.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.arrNotification = []
        self.isTblReload = false
        self.isLoading = true
        
        self.CurrentPage = 1
        self.isStopPaging = false
        self.callNotificationListAPI()
    }
    
    func reloadData(){
        self.notificationTV.reloadData()
    }
    // MARK: cell reorder / long press

//    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
//        let locationInView = sender.location(in: notificationTV)
//      let indexPath = notificationTV.indexPathForRow(at: locationInView)
//
//      if sender.state == .began {
//        if indexPath != nil {
//          dragInitialIndexPath = indexPath
//          let cell = notificationTV.cellForRow(at: indexPath!)
//          dragCellSnapshot = snapshotOfCell(inputView: cell!)
//          var center = cell?.center
//          dragCellSnapshot?.center = center!
//          dragCellSnapshot?.alpha = 0.0
//            notificationTV.addSubview(dragCellSnapshot!)
//
//          UIView.animate(withDuration: 0.25, animations: { () -> Void in
//            center?.y = locationInView.y
//            self.dragCellSnapshot?.center = center!
//            self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
//            self.dragCellSnapshot?.alpha = 0.99
//            cell?.alpha = 0.0
//          }, completion: { (finished) -> Void in
//            if finished {
//              cell?.isHidden = true
//            }
//          })
//        }
//      } else if sender.state == .changed && dragInitialIndexPath != nil {
//        var center = dragCellSnapshot?.center
//        center?.y = locationInView.y
//        dragCellSnapshot?.center = center!
//
//        // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
//        if indexPath != nil && indexPath != dragInitialIndexPath {
//          // update your data model
//          //let dataToMove = data[dragInitialIndexPath!.row]
//         // data.remove(at: dragInitialIndexPath!.row)
//          //data.insert(dataToMove, at: indexPath!.row)
//
//            notificationTV.moveRow(at: dragInitialIndexPath!, to: indexPath!)
//          dragInitialIndexPath = indexPath
//        }
//      } else if sender.state == .ended && dragInitialIndexPath != nil {
//        let cell = notificationTV.cellForRow(at: dragInitialIndexPath!)
//        cell?.isHidden = false
//        cell?.alpha = 0.0
//        UIView.animate(withDuration: 0.25, animations: { () -> Void in
//          self.dragCellSnapshot?.center = (cell?.center)!
//          self.dragCellSnapshot?.transform = CGAffineTransform.identity
//          self.dragCellSnapshot?.alpha = 0.0
//          cell?.alpha = 1.0
//        }, completion: { (finished) -> Void in
//          if finished {
//            self.dragInitialIndexPath = nil
//            self.dragCellSnapshot?.removeFromSuperview()
//            self.dragCellSnapshot = nil
//          }
//        })
//      }
//    }

//    func snapshotOfCell(inputView: UIView) -> UIView {
//      UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
//      inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
//      let image = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//
//      let cellSnapshot = UIImageView(image: image)
//      cellSnapshot.layer.masksToBounds = false
//      cellSnapshot.layer.cornerRadius = 0.0
//      cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
//      cellSnapshot.layer.shadowRadius = 5.0
//      cellSnapshot.layer.shadowOpacity = 0.4
//      return cellSnapshot
//    }
//
}


extension NotificationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrNotification.count > 0 {
            return self.arrNotification.count
        } else {
            return (!self.isTblReload) ? 10 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = notificationTV.dequeueReusableCell(withIdentifier: NotificationCell.className) as! NotificationCell
        cell.selectionStyle = .none
        if(!self.isTblReload){
            let cell = self.notificationTV.dequeueReusableCell(withIdentifier: NotiShimmerCell.className) as! NotiShimmerCell
            cell.lblNoti.text = "Your Orderb #1234 has been suc..."
            return cell
        }else{
            if(self.arrNotification.count > 0){
                cell.imgNotification.image = UIImage(named: "IC_checkRightGreen")
                cell.lblNotification.text = arrNotification[indexPath.row].notificationMessage ?? ""
                
                return cell
            }else{
                let NoDatacell = self.notificationTV.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! NoDataCell
                NoDatacell.imgNodata.image = UIImage(named: "ic_notification")
                NoDatacell.lblData.text = "No notification available"
                return NoDatacell
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(!self.isTblReload){
            return UITableView.automaticDimension
        }else{
            if self.arrNotification.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.notificationTV.contentOffset.y >= (self.notificationTV.contentSize.height - self.notificationTV.frame.size.height)) && self.isStopPaging == false && self.isApiProcessing == false {
            print("call from scroll..")
            self.CurrentPage += 1
            self.callNotificationListAPI()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: GasDoorOpenPopUpVC = GasDoorOpenPopUpVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    
    
    
    
}
extension NotificationListVC{
    
    func callNotificationListAPI(){
        self.notificationModelClass.notificationVC = self
        let NotificationReqModel = NotificationReqModel()
        NotificationReqModel.page = "\(self.CurrentPage)"
        self.notificationModelClass.webserviceNotificationListAPI(reqModel: NotificationReqModel)
    }
}
class NotificationCell : UITableViewCell{
    
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblNotification: ThemeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
