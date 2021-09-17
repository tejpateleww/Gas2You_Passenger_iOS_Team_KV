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
    
    
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    var arrNotification = [notification]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTV.delegate = self
        notificationTV.dataSource = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Notifications", controller: self)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.2 // optional
        notificationTV.addGestureRecognizer(longPress)
        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_checkRightGreen"), msg: "Your Order #1234 has been completed"))
        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_checkRightGreen"), msg: "Your Order #1234 has been completed"))
        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_wrongRed"), msg: "Your booking #1205 has been cancelled"))
        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_rightCheck"), msg: "Your Order #1234 has been placed"))
        arrNotification.append(notification(img: #imageLiteral(resourceName: "IC_rightCheck"), msg: "Your Order #1234 has been placed"))
    }
    
    // MARK: cell reorder / long press

    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: notificationTV)
      let indexPath = notificationTV.indexPathForRow(at: locationInView)

      if sender.state == .began {
        if indexPath != nil {
          dragInitialIndexPath = indexPath
          let cell = notificationTV.cellForRow(at: indexPath!)
          dragCellSnapshot = snapshotOfCell(inputView: cell!)
          var center = cell?.center
          dragCellSnapshot?.center = center!
          dragCellSnapshot?.alpha = 0.0
            notificationTV.addSubview(dragCellSnapshot!)

          UIView.animate(withDuration: 0.25, animations: { () -> Void in
            center?.y = locationInView.y
            self.dragCellSnapshot?.center = center!
            self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
            self.dragCellSnapshot?.alpha = 0.99
            cell?.alpha = 0.0
          }, completion: { (finished) -> Void in
            if finished {
              cell?.isHidden = true
            }
          })
        }
      } else if sender.state == .changed && dragInitialIndexPath != nil {
        var center = dragCellSnapshot?.center
        center?.y = locationInView.y
        dragCellSnapshot?.center = center!

        // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
        if indexPath != nil && indexPath != dragInitialIndexPath {
          // update your data model
          //let dataToMove = data[dragInitialIndexPath!.row]
         // data.remove(at: dragInitialIndexPath!.row)
          //data.insert(dataToMove, at: indexPath!.row)

            notificationTV.moveRow(at: dragInitialIndexPath!, to: indexPath!)
          dragInitialIndexPath = indexPath
        }
      } else if sender.state == .ended && dragInitialIndexPath != nil {
        let cell = notificationTV.cellForRow(at: dragInitialIndexPath!)
        cell?.isHidden = false
        cell?.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.dragCellSnapshot?.center = (cell?.center)!
          self.dragCellSnapshot?.transform = CGAffineTransform.identity
          self.dragCellSnapshot?.alpha = 0.0
          cell?.alpha = 1.0
        }, completion: { (finished) -> Void in
          if finished {
            self.dragInitialIndexPath = nil
            self.dragCellSnapshot?.removeFromSuperview()
            self.dragCellSnapshot = nil
          }
        })
      }
    }

    func snapshotOfCell(inputView: UIView) -> UIView {
      UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
      inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      let cellSnapshot = UIImageView(image: image)
      cellSnapshot.layer.masksToBounds = false
      cellSnapshot.layer.cornerRadius = 0.0
      cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
      cellSnapshot.layer.shadowRadius = 5.0
      cellSnapshot.layer.shadowOpacity = 0.4
      return cellSnapshot
    }
    
}


extension NotificationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTV.dequeueReusableCell(withIdentifier: NotificationCell.className) as! NotificationCell
        cell.imgNotification.image = arrNotification[indexPath.row].img
        cell.lblNotification.text = arrNotification[indexPath.row].msg
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let GasDoorOpenPopUpVC: GasDoorOpenPopUpVC = GasDoorOpenPopUpVC.instantiate(fromAppStoryboard: .Main)
        GasDoorOpenPopUpVC.modalPresentationStyle = .overFullScreen
        present(GasDoorOpenPopUpVC, animated: false, completion: nil)
    }
    
    
    
    
    
}

class NotificationCell : UITableViewCell{
    
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblNotification: ThemeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
